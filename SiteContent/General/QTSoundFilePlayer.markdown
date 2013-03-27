Kurt Revis's General/QTSoundFilePlayer is awesome :)  General/CoreAudio can be incredibly difficult to use, including the fact that there is no obvious way to feed it a sound file from disk. General/QTSoundFilePlayer utilizes General/QuickTime to convert any sound file into the data stream General/CoreAudio uses and allows nearly fully control over the sound playback.  I'm using it in Adium ( http://www.adiumx.com ) to allow us to manage sound volume and, via a small change to General/QTSoundFilePlayer, output device.  General/NSSound offers neither of these possibilities; General/QuickTime allows sound control but has tons of overhead and takes a lot of CPU while playing.

General/QTSoundFilePlayer is available in his General/PlayBufferedSoundFile sample program ( http://www.snoize.com/ ).

--General/EvanSchoenberg

----

**I've been looking for months about HOW TO CONNECT General/QTSoundFilePlayer to a effect General/AudioUnit.**
It seems that it's been developed under General/AudioUnits 1... and now 2 is being used... ???

I need a caritative soul to help me in this... felipe at baytex period net

--Felipe Baytelman