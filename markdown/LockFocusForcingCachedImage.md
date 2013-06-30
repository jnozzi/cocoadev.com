

I'm a bit new to Cocoa programming, and I'm having a peculiar problem with General/[NSImage lockFocus].  It seems that simply calling lockFocus on one of my images (I'm trying to composite another over it) removes the General/NSBitmapImageRep representation within the General/NSImage and replaces it with a General/NSCachedImageRep.  Ultimately what I'm trying to do here is create an General/NSImage from a General/PixMap from the General/GWorld of the sequence grabber, modify the image somewhat, then send the new data to General/DecompressSequenceFrameS.

*I know this hasn't been touched in a long time, but...what's the problem with an General/NSCachedImageRep? It's probably the correct response to lockFocus. After all, you can't draw on the General/NSBitmapImageRep...I think.*