A General/CIImage object represents an immutable image in General/CoreImage.

It is tempting to use General/NSBitmapImageRep in the following manner to build a General/CIImage.
    
General/NSBitmapImageRep * bitmap = ... //bitmap want to convert
General/CIImage *initialCIImage = General/[[CIImage alloc] initWithBitmapImageRep:bitmap];

Be warned, this seems to be unreliable. In particular it seems that the internal bytesPerRow is not a multiple of 16 and
then in some circumstances artifacts like skewing occur (the docs only recommend 16 but don't say it is compulsary - possible Apple bug?)

I've been using the following code with success to draw into a bitmap for use in General/CIImage -- General/RbrtPntn
    
General/NSRect rect = ... the (0,0,width,height) bounds of the final image

// Build an offscreen General/CGContext
int bytesPerRow = rect.size.width*4;			//bytes per row - one byte each for argb
bytesPerRow += (16 - bytesPerRow%16)%16;		// ensure it is a multiple of 16
size_t byteSize = bytesPerRow * rect.size.height;
void * bitmapData = malloc(byteSize); 
//bzero(bitmapData, byteSize); //only necessary if don't draw the entire image
	
General/CGColorSpaceRef colorSpace = General/CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB); 
General/CGContextRef cg = General/CGBitmapContextCreate(bitmapData,
	rect.size.width,
	rect.size.height,
	8, // bits per component
	bytesPerRow,
	colorSpace,
	kCGImageAlphaPremultipliedFirst); //later want kCIFormatARGB8 in General/CIImage

// Ensure the y-axis is flipped
General/CGContextTranslateCTM(cg, 0, rect.size.height);	
General/CGContextScaleCTM(cg, 1.0, -1.0 );
General/CGContextSetPatternPhase(cg, General/CGSizeMake(0,rect.size.height)); 
	
// Draw into the offscreen General/CGContext
General/[NSGraphicsContext saveGraphicsState];
General/NSGraphicsContext * nscg = General/[NSGraphicsContext graphicsContextWithGraphicsPort:cg flipped:NO];
General/[NSGraphicsContext setCurrentContext:nscg];
		
	// Here is where you want to do all of your drawing...
	General/[[NSColor blueColor] set];
	General/[NSBezierPath fillRect:rect];
	// etc, etc...

General/[NSGraphicsContext restoreGraphicsState];
General/CGContextRelease(cg);

// Extract the General/CIImage from the raw bitmap data that was used in the offscreen General/CGContext
General/CIImage * coreimage = General/[[CIImage alloc] 
	initWithBitmapData:General/[NSData dataWithBytesNoCopy:bitmapData length:byteSize] 
	bytesPerRow:bytesPerRow 
	size:General/CGSizeMake(rect.size.width, rect.size.height) 
	format:kCIFormatARGB8
	colorSpace:colorSpace];
	
// Housekeeping
General/CGColorSpaceRelease(colorSpace); 
	
return coreimage;


----
I'm having a lot of trouble making a simple General/NSImage black and white using General/CoreImage (I'm new to it), and turning the General/NSImage to a General/CIImage is the issue. Here is my drawRect code segment:

    
	General/CIContext *bwimage;
	General/CIImage *resimage, *ciresult;
	General/CIFilter *bwfilter;
...
	if (isBlackAndWhite) {
		bwimage = General/[[NSGraphicsContext currentContext] General/CIContext];
		bwfilter = General/[CIFilter filterWithName:@"General/CIColorMonochrome"];
		[bwfilter setDefaults];
		ciresult = General/[CIImage imageWithData:General/self image] [[TIFFRepresentation]];
		[bwfilter setValue:ciresult forKey:@"inputImage"];
		[bwfilter setValue:General/[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor"];
		resimage = [bwfilter valueForKey:@"outputImage"];
		[resimage drawAtPoint:General/NSZeroPoint fromRect:General/NSZeroRect operation:General/NSCompositeSourceOver fraction:1];
	}


This does nothing.

If I use the above function code:

    
// code by Robert Pointon
- (General/CIImage *)coreImageResult
{
	// CODE BY PIETRO GAGLIARDI MODIFYING ORIGINAL
	General/NSRect rect;
	
	rect.origin = General/NSZeroPoint;
	rect.size = General/self image] size];
	// END CODE
	// Build an offscreen [[CGContext
	int bytesPerRow = rect.size.width*4;			//bytes per row - one byte each for argb
	bytesPerRow += (16 - bytesPerRow%16)%16;		// ensure it is a multiple of 16
	size_t byteSize = bytesPerRow * rect.size.height;
	void * bitmapData = malloc(byteSize); 
	//bzero(bitmapData, byteSize); //only necessary if don't draw the entire image
		
	General/CGColorSpaceRef colorSpace = General/CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB); 
	General/CGContextRef cg = General/CGBitmapContextCreate(bitmapData,
		rect.size.width,
		rect.size.height,
		8, // bits per component
		bytesPerRow,
		colorSpace,
		kCGImageAlphaPremultipliedFirst); //later want kCIFormatARGB8 in General/CIImage

	// Ensure the y-axis is flipped
	General/CGContextTranslateCTM(cg, 0, rect.size.height);	
	General/CGContextScaleCTM(cg, 1.0, -1.0 );
	General/CGContextSetPatternPhase(cg, General/CGSizeMake(0,rect.size.height)); 
		
	// Draw into the offscreen General/CGContext
	General/[NSGraphicsContext saveGraphicsState];
	General/NSGraphicsContext * nscg = General/[NSGraphicsContext graphicsContextWithGraphicsPort:cg flipped:NO];
	General/[NSGraphicsContext setCurrentContext:nscg];
			
		// Here is where you want to do all of your drawing...
		// BEGIN CODE BY PIETRO GAGLIARDI, REPLACING OLD CODE
		General/self image] drawInRect:rect fromRect:[[NSZeroRect operation:General/NSCompositeSourceOver fraction:1];
		// END CODE
		// etc, etc...

	General/[NSGraphicsContext restoreGraphicsState];
	General/CGContextRelease(cg);

	// Extract the General/CIImage from the raw bitmap data that was used in the offscreen General/CGContext
	General/CIImage * coreimage = General/[[CIImage alloc] 
		initWithBitmapData:General/[NSData dataWithBytesNoCopy:bitmapData length:byteSize] 
		bytesPerRow:bytesPerRow 
		size:General/CGSizeMake(rect.size.width, rect.size.height) 
		format:kCIFormatARGB8
		colorSpace:colorSpace];
		
	// Housekeeping
	General/CGColorSpaceRelease(colorSpace); 
		
	return coreimage;
}


and do this:

    
		ciresult = [self coreImageResult];


This also does nothing. What am I doing wrong? - General/PietroGagliardi

----