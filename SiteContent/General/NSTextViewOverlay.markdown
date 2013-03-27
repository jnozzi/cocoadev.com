I'm trying to draw small indicator images over-top the text in an General/NSTextView. I want my custom General/NSView to overlay the text view's enclosing scroll view (drawing the images only for the visible region). I'd *really* like it to be all self-contained, so I added it to my General/NSTextView subclass as one .m/.h pair (don't know the proper term).

On awakeFromNib, the General/NSTextView creates an General/OverlayView and gives it its rules (what to look for and draw over). On drawRect, the General/OverlayView then finds all the coordinates of the place to draw, then composites the special images onto itself. This all works just fine.

HOWEVER:

I'm having trouble figuring out to which view to attach the General/OverlayView, what to listen for to redraw only when needed (during scroll, during typing, etc.). Assuming my General/NSTextView is enclosed in a standard General/NSScrollView, to which view do I attach my General/OverlayView so that it's always in the right place and always updating appropriately?

----

Your custom view should be a subview of the General/NSTextView subclass. Then in your General/NSTextView subclass you can override -(void)textDidChange and update your view. Since the custom view is a subview of the General/TextView, scrolling and everything will already be handled.

----

For suggestions about this and related issues, see General/ControlsMixedWithTextHowTo and topics related to General/NSTextAttachment