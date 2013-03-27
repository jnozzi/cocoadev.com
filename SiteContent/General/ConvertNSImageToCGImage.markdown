  I've been searching for a simple way to convert an General/NSImage into a General/CGImage(General/CoreGraphics) but couldn't find anything. So this is the neatest way I could figure via the toll free bridging functions of General/NSData and General/CFData. 

    
    General/NSImage* image = General/[[NSImage alloc] initByReferencingFile: filename]
	General/NSData* cocoaData = General/[NSBitmapImageRep General/TIFFRepresentationOfImageRepsInArray: [image representations]];
	General/CFDataRef carbonData = (General/CFDataRef)cocoaData;
	General/CGImageSourceRef imageSourceRef = General/CGImageSourceCreateWithData(carbonData, NULL);
	     // instead of the NULL above, you can fill a General/CFDictionary full of options
	     // but the default values work for me
	cgImage = General/CGImageSourceCreateImageAtIndex(imageSourceRef, 0, NULL);
	     // again, instead of the NULL above, you can fill a General/CFDictionary full of options if you want


---- What about different representations, can those be saved?
----
Might want to add a release of the imageSourceRef after you have the image... *seems* to fix a leak that 'leaks' was complaining about... i.e.,

    
			General/CFRelease( imageSourceRef );
			imageSourceRef = NULL;


----

Bear in mind that an General/NSImage and General/CGImage are not exactly equivalent objects. An General/NSImage encapsulates a whole variety of formats in a "black box" fashion, including vector images (e.g. PDF). A General/CGImage is always a bitmap wrapped around a block of memory containing pixels. Therefore converting to a General/CGImage always involves rasterizing an image, if it is not in that form already. Code I have sometimes used is given below. It's more involved than that above, and always converts to a 32-bit RGBA format, but it's often useful. --GC

    

@implementation General/NSImage (General/CGImageConversion)

- (General/NSBitmapImageRep*)	bitmap
{
	// returns a 32-bit bitmap rep of the receiver, whatever its original format. The image rep is not added to the image.
	
	General/NSSize size = [self size];

	int rowBytes = ((int)(ceil(size.width)) * 4 + 0x0000000F) & ~0x0000000F; // 16-byte aligned

	General/NSBitmapImageRep *imageRep = General/[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil 
														pixelsWide:size.width 
														pixelsHigh:size.height 
														bitsPerSample:8 
														samplesPerPixel:4 
														hasAlpha:YES 
														isPlanar:NO 
														colorSpaceName:General/NSCalibratedRGBColorSpace 
														bitmapFormat:General/NSAlphaNonpremultipliedBitmapFormat 
														bytesPerRow:rowBytes 
														bitsPerPixel:32];
														
	if ( imageRep == NULL )
		return NULL;
	
	General/NSGraphicsContext* imageContext = General/[NSGraphicsContext graphicsContextWithBitmapImageRep:imageRep];
	
	General/[NSGraphicsContext saveGraphicsState];
	General/[NSGraphicsContext setCurrentContext:imageContext];
	
	[self drawAtPoint:General/NSZeroPoint fromRect:General/NSZeroRect operation:General/NSCompositeCopy fraction:1.0];
	
	General/[NSGraphicsContext restoreGraphicsState];
	
	return [imageRep autorelease];
}


static void General/BitmapReleaseCallback( void* info, const void* data, size_t size )
{
	General/NSBitmapImageRep* bm = (General/NSBitmapImageRep*)info;
	[bm release];
}



