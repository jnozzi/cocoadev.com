Core Image is Apple's new hardware accelerated Framework for creating and using filters, effects and transitions.

More information:
http://developer.apple.com/macosx/coreimage.html

----

Just put some sample code up at http://www.macs.hw.ac.uk/~rpointon/osx/coreimage.html

It shows how to do some core image transitions, with the help of General/NSAnimation. The transition is between two General/NSView.

Also shows some transparency and shadow tricks.

- General/RbrtPntn

----

How do I render a core image to the screen without sucking it back from the video card into main memory first?  The above code begins
to suffer in performance for large windows because it renders the core image as part of an General/NSView within a General/NSWindow. I'm missing
something obvious here...

----

You need to create a General/CIContext from an General/NSOpenGLView and just draw directly inside the drawRect call. Check Apple's example named: General/CIExposureSample.

-- Jacques Lema

----

Does anybody know how to programmatically check if the hardware an application is running on supports Core Image hardware acceleration or not? Is there a certain General/OpenGL extension that must be present for Core Image hardware acceleration to work?

----

You need to check for a card that supports: 'GL_ARB_fragment_program'

Here what I use in General/ChocoFlop to detect this:

    
General/self openGLContext] makeCurrentContext];
const [[GLubyte* strExt = glGetString (GL_EXTENSIONS);
const General/GLubyte* extname = (General/GLubyte*) "GL_ARB_fragment_program";
pixelShadersSupported  = (BOOL)gluCheckExtension(extname, strExt);


I believe the Nvidia 4200Go in G4 Powerbook 12' machines support this but is slower than CPU-based operations. Apple's implementation automatically disables GPU hardware acceleration for this specific device.

-- Jacques Lema

Also check this: http://developer.apple.com/qa/qa2001/qa1218.html

----

I just published Flipr, sample code to do widget-like window flipping - it's a category on General/NSWindow, and uses General/CoreImage and General/NSAnimation.

Details and downloads here: http://www.brockerhoff.net/src/index.html

*General/RainerBrockerhoff*

----
Flipping windows with General/CoreImage is rather wasteful. You're better off flipping them with General/CGSSetWindowWarp. You'll get 60fps on most machines and there's no messy window or shadow redrawing to deal with.

--- General/KelvinNishikawa --

----
I believe the objective was to avoid undocumented General/APIs.  However, can these window effects now be all done by General/CoreAnimation?