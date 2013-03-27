I need to convert General/NSCachedImageRep to General/NSBitmapImageRep. Is there any API or method to do so?

Thanks,

----
Create an General/NSBitmapImageRep of appropriate size.
Add it to an General/NSImage instance.
lock focus on it.
composit the cached image rep.
unlock focus.
----
That's incorrect.  When you lockFocus on an General/NSImage, that creates an General/NSCachedImageRep (if necessary), throws away the other image image reps, and draws into the cached rep.  An General/NSCachedImageRep is basically an offscreen window where you can draw, and from which it is very efficient to copy bits to another window.  To draw directly into an General/NSBitmapImageRep, you need to use +General/[NSGraphicsContext graphicsContextWithBitmapImageRep:] and +General/[NSGraphicsContext setCurrentContext:].  See http://developer.apple.com/samplecode/Reducer/listing16.html for an example (search the page for setCurrentContext:).