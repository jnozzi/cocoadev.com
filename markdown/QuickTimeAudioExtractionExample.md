

Hello,

I'm trying to use Apple's Audio Extraction API (http://developer.apple.com/quicktime/audioextraction.html) to write a method that will load a WAV file (or any media file, I suppose) and put the audio contents into a buffer of floats.

It's very hacky and full of potential bugs (ie, I've hardcoded the size of the buffers, for a start!) but I'll fix those later. For the time being I want to know why the actual call to General/MovieAudioExtractionFillBuffer is failing with code -2209 (badCallOrderErr), since everything right up to that call runs correctly (or so it appears to in the debugger).

Can anyone see what I'm doing wrong (other than the obvious hack type stuff)?

Any suggestions most appreciated!


- Ade 13/02/06

----

I thought I'd follow up on my original post. I've updated the code below and this mostly works for pretty much any media file containing audio. It takes an General/NSString with a URL (such as @"file:///test.mov"), imports it and stores it as interleaves floats in a buffer called samples* (which you need to provide). sampleCount is a count of the number of samples, too.

Caveat: Bugs lie herein, code could be much more stable but seems to work. Non-stereo files seem to fail, perhaps I have something wrong in the way I set up the asbd. Any comments/advice warmly welcomed.


- Ade 06/03/06

    

float* samples;
UInt32 sampleCount;

