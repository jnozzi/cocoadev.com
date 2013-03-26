Alea (spelled [[ALeA]] to wikificate it here) is a Cocoa-based game design kit written by [[ToM]]. It's designed to make it easy to create Secret-of-Monkey-Island style adventure games, but it's got a modular architecture which should be relatively easy to adapt to other forms.

I originally intended to sell it as shareware, but I've decided to release the source code under a BSD license instead. It's available for download at http://alea.sourceforge.net

My reasons for releasing it like this are partly personal (my interests have moved on from Cocoa programming to other things), and partly because I wanted to give something back to this community, which I found to be a fantastic resource while I was writing it (special thanks to [[StevenFrank]], [[MikeTrent]], [[KritTer]], [[ShamylZakariya]] and others who've helped me enormously over the years without being aware of it). 

That said, any mistakes in it are my own. I haven't looked at this in over a year... I'm not sure if it will work properly on Intel Macs, for example. 

Anyhoo, I hope you enjoy/find this useful. Specific things newbies might find interesting in it are:


* embedding frameworks (cf. [[MoreOnEmbeddingFrameworks]]);
* [[OpenGL]] texture mapping (eg. [[OpenGLTextureFromNSImage]], [[OpenGLTextureMapping]], [[QuickTimeSurfaceTexture]]);
* [[QuickTime]] and [[CoreAudio]] (eg. [[CarbonSound]],[[CoreAudio]]);
* integrating and [[NSOpenGLView]] into the Cocoa event management mechanism.
* full screen (eg. [[CoregraphicsFullscreen]], [[ImplementingFullScreen]], [[NSWindowFullScreen]]);
* plug-ins (cf. [[PlugIns]]);
* creating a help system (see [[AppleHelp]]);
* scripting (especially as an example of using [[LuA]]);
* simulating multi-threading through judicious use of runloops and timers (cf. [[AnimationTimingAndCocoaDiscussion]], [[RunLoop]]).