I am trying to get started in using core audio. I created a tone generator using HAL functions, which works very nicely. I now need to convert the sounds into MP3 format and write into a file.

I can't get going at all. I never felt so stupid in my life. I can't find the solution to a problem, which gives me the following compile error:

/usr/bin/ld: Undefined symbols: _AudioConverterDispose _AudioConverterFillComplexBuffer _AudioConverterNew _AudioFileClose _AudioFileCreate _AudioFileWritePackets 

The code calls up these six functions but without an underscore. I suspect that I am not importing a needed header file, or the Core Audio framework is not set up properly, but I ran out of things to try.

I could not find any references to header files or [[XCode]] setup in the Core Audio documentation, though the call that give the problem are described.

I re-downloaded the Core Audio SDK from the Apple web site.

I re-installed Tiger Developer Tool.

I copied the [[MTCoreAudio]].framework into the root Frameworks folder.

I did a Spotlight search, but could not find any header files that contained the [[CoreAudio]] functions I used.

Any suggestions are welcome.

Udo

----

I don't know anything about [[CoreAudio]], but I do know that the linker automatically sticks an underscore in front of function names (and maybe even all globals). This might help you in your search. However I would suspect (as a Panther user who's never tried [[CoreAudio]]) that Apple screwed up when setting up the [[CoreAudio]] framework. --[[JediKnil]]
----
When you get undefined symbols, it's because you're not linking against the library or framework which contains them.
----
Link against <code>/System/Library/Frameworks/[[AudioToolbox]].framework</code> and you should be OK

----

Well, I thought if at first you don't succeed, try again. I experimented some more and found the answer. 

To compile the five functions I used, which are listed in the Apple Core Audio documentation, you do not need <[[CoreAudio]]/[[CoreAudio]].h> but <[[SndKit]]/[[SndKit]].h>. Makes sense, or does it?

Udo

----

Here I am again! Progressing, but stuck once more. The [[SndKit]] framework now links, but I get an error that it can not find lame.h and shout.h header files. The error message is:

''/Library/Frameworks/[[SndKit]].framework/Headers/SndAudioProcessorMP3Encoder.h:29:24: error: shout/shout.h: No such file or directory. ''

Indeed, the SndAudioProcessorMP3Encoder.h file contained in the framework provided by Apple asks for some files not provided by Apple.

I downloaded the lame-3.96.1 distribution and the icecast-2.2.0 distribution. (The latter contains shout.h.)

I searched the [[XCode]] documentation, but found no references as how to install non-apple extensions. The instructions included in the distribution are way above my head. They assume the user knows a lot more than I do. I tried various ways to install the header files alone, and the complete package so that [[XCode]] recognises the header file. I am stuck once more. Again suggestions would be welcome, even if not specific to lame.h, but how to install any third party code into an [[XCode]] project.

Udo

----

I am making progress by finding titbits of information here and there, but mostly by trial and error. I now installed lame, and Xcode finds the libraries. Here is what I did:

1. Downloaded the "lame-3.96.1" distribution from the Internet.

2. Copied the "lame-3.96.1" folder into the "Documents/temp" folder.

3. In terminal set cd to "lame-3.96.1"  folder

4. Type sudo ( + space)

5. Drag config file from "lame-3.96.1" folder into terminal. Follower by <cr>

6. Type sudo make.

7. Type sudo make install.

8. Copied lame.h from [[SndKit]].framework/lame/include to [[SndKit]].framework/Headers (Was this necessary?)

Tried to install icecast libraries the same way, but config failed. Got configure: error: must have Ogg Vorbis v1.0 or above installed. I am downloading the Ogg Vorbis distribution at this moment.

Will keep you posted  ----- Udo

----

To keep you posted as promised: I gave up on this approach.

In the meantime apple posted a nice [[CoreAudio]] example in [[WhackedTV]]. I can  create sound file in various formats with [[WhackedTV]], when my sound generating application and [[WhackedTV]] are running at the same time, AND I connect the headphone jack to Line In jack with a patch cord on my Dual 1.25 [[GHz]] G4.

When I have the [[NSLog]] 2 line, in the example code below, enabled one input and four outputs are listed. However, all my efforts to modify [[WhackedTV]] to get any of the four outputs into the Record Settings Line Input popup button ended in failure, showing my lack of knowledge of [[CoreAudio]]. I also noted that when the single item (Line In) in the input popup button is selected, the (unmodified) selectRecordInputmethod ends up in the bail section of the code. This may or may not be related to my problem to get the other sources onto the Record input button.

I added some [[NSLog]] staments to the selectRecordInput method as follows:

// ---------------
- ([[IBAction]])selectRecordInput:(id)sender
{
    [[OSStatus]] err = noErr;
    [[NSArray]] '' list = nil;
	
    [[NSLog]] (@"arrived in selectRecordInput"); //  <- [[NSLog]] 1
    
    BAILSETERR([mChan getPropertyWithClass: kQTPropertyClass_SGAudioRecordDevice
                             id: kQTSGAudioPropertyID_OutputListWithAttributes
                           size: sizeof(list)
                        address: &list 
					   sizeUsed: NULL]);
  			
    if (list)
    {		
        [[NSDictionary]] '' selDict = [list objectAtIndex:[sender indexOfSelectedItem]];
        UInt32 newSel = 
            [([[NSNumber]]'')[selDict objectForKey:(id)kQTAudioDeviceAttribute_DeviceInputID] 
                unsignedIntValue];
		
		// [[NSLog]] (@"objectForKey = %@, [list objectAtIndex:[sender indexOfSelectedItem]]"); // <- [[NSLog]] 2
        
        BAILSETERR( 
            [self setSGAudioPropertyWithClass: kQTPropertyClass_SGAudioRecordDevice
                                           id: kQTSGAudioPropertyID_InputSelection
                                         size: sizeof(newSel)
                                      address: &newSel] );  // this is line 226 in editor
    }
	    
bail:
    [[NSLog]] (@"arrived in selectRecordInput - bail:"); //  <- [[NSLog]] 3
    [list release];
    return;
}

// ---------------

When I select the only input item in the "Line In" popup button,  I get the following log output:

[Session started at 2005-11-28 00:55:08 -0500.]

2005-11-28 00:55:22.487 [[WhackedTV]][1106] arrived in selectRecordInput

[[SGAudioSettings]].mm:556:-[[[SGAudioSettings]] selectRecordInput:] ### Err -2195

2005-11-28 00:55:22.488 [[WhackedTV]][1106] arrived in selectRecordInput - bail:

Is this intentional considering that there are really no options on the Line In popup button, or is this a bug.

Any hints how to get, for example, the "Line Out" appear in Line Input popup button in [[WhackedTV]] would be appreciated.

Udo

----