

I want to convert General/NSBitmapImageReps from any colour format into grayscale General/NSBitmapImageReps. To cover the widest possible range of possible input General/NSBitmapImageRep formats, I am following the advice in the Cocoa drawing guide (Cocoa Drawing Guide > Images > Working with Images > Converting Between Color Spaces) of translating the General/NSBitmapImageRep into a General/CGImage. To preserve the highest possible bit depth, the General/CGContext containing the General/CGImage was made with floating point precision (kCGBitmapFloatComponents). To conform to my desired target format, the General/CGBitmapInfo also specified no alpha (kCGImageAlphaNone) and the General/CGColorSpace was set to kCGColorSpaceGenericGray. Despite this being my first excursion into Quartz, this all seems to work fine.

I then need to recover the General/CGImage as a General/NSBitmapImageRep. The Cocoa drawing guide shows how to do this by drawing into an General/NSImage, thereby creating an General/NSCachedImageRep. When I try to recover the image into General/NSBitmapImageRep by getting General/TIFFRepresentation, it seems to have been turned back into a standard RGBA image. So I tried to use the new General/NSGraphicsContext method, graphicsContextWithBitmapImageRep. This allows you to create a General/CGContext graphics context where you can draw directly into a specified General/NSBitmapImageRep. My code is here (the General/CGImage is called theCGImage and its coordinates are given in imageRect).

    
General/NSBitmapImageRep *grayscaleBitmap = General/[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil 
				pixelsWide:imageWidth pixelsHigh:imageHeight  
				bitsPerSample: 8*sizeof(float)
				samplesPerPixel:1 
				hasAlpha:NO
				isPlanar:NO
				colorSpaceName:General/NSCalibratedWhiteColorSpace  
				bitmapFormat:General/NSFloatingPointSamplesBitmapFormat 
				bytesPerRow:0
				bitsPerPixel:0];

General/NSGraphicsContext* aBitmapGC=
		General/[NSGraphicsContext graphicsContextWithBitmapImageRep:grayscaleBitmap];

General/CGContextRef imageContext = (General/CGContextRef)[aBitmapGC graphicsPort];

General/CGContextDrawImage(imageContext, *(General/CGRect*)&imageRect, theCGImage);


When I run this, I get a completely black image. The error log tells me:
<code>
General/CGBitmapContextCreate: unsupported parameter combination: 32 integer bits/component; 32 bits/pixel; 1-component colorspace; kCGImageAlphaNone.
</code>


I think the overall approach is fine, because if I set the General/NSBitmapImageRep to a more standard format (bitsPerSample 8, bitmapFormat 0), I get a standard 8-bit grayscale representation of the image. So what is it that General/CGBitmapContextCreate doesn’t like? It worries me that the error log says I’m trying to create 32 integer bits/component rather than a float. One idea I entertained is that the General/NSBitmapImageRep has to conform to a representation supported by General/CGImage. In the Quartz 2D Programming Guide (Quartz 2D Programming Guide > Graphics Contexts > Creating a Bitmap Graphics Context > Supported Pixel Formats) it says there is one floating point grayscale format. Rather surprisingly it is described as 128 bits per pixel, 32 bits per component, (kCGImageAlphaNone | kCGBitmapFloatComponents) as though it stores it like a regular RGBA representation, but only using one of the four available floats (or using all three RGB samples set to the same value). But if I try to set up my General/NSBitmapImageRep to mimic this (bitsPerSample 32, samplesPerPixel 4, bitmapFormat General/NSFloatingPointSamplesBitmapFormat) I get the error message: 
<code>
Inconsistent set of values to create General/NSBitmapImageRep.
</code>

Is this a bug in General/NSBitmapImageRep that can’t properly deal with floating point sample specification, or am I doing something wrong? Or should I be extracting the image data from the General/CGImage in a different way?

Thanks in advance, General/JulianBlow

----

I’ve found a different way of getting the data out of the General/CGImage, by directly exporting the image data as General/NSData and using this to create an General/NSBitmapImageRep:

    
General/NSMutableData* imageData = General/[NSMutableData data];
General/CGImageDestinationRef destCG=
			General/CGImageDestinationCreateWithData((General/CFMutableDataRef)imageData,
			kUTTypeTIFF,1,NULL);
General/CGImageDestinationAddImage(destCG, theCGImage, NULL);
General/CGImageDestinationFinalize(destCG);
	
General/NSBitmapImageRep *grayscaleBitmap=General/[[NSBitmapImageRep alloc] initWithData:imageData];
General/CGImageRelease(theCGImage);
General/CFRelease(destCG);


This produces a grayscale 32 bit float image as required. I’m still interested in why drawing into the General/NSBitmapImageRep doesn’t work though.

Julian