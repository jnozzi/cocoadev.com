

see also General/CoreAudioAndAudioUnitsTutorial

I am trying to program a simple wave-editor. I�ve heard about the new OS X General/CoreAudio interface, which should make audio programming a lot easier, than in OS 9. Is there any documentation for General/CoreAudio avaible ?

-- General/ThomasSempf

----

General/CoreAudio is a fairly low-level API. General/CarbonSound on the other hand is more your application sound library (include the Carbon framework). I assume your needs are above General/NSSound?

If General/CoreAudio is what you want then check out /Developer/Examples/General/CoreAudio/ for some examples.

General/CoreAudio will do what you want (I think) but there's probably a higher-level way to do it. You should have a look at General/CarbonSound. It's much better documented than General/CoreAudio.

file:///Developer/Documentation/General/QuickTime/INMAC/SOUND/imsoundmgr.htm

or on the web

http://developer.apple.com/techpubs/quicktime/qtdevdocs/INMAC/SOUND/imsoundmgr.htm

My audio programming is probably at the General/NSSound level. In fact I don't think I've ever written a Cocoa app that uses sound for more than a system beep.

Anyone more experienced?

-- General/PeterMonty


*General/CarbonSound (otherwise known as the General/SoundManager) is a deprecated API that no one should be writing to any longer. Use General/CoreAudio or General/QuickTime instead. The reason for this is that the General/SoundManager does not support, and never will support, modern audio hardware with more than two channels and sample rates and bit depths above CD audio. *

-creed

----

Thanks for all the links. By the way, is there any general sound programming documentation out there ?

-- General/ThomasSempf

----

You mean general, non-Mac OS X related documentation? Sorry, like I said, it's not my forte. Google might help.

-- General/PeterMonty

That's all great, but if you want to do something under Cocoa with sound, good luck. You can't even record a sound since there's no method for it. Also, the "sound pause" method doesn't seem to work.

It seems audio sucks big time under Cocoa, which is supposed to be the big reason to develop under OS X.

-jeffrey_hazelwood@yahoo.com

Cocoa is for application development, not audio specifically. That's why we have General/CoreAudio. For a nice Objective-C spin on things, there are the General/SndKit and General/MusicKit (google search should turn something up). I agree that General/NSSound is terrible. But General/CoreAudio is pretty much terrific, if you can figure it out.

-- General/RobRix

Got General/MusicKit and General/SoundKit installed along w/ the assorted libraries. I'm mucking around with it under Cocoa. It plays, pauses, stops and resumes sounds fine. Can't get it to record from the internal mic. Shouldn't that be the codec mic?

-jeffrey_hazelwood@yahoo.com

----

Thanks for all the tips and links

-- General/ThomasSempf

http://pete.yandell.com/ has some audio programming info, or did last I checked. HTH, -- General/RobRix

----

Also, check out General/MTCoreAudio Framework at http://aldebaran.armory.com/~zenomt/macosx/General/MTCoreAudio/

And there's some example code in the DGC Examples at the omni site (don't have the URL handy).

-- General/JayPrince

Found the URL: http://www.omnigroup.com/developer/gamedevelopment/gdc2001/ -- General/RobRix

----

If you're doing an audio sample editor, you probably want to look at General/AudioUnits in addition to General/CoreAudio. They'll give you effects for free.

----

I found General/MTCoreAudio to be very difficult to use, unless you already know what you're doing with the standard General/CoreAudio.  General/SndKit seems to work well for me; the included "recsnd" example records from my internal mic just fine, after a simple build with Xcode.

// Daniel Currie

----

I've been looking for months about HOW TO CONNECT General/QTSoundFilePlayer to a effect General/AudioUnit?. It seems that it's been developed under General/AudioUnits 1... and now 2 is being used... ???

I'm using General/QTSoundFilePlayer because it's the only example project that allows you to playback an audio file and jump into a precise location within the file. If theres is any other project doing this based on General/CoreAudio, please contact me.

I need to playback audio files (MP3, AAC: already doing it with General/QuickTime as decoder, passing the audio to an Output General/AudioUnit), control volume (easy), change the playback position (QT does it), add effects (I cannot manage to connect QT General/AudioUnit to an Effect one), get the sound wave (???), etc... (Big project)

--Felipe Baytelman  (felipe at baytex period net)

----

How do I play simple tones? I just want to say "Generate a tone at X Hz for Y seconds via the speakers".. I'm creating a morse-code learning program.

Thanks,
--Geoffrey Gallaway

----

I'd also like to specify "Generate a tone at X Hz for Y seconds via the speakers" (well, I'd like to generate two tones concurrently, I need to create a DTMF generator). Any help would be greatly appreciated.

Thanks,
--Jon Nathan

----
I could put that to use too. --thirded = @"The third person.";

----
I had some good luck with Apple's CASoundLab2 example: http://developer.apple.com/samplecode/CASoundLab2/CASoundLab2.html
--JN

----

Hi, I'd like to know if its possible to do the inverse thing, couse i need to decode dtmf codes in a cocoa app... :\
-- Yuchi

----
Oooh, me too! Me too! Anyone have ideas on how to decode DTMF tones or if it's even possible without an external decoder?

----
It's certainly possible, but you get into fun sound-processing stuff. It's way easier to generate a tone than it is to recognize one. I don't know a lot about this stuff, but you'll probably want to take a look at the Fast Fourier Transform (I believe Apple has an implementation in Accelerate.framework or vecLib) and see what that can give you.

----
For decoding DTMF and even more complex stuff you could use the General/GNUradio http://www.gnu.org/software/gnuradio/

I got good sound editing program, try http://www.fleximusic.com/

----

Sycamore - an Objective-C Framework that simplifies using General/CoreAudio from Cocoa 

http://www.illposed.com/software/

----

General/MTCoreAudio.framework

http://aldebaran.armory.com/~zenomt/macosx/General/MTCoreAudio/