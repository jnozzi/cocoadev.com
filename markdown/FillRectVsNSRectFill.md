

I'm trying to fill an General/NSView subclass (actually General/ScreenSaverView subclass) with General/[NSColor clearColor], but General/[NSBezierPath fillRect:] doesn't work the way I'd expect. First I run:
    
General/self window] setOpaque:0];
[[[[NSColor clearColor] set];
General/self window] setBackgroundColor:[[[NSColor clearColor]]; // not sure if this is necessary

Then I try to fill the General/NSView with clear with:
    General/[NSBezierPath fillRect:[self frame]];
but it doesn't work! But the following line does work:
    General/NSRectFill([self frame]);
What's going on here?

----

You have to refresh the General/NSView.
----
Does that mean General/NSRectFill draws directly onscreen? Will it be copied to the window's offscreen buffer? General/EnglaBenny
----
    General/NSRectFill(...); does not overlay onto the background, it simply blasts the pixels in the specified rectangle to whatever General/NSColor has been set. However, you can use     General/NSRectFillUsingOperation(...); to (somewhat) mimick the General/NSBezierPath method.

----

Ok I ran a side-by-side test on     -General/[NSBezierPath fillRect:] vs.     General/NSRectFill(). These are two General/NSViews whose     drawRect: methods call the rectangle-filling routine, both with pure red at 50% alpha.

http://mcleskey.org/temp/comparison.jpg

Now I think I get it...    -General/[NSBezierPath fillRect:] overlays a rectangle of the current color over the background.

----

Another difference seems to be that General/NSRectFill uses pixel coordinates, whereas fillRect does not.  I.e. if I fill a box e.g.     @(10, 10) size: 100x100 it will have a fuzzy edge with fillRect (because the coordinate system is offset by half a pixel) which it does not when using General/NSRectFill.