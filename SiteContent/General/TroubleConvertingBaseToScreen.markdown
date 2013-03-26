

I'm writing a method to return a point (in screen coordinates) relative to a view in my application, so I can position a second window there. This should be simple stuff, but for some reason I'm having trouble getting the proper coordinates from the view. The view hierarchy in my application looks a little like this:

<code>
[[NSWindow]]
Window's contentView
[[NSSplitView]]
[[NSTabView]]
Custom View
</code>

In order to convert a point from Custom View to screen coordinates, I have this method:

<code>
- ([[NSPoint]])screenOriginForWindow;
{
	[[NSView]] ''view = [[tabView selectedTabViewItem] view];
	if ( !view )
		return [[NSZeroPoint]];

	float x = [[NSMinX]]( [view frame] );
	float y = [view isFlipped] ? [[NSMinY]]( [view frame] ) : [[NSMaxY]]( [view frame] );
	[[NSPoint]] origin = [view convertPoint:[[NSMakePoint]]( x, y ) toView:nil];

	return [[self window] convertBaseToScreen:origin];
}
</code>

From reading the documentation it seems this should work, but it does not. The [[NSSplitView]] and the Window's contentView work correctly, but anything else seems to be positioned wrong, as if <code>convertPoint</code> isn't doing it's job, or the split view is messing up the frame origin on its subviews somehow. Does anyone have an idea how I'm messing this up?

----

You should convert the point in two steps:


*
1. Convert from view to window coordinates
*
2. Convert from window to screen coordinates


Given a point p inside a view v (p must be in terms of v's bounds, not its frame!):

<code>
[[NSPoint]] windowPoint = [v convertPoint:p toView:nil];
[[NSPoint]] screenPoint = [[v window] convertBaseToScreen:windowPoint];
</code>

Or do it all in one line:

<code>
[[NSPoint]] screenPoint = [[v window] convertBaseToScreen:[v convertPoint:p toView:nil]];
</code>

----
Thank you for your reply. The problem in my code was that I wasn't using the bounding rectangle to create the point-- I didn't realize the frame rectangle wouldn't work!