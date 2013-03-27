

In my application I am trying to draw thumbnails of different images on another image.

I took the sample code from following link
http://developer.apple.com/documentation/Cocoa/Conceptual/General/CocoaDrawingGuide/index.html#//apple_ref/doc/uid/TP40003290
Which I have modified later for my requirements.

    
General/NSRect offscreenRect = General/NSMakeRect(0.0, 0.0, 1725.0, 1725.0);
General/NSBitmapImageRep* offscreenRep = nil;

offscreenRep = General/[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil
                        pixelsWide:offscreenRect.size.width
                        pixelsHigh:offscreenRect.size.height
                        bitsPerSample:8
                        samplesPerPixel:4
                        hasAlpha:YES
                        isPlanar:NO
                        colorSpaceName:General/NSCalibratedRGBColorSpace
                        bitmapFormat:0
                        bytesPerRow:(4 * offscreenRect.size.width)
                        bitsPerPixel:32];

General/[NSGraphicsContext saveGraphicsState];
General/[NSGraphicsContext setCurrentContext:General/[NSGraphicsContext graphicsContextWithBitmapImageRep:offscreenRep]];

// Draw your content...
General/NSBitmapImageRep* imageRep = General/[[NSBitmapImageRep alloc] initWithData:General/[NSData dataWithContentsOfFile:path]]; //Background image for the container bitmap rep

[imageRep drawInRect:General/NSMakeRect(0, 0, offscreenRep pixelsWide], offscreenRep pixelsHifh])];


General/[NSGraphicsContext restoreGraphicsState];


Problem: Only a small portion of the imageRep, is drawn on offscreenRep.
I have made sure the reolution of offscreenRep to be greater than imageRep. So
imageRep fits onto it.
Any thing wrong in the above code?