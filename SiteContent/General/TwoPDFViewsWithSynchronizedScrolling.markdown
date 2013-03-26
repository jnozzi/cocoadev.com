

I'm trying to synchronize the scrolling of two [[PDFViews]].

I have created a subclass called, "[[SynchroScrollView]]" which was described in the Scroll View Programming Guide. http://developer.apple.com/documentation/Cocoa/Conceptual/[[NSScrollViewGuide]]/index.html

My problem is I can't figure out how to swap the [[NSScroller]](s) that currently come as subviews of the [[PDFView]] class with the [[SynchroScrollView]] instances. I'd rather not build a [[PDFViewer]] from scratch, but if I have to, I guess I'll have to.

Some info:
My window's contentView includes a  [[PDFView]] as well as some other outlets.
The [[PDFView]]'s subviews are two [[NSScrollViews]] (I don't know why there are two...for vertical and horizontal is all I can guess);
Each [[NSScrollView]] has an [[NSClipView]] as a subview and each [[NSClipView]] has a [[PDFMatteView]].


Also, I'm happy to hear any other solutions to the synchronization problem if you have them.

Thank you.
----
You could try switching to the hierarchial view in IB, selecting the [[NSScrollView]]<nowiki/>s, and then using the inspector panel, choosing a custom class, i.e. your S<nowiki/>ynchroScrollView. Should work. --[[JediKnil]]

----
Thanks [[JediKnil]], I've never used hierarchical view before and I'm glad you suggested it because now I know about it and it looks like a pretty valuable tool. That being said, when I looked at [[PDFView]] within the hierarchical view, there were no disclosure triangles to suggest that there were subviews for [[PDFView]]...maybe I'm missing something...any other ideas?
-[[EricB]]

----
Oops...sorry...I assumed [[PDFView]] was like the other scrollable views in IB. I guess it needs a more specific way to scroll, with the pages and all. OK, I take back what I said. So, sorry, but I haven't worked with the PDF Kit before. So I'll offer one risky suggestion...make ALL scroll views that come out of a nib S<nowiki/>ynchroScrollViews, using <code>setClass:forClassName:</code>. Then connect the scroll views yourself, which itself is risky because you can't get at them besides getting the subviews. But probably you should wait for someone better with PDF Kit to come along. And Apple does say, on the [[PDFView]] page, that "''you can also create a custom PDF viewer by using the PDF Kit utility classes directly and not using [[PDFView]] at all.''" --[[JediKnil]]

----
Another enlightening recommendation...I've learned alot by following through on it though I still can't get the [[PDFView]] instances subviews (normally [[NSScrollView]]) to actually be [[SyncroScrollView]] instances with this method... I'll keep trying though I'm still open to other solutions...thanks again [[JediKnil]].

----
Well, now the two [[PDFView]] subclass instance subviews are showing up as [[SynchroScrollView]] so at least that's good...I used:

<code>
- (id) initWithCoder: ([[NSCoder]] '') decoder
{
        BOOL useSetClass = NO;
        BOOL useDecodeClassName = NO;
	
        if ( [decoder respondsToSelector: @selector
		(setClass:forClassName:)] ) {
		useSetClass = YES;
		[([[NSKeyedUnarchiver]] '') decoder setClass: [[[SynchroScrollView]] class] forClassName: @"[[NSScrollView]]"];
		
	}
        else if ( [decoder respondsToSelector: @selector
		(decodeClassName:asClassName:)] ) {
		useDecodeClassName = YES;
		[([[NSUnarchiver]] '') decoder decodeClassName: @"[[NSScrollView]]" asClassName: @"[[SynchroScrollView]]"];
	}
	
        self = [super initWithCoder: decoder];
	
         if ( useSetClass ) {
		[([[NSKeyedUnarchiver]] '') decoder setClass: [[[SynchroScrollView]] class] forClassName: @"[[NSScrollView]]"];
	}
	else if ( useDecodeClassName ) {
		[([[NSUnarchiver]] '') decoder decodeClassName: @"[[NSScrollView]]" asClassName: @"[[SynchroScrollView]]"];
	}
        return self;
}
</code>

