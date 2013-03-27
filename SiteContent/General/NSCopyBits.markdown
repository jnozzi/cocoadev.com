

    General/NSCopyBits() lets you copy raw pixels around. It is a thin wrapper around     memcpy().

    General/NSCopyBits(), or something like it, is used in     General/NSClipView when it     -copiesOnScroll.

Officially, you can either pass a valid General/GState or pass     General/NSNullObject (nobody knows what that is, but it apparently means     0) to draw into the current graphics context. Passing a General/GState seems to do nothing though, so take the latter route. You can use it in     -General/[NSView drawRect:] like normal, but     General/NSCopyBits() is primarily useful for General/IncrementalDrawing�it relies on what was already drawn�so it can make sense to use it elsewhere. That means bracketing your drawing with     -lockFocusIfCanDraw and     -unlockFocus.

Copying leaves the source area alone (except where the destination intersects). Normally you will want to draw new content over it.

    General/NSCopyBits() has a number of bugs that prevent me from recommending it wholeheartedly:

* It does *something* different when copying up and to the left vs. down and to the right. General/QuartzDebug shows lots of screen updates in the former directions but none in the latter.
* If you     -lockFocused on your own and want to flush, neither     -General/[NSGraphicsContext flushGraphics] nor     -General/[NSWindow flushWindow] work unless other drawing was done (but only when copying down and to the right).

If you can require General/TigerOrLater, consider using     General/CGLayer.

Copying pixels around is faster than redrawing images, and is much faster than rendering complex content. However, it's slower than:

* Using separate windows to achieve the same effect.
* General/OpenGL on modern machines.


----
*2007/11/23:* The bugs mentioned above seem to have been fixed, either in 10.5 or 10.5.1. Now it works perfectly, and seems to be just as fast as moving an General/OpenGL texture (Mac Mini 1.83GHz, Intel GMA 950). Since I'm not entirely sure what fixed it, and it may still be relevant for 10.5.0, I won't remove the list from this page for now.