- (General/CGImageRef)		cgImage
{
	General/NSBitmapImageRep*	bm = General/self bitmap] retain]; // data provider will release this
	int					rowBytes, width, height;
	
	rowBytes = [bm bytesPerRow];
	width = [bm pixelsWide];
	height = [bm pixelsHigh];

	[[CGDataProviderRef provider = General/CGDataProviderCreateWithData( bm, [bm bitmapData], rowBytes * height, General/BitmapReleaseCallback );
	General/CGColorSpaceRef colorspace = General/CGColorSpaceCreateWithName( kCGColorSpaceGenericRGB );
	General/CGBitmapInfo	bitsInfo = kCGImageAlphaLast;
	
	General/CGImageRef img = General/CGImageCreate( width, height, 8, 32, rowBytes, colorspace, bitsInfo, provider, NULL, NO, kCGRenderingIntentDefault );
	
	General/CGDataProviderRelease( provider );
	General/CGColorSpaceRelease( colorspace );
	
	return img;
}

@end



Update: Now Leopard is public, the following may be of interest:

General/NSBitmapImageRep - Creating from a General/CGImage, Getting a General/CGImage

General/AppKit also includes a new initializer method for creating an General/NSBitmapImageRep from a Quartz General/CGImage:
    - (id)initWithCGImage:(General/CGImageRef)cgImage;
An General/NSBitmapImageRep that is created in this way retains the given General/CGImage as its primary underlying representation, reflecting the General/CGImage's properties as its own and using the General/CGImage to draw when asked to draw.

Since the General/CGImageRef is simply retained by the General/NSBitmapImageRep, its resident image data is referenced instead of being copied. If the General/NSBitmapImageRep is asked for its pixel data (via a -bitmapData or -getBitmapDataPlanes: message), it will oblige by unpacking a copy of the General/CGImage's content to an internal buffer. The resultant pixel data should be considered read-only. Changing it through the returned pointer(s) will not cause the General/CGImage to be re-created.

Regardless of how it was created, an General/NSBitmapImageRep can now be asked to return an autoreleased General/CGImage representation of itself:
    - (General/CGImageRef)General/CGImage;
Using this method may cause the General/CGImage to be created, if the General/NSBitmapImageRep does not already have a General/CGImage representation of itself. Once created, the General/CGImage is owned by the General/NSBitmapImageRep, which is responsible for releasing it when the General/NSBitmapImageRep itself is deallocated.
----
Why are General/NSBitmapImageRep and General/CGImage gratuitously different ?

When Apple was creating Core Graphics after the aquisition of General/NeXT, they obviously already had General/NSBitmapImageRep at their disposal.  They could have either implemented General/CGImage using General/NSBitmapImageRep or reimplemented General/NSBitmapImageRep using General/CGImage or even toll-free bridged General/CGImage and General/NSBitmapImageRep.

Why do we have to copy the data out of an General/NSBitmapImageRep to create a General/CGImage and visa versa.  Why do they store image data differently ?

If the code above is used with an General/NSImage that already has an General/NSBitmapImageRep, two more copies of the image data are created just to get a flippin General/CGImage!  One of the copies is then discarded.  Come on!  This is absurd.

----
The two are considerably different, and not just gratuitously.

General/NSBitmapImageRep is a simple wrapper around a blob of bitmap data. It has a single region of in-memory bitmap data (multiple regions if it's planar) and then various metadata about that bitmap, such as the pixel format, rowbytes, etc.

General/CGImage is a more complex wrapper around more conceptual image data. This data does not have to be bitmap data, and it does not have to be in memory.

In short, General/CGImage is an abstract raster image container with many capabilities which are more akin to General/NSImage than General/NSBitmapImageRep. It serves different needs for different purposes.

If you don't like the redundancy of creating a second copy if your General/NSImage has an General/NSBitmapImageRep, might I suggest that you special-case the the code to use the existing bitmap rep if there is one? -- General/MikeAsh
----
Right above on this very page, the oposite is stated: "Bear in mind that an General/NSImage and General/CGImage are not exactly equivalent objects. An General/NSImage encapsulates a whole variety of formats in a "black box" fashion, including vector images (e.g. PDF). A General/CGImage is always a bitmap wrapped around a block of memory containing pixels. Therefore converting to a General/CGImage always involves rasterizing an image, if it is not in that form already. Code I have sometimes used is given below. It's more involved than that above, and always converts to a 32-bit RGBA format, but it's often useful. --GC"

General/GCImage is indeed a sub-set of General/NSBitbapImageRep and not the superset claimed.

----
What are you talking about? I never said that General/CGImage is equivalent to General/NSImage, nor did I say that General/CGImage was a superset of General/NSBitmapImageRep. General/CGImage is *different* from those two, while combining capabilities of each. This is why there is no simple shortcut way to go from one to the other. -- General/MikeAsh

----
*If the code above is used with an General/NSImage that already has an General/NSBitmapImageRep, two more copies of the image data are created just to get a flippin General/CGImage!  One of the copies is then discarded.  Come on!  This is absurd.*

Whatever Apple's reasoning, we are stuck with it. However, the above code is not making two copies - it's making one. The first copy is made only to ensure that whatever the original format of the General/NSImage (even PDF), the bitmap is in RGBA 32-bit format. The second method wraps the same pixel data in a General/CGImage without copying it - the bitmap rep's data buffer is simply retained by the second object, so when the first is released, ownership of the same pixel buffer passes to the General/CGImage. If your image already has a suitable 32-bit RGBA General/NSBitmapImageRep, you can use that "as is" without the first copy (though the code as given would need to be refactored slightly - maybe make the second method a category on General/NSBitmapImageRep, rather than General/NSImage - which is what Leopard does). --GC

----
Actually this is somewhat wrong; the ownership is not passed, and the General/CGImage will become invalid when the General/NSBitmapImageRep is destroyed. To implement this correctly, data needs to be allocated separately and passed to the General/NSBitmapImageRep, and then a deallocator function needs to be provided to General/CGDataProviderCreateWithData. -- General/MikeAsh

----

Yep, I think you may be right - it's a bit hard to follow the docs on this one. On reflection it looks like the pixel buffer may be leaking, but the General/CGImage doesn't become invalid when the bitmap goes away (it appears to work without any problems as far as rendering the General/CGImage long after the bitmap has been released anyway). Maybe I'm just getting lucky... I'll have another look at it. Thanks. --GC

Update: I have amended the code above so that the General/CGImage effectively retains the General/NSBitmapImageRep (and hence the pixel buffer) it creates, via the data provider. This is then released by the data provider when requested. It's perhaps not the ideal solution but required the smallest change to the code. --GC

----
The overhead of the General/NSBitmapImageRep compared to the data it contains is very small, so I don't see anything wrong with this solution personally, and it's definitely simpler than managing the backing store yourself. -- General/MikeAsh

----
For whatever reason, the code above was telling me:

<Error>: General/CGBitmapContextCreate: unsupported parameter combination: 8 integer bits/component; 32 bits/pixel; 3-component colorspace; kCGImageAlphaLast; 1872 bytes/row.


I fixed it by changing the bitmap format to not specify that the alpha is premultiplied (bitmapFormat:0):


    
	General/NSBitmapImageRep *imageRep = General/[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil 
				pixelsWide:size.width 
				pixelsHigh:size.height 
				bitsPerSample:8 
				samplesPerPixel:4 
				hasAlpha:YES 
				isPlanar:NO 
				colorSpaceName:General/NSCalibratedRGBColorSpace 
				bitmapFormat:0 
				bytesPerRow:rowBytes 
				bitsPerPixel:32];


I was running the code under Leopard, if that makes any difference.