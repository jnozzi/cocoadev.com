Has anybody experimented with using General/OpenGL views inside an overlay window. I'm thinking this could be an interesting way to add effects to Cocoa based views/windows?

I'll give it a try but before I do I was wonder if anybody else has tried?

----

I've used overlay windows successfully on top of a General/QTMovieView.  If you want the overlay window to be properly transparent, make sure that:


* your window isn't opaque, i.e. [window setOpaque:NO], and
* Set the General/OpenGL context to also be non-opaque, which you can do by adding the following code snippet into your -prepareOpenGL method:


    
const long opaqueValue = 0;
General/self openGLContext] setValues:&opaqueValue forParameter:[[NSOpenGLCPSurfaceOpacity];


--General/AndrePang

----

Thanks Andre. When I finally get around to trying this I'm sure it will come in handy. Thanks again.