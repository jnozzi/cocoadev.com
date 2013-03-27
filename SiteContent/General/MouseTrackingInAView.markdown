There are two general techniques for     General/NSView subclasses to handle clicks and drags. General/MouseTrackingInACell is separate and more complex (although some techniques transfer).

**Modal style**: your function does not return until the mouse goes up.
    
- (void)mouseDown:(General/NSEvent *)firstEvent
{
	// Handle the initial mouse down.
	General/NSEvent *latestEvent;
	while((latestEvent = General/self window] nextEventMatchingMask:[[NSLeftMouseDraggedMask | General/NSLeftMouseUpMask untilDate:General/[NSDate distantFuture] inMode:General/NSEventTrackingRunLoopMode dequeue:YES]) && [latestEvent type] != General/NSLeftMouseUp) {
		// Handle the mouse drag.
	}
	General/self window] discardEventsMatchingMask:[[NSAnyEventMask beforeEvent:latestEvent];
	// Handle the mouse up.
}


*Advantages

*You don't need to use ivars because everything happens in one function.
*You write the code that gets the events yourself, so you can do whatever you want.
*It's modal, so you don't have to worry about anything else happening.

*Notes

*You have to specify the General/RunLoop mode to use. You probably want     General/NSEventTrackingRunLoopMode.
*Send     -discardEventsMatchingMask:beforeEvent: afterward to make sure other events that happen during the drag are ignored.
*Remember that there's a difference between, for example,     General/NSLeftMouseUp and     General/NSLeftMouseUpMask. If necessary, you can use     General/NSEventMaskFromType().



**Non-modal style**: you let the system tell you when a drag event occurs.
    
- (void)mouseDown:(General/NSEvent *)anEvent
{
	General/self window] disableCursorRects];
	// Handle the mouse down.
}
- (void)mouseDragged:([[NSEvent *)anEvent
{
	// Handle the mouse drag. If the mouse is not dragged, this method is not invoked.
}
- (void)mouseUp:(General/NSEvent *)anEvent
{
	// Handle the mouse up.
	[[self window] enableCursorRects];
}


*Advantages

*It's arguably simpler.
*Subclassers can override just one of the methods to change a portion of the behavior.

*Notes

*    -disableCursorRects is necessary if you want to have a custom cursor persist during the drag.