The only thing I don't understand - the output from <code>[[NSLog]](@"[[ScrollViews]] %@", [[self pdfView] )</code> is "<code>2007-01-02 11:49:01.848 [[RealEyes]][5866] [[ScrollViews]] (<[[SynchroScrollView]]: 0x37a420>, <[[NSScrollView]]: 0x5215f00>)</code>"...why aren't they both [[SynchroScrollView]]?

----
''Your code was all brokenly formatted, I fixed it up. See [[TextFormattingRules]] for info on how to make your code show up properly.

----
After creating my own [[PDFKitViewer]], I came up with a more elegant solution, adding a [[SynchroScrollView]] category to [[NSScrollView]]. My code is below. - [[EricBadros]]

<code>
#import <Appkit/[[NSScrollView]].h>
@interface [[NSScrollView]] ([[SynchroScrollView]])

	[[NSScrollView]]'' synchronizedScrollView; // not retained, global
	


- (void)setSynchronizedScrollView:([[NSScrollView]]'')scrollview;
- (void)stopSynchronizing;
- (void)synchronizedViewContentBoundsDidChange:([[NSNotification]] '')notification;
@end

@implementation [[NSScrollView]] ([[SynchroScrollView]])

	- (void)setSynchronizedScrollView:([[NSScrollView]]'')scrollview
	{
		[[NSView]] ''synchronizedContentView;
		
		// stop an existing scroll view synchronizing
		[self stopSynchronizing];
		
		// don't retain the watched view, because we assume that it will
		// be retained by the view hierarchy for as long as we're around.
		synchronizedScrollView = scrollview;
		
		// get the content view of the 
		synchronizedContentView=[synchronizedScrollView contentView];
		
		// Make sure the watched view is sending bounds changed
		// notifications (which is probably does anyway, but calling
		// this again won't hurt).
		[synchronizedContentView setPostsBoundsChangedNotifications:YES];
		
		// a register for those notifications on the synchronized content view.
		[[[[NSNotificationCenter]] defaultCenter] addObserver:self
                                                                           selector:@selector(synchronizedViewContentBoundsDidChange:)
				                                              name:[[NSViewBoundsDidChangeNotification]]
							                     object:synchronizedContentView];
		
	}
	
	- (void)synchronizedViewContentBoundsDidChange:([[NSNotification]] '')notification
	{
		// get the changed content view from the notification
		[[NSView]] ''changedContentView=[notification object];
		
		// get the origin of the [[NSClipView]] of the scroll view that
		// we're watching
		[[NSPoint]] changedBoundsOrigin = [changedContentView bounds].origin;
		
		// get our current origin
		[[NSPoint]] curOffset = [[self contentView] bounds].origin;
		[[NSPoint]] newOffset = curOffset;
		
		// scrolling is synchronized in the vertical plane
		// so only modify the y component of the offset
		newOffset.y = changedBoundsOrigin.y;
		
		// if our synced position is different from our current
		// position, reposition our content view
		if (![[NSEqualPoints]](curOffset, changedBoundsOrigin))
			{
			// note that a scroll view watching this one will
			// get notified here
			[[self contentView] scrollToPoint:newOffset];
			
			// we have to tell the [[NSScrollView]] to update its
			// scrollers
			[self reflectScrolledClipView:[self contentView]];
			}
	}
	
	- (void)stopSynchronizing
	{
		if (synchronizedScrollView != nil) {
			[[NSView]]'' synchronizedContentView = [synchronizedScrollView contentView];
			// remove any existing notification registration		
			[[[[NSNotificationCenter]] defaultCenter] removeObserver:self	name:[[NSViewBoundsDidChangeNotification]] object:synchronizedContentView];
			
			// set synchronizedScrollView to nil
			synchronizedScrollView=nil;
		}
		
	}
