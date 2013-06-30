I have tried for some time now get the "isFlipped" behaviour of General/NSView into General/CALayer.
The recent try doesn't work at all:

    
- (void) setFrame: (General/NSRect)frameRect;
{
	[super setFrame: frameRect];
	if ( [self isFlipped] && isNotEmpty([self layer]))
		General/self layer] setAffineTransform: 
			[[CGAffineTransformMake (1, 0, 0, -1, 0, General/NSHeight(frameRect) )];
} 

 
Is there a way to make this work, or will I have to wait until (or if) Apple implements this
 (I really HATE working with unflipped coordinates)? Thanks!