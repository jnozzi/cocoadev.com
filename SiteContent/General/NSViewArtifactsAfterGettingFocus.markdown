

I've subclassed an General/NSView to draw an image across it.
This works fine but everytime I press a button or anything else that is in the view (I have dropped a General/NSSearchField on top of the view in IB so it's in the view)
then lines and other artifacts apper around those objects...

http://www.frikkinsoft.eu/screenshot2.png

I've just subclassed -drawRect...

    

- (void)drawRect:(General/NSRect)rect
{	
	General/NSImage *img = General/[NSImage imageNamed:@"General/BottomBar.tif"];

	[img drawInRect: rect  
		   fromRect: General/NSZeroRect 
		  operation: General/NSCompositeSourceOver 
		   fraction: 1.0];
        [img release];
	
	General/NSBezierPath *path = General/[NSBezierPath bezierPathWithRect:rect];
	[path setLineWidth:1];
	General/[[NSColor darkGrayColor] set];
	[path stroke];
}


----

The rect passed in represents the portion of your view that needs to be redrawn - you're assuming it's the whole view.  You can get your whole view's location by sending [self bounds].

The section with the path, for example, draws a gray box around the invalidated area each time.  That's not what you want.