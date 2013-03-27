

I have a Cocoa application that subclasses     General/NSView, much like this General/CustomGLView, to do some O<nowiki/>penGL graphics. The context is double buffered, however calls to     General/NSOpenGLContext f<nowiki/>lushBuffer fail in certain situations. The debugger shows me that     f<nowiki/>lushBuffer gets as far as     glsSwapIsBackingStore before failing. 

What would cause     f<nowiki/>lushBuffer to fail?

----
It fails because it's buggy or something. Try calling glFlush() directly.

----
Try to avoid glFlush()... I would suggest first running your code under General/OpenGL profiler to find out if there are any GL errors.