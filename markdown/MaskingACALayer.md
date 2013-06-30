
I couldn't find any examples of using a mask on a General/CALayer, so I'm posting one.  
Just create a custom view and put this code in it to see how they work.

Or download the sample project I created and posted on my blog.

http://allusions.sourceforge.net/cocoamondo/?p=3

-- General/MatthieuCormier

    

- (void)awakeFromNib {    
  [self maskTest]; 
}

- (General/CGImageRef)createMaskImage {
  General/[[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] set];
  
  float minX = 0;
  float minY = 0;
  float maxX = 100;
  float maxY = 100;  
  
  General/NSBezierPath* path = General/[NSBezierPath bezierPath];
  General/NSPoint topLeft     = General/NSMakePoint (minX, maxY);
	General/NSPoint topRight    = General/NSMakePoint (maxX, maxY);
	General/NSPoint bottomRight = General/NSMakePoint (maxX, minY);
	General/NSPoint bottomLeft  = General/NSMakePoint (minX, minY);
  
  General/NSPoint centerPoint = General/NSMakePoint((maxX - minX) * 0.5, (maxY - minY) * 0.5);
  
  [path moveToPoint:topLeft];
  [path lineToPoint:topRight];  
  [path curveToPoint:centerPoint controlPoint1:General/NSMakePoint((maxX - minX) * 0.5, maxY) 
       controlPoint2:centerPoint];  
  [path curveToPoint:bottomRight controlPoint1:General/NSMakePoint((maxX - minX) * 0.5, minY) 
       controlPoint2:bottomRight];
  [path lineToPoint:bottomLeft];
  
  General/NSImage* maskImage = General/[[NSImage alloc] initWithSize:General/NSMakeSize(100, 100)];
  [maskImage lockFocus];
  {
    General/[[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] set];
    [path fill];
    [path stroke];
  }
  [maskImage unlockFocus];
    
 
  General/CGImageSourceRef source;
  
  source = General/CGImageSourceCreateWithData((General/CFDataRef)[maskImage General/TIFFRepresentation], NULL);
  General/CGImageRef maskRef =  General/CGImageSourceCreateImageAtIndex(source, 0, NULL);
  
  [maskImage release];
  return maskRef;
  
}



- (void)maskTest {
  General/CGRect viewFrame = General/NSRectToCGRect( self.frame );
  viewFrame.origin.y = 0;
  
  // create a layer and match its frame to the view's frame
  self.wantsLayer = YES;
  General/CALayer* mainLayer = self.layer;
  mainLayer.name = @"mainLayer";
  mainLayer.frame = viewFrame;
  mainLayer.delegate = self;
  
  // causes the layer content to be drawn in -drawRect:
  [mainLayer setNeedsDisplay];
  
  
  General/CGFloat midX = General/CGRectGetMidX( mainLayer.frame );
  General/CGFloat midY = General/CGRectGetMidY( mainLayer.frame );
  
  // create a "container" layer for all content layers.
  // same frame as the view's master layer, automatically
  // resizes as necessary.    
  General/CALayer* contentContainer = General/[CALayer layer];    
  contentContainer.bounds           = mainLayer.bounds;
  contentContainer.delegate         = self;
  contentContainer.anchorPoint      = General/CGPointMake(0.5,0.5);
  contentContainer.position         = General/CGPointMake( midX, midY );
  contentContainer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
  
  contentContainer.borderWidth = 2.0;
  contentContainer.borderColor = General/SFWhiteColor;
  
  [self.layer addSublayer:contentContainer];
  
  
  General/CALayer* boxLayer = General/[CALayer layer];    
  boxLayer.frame           = General/CGRectMake(0, 0, 100, 100);
  boxLayer.backgroundColor =  General/CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f);
  boxLayer.position = General/CGPointMake(110, 10);
  boxLayer.anchorPoint = General/CGPointMake(0,0);
  
  
  General/CALayer* maskLayer = General/[CALayer layer];    
  maskLayer.frame           = General/CGRectMake(0, 0, 100, 100);
  maskLayer.position = General/CGPointMake(0, 0);
  maskLayer.anchorPoint = General/CGPointMake(0,0);  
  
  General/CGImageRef maskImage = [self createMaskImage];
  [maskLayer setContents:(id)maskImage];


  [boxLayer setMask:maskLayer];
  
  [contentContainer addSublayer:boxLayer];
  
  [contentContainer layoutSublayers];
  [contentContainer layoutIfNeeded]; 
}

