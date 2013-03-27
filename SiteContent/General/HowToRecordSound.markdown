see also (especially) General/CoreAudio and General/CoreAudioAndAudioUnitsTutorial

Can someone give me a heads up for how to get grab sound input?

To start out, I would like to just have a window that has a record button and a stop button.  Pressing the record button would get input from whichever mic was chosen in the System Preferences.  The stop button would stop the recording.  Very simple.  I think in Cocoa you can use General/NSMovie and General/NSMovieView, but I don't see anything in General/NSMovie that allows recording.

Can someone get me started as to what to do or where to look?  Thank you in advance.  - General/AlexanderD

----

Please only put comments if you have constructive input.  I have read the General/CoreAudio manual and the two examples that were given.  I have really given this a lot of thought.  Someone asked for a specific question.  Please see the very specific questions above.  I would really appreciate anyone who is willing to give specific answers to the questions above.  If you don't know how to use General/CoreAudio within a Cocoa program or are unwilling to help then please do not post here.  Rude comments are not what make this board great.  Thank you in advance for any help you can offer me.  Also, it would be nice if people would sign their posts. - General/AlexanderD

----
I think you are looking for General/CoreAudio. I seem to remember someone wrote an Objective-C wrapper for it at one point. Poke around the General/CoreAudio portion of ADC, I believe they provide a link to it.

I tried lookinng in General/CoreAudio, but nothing popped out at me.  Does anyone know how to do recording in Cocoa at the very simplest level?  - General/AlexanderD
----

If it could be done in three to five steps, then it'd be easy enough to copy and paste from the scores of example code people would have posted all over the place. :-) You're wanting a complicated subject to become clear to you. Unfortunately, it doesn't work that way. The only way to make a complicated subject clear is to educate yourself. This honestly is not meant to be a harsh criticism - just the facts. Unless someone is willing to be *VERY* nice and do this work for you, it's up to you to use the help you *have* been given (in the form of copious reference links) and figure it out. If you get stuck on a specific point, ask a specific question and you'll be sure to get a specific question. ;-)

Asking questions and posting on this website is one way for me to educate myself.  The people on this website have always been very helpful in their advice, which is why I posted here.  I have tried looking at every online example that I can find, the Core Audio documentation, and the links above.  It is still not clear to me.  Do you know how to record, and can help me understand the example above at www.mat.edu?  What I have been able to glean from the example above is that there are three libraries included in the object.  I am not sure if the third one is really necessary for recording, or if it is necessary for how this particular person sets up the object.

    
#import <Foundation/Foundation.h>
#import <General/CoreAudio/General/CoreAudio.h>
#import <objc/objc-runtime.h>


Also, it seems like the following functions are probably integral in making the recording.  Is this true?  Could you help me to understand how these functions can be used together to record?

    
General/AudioHardwareGetProperty()  //This function seems to get the default input device
                            // (microphone) and put it in the inDevice variable
General/AudioDeviceAddIOProc()      //This function seems to add the General/IOProc to the device
                            //Can anyone explain what the General/IOProc is and why
                            //it is added to the device?
(*General/AudioDeviceIOProc)(General/AudioDeviceID inDevice, const General/AudioTimeStamp*inNow,
            const General/AudioBufferList *inInputData, const General/AudioTimeStamp *inInputTime,
            General/AudioBufferList *outOutputData,  const General/AudioTimeStamp*inOutputTime,
            void *inClientData); typedef General/OSStatus
                             //I have no idea what this is for or does
General/AudioDeviceGetProperty()    //This function does not seem to be called by anything
General/AudioDeviceStart()          //This function appears to start the recording
General/AudioDeviceStop()           //This function appears to stop the recording
General/AudioDeviceRemoveIOProc()   //This function appears to shut off the device


Then I would like to know where the recording is after you have called audiodevicestart and audiodevicestop.  What would be involved in having this saved as an aiff file?  Hope this helps clarify the problem and thank you in advance for any insight you can bring to my question. - General/AlexanderD

----
> *Also, it seems like the following functions are probably integral in making the recording.  Is this true?*

Yes

> *Could you help me to understand how these functions can be used together to record?*

> "Then I would like to know where the recording is after you have called audiodevicestart and audiodevicestop."

In the example cited above, the recording *data* was passed to the callback.

    
static General/OSStatus ioProc(General/AudioDeviceID inDevice, const General/AudioTimeStamp* inNow, const General/AudioBufferList* inInputData, const General/AudioTimeStamp* inInputTime, General/AudioBufferList* outOutputData, const General/AudioTimeStamp* inOutputTime, void* inClientData);


The reason this is passed back to the program (incrementally in real time) is just another example of "what sounds like something simple to do", is not. General/CoreAudio has no idea what you want to do with the recorded data after it has captured it. Send it to a file? Send it to the speakers?, Send it to an external device? What format? What Quality? What Device? Do you want to massage the data before something else is done with it? The list goes on and on. This is the reason General/CoreAudio punts (like a good API should) and hands the data back to you so you can figure it out.

