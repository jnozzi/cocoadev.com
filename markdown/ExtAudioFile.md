Since Mac OS X v10.4 there is a nice extension of General/AudioFiles available: General/ExtAudioFile.

With General/ExtAudioFile it is very easy to read/write audio files even if they are in a compressed format (like MP3)

**Example**

Reading a audio file into memory. After reading the file's data will be available in our buffer as uncompressed AIFF (2 channel, 44.1kHz).
    
   Float64 kGraphSampleRate=44100.; // Our internal sample rate
   General/ExtAudioFileRef xafref=nil;

   @try
   {
      General/OSStatus err = noErr;
      General/FSRef theRef;

      NSURL *fileURL = [NSURL fileURLWithPath: resourcePath];
      if(!General/CFURLGetFSRef((General/CFURLRef)fileURL, &theRef))
         @throw General/[NSException exceptionWithName:@"Exception" reason:@"General/CFURLGetFSRef == false" userInfo:nil];

      err = General/ExtAudioFileOpen(&theRef, &xafref);
      _ThrowExceptionIfErr(@"General/ExtAudioFileOpen", err);

      UInt32 propSize;

      General/CAStreamBasicDescription clientFormat;
      propSize = sizeof(clientFormat);

      err = General/ExtAudioFileGetProperty(xafref, kExtAudioFileProperty_FileDataFormat, &propSize, &clientFormat);
      _ThrowExceptionIfErr(@"kExtAudioFileProperty_FileDataFormat", err);


      // If you need to alloc a buffer, you'll need to alloc filelength*channels*rateRatio bytes
      //double rateRatio = kGraphSampleRate / clientFormat.mSampleRate;

      // read as 44.1kHz 2Ch audio in  this example
      clientFormat.mSampleRate = kGraphSampleRate;
      clientFormat.General/SetCanonical(2, true);

      propSize = sizeof(clientFormat);
      err = General/ExtAudioFileSetProperty(xafref, kExtAudioFileProperty_ClientDataFormat, propSize, &clientFormat);
      _ThrowExceptionIfErr(@"kExtAudioFileProperty_ClientDataFormat", err);
         
      UInt32 numPackets = kSegmentSize; // Frames to read (might be filelength (in frames) to read the whole file)
      UInt32 samples = numPackets<<1; // 2 channels (samples) per frame

      General/AudioBufferList bufList;
      bufList.mNumberBuffers = 1;
      bufList.mBuffers[0].mNumberChannels = 2; // Always 2 channels in this example
      bufList.mBuffers[0].mData = data; // data is a pointer (float*) so our sample buffer
      bufList.mBuffers[0].mDataByteSize = samples * sizeof(Float32);

      UInt32 loadedPackets = numPackets;
      err = General/ExtAudioFileRead(xafref, &loadedPackets, &bufList);
      if (err) 
      {
         _ThrowExceptionIfErr(@"General/ExtAudioFileRead", err);
      }
    
      General/ExtAudioFileDispose(xafref);
   }
   @catch(General/NSException* exception)
   {
      if(data) free(data);
      data = nil;
      
      if(xafref) General/ExtAudioFileDispose(xafref);

      General/NSLog(@"loadSegment: Caught %@: %@", [exception name], [exception reason]);
   }



**CAUTION! There is (at least) one bug in Apple's implementation!** (at least Mac OS X 10.4.5 and older)

The function General/ExtAudioFileSeek sets the file's read position to the specified sample frame number. The next call to General/ExtAudioFileRead will return samples from precisely this location, even if it is located in the middle of a packet. 

Due a bug General/ExtAudioFileSeek is not accurate when used with compressed file formats. It seems that the file offset caused by leading frames in the compressed file header will not be considered by this  function.

Here is a workaround which fixes the problem (at least for MP3 files in my case) until Apple solves the problem:

    
      //
      // WORKAROUND for bug in General/ExtFileAudio
      //
      
      SInt64 headerFrames = 0;
      
      General/AudioConverterRef acRef;
      UInt32 acrsize=sizeof(General/AudioConverterRef);
      err = General/ExtAudioFileGetProperty(xafref, kExtAudioFileProperty_AudioConverter, &acrsize, &acRef);
      _ThrowExceptionIfErr(@"kExtAudioFileProperty_AudioConverter", err);

      General/AudioConverterPrimeInfo primeInfo;
      UInt32 piSize=sizeof(General/AudioConverterPrimeInfo);
      err = General/AudioConverterGetProperty(acRef, kAudioConverterPrimeInfo, &piSize, &primeInfo);
      if(err != kAudioConverterErr_PropertyNotSupported) // Only if decompressing
      {
         _ThrowExceptionIfErr(@"kAudioConverterPrimeInfo", err);
         
         headerFrames=primeInfo.leadingFrames;
      }

      err = General/ExtAudioFileSeek(xafref, (SInt64)segmentStart+headerFrames);
      _ThrowExceptionIfErr(@"General/ExtAudioFileSeek", err);



This bug seems also affecting General/ExtAudioFileTell.

--- Eberhard Rensch, 02/16/2006

----

Edited code to change sample rate from an unusual 41.1kHz to a more conventional 44.1kHz ;)

-- Richard Haig, 04/28/2006