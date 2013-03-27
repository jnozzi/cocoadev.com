

Does anybody know how to save an General/NSImage as a JPEG? General/NSImage has built-in support for producing a TIFF image, but I want JPEG. Would I have to use Quicktime.h for this? Probably. If so, could you give me some code. I don't know how to use Carbon code with Cocoa.

Thanks.

----

You could try this:

    
General/NSArray *representations;
General/NSData *bitmapData;

representations = [myImage representations];

bitmapData = General/[NSBitmapImageRep representationOfImageRepsInArray:representations 
    usingType:General/NSJPEGFileType properties:nil];

[bitmapData writeToFile:@"/Users/bob/General/MyImage.jpeg" atomically:YES];


-- Ibson

----

Thanks, it works great!

----

You may also want to add some Properties for better quality e.g:
    
        bitmapData = General/[NSBitmapImageRep representationOfImageRepsInArray:representations 
            usingType:General/NSJPEGFileType 
            properties:General/[NSDictionary dictionaryWithObject:General/[NSDecimalNumber numberWithFloat:1.0] 
                                                   forKey:General/NSImageCompressionFactor]];


to get an Jpeg you actually want to look at ;-)

dom

----

Has Apple added support for reading/writing Progressive JPEG yet?

*In 10.4 you can add YES (wrapped in an General/NSNumber) for the key General/NSImageProgressive in the properties dictionary to get progressive JPEGS*

----

I'm assuming it uses the General/QuickTime exporter, which means that 0.90 should still make it high quality and much smaller.

An alternate General/NSJPEGImageRep using libjpeg might be interesting.
----
When trying the above code, I get an empty array of representations. I'm using the code in a command line application. Do I have to instantiate other Classes than General/NSAutoReleasePool ? 

Update: Using the code from General/NSImageFromAMovieFrame the code above works. It seems the image has to
have at least one General/NSBitmapImageRep. In the code I used earlier the General/NSImage was based on a General/NSBitmapImageRep...

Martin

----

The code above is good, but if you've done any thing to your General/NSImage after it was created - even if you simply called [image lockFocus], then its internal General/NSBitmapImageRep was prepared for screen drawing and was converted into an General/NSCachedImageRep - and you can no longer just write it out using the code above. I ran into this because I was creating an General/NSImage and/or an General/NSBitmapImageRep from jpeg data, but then attempting to write a string across the lower portion of the image - this works fine, but I could no longer write the image out. As I mentioned above, if I didn't even do the text drawing, but simply called -lockFocus, I could no longer write it out. The solution is to add another step - save the cached image rep as TIFF data, then create another bitmap image rep out of it:

    
// do whatever you need to do to create and/or modify your General/NSImage
General/NSData *imageData = [image  General/TIFFRepresentation];
General/NSBitmapImageRep *imageRep = General/[NSBitmapImageRep imageRepWithData:imageData];
General/NSDictionary *imageProps = General/[NSDictionary dictionaryWithObject:General/[NSNumber numberWithFloat:0.9] forKey:General/NSImageCompressionFactor];
imageData = [imageRep representationUsingType:General/NSJPEGFileType properties:imageProps];
[imageData writeToFile:filename atomically:NO];


(Yes, you can cut out a few of those intermediate variables).

-General/BlakeSeely

Blake's code amendment made it work for me.  Thanks!

General/EcumeDesJours