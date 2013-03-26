

Hi guys,

I'm trying to make a transparent textView and it works when called in <code>awakeFromNib</code>, but when it is called from an [[IBAction]] a textView changes only its color but not transparency. It changes transparency only when I switch to Finder and back (or to another app or just another window in this very app).

I tried to call <code>display</code>, <code>update</code>, <code>invalidateShadow</code> on everything: window, textView, scrollView, window's contentView, and also <code>[[NSApp]] updateWindows</code> without any luck. What can be wrong here?

<code>
- ([[IBAction]])setTransparent:(id)sender
{
	[[NSColor]] ''backColorWithAlpha = [[[NSColor]] colorWithCalibratedRed:0.5
		green:0.5
	       blue:0.5
		alpha:0.5];
	[textView setBackgroundColor:backColorWithAlpha];
	[scrollerView setDrawsBackground:NO];
	[mainWindow setOpaque:NO];
}
</code>