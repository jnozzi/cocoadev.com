

I have an General/NSWindow with a custom view, General/InnerView as its contentView. Here's the code for General/InnerView

    
- (void) drawRect:(General/NSRect)rect {
	rect = [self frame];
	General/[[NSColor whiteColor] set];
	General/NSRect clearRect = rect;
	clearRect.origin.y += margin;
	clearRect.size.height -= margin;
	General/NSRectFill(clearRect);
	
	if (winCapture==nil || (General/NSEqualSizes([winCapture size],General/[SolWin frame].size)==NO)) {
		if (inCapture++ == 0) {
			General/NSTimer *timer = General/[NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(captureWin:) userInfo:nil repeats:NO];
			General/[[NSRunLoop currentRunLoop] addTimer:timer forMode:General/NSDefaultRunLoopMode];
		}
	} else {
		General/NSRect wrect = General/[SolWin frame];
		wrect.origin = General/NSZeroPoint;
		[winCapture drawInRect:clearRect fromRect:wrect operation:General/NSCompositeSourceOver fraction:1.0];
	}
}
- (void)captureWin:(General/NSTimer*)timer {
	General/NSRect wrect = General/[SolWin frame];
	wrect.origin = General/NSZeroPoint;
	General/NSData *data = General/[SolWin dataWithPDFInsideRect:wrect];
	if (winCapture!=nil)
		[winCapture release];
	winCapture = General/[[NSImage alloc] initWithData:data];
	[self setNeedsDisplay:YES];
	inCapture = 0;
}


The result looks like this:
http://lavacat.com/wiki.gif

Why do I get black corners? -- gekko513
----

What you are seeing is an RGBA image that isn't drawing its alpha component correctly. If you save a tiff of the image and view the tiff in "Preview" you will see the corners drawn correctly. --zootbobbalu

    
- (void)drawRect:(General/NSRect)rect {
	General/[[NSColor redColor] set]; General/NSRectFill(rect);
}

- (void)captureWindow {
	General/NSLog(@"<%p>%s:", self, __PRETTY_FUNCTION__);
	General/NSRect windowFrame = General/self window] frame];
	windowFrame.origin = [[NSZeroPoint;
	General/NSData *data = General/self window] dataWithPDFInsideRect:windowFrame];
	[[NSImage *image = General/[[NSImage alloc] initWithData:data];
	General/NSData *tiff = [image General/TIFFRepresentation];
	[tiff writeToFile:@"/tmp/window.tiff" atomically:YES];
}

- (void)mouseDown:(General/NSEvent *)theEvent {
	[self captureWindow];
}


----

You'll need to override -isOpaque to return NO if you want to draw anything with alpha or transparency.
----
Strange. None of your suggestions seem to work. I even copied the example code from --zoot directly and I still got black corners, also on /tmp/window.tiff. I tried to override isOpaque, for all additional 3 combinations of adding the method to my General/NSWindow subclass S<nowiki/>olWindow and the General/InnerView. I finally tried to remove the [self setOpaque:NO] that I had called in S<nowiki/>olWindow.

Thanks, by the way, for trying to help out, and so quickly, too. -- gekko513

(And if I swap dataWithPDFInsideRect with dataWithEPSInsideRect, I get 3 corners almost correct but the bottom left corner has an even larger black square.)