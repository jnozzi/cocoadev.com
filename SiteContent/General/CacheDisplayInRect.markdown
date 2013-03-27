Howdy!

Trying to get the contents of an General/NSView dumped to a bitmap ( it is actually an General/OpenGl View subclass of General/NSView ).

Seems like the following code should do this:

    
General/NSRect l_Rect_Bounds = [aNSView bounds];
General/NSBitmapImageRep *l_NSView_Content_Bitmap = [aNSView bitmapImageRepForCachingDisplayInRect:l_Rect_Bounds ];

// Seems to exit from function here?
[aNSView cacheDisplayInRect:l_Rect_Bounds toBitmapImageRep:l_NSView_Content_Bitmap ];


I am new to Cocoa OBJ C programming. Not sure what would be causing this.

Thanks!
Eric Kinman

----

Check out General/NSView's - (General/NSData *)dataWithPDFInsideRect:(General/NSRect)aRect method. 

Also check out General/HowToUseThisSite and learn to properly format your wiki pages. :-)



Sorry, what would dataWithPDFInsideRect do for me that cacheDisplayRect would not? I am trying to dump the contents of an General/NSView:General/OpenGL view to a QT Movie.

*To be honest, I don't know, since you say, "Not sure what would be causing this." without saying what's being caused. We're left to guess whether you really know what you intend to do. You may want to clarify (or at least initially specify) your problem.*

Good point! The cacheDisplayInRect currently causes the enclosing function to exit back to the caller. Very strange, no errors reported. Does not continue executing the enclosing functions, just dumps. I have not encountered this before. I was wondering if the General/NSView being an General/OpenGL view would be an issue with cacheDisplayRect?

----

General/NSOpenGLView behaves differently from most other views and things like cacheDisplayInRect or dataWithPDFInsideRect don't work with it. You need to use General/OpenGL to get pixel data out of it if that's what you want to do. Look at the glReadPixels() function.

See: General/ScreenShotCode for example code which uses this function to produce a bitmap.

----

Using glReadPixels( x, y, w, h, GL_RGB, GL_UNSIGNED_BYTE, (General/GLvoid*) l_Frame_Data ); Slow, but works for my purposes. Thank you for the time.

*Glad to hear it. Discussion retired.*