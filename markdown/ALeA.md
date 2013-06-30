Alea (spelled General/ALeA to wikificate it here) is a Cocoa-based game design kit written by General/ToM. It's designed to make it easy to create Secret-of-Monkey-Island style adventure games, but it's got a modular architecture which should be relatively easy to adapt to other forms.

I originally intended to sell it as shareware, but I've decided to release the source code under a BSD license instead. It's available for download at http://alea.sourceforge.net

My reasons for releasing it like this are partly personal (my interests have moved on from Cocoa programming to other things), and partly because I wanted to give something back to this community, which I found to be a fantastic resource while I was writing it (special thanks to General/StevenFrank, General/MikeTrent, General/KritTer, General/ShamylZakariya and others who've helped me enormously over the years without being aware of it). 

That said, any mistakes in it are my own. I haven't looked at this in over a year... I'm not sure if it will work properly on Intel Macs, for example. 

Anyhoo, I hope you enjoy/find this useful. Specific things newbies might find interesting in it are:


* embedding frameworks (cf. General/MoreOnEmbeddingFrameworks);
* General/OpenGL texture mapping (eg. General/OpenGLTextureFromNSImage, General/OpenGLTextureMapping, General/QuickTimeSurfaceTexture);
* General/QuickTime and General/CoreAudio (eg. General/CarbonSound,General/CoreAudio);
* integrating and General/NSOpenGLView into the Cocoa event management mechanism.
* full screen (eg. General/CoregraphicsFullscreen, General/ImplementingFullScreen, General/NSWindowFullScreen);
* plug-ins (cf. General/PlugIns);
* creating a help system (see General/AppleHelp);
* scripting (especially as an example of using General/LuA);
* simulating multi-threading through judicious use of runloops and timers (cf. General/AnimationTimingAndCocoaDiscussion, General/RunLoop).