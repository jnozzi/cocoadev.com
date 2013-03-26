If you want to see through an [[NSTextView]] instance that is the document view of a scroll view, use the following code:

<code>
void [[MakeTextViewBackgroundTransparent]]([[NSTextView]] ''aTextView)
{
	[aTextView setDrawsBackground:NO];
	[[aTextView enclosingScrollView] setDrawsBackground:NO];
	[[[aTextView enclosingScrollView] superview] setNeedsDisplay:YES];
}
</code>

After executing the code, the drawing performed by of whatever view is the superview of the scroll view will be visible behind the text.  The text can be edited and re-displayed normally as needed.

----
On a related note: Overlapping sibling views are '''not''' recommended in the Mac OS X "Tiger" time frame.  From the ADC:
''"Note: For performance reasons, Cocoa does not enforce clipping among sibling views or guarantee correct invalidation and drawing behavior when sibling views overlap. If you want a view to be drawn in front of another view, you should make the front view a subview (or descendant) of the rear view."''

For more information, see http://developer.apple.com/documentation/Cocoa/Conceptual/[[CocoaViewsGuide]]/[[WorkingWithAViewHierarchy]]/chapter_4_section_5.html and http://www.cocoabuilder.com/archive/message/cocoa/2006/8/4/169010.