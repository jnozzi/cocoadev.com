How do I create a [[NSPanel]] which displays with its titlebar on the left hand side?  I know that I've seen this style of window before on multiple occasions and I'm pretty sure some of those have been in cocoa apps.  It's usually used for floating toolbars (I think it's used this way in Word, among other applications) and that's exactly what I need to use it for.
--Reid Beels

----
I'm ''pretty'' sure you'll have to create your own subclass, set the window's style mask to [[NSBorderlessWindowMask]], then draw your own directly to the window's contentView, tracking dragging through the rect of your custom  titlebar mockup.

----
I've seen it in Carbon apps, never in Cocoa. Word isn't Cocoa. You could probably create a Carbon window like that from Cocoa.

----
I haven't tested this, but it looks like you have to create the window using carbon then use [[NSWindow]]'s initWithWindowRef:

----
I got this working, partially. It doesn't draw the window correctly, but it shows up. Any ideas on how to make it work better (it definitely is a Carbon window still)? Also, it seems that using setFrame:display: doesn't work correctly with the coordinates. In the code below I manually create the bounds. --[[KevinWojniak]]

<code>
[[NSView]] ''contentView = // some view
[[NSRect]] frame = [[NSMakeRect]](100, 100, [[NSWidth]]([contentView frame]), [[NSHeight]]([contentView frame]));
[[NSWindow]] ''cocoaWin = nil;

[[WindowRef]] carbonWin;
Rect bounds = {[[NSMinY]](frame) + [[[[NSStatusBar]] systemStatusBar] thickness],
			[[NSMinX]](frame) + 12,
			[[NSMinY]](frame)+[[NSHeight]](frame),
			[[NSMinX]](frame) + 12 + [[NSWidth]](frame)};
[[OSStatus]] res = [[CreateNewWindow]](kFloatingWindowClass,
							   kWindowCloseBoxAttribute |
							   kWindowCollapseBoxAttribute |
							   kWindowStandardHandlerAttribute |
							   kWindowCompositingAttribute |
							   kWindowSideTitlebarAttribute |
							   kWindowResizableAttribute,
							   &bounds,
							   &carbonWin);

if (res == noErr)
{
	cocoaWin = [[[[NSWindow]] alloc] initWithWindowRef:(void '')carbonWin];
	[cocoaWin setContentView:contentView];
	[cocoaWin makeKeyAndOrderFront:nil];
	// from here on out it gets funky...
}
</code>

----
I got it working fine by [[ORing]] the undocumented value ( 1 << 9 ) to the style mask for an [[NSPanel]]. The close button is going to look way too big, but if you add [[NSUtilityWindowMask]], it looks and works fine (at least on Leopard). I guess we should all lobby Apple to document that value so they don't break it in future versions.