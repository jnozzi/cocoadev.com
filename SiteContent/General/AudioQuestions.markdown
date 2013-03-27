Feel free to post new questions here but see General/CoreAudioAndAudioUnitsTutorial first; it may point you in the right direction

----

I have a problem using Apple's Audio Extraction API in General/QuickTime 7. I've got some sample code at General/QuickTimeAudioExtractionExample which it would be nice to get working. Any help or advice would be warmly appreciated! - Ade 13/02/06

----

How can I generate MIDI signals in my app that can be registered by General/GarageBand? There are apps like VMK ( http://www.versiontracker.com/dyn/moreinfo/mac/22642 ) which can do this, but I haven't a clue where to start.
--Nick, May 8, 2006

Hia Nick. You will have to do some General/CoreMidi work. I am not sure (I have a passing familiarity with midi), but I think you need to create a virtual endpoint in General/CoreMidi, then connect it in garage band, and off you go. Setting up an endpoint is a very easy task, but unless you use a simple MIDI file reader/streamer, you will have to schedule the midi notes yourself, and I believe (not sure) that this requires some real-time multithreaded programming. Take a look at snoize.com for some example code. I also recall finding more than one Cocoa-General/CoreMIDI bridge on the net, so google about. Also read the General/CoreMIDI API, it is fairly easy. --General/JeremyJurksztowicz

Create a client using General/MIDIClientCreate(), then create a virtual endpoint using General/MIDISourceCreate(). At this point Garage Band will show a popup because it has found a new MIDI input. To send MIDI events, create packets using General/MIDIPacketListInit() and General/MIDIPacketListAdd() and schedule them by passing the packet list and the previously created virtual endpoint to General/MIDIReceived(). The timestamp for a packet is one of the arguments of General/MIDIPacketListAdd(), so you can add packets that will be played in the future. -- Maarten ter Huurne 2011-06-14