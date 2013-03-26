

I have a Cocoa application that subclasses <code>[[NSView]]</code>, much like this [[CustomGLView]], to do some O<nowiki/>penGL graphics. The context is double buffered, however calls to <code>[[NSOpenGLContext]] f<nowiki/>lushBuffer</code> fail in certain situations. The debugger shows me that <code>f<nowiki/>lushBuffer</code> gets as far as <code>glsSwapIsBackingStore</code> before failing. 

What would cause <code>f<nowiki/>lushBuffer</code> to fail?

----
It fails because it's buggy or something. Try calling glFlush() directly.

----
Try to avoid glFlush()... I would suggest first running your code under [[OpenGL]] profiler to find out if there are any GL errors.