> *What would be involved in having this saved as an aiff file?*

Core audio has some other interesting concepts, such as General/AudioFile and General/AudioConverter

----

"Asking questions and posting on this website is one way for me to educate myself."
- Indeed, but this is a Cocoa Wiki, not a General/CoreAudio Wiki. Everyone here is more than happy to point you in the right direction and answer specific questions, but nobody is really willing to post a how-to on such a complicated subject. They'd have to go through the same learning process as you to find out how to do exactly what you want to do. Some concepts are just too difficult to post a general how-to - especially if someone wants it in 'three to five steps'. Again, ask specific questions and you'll get specific answers.

----

Exactly...

Recording audio is not a 'three to five steps' process no mater how you try to 'dumb it down'. There are just too many variables involved. For those that think General/CoreAudio is complicated; The WIN32 API to achieve the same thing is far worse in my experience. Consider yourself lucky...

It actually wasn't dumbing down that I needed, it was a general overview.  I am sure there are probably some key ideas or principles to keep in mind when you are using General/CoreAudio to record from a microphone and save as a file.  It seems like the General/CoreAudio documentation starts by looking at all the tiny details.  To get started that doesn't help.  I can't see the forest for the trees.  How about if we start with one or two key concepts to get me started.  I have figured out many things in programming already, so perhaps I'll be able to take it from there.

----

Ok, it seems like, from what people are saying, that it is impossible to record a sound from a microphone and save it to an aiff file in Cocoa.  The only way to do it then is to use General/CoreAudio.  In General/CoreAudio recording is not a simple process "there are just too many variables involved".  Ok, I get that.  Now, every path no matter how long, intricate, complicated, etc, has a beginning.  Assuming that I have a base of Cocoa Programming (such as a familiarity with Interface Builder and General/XCode).  Imagine a situation in which there is a button that calls an action method named "record".  I am trying to find what to put in this method.  What is the first step necessary in recording?  It would appear that the very first thing I need to do is call the function General/AudioHardwareGetProperty() to get the default input device (in my case the built in microphone of my iBook) and store this in a General/AudioDeviceID variable, to be used in later functions.  I need to pass a constant which tells the function that I will be needing the ID of the default hardware device.  I also need to pass a UInt32 which holds the value of the size of a General/AudioDeviceID variable.

So far so good?  Would that be a good place to start?  We could call that step one.

Then, again according to the same example, it would appear that I should call the function General/AudioDeviceAddIOProc().  I need to pass the General/AudioDeviceID variable that I got from the first function, to this second function.  In addition there is an General/AudioDeviceIOProc variable and a void pointer named inClientData in the General/CoreAudio documentation and self in the code example.  What is the General/AudioDeviceIOProc variable?  What role does it play in this recording example.  Ditto for the inClientData variable. - General/AlexanderD

----

How about this. Bring the General/SoundInputGrabber class from the example into your project and use it. It works.

*I tried doing this, and I get the following error when attempting to record:

    General/AudioDeviceAddIOProc returned error 1852797029 ('nope')

Anyone know what's going wrong? Thanks! :-)  - Davey *

Nevermind, found a very good example! Visit this link: http://borkware.com/rants/sound/

- Davey

----

The easiest way is to use General/QuickTime sequence grabber API. Look at General/WhackedTV example code. Basically (without any error checking), it goes like this:


    
#import <Cocoa/Cocoa.h>
#import <General/QuickTime/General/QuickTimeComponents.h>
    // Don't forget to add General/QuickTime.framework to your project

//// Setup

General/SeqGrabComponent sequenceGrabber;
General/OpenADefaultComponent(General/SeqGrabComponentType, 0, &sequenceGrabber);
General/SGInitialize(sequenceGrabber);

General/SGChannel channel;
General/SGNewChannel(sequenceGrabber, General/SGAudioMediaType, &channel);
General/SGSetChannelUsage(channel, seqGrabRecord);

Handle dataRef = NULL;
General/OSType dataRefType = 0;
        
General/QTNewDataReferenceFromFullPathCFString((General/CFStringRef)@"/tmp/General/AudioRecording.mov", 
                                                 (UInt32)kQTNativeDefaultPathStyle, 
                                                 0, 
                                                 &dataRef, 
                                                 &dataRefType);

General/SGSetDataRef(sequenceGrabber, dataRef, dataRefType, seqGrabToDisk);

General/DisposeHandle(dataRef);

//// Recording

General/SGStartRecord(sequenceGrabber);

// Setup a timer to drive the sequence grabber. The timer method should call General/SGIdle(sequenceGrabber)

//// Stoping

General/SGStop(sequenceGrabber);

// Stop also the idle timer

//// Cleanup

General/SGDisposeChannel(sequenceGrabber, channel);
General/CloseComponent(sequenceGrabber);


