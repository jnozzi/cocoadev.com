A basic override of drawRect which will show you how much of the view is being redrawn in a given pass.  Useful to help minimize drawing.

    
- (void)drawRect:(General/NSRect)aRect
{
	int percentArea = (aRect.size.width * aRect.size.height) / ([self frame].size.width *[self frame].size.height) * 100;
	General/NSLog(@"General/MyView drawRect: of area %d%% of total", percentArea); 
		
	[super drawRect:aRect];
}
