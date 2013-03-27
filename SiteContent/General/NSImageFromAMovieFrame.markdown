

Here is better code for extracting an General/NSImage from a General/GWorld that doesn't involve copying pixel by pixel and is easily generalized - General/ChrisMeyer

    

-(General/NSImage *)imageFromGWorld:(General/GWorldPtr)gworld
{
    General/NSParameterAssert( gworld != NULL );
    
    General/PixMapHandle pixMapHandle = General/GetGWorldPixMap( gworld );
    if ( General/LockPixels( pixMapHandle ) )
    {
        Rect portRect;
        General/GetPortBounds( gworld, &portRect );
        int pixels_wide = (portRect.right - portRect.left);
        int pixels_high = (portRect.bottom - portRect.top);
        
        int bps = 8;
        int spp = 4;
        BOOL has_alpha = YES;
        
        General/NSBitmapImageRep *bitmap_rep = General/[[[NSBitmapImageRep alloc]
            initWithBitmapDataPlanes:NULL
                          pixelsWide:pixels_wide
                          pixelsHigh:pixels_high
                       bitsPerSample:bps
                     samplesPerPixel:spp
                            hasAlpha:has_alpha
                            isPlanar:NO
                      colorSpaceName:General/NSDeviceRGBColorSpace
                         bytesPerRow:NULL
                        bitsPerPixel:NULL] autorelease];
        
        General/CGColorSpaceRef dst_colorspaceref = General/CGColorSpaceCreateDeviceRGB();
        
        General/CGImageAlphaInfo dst_alphainfo = has_alpha ? kCGImageAlphaPremultipliedLast : kCGImageAlphaNone;
        
        General/CGContextRef dst_contextref = General/CGBitmapContextCreate( [bitmap_rep bitmapData],
                                                             pixels_wide,
                                                             pixels_high,
                                                             bps,
                                                             [bitmap_rep bytesPerRow],
                                                             dst_colorspaceref,
                                                             dst_alphainfo );

        void *pixBaseAddr = General/GetPixBaseAddr(pixMapHandle);
        
        long pixmapRowBytes = General/GetPixRowBytes(pixMapHandle);
            
        General/CGDataProviderRef dataproviderref = General/CGDataProviderCreateWithData( NULL, pixBaseAddr, pixmapRowBytes * pixels_high, NULL );

        int src_bps = 8;
        int src_spp = 4;
        BOOL src_has_alpha = YES;
        
        General/CGColorSpaceRef src_colorspaceref = General/CGColorSpaceCreateDeviceRGB();
        
        General/CGImageAlphaInfo src_alphainfo = src_has_alpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNone;
        
        General/CGImageRef src_imageref = General/CGImageCreate( pixels_wide,
                                                 pixels_high,
                                                 src_bps,
                                                 src_bps * src_spp,
                                                 pixmapRowBytes,
                                                 src_colorspaceref,
                                                 src_alphainfo,
                                                 dataproviderref,
                                                 NULL,
                                                 NO, // shouldInterpolate
                                                 kCGRenderingIntentDefault );
        
        General/CGRect rect = General/CGRectMake( 0, 0, pixels_wide, pixels_high );
        
        General/CGContextDrawImage( dst_contextref, rect, src_imageref );
        
        General/CGImageRelease( src_imageref );
        General/CGColorSpaceRelease( src_colorspaceref );
        General/CGDataProviderRelease( dataproviderref );
        General/CGContextRelease( dst_contextref );
        General/CGColorSpaceRelease( dst_colorspaceref );
        
        General/UnlockPixels( pixMapHandle );
        
        General/NSImage *image = General/[[[NSImage alloc] initWithSize:General/NSMakeSize(pixels_wide, pixels_high)] autorelease];
        [image addRepresentation:bitmap_rep];
        return image;
    }
    return NULL;
}



----

This is some code I worked up a while ago to extract a single frame from a General/QuickTime movie and return it as an General/NSImage. Portions of this code are derived from Apple's General/QuickTime sample code, specifically General/CocoaVideoFrameFromNSImage ... which achieves almost what this code does, but not in such a self-contained manner. Apple's sample uses General/NSQuickdrawView, and I wanted something that was a bit more abstract and not tied to an General/NSView class. -- General/DrewThaler

    
// ---------------------------------------
//  imageFromMovie:atTime:
// ---------------------------------------
//
- (General/NSImage*)imageFromMovie:(Movie)movie atTime:(General/TimeValue)time
{
    // Pin the time to legal values.
    General/TimeValue duration = General/GetMovieDuration(movie);
    if (time > duration)
        time = duration;
    if (time < 0) time = 0;
    
    // Create an offscreen General/GWorld for the movie to draw into.
    General/GWorldPtr gworld = [self gworldForMovie:movie];
    
    // Set the General/GWorld for the movie.
    General/GDHandle oldDevice;
    General/CGrafPtr oldPort;
    General/GetMovieGWorld(movie,&oldPort,&oldDevice);
    General/SetMovieGWorld(movie,gworld,General/GetGWorldDevice(gworld));
    
    // Advance the movie to the appropriate time value.
    General/SetMovieTimeValue(movie,time);
    
    // Draw the movie.
    General/UpdateMovie(movie);
    General/MoviesTask(movie,0);
    
    // Create an General/NSImage from the General/GWorld.
    General/NSImage *image = [self imageFromGWorld:gworld];
    
    // Restore the previous General/GWorld, then dispose the one we allocated.
    General/SetMovieGWorld(movie,oldPort,oldDevice);
    General/DisposeGWorld(gworld);
    
    return image;
}



