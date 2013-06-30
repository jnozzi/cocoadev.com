

I am reading a tiff into an General/NSImage.
I am creating another General/NSImage.
I am trying to composite the first General/NSImage into the second.

The problem I'm having is that the General/NSImage that I create is always set up at 72 DPI and the General/NSImage that I read in is at various General/DPIs and when I composite the one into the other it changes it's size.

Is there a way to determine the DPI of an General/NSImage so that I can create the new General/NSImage at the same DPI?
----
You can get the actual size of the General/NSImage, and get the pixel size of the General/NSBitmapImageRep which contains the actual TIFF data, and then a simple division gets you the DPI.

----

Here's what I use to show the images at system dpi - which is 72 on Tiger AFAIU - General/BjoernKriews

    
        [image setScalesWhenResized: YES];
        
        General/NSBitmapImageRep *rep = [image bestRepresentationForDevice: nil];
        
        General/NSSize pixelSize = General/NSMakeSize([rep pixelsWide],[rep pixelsHigh]);
        
        [image setSize: pixelSize];

----
Thanks, but that code didn't seem to help.
Still, when I composite the 200 DPI image (that I'm reading in) into the 72 DPI image (that I'm creating), the compositied image is coming in much smaller.
----

You may be better served by skipping General/NSImage altogether and going directly to General/NSBitmapImageRep.
----
I don't see how that will solve my issue - will it?  I mean, I still need to composite one image into another of different size.  And how can I just use General/NSBitmapImageRep without going through an General/NSImage?

Thanks.
----

check out the example code posted here -> General/ImageCompositing

----
Thanks everyone - I see now.  General/NSBitmapImageRep's -size isn't the same as it's -pixelWidth and -pixelHeight.  Setting the my General/NSImage's size to General/NSBitmapImageRep's size does the trick.
----
Thank you!  I wrote my own screen-saver to display iPhoto albums (with more options than the built-in photo savers), and I've been beating my head against my keyboard trying to figure out how to force 72 dpi on the JPG files.  I've got a bunch of slides scanned at very high resolutions that look like postage stamps on my screen.  When I force stretching it get very pixelated images.  This solves my problem nicely.
----