// import from a URL, such as file:///test.mov
- (void) importAudioFromFile:(General/NSString*)path {
	
	General/OSErr						error; 
	Handle						dataRef; 
	General/OSType						dataRefType; 
	General/CFURLRef					fileLocation;
	Movie						soundToPlay;
	General/MovieAudioExtractionRef		extractionSessionRef = nil;
	General/AudioChannelLayout*			layout			 = nil;
	UInt32						size				= 0;
	General/AudioStreamBasicDescription	asbd;

	General/NSLog(@"General/EnterMovies...");		
	General/EnterMovies();

	General/NSLog(@"Setting fileLocation...");
	fileLocation = General/CFURLCreateWithString(NULL, path, NULL);

	General/NSLog(@"Creating new data reference...");
	error = General/QTNewDataReferenceFromCFURL(fileLocation, 0, &dataRef, &dataRefType);
	General/NSLog(@"   %d",error);
	
	General/NSLog(@"Creating new movie...");
	short fileID = movieInDataForkResID; 
	short flags = 0; 
	error = General/NewMovieFromDataRef(&soundToPlay, flags, &fileID, dataRef, dataRefType);
	General/NSLog(@"   %d",error);

	General/NSLog(@"Setting movie active...");
	General/SetMovieActive(soundToPlay, TRUE);

	General/NSLog(@"Beginning extraction session...");
	error = General/MovieAudioExtractionBegin(soundToPlay, 0, &extractionSessionRef); 
	General/NSLog(@"   %d",error);

	General/NSLog(@"Getting property info...");
	error = General/MovieAudioExtractionGetPropertyInfo(extractionSessionRef,
			kQTPropertyClass_MovieAudioExtraction_Audio,
			kQTMovieAudioExtractionAudioPropertyID_AudioChannelLayout,
			NULL, &size, NULL);
	General/NSLog(@"   %d",error);
		
	if (error == noErr) {
		// Allocate memory for the channel layout
		layout = calloc(1, size);
		if (layout == nil) {
			error = memFullErr;
			General/NSLog(@"Oops, out of memory");
		}
		// Get the layout for the current extraction configuration.
		// This will have already been expanded into channel descriptions.
		General/NSLog(@"Getting property...");
		error = General/MovieAudioExtractionGetProperty(extractionSessionRef,
				kQTPropertyClass_MovieAudioExtraction_Audio,
				kQTMovieAudioExtractionAudioPropertyID_AudioChannelLayout,
				size, layout, nil);   
		General/NSLog(@"   %d",error);
	}
	
	General/NSLog(@"Getting audio stream basic description (absd)...");
	error = General/MovieAudioExtractionGetProperty(extractionSessionRef,
			kQTPropertyClass_MovieAudioExtraction_Audio,
			kQTMovieAudioExtractionAudioPropertyID_AudioStreamBasicDescription,
			sizeof (asbd), &asbd, nil);
	General/NSLog(@"   %d",error);
	
	General/NSLog(@"   format flags   = %d",asbd.mFormatFlags);
	General/NSLog(@"   sample rate    = %f",asbd.mSampleRate);
	General/NSLog(@"   b/packet       = %d",asbd.mBytesPerPacket);
	General/NSLog(@"   f/packet       = %d",asbd.mFramesPerPacket);
	General/NSLog(@"   b/frame        = %d",asbd.mBytesPerFrame);
	General/NSLog(@"   channels/frame = %d",asbd.mChannelsPerFrame);
	General/NSLog(@"   b/channel      = %d",asbd.mBitsPerChannel);
	
	if (asbd.mChannelsPerFrame != 2) {
		General/NSLog(@"Cannot import non-stereo audio!");
	}
	
	asbd.mFormatFlags = kAudioFormatFlagIsFloat |
						kAudioFormatFlagIsPacked |
						kAudioFormatFlagsNativeEndian; // NOT kAudioFormatFlagIsNonInterleaved!
	asbd.mChannelsPerFrame = 2;
	asbd.mBitsPerChannel = sizeof(float) * 8;
	asbd.mBytesPerFrame = sizeof(float) * asbd.mChannelsPerFrame;
	asbd.mBytesPerPacket = asbd.mBytesPerFrame;

	General/NSLog(@"Setting new asbd...");
	error = General/MovieAudioExtractionSetProperty(extractionSessionRef,
			kQTPropertyClass_MovieAudioExtraction_Audio,
			kQTMovieAudioExtractionAudioPropertyID_AudioStreamBasicDescription,
			sizeof (asbd), &asbd);
	General/NSLog(@"   %d",error);
	
	
	General/NSLog(@"   format flags   = %d",asbd.mFormatFlags);
	General/NSLog(@"   sample rate    = %f",asbd.mSampleRate);
	General/NSLog(@"   b/packet       = %d",asbd.mBytesPerPacket);
	General/NSLog(@"   f/packet       = %d",asbd.mFramesPerPacket);
	General/NSLog(@"   b/frame        = %d",asbd.mBytesPerFrame);
	General/NSLog(@"   channels/frame = %d",asbd.mChannelsPerFrame);
	General/NSLog(@"   b/channel      = %d",asbd.mBitsPerChannel);

	float				numFramesF = asbd.mSampleRate * ((float) General/GetMovieDuration(soundToPlay) / (float) General/GetMovieTimeScale(soundToPlay));
	UInt32				numFrames				= (UInt32) numFramesF;
	General/NSLog(@"numFrames is %d",numFrames);

	UInt32				extractionFlags			= 0;
	General/AudioBufferList*	buffer					= calloc(sizeof(General/AudioBufferList), 1);

	buffer->mNumberBuffers = 1;
	buffer->mBuffers[0].mNumberChannels = asbd.mChannelsPerFrame;
	buffer->mBuffers[0].mDataByteSize = sizeof(float) * buffer->mBuffers[0].mNumberChannels * numFrames;
	
	samples = calloc(buffer->mBuffers[0].mDataByteSize, 1);
	buffer->mBuffers[0].mData = samples;
	sampleCount = numFrames * buffer->mBuffers[0].mNumberChannels;
		
	General/NSLog(@"Filling buffer of audio...");
	error = General/MovieAudioExtractionFillBuffer(extractionSessionRef, &numFrames, buffer, &extractionFlags);
	General/NSLog(@"   %d",error);
	General/NSLog(@"   Extraction flags = %d (contains %d?)",extractionFlags,kQTMovieAudioExtractionComplete);
 	
	General/NSLog(@"Ending extraction session...");
	error = General/MovieAudioExtractionEnd(extractionSessionRef);
	General/NSLog(@"   %d",error);

	General/NSLog(@"General/ExitMovies...");
	General/ExitMovies();

	General/NSLog(@"Loaded %d samples",sampleCount);

}

