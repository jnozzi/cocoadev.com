

I'm trying to fill an [[NSView]] subclass (actually [[ScreenSaverView]] subclass) with [[[NSColor]] clearColor], but [[[NSBezierPath]] fillRect:] doesn't work the way I'd expect. First I run:
<code>
[[self window] setOpaque:0];
[[[[NSColor]] clearColor] set];
[[self window] setBackgroundColor:[[[NSColor]] clearColor]]; // not sure if this is necessary
</code>
Then I try to fill the [[NSView]] with clear with:
<code>[[[NSBezierPath]] fillRect:[self frame]];</code>
but it doesn't work! But the following line does work:
<code>[[NSRectFill]]([self frame]);</code>
What's going on here?

----

You have to refresh the [[NSView]].
----
Does that mean [[NSRectFill]] draws directly onscreen? Will it be copied to the window's offscreen buffer? [[EnglaBenny]]
----
<code>[[NSRectFill]](...);</code> does not overlay onto the background, it simply blasts the pixels in the specified rectangle to whatever [[NSColor]] has been set. However, you can use <code>[[NSRectFillUsingOperation]](...);</code> to (somewhat) mimick the [[NSBezierPath]] method.

----

Ok I ran a side-by-side test on <code>-[[[NSBezierPath]] fillRect:]</code> vs. <code>[[NSRectFill]]()</code>. These are two [[NSViews]] whose <code>drawRect:</code> methods call the rectangle-filling routine, both with pure red at 50% alpha.

http://mcleskey.org/temp/comparison.jpg

Now I think I get it...<code>-[[[NSBezierPath]] fillRect:]</code> overlays a rectangle of the current color over the background.

----

Another difference seems to be that [[NSRectFill]] uses pixel coordinates, whereas fillRect does not.  I.e. if I fill a box e.g. <code>@(10, 10) size: 100x100</code> it will have a fuzzy edge with fillRect (because the coordinate system is offset by half a pixel) which it does not when using [[NSRectFill]].