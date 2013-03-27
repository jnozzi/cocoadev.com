Tests whether the specified point is in the rectangle.

Example:
    
- (void)mouseMoved:(General/NSEvent *)theEvent
{
	General/NSPoint mouseLoc = [self convertPoint:[theEvent locationInWindow] toView:nil];
	if (General/NSPointInRect(mouseLoc, [self rectForBall]))
		// *mouse on*
	else
		// *mouse off*
}