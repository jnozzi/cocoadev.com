I have a quick question, and I haven't found a definitive answer through Google, so I thought I'd ask here: Is there a fast, easy way to get an General/NSImage from General/CGImageRef? A method I want to use in my program returns this.

----

I would also like to know how to do this.  Does not seem to be documented well (if at all).

----

Under 10.6:  

    
General/[[NSImage alloc] initWithCGImage:cgImage size:size];

You can pass     General/NSZeroSize if you want     General/NSMakeSize(General/CGImageGetWidth(cgImage), General/CGImageGetHeight(cgImage)).  This argument is present because General/NSImage has a logical size that is distinct from its size in pixels.  General/CGImage doesn't.  

Under 10.5:

    

// Create a bitmap rep from the image...
General/NSBitmapImageRep *bitmapRep = General/[[NSBitmapImageRep alloc] initWithCGImage:cgImage];
// Create an General/NSImage and add the bitmap rep to it...
General/NSImage *image = General/[[NSImage alloc] init];
[image addRepresentation:bitmapRep];
[bitmapRep release];