// ---------------------------------------
// gworldForMovie:
// ---------------------------------------
//  Get the bounding rectangle of the Movie the create a 32-bit General/GWorld
//  with those dimensions.
//  This General/GWorld will be used for rendering Movie frames into.

-(General/GWorldPtr) gworldForMovie:(Movie)movie
{
    Rect        srcRect;
    General/GWorldPtr   newGWorld = NULL;
    General/CGrafPtr    savedPort;
    General/GDHandle    savedDevice;
    
    General/OSErr err = noErr;
    General/GetGWorld(&savedPort, &savedDevice);

    General/GetMovieBox(movie,&srcRect);
    
    err = General/NewGWorld(&newGWorld,
                    k32ARGBPixelFormat,
                    &srcRect,
                    NULL,
                    NULL,
                    0);
    if (err == noErr)
    {
        if (General/LockPixels(General/GetGWorldPixMap(newGWorld)))
        {
            Rect        portRect;
            General/RGBColor    theBlackColor   = { 0, 0, 0 };
            General/RGBColor    theWhiteColor   = { 65535, 65535, 65535 };

            General/SetGWorld(newGWorld, NULL);
            General/GetPortBounds(newGWorld, &portRect);
            General/RGBBackColor(&theBlackColor);
            General/RGBForeColor(&theWhiteColor);
            General/EraseRect(&portRect);
            
            General/UnlockPixels(General/GetGWorldPixMap(newGWorld));
        }
    }
    
    General/SetGWorld(savedPort, savedDevice);
    General/NSAssert(newGWorld != NULL, @"NULL gworld");
    return newGWorld;
}


// ---------------------------------------
// imageFromGWorld:
// ---------------------------------------
// Convert contents of a gworld to an General/NSImage 
//
-(General/NSImage *)imageFromGWorld:(General/GWorldPtr) gWorldPtr
{
    General/PixMapHandle        pixMapHandle = NULL;
    Ptr                 pixBaseAddr = nil;
    General/NSBitmapImageRep    *imageRep = nil;
    General/NSImage             *image = nil;
    
    General/NSAssert(gWorldPtr != nil, @"nil gWorldPtr");

    // Lock the pixels
    pixMapHandle = General/GetGWorldPixMap(gWorldPtr);
    if (pixMapHandle)
    {
        Rect        portRect;
        unsigned    portWidth, portHeight;
        int         bitsPerSample, samplesPerPixel;
        BOOL        hasAlpha, isPlanar;
        int         destRowBytes;

        General/NSAssert(General/LockPixels(pixMapHandle) != false, @"General/LockPixels returns false");
    
        General/GetPortBounds(gWorldPtr, &portRect);
        portWidth = (portRect.right - portRect.left);
        portHeight = (portRect.bottom - portRect.top);
    
        bitsPerSample   = 8;
        samplesPerPixel = 4;
        hasAlpha        = YES;
        isPlanar        = NO;
        destRowBytes    = portWidth * samplesPerPixel;
        imageRep        = General/[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL 
                                                                pixelsWide:portWidth 
                                                                pixelsHigh:portHeight 
                                                            bitsPerSample:bitsPerSample 
                                                        samplesPerPixel:samplesPerPixel 
                                                                hasAlpha:hasAlpha 
                                                                isPlanar:NO
                                                          colorSpaceName:General/NSDeviceRGBColorSpace 
                                                             bytesPerRow:destRowBytes 
                                                            bitsPerPixel:0];
        if (imageRep)
        {
            char    *theData;
            int     pixmapRowBytes;
            int     rowByte,rowIndex;

            theData = [imageRep bitmapData];
        
            pixBaseAddr = General/GetPixBaseAddr(pixMapHandle);
            if (pixBaseAddr)
            {
                pixmapRowBytes = General/GetPixRowBytes(pixMapHandle);
            
                for (rowIndex=0; rowIndex< portHeight; rowIndex++)
                {
                    unsigned char *dst = theData + rowIndex * destRowBytes;
                    unsigned char *src = pixBaseAddr + rowIndex * pixmapRowBytes;
                    unsigned char a,r,g,b;
                    
                    for (rowByte = 0; rowByte < portWidth; rowByte++)
                    {
                        a = *src++;     // get source Alpha component
                        r = *src++;     // get source Red component
                        g = *src++;     // get source Green component
                        b = *src++;     // get source Blue component  
            
                        *dst++ = r;     // set dest. Alpha component
                        *dst++ = g;     // set dest. Red component
                        *dst++ = b;     // set dest. Green component
                        *dst++ = a;     // set dest. Blue component  
                    }
                }
            
                image = General/[[[NSImage alloc] initWithSize:General/NSMakeSize(portWidth, portHeight)] autorelease];
                if (image)
                {
                    [image addRepresentation:imageRep];
                    [imageRep release];
                }
            }
        }
    }

    General/NSAssert(pixMapHandle != NULL, @"null pixMapHandle");
    General/NSAssert(imageRep != nil, @"nil imageRep");
    General/NSAssert(pixBaseAddr != nil, @"nil pixBaseAddr");
    General/NSAssert(image != nil, @"nil image");

    if (pixMapHandle)
    {
        General/UnlockPixels(pixMapHandle);
    }

    return image;
}


Unless I'm missing something, this code doesn't seem to respect movies that have had changes made to Hue, Saturation, Brightness, Contrast, etc. ?