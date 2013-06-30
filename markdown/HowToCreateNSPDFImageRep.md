

Does anyone know how to create a General/NSPDFImageRep from a series of drawing commands (such as [bezier stroke] etc.)?

----

If your drawing commands are in an General/NSView then you can simply call:

    
[self writePDFInsideRect:[self bounds] toPasteboard:pb];


which will, in turn, call drawRect: on your General/NSView and translate the drawing commands into a PDF data stream. It's easy to get the General/NSPDFImageRep from the pasteboard. -General/ChrisMeyer

----

Using the same concept issuing drawing commands in a view, it should also be possible to call:

General/NSPDFImageRep *myPDFRep = General/[NSPDFImageRep imageRepWithData:[aView dataWithPDFInsideRect:aRect]];

or

General/NSPDFImageRep *myPDFRep = General/[[NSPDFImageRep alloc] initWithData:[aView dataWithPDFInsideRect:aRect]];

and get the same result. In the first example, don't forget to retain the instance if you want to keep it around. -General/BrockBrandenberg