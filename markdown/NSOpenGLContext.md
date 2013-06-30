

A wrapper for General/OpenGL in Cocoa. General/NSOpenGLContext lets you display General/OpenGL graphics in a view, or full screen. Internally, it uses CGL to set up General/OpenGL. It's much simpler to use than CGL itself, especially when you're not just drawing full screen. General/NSOpenGLView is even easier to use, but (of course) not as flexible.

You need an General/NSOpenGLPixelFormat in order to create a new General/NSOpenGLContext instance.