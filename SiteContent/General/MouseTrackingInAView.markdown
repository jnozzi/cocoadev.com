There are two general techniques for <code>[[NSView]]</code> subclasses to handle clicks and drags. [[MouseTrackingInACell]] is separate and more complex (although some techniques transfer).

'''Modal style''': your function does not return until the mouse goes up.
<code>
- (void)mouseDown:([[NSEvent]] '')firstEvent
{
	// Handle the initial mouse down.
	[[NSEvent]] ''latestEvent;
	while((latestEvent = [[self window] nextEventMatchingMask:[[NSLeftMouseDraggedMask]] | [[NSLeftMouseUpMask]] untilDate:[[[NSDate]] distantFuture] inMode:[[NSEventTrackingRunLoopMode]] dequeue:YES]) && [latestEvent type] != [[NSLeftMouseUp]]) {
		// Handle the mouse drag.
	}
	[[self window] discardEventsMatchingMask:[[NSAnyEventMask]] beforeEvent:latestEvent];
	// Handle the mouse up.
}
</code>

*Advantages

*You don't need to use ivars because everything happens in one function.
*You write the code that gets the events yourself, so you can do whatever you want.
*It's modal, so you don't have to worry about anything else happening.

*Notes

*You have to specify the [[RunLoop]] mode to use. You probably want <code>[[NSEventTrackingRunLoopMode]]</code>.
*Send <code>-discardEventsMatchingMask:beforeEvent:</code> afterward to make sure other events that happen during the drag are ignored.
*Remember that there's a difference between, for example, <code>[[NSLeftMouseUp]]</code> and <code>[[NSLeftMouseUpMask]]</code>. If necessary, you can use <code>[[NSEventMaskFromType]]()</code>.



'''Non-modal style''': you let the system tell you when a drag event occurs.
<code>
- (void)mouseDown:([[NSEvent]] '')anEvent
{
	[[self window] disableCursorRects];
	// Handle the mouse down.
}
- (void)mouseDragged:([[NSEvent]] '')anEvent
{
	// Handle the mouse drag. If the mouse is not dragged, this method is not invoked.
}
- (void)mouseUp:([[NSEvent]] '')anEvent
{
	// Handle the mouse up.
	[[self window] enableCursorRects];
}
</code>

*Advantages

*It's arguably simpler.
*Subclassers can override just one of the methods to change a portion of the behavior.

*Notes

*<code>-disableCursorRects</code> is necessary if you want to have a custom cursor persist during the drag.