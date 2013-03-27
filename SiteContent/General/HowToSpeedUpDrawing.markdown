 
* **General:**
* Profile with Shark.
* If you can determine that something won't be visible (for example, it's behind other graphics), don't draw it. Don't worry about your computations slowing things down--a little bit of math is thousands of times faster than filling a rectangle.
* Use     -General/[NSView setNeedsDisplayInRect:] instead of     -General/[NSView setNeedsDisplay:] and make the rectangle as small as possible.
* Use     -General/[NSView getRectsBeingDrawn:count:]. Be extremely wary of the rectangle that gets passed in to     -drawRect:--it's probably been grown to encompass every smaller rectangle you carefully marked with     -setNeedsDisplayInRect:. If you marked a pixel in three corners, you'd be redrawing the entire view.
* Override     -General/[NSView wantsDefaultClipping] and return     NO. According to the docs, you then have to be very carful not to draw outside of the dirty rects (    -getRectsBeingDrawn:count:).
* Override     -General/[NSView isOpaque] and return     YES. You can also vary this dynamically based on the content of your view. It might even be possible to decide based on what areas of your view need display, but that's not tested or recommended.
* If you care more about being responsive than fast, you can     -General/[NSView displayIfNeeded] (or one of the many variants) as early as possible. If anything, this slows down your actual performance, but you can draw a fraction of a second earlier. You still won't be able to eliminate all lag: if it's an issue, try General/OpenGL.
* It might be obvious, but avoid sending     -General/[NSView setNeedsDisplay:NO] if you decide you don't need to redisplay the whole view. If you have a setter that invalidates, give it an argument to let you control whether it should, so you can do the marking in higher-level methods that know more about what's changed.
* Use separate windows for graphical components that change separately from (and draw on top of) the rest of the view. Higher overhead, but you will not be able to do compositing yourself faster than the General/WindowServer does. Start by looking up     -General/[NSWindow addChildWindow:ordered:].
* If your content takes a long time to render but doesn't change often, cache it in an     General/NSImage or (on 10.4 and later) a     General/CGLayer.
* If you want to move graphics around on the screen, use     General/NSCopyBits().
* Use General/OpenGL.

* **Painting:**
* When picking an     General/NSCompositingOperation, choose     General/NSCompositeCopy over     General/NSCompositeSourceOver whenever you aren't drawing with an alpha channel. Your can test images with     -General/[NSImageRep hasAlpha].
* Don't use     General/[[NSBezierPath bezierPathWithRect:] fill]. If you need     General/NSCompositeSourceOver,     General/NSRectFillUsingOperation() is faster. Otherwise use     General/NSRectFill().

* **Images:**
* If you draw different parts of the same image frequently, try changing the     General/NSImageCacheMode to     General/NSImageCacheAlways. This will cause the image to load completely the first time its drawn, instead of using General/LazyLoading.
* Images with embedded General/ColorSync profiles draw slower. You can get the profile with     -General/[NSBitmapImageRep valueForProperty:General/NSImageColorSyncProfileData] and then use the General/ColorSyncManager to process it (for an example, see General/GetColorProfileName).

* **Degrade your content (last resort):**
* You can try to get away with drawing less or less accurately when     -General/[NSView inLiveResize] returns     YES.
* Turn down image scaling quality by sending     -General/[NSGraphicsContext setImageInterpolation:] and passing in     General/NSImageInterpolationLow or     General/NSImageInterpolationNone.
* You can turn off antialiasing with     -General/[NSGraphicsContext setShouldAntialias:]. This is not usually worth it, since antialiasing is probably not your bottleneck.



----
This page used to contain a long General/MailingListMode -ish discussion about General/HowToDraw. Check the history if you're really interested in the gory details.