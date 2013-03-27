

Hi, folks :) sorry my english again

The question is, is there are some special frameworks to grabb frames (video stream) from web camera? I know that Cocoa, General/QiuckTime and other have an interface to work with General/CoreVideo. But may be there is something more simple and more special for grabbing? The thing is that i have Qt application and Cocoa code for camera works incorrect a little, and i think to remake app using may be some of THIS frameworks... If i'll find... 

----

It's pretty easy with a Quartz Composition and a General/QCView.

----

Weeeell, it's for rendering video? May you show me a little code for capturing (like callbacks, getting simple frames, etc) with that General/QuartzComposer?

thnks :)

----

Quartz Composer is a groundbreaking graphics development environment that allows you to explore the incredible power of the graphics stack of Mac OS X Tiger. With Quartz Composer, you can easily combine the capabilities of Cocoa, Quartz 2D, Core Image, General/OpenGL, and General/QuickTime, all using an approachable visual programming paradigm. Use Quartz Composer to prototype Core Image filters, build engaging screen savers, create custom user-interface widgets, make data-driven visual effects, and even perform live performance animations.

Nothing about video capturing ( Is there are something else? General/QuartzCore already used..

----

As another poster said - it's pretty easy with a Quartz Composition and a General/QCView.  Quartz Composer includes modules for video capture - and this is basically what General/PhotoBooth uses.

----

Ok, i'v missed something. I'll look. Is it different from General/QTQuartzPlayer? It is another thing or simply more uplevel? (used in i mean)

----

The question. - (General/IBAction) start:(id)sender; - starting rendering process blah blah.. Is it Cocoa interface (mean General/IBAction)? It's bad, because the problem a have is in that. Something more.. cpp..