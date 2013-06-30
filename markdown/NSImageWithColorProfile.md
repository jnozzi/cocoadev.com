

I have a source General/NSImage, with a color profile (sRGB, for example). I want to create a new image based on the source one, with the same color profile and colors.

With the example below, the destination image is created OK, P<nowiki/>hotoShop even reports the source and dest image have the same profile, but the colors in the destination are not the same as the source's color.

I'm pretty sure the colors in the destination image are the colors from the source, interpreted using my monitor profile.
If I dont specify a profile before writing the destination image, the profile reported by P<nowiki/>hotoShop is my monitor profile. Applying my monitor profile to the source image in P<nowiki/>hotoShop gives me the destination image.
Specifying the color profile of the destination image just changes the name displayed by P<nowiki/>hotoShop. The colors dont change.

I've Googled, searched General/CocoaBuilder.com, looked at tons of sample code, read the documentation on General/NSBitmapImageRep, General/NSImage, etc..., but I still dont have a clue on how to do it.

Any help would be greatly appreciated.

General/StephanBurlot

----

    
  General/NSData              *colorSyncProfile = nil;
  General/NSRect              srcRect;
  General/NSImage             *dstImage;
  General/NSBitmapImageRep    *dstImageRep;

  General/NSImage *srcImage = General/[[NSImage alloc] initWithContentsOfFile:SRC];
  General/NSBitmapImageRep *theBitmap= General/[NSBitmapImageRep imageRepWithData:[srcImage General/TIFFRepresentation]];

  if (theBitmap != nil)
  {
    // keep a copy of the current color profile
    colorSyncProfile = General/theBitmap valueForProperty:[[NSImageColorSyncProfileData] copy];
    // size the image at 72 dpi
    srcRect = General/NSMakeRect(0, 0, [theBitmap pixelsWide], [theBitmap pixelsHigh]);
    [srcImage setSize:srcRect.size];
  }
  else
  {
    General/NSLog(@"image has no bitmaprep");
    return;
  }

  // allocate destination image
  dstImage = General/[[NSImage alloc] initWithSize:srcRect.size];
  if (dstImage == NULL)
  {
    General/NSLog(@"dstImage is NULL!");
    return;
  }

  dstImageRep  = General/[[NSBitmapImageRep alloc] 
                  initWithBitmapDataPlanes:NULL
                  pixelsWide:srcRect.size.width 
                  pixelsHigh:srcRect.size.height
                  bitsPerSample:[theBitmap bitsPerSample]
                  samplesPerPixel:[theBitmap samplesPerPixel]
                  hasAlpha:[theBitmap hasAlpha]
                  isPlanar:NO
                  colorSpaceName:General/NSCalibratedRGBColorSpace
                  bytesPerRow:nil 
                  bitsPerPixel:nil];

  if (dstImageRep == NULL)
  {
    General/NSLog(@"dstImageRep is NULL!");
    return;
  }

  // set the color profile of the new bitmap
  [dstImageRep setProperty:General/NSImageColorSyncProfileData withValue:colorSyncProfile];
  [dstImage addRepresentation:dstImageRep];
  [dstImageRep release];

  // draw the src image into the destination
  [dstImage setBackgroundColor:General/[NSColor whiteColor]];
  [dstImage lockFocus];
  General/NSEraseRect(srcRect);
  [srcImage drawInRect:srcRect fromRect:srcRect operation:General/NSCompositeCopy fraction:1.0];
  [dstImage unlockFocus];
  [srcImage release];

  // fetch an General/NSBitmapImageRep (we cant save an General/NSCachedBitmap)
  [dstImage lockFocus];
  theBitmap = General/[[NSBitmapImageRep alloc] initWithFocusedViewRect:srcRect];
  [dstImage unlockFocus];

  // set the color profile of the destination
  [theBitmap setProperty:General/NSImageColorSyncProfileData withValue:colorSyncProfile];

  // and write a jpeg
  General/NSData *bitmapData = [(General/NSBitmapImageRep *)theBitmap representationUsingType: General/NSJPEGFileType
            properties:General/[NSDictionary dictionaryWithObject:General/[NSDecimalNumber numberWithFloat:0.8] 
                                                   forKey:General/NSImageCompressionFactor]];
  [bitmapData writeToFile:DST atomically:NO];