+ ([[NSCursor]] '') dragCursor
{
    static [[NSCursor]]  ''openHandCursor = nil;
	
    if (openHandCursor == nil)
		{
        [[NSImage]]    ''image;
        image = [[[NSImage]] imageNamed: @"fingerCursor"];
        openHandCursor = [[[[NSCursor]] alloc] initWithImage: image hotSpot: [[NSMakePoint]] (8, 8)]; // guess that the center is good
		}
	
    return openHandCursor;
}



//  canScroll -- Return YES if the user could scroll.
- (BOOL) canScroll
{
    if ([[self documentView] frame].size.height > [self documentVisibleRect].size.height)
        return YES;
    if ([[self documentView] frame].size.width > [self documentVisibleRect].size.width)
        return YES;
	
    return NO;
}



//  tile -- Override to update the document cursor.
/''- (void) tile
{
    //[super tile];
	
    //  If the user can scroll right now, make our document cursor reflect that.
	if ([self canScroll])
        [self setDocumentCursor: [[self class] dragCursor]];
    else
        [self setDocumentCursor: [[[NSCursor]] arrowCursor]];
}''/



//  dragDocumentWithMouseDown: -- Given a mousedown event, which should be in
//  our document view, track the mouse to let the user drag the document.
- (BOOL) dragDocumentWithMouseDown: ([[NSEvent]] '') theEvent // RETURN: YES => user dragged (not clicked)
{
	[[NSPoint]]     initialLocation;
    [[NSRect]]      visibleRect;
    BOOL      keepGoing;
    BOOL      result = NO;
	
	initialLocation = [theEvent locationInWindow];
    visibleRect = [[self documentView] visibleRect];
    keepGoing = YES;
	
    while (keepGoing)
		{
        theEvent = [[self window] nextEventMatchingMask: [[NSLeftMouseUpMask]] | [[NSLeftMouseDraggedMask]]];
        switch ([theEvent type])
			{
            case [[NSLeftMouseDragged]]:
				{
					[[NSPoint]]  newLocation;
					[[NSRect]]  newVisibleRect;
					float  xDelta, yDelta;
					
					newLocation = [theEvent locationInWindow];
					xDelta = initialLocation.x - newLocation.x;
					yDelta = initialLocation.y - newLocation.y;
					
					//  This was an amusing bug: without checking for flipped,
					//  you could drag up, and the document would sometimes move down!
					if ([[self documentView] isFlipped])
						yDelta = -yDelta;
					
					//  If they drag MORE than one pixel, consider it a drag
					if ( (abs (xDelta) > 1) || (abs (yDelta) > 1) )
						result = YES;
					
					newVisibleRect = [[NSOffsetRect]] (visibleRect, xDelta, yDelta);
					[[self documentView] scrollRectToVisible: newVisibleRect];
				}
				break;
				
            case [[NSLeftMouseUp]]:
                keepGoing = NO;
                break;
				
            default:
                /'' Ignore any other kind of event. ''/
                break;
			}                // end of switch (event type)
		}                  // end of mouse-tracking loop
	
    return result;
}
@end
</code>

----
I'm not sure how this is working.  You can not add instance variables to a category.  [[SynchroScrollView]] should be a subclass of [[NSScrollView]] instead to add an instance variable. 

----
It's not an instance variable, it's a global. This probably means that this category can only be used on one pair of views in any given app.

----
Ahh yes..  see that now.. added "global" to comment on that line so it isn't so easily overlooked by others.. :)

----
I wonder why in the Apple code that part of this is taken from, the synchronizedViewContentBoundsDidChange method uses [[self contentView] scrollToPoint:newOffset] instead of [[self documentView] scrollPoint:newOffset]?  Calling scrollPoint on the documentView is more general I think unless it doesn't work in all cases.  I needed to use the documentView method  for horizontally scrolling (with a change to get the x offset) [[NSTableViews]] with column headers.  Otherwise horizontally scrolling a [[NSTableView]] with contentView->scrollToPoint scrolls the columns only and not the column headers.  -DB