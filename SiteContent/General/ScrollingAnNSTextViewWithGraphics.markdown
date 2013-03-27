I have a subclass of General/NSTextView that I am drawing some text to (drawAtPoint::) and graphics (General/NSRectFill).  When I enable the scroller in IB it does seem to function as I would expect, ie. the scroller doesn't change as I draw beyond the bounds of the view.

*(I suppose that it might have been better for me to subclass General/NSView and wrap that view in a scrollView, but when I first started this little project I was having trouble getting what I wanted out of my General/NSView subclass.)*

Any thoughts?

----

Don't draw the text yourself, add it to the textStorage of the General/NSTextView.

Also, subclass General/NSTextAttachmentCell and draw your graphics in
    
- (void)drawWithFrame:(General/NSRect)cellFrame
               inView:(General/NSView*)controlView
       characterIndex:(unsigned)charIndex
        layoutManager:(General/NSLayoutManager *)layoutManager;


Charla [ http://charla.sourceforge.net/ ] does this to draw smileys in an General/NSTextView among the text.

Areas of interest: main.m, Parser.m's -insertSmileys:, Smiley.h/m, General/SmileyFileWrapper.h/m and General/AnimatedAttachmentCell.h/m

----
I see.  Thanks.  But what if my view has no text at all?  Just the graphics, that draw off of the viewable "page"?  How then do I let the view know that there is more stuff to see and update the scrollers accordingly?
----
    
[yourDrawingView setPostsBoundsChangedNotifications:YES];
[yourDrawingView setPostsFrameChangedNotifications:YES];

Maybe?