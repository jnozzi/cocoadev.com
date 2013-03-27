**At least with Panther, it would seem that the General/NSTableView draw its own General/FocusRing � so perhaps this page is only useful for pre-Panther development?**
----
Here is a way to draw a focus ring around an General/NSTableView when it is the General/FirstResponder:

Create a subclass of General/NSScrollView:

    
@interface General/FocusRingScrollView : General/NSScrollView 
{
    BOOL shouldDrawFocusRing;
    General/NSResponder* lastResp;
}
@end

@implementation General/FocusRingScrollView

- (BOOL)needsDisplay;
{
    General/NSResponder* resp = nil;

    if ( General/self window] isKeyWindow] ) 
    {
        resp = [[self window] firstResponder];
        if (resp == lastResp) 
            return [super needsDisplay];
    } 
    else if ( lastResp == nil )  
    {
        return [super needsDisplay];
    }
    shouldDrawFocusRing = (resp != nil && [resp isKindOfClass:[[[NSView class]] 
                            && [(General/NSView*)resp isDescendantOf:self]); 
    lastResp = resp;
    [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
    return YES;
}


- (void)drawRect:(General/NSRect)rect 
{
    [super drawRect:rect];

    if ( shouldDrawFocusRing ) 
    {
        General/NSSetFocusRingStyle(General/NSFocusRingOnly);
        General/NSRectFill(rect);
    }
}

@end


In General/InterfaceBuilder, also subclass General/NSScrollView as General/FocusRingScrollView.  Then on the inspector panel for the scroll view containing the table in question, set the Custom Class to General/FocusRingScrollView.

Many thanks to Nicholas Riley for his help with this.

-- General/StevenFrank

----


Here's a fix for the drawRect method:

    
- (void) drawRect:(General/NSRect)rect
{
    [super drawRect:rect];
    if(shouldDrawFocusRing) {
        [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
        General/NSSetFocusRingStyle(General/NSFocusRingOnly);
        General/NSRectFill([self bounds]);
    }
}


Otherwise,  once it has been drawn a few times, the focus ring drawing gets corrupted at some places.

----

The above "fix" does not work; it causes the focus rect to be drawn way too often, killing performance (even on a General/GeeFour/800).  I've not had problems with the first method, and it's in use in several apps of mine. -- General/NicholasRiley

----
You should NOT be calling set...General/NeedsDisplay...: in a drawRect: method! -Sean
----

I have a different, but essential, fix to drawRect.  The focus ring is drawn for the passed-in rect parameter, but this is not necessarily the bounding rect of the scroll view - it can be just the rect that needs updating.  I've seen the edge of the focus ring draw through the middle of an outline view for this reason (when only some columns need to be redrawn).  The fix is just to get the view's bounds and ignore the passed-in rect.

    
- (void)drawRect:(General/NSRect)rect 
{
    [super drawRect:rect];

    if ( shouldDrawFocusRing ) 
    {
        General/NSSetFocusRingStyle(General/NSFocusRingOnly);
        General/NSRectFill([self bounds]);
    }
}


- Christopher Corbell

----
Yet another small glitch is corrected by overriding both setFrameOrigin and setFrameSize. setFrame calls those two in fact. If you place the view in a General/NSSplitView (bottom or right) and you move the down (or right) the split while the focused view has the focus, you will see trailing marks...

    
- (void)setFrameOrigin:(General/NSPoint)origin
{
    if (shouldDrawFocusRing) {
    
        [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
    }
    
    [super setFrameOrigin:origin];
}

- (void)setFrameSize:(General/NSSize)size
{
    if (shouldDrawFocusRing) {
    
        [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
    }
    
    [super setFrameSize:size];
}


- Eric

----
As it says above, the General/NSTableView now draws the focus ring itself, but say for your own custom view the above techniques are useful, but you should be cafeful to save the graphics context, like so:
    
General/[NSGraphicsContext saveGraphicsState];
General/NSSetFocusRingStyle (General/NSFocusRingOnly);
General/[[NSBezierPath bezierPathWithRect:[self bounds]] fill];
General/[NSGraphicsContext restoreGraphicsState];

-Sean

----
I have a reversed situation. I need never focused my General/TableView. How can I do it?