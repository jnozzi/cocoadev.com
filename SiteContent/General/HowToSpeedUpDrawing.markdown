 
* '''General:'''
* Profile with Shark.
* If you can determine that something won't be visible (for example, it's behind other graphics), don't draw it. Don't worry about your computations slowing things down--a little bit of math is thousands of times faster than filling a rectangle.
* Use <code>-[[[NSView]] setNeedsDisplayInRect:]</code> instead of <code>-[[[NSView]] setNeedsDisplay:]</code> and make the rectangle as small as possible.
* Use <code>-[[[NSView]] getRectsBeingDrawn:count:]</code>. Be extremely wary of the rectangle that gets passed in to <code>-drawRect:</code>--it's probably been grown to encompass every smaller rectangle you carefully marked with <code>-setNeedsDisplayInRect:</code>. If you marked a pixel in three corners, you'd be redrawing the entire view.
* Override <code>-[[[NSView]] wantsDefaultClipping]</code> and return <code>NO</code>. According to the docs, you then have to be very carful not to draw outside of the dirty rects (<code>-getRectsBeingDrawn:count:</code>).
* Override <code>-[[[NSView]] isOpaque]</code> and return <code>YES</code>. You can also vary this dynamically based on the content of your view. It might even be possible to decide based on what areas of your view need display, but that's not tested or recommended.
* If you care more about being responsive than fast, you can <code>-[[[NSView]] displayIfNeeded]</code> (or one of the many variants) as early as possible. If anything, this slows down your actual performance, but you can draw a fraction of a second earlier. You still won't be able to eliminate all lag: if it's an issue, try [[OpenGL]].
* It might be obvious, but avoid sending <code>-[[[NSView]] setNeedsDisplay:NO]</code> if you decide you don't need to redisplay the whole view. If you have a setter that invalidates, give it an argument to let you control whether it should, so you can do the marking in higher-level methods that know more about what's changed.
* Use separate windows for graphical components that change separately from (and draw on top of) the rest of the view. Higher overhead, but you will not be able to do compositing yourself faster than the [[WindowServer]] does. Start by looking up <code>-[[[NSWindow]] addChildWindow:ordered:]</code>.
* If your content takes a long time to render but doesn't change often, cache it in an <code>[[NSImage]]</code> or (on 10.4 and later) a <code>[[CGLayer]]</code>.
* If you want to move graphics around on the screen, use <code>[[NSCopyBits]]()</code>.
* Use [[OpenGL]].

* '''Painting:'''
* When picking an <code>[[NSCompositingOperation]]</code>, choose <code>[[NSCompositeCopy]]</code> over <code>[[NSCompositeSourceOver]]</code> whenever you aren't drawing with an alpha channel. Your can test images with <code>-[[[NSImageRep]] hasAlpha]</code>.
* Don't use <code>[[[[NSBezierPath]] bezierPathWithRect:] fill]</code>. If you need <code>[[NSCompositeSourceOver]]</code>, <code>[[NSRectFillUsingOperation]]()</code> is faster. Otherwise use <code>[[NSRectFill]]()</code>.

* '''Images:'''
* If you draw different parts of the same image frequently, try changing the <code>[[NSImageCacheMode]]</code> to <code>[[NSImageCacheAlways]]</code>. This will cause the image to load completely the first time its drawn, instead of using [[LazyLoading]].
* Images with embedded [[ColorSync]] profiles draw slower. You can get the profile with <code>-[[[NSBitmapImageRep]] valueForProperty:[[NSImageColorSyncProfileData]]]</code> and then use the [[ColorSyncManager]] to process it (for an example, see [[GetColorProfileName]]).

* '''Degrade your content (last resort):'''
* You can try to get away with drawing less or less accurately when <code>-[[[NSView]] inLiveResize]</code> returns <code>YES</code>.
* Turn down image scaling quality by sending <code>-[[[NSGraphicsContext]] setImageInterpolation:]</code> and passing in <code>[[NSImageInterpolationLow]]</code> or <code>[[NSImageInterpolationNone]]</code>.
* You can turn off antialiasing with <code>-[[[NSGraphicsContext]] setShouldAntialias:]</code>. This is not usually worth it, since antialiasing is probably not your bottleneck.



----
This page used to contain a long [[MailingListMode]] -ish discussion about [[HowToDraw]]. Check the history if you're really interested in the gory details.