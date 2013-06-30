How do you composite text onto images?

----

(Taken from General/ImageCompositing)
    
General/NSImage *canvas = General/[[[NSImage alloc] initWithSize:General/NSMakeSize(100, 100)] autorelease];
[canvas lockFocus];
General/NSString *myString = @"Hello World!";
[myString drawAtPoint:General/NSMakePoint(10, 10) withAttributes:nil];
[canvas unlockFocus];
