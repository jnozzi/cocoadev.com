I have modified the code at General/FieldEditorIssues to produce a text field which has the appearance of the General/AddressBook / Library text fields mentioned in General/HighlightButtonsLikeDLandAB.

I'm completely at a loss as to how to go about turning one of these into a view with many editable text fields. Does anyone have any suggestions as to the best way to approach this? My preliminary thoughts are:

One view with many strings? Or many of these views in a custom superview? As to the first, how to manage the strings and click handling, for the second, how do we deal with multi-line resizing and moving the elements below? 

I'll post any improvements made back here as it seems to be a popular subject at the moment. -BB

Code follows:

    
@interface General/FieldEditorTestView : General/NSView
{
    General/NSRect itemRect;
    General/NSString *itemTitle;
    General/NSSize maxSize;
    General/NSTextView *mEditor;
	General/IBOutlet General/NSButton *editButton;
}
- (void)calculateMaxSize;
@end


    
#import "General/FieldEditorTestView.h"

@implementation General/FieldEditorTestView

- (BOOL)isFlipped
{
    return YES;
}

- (BOOL)isOpaque
{
    return NO;
}

- (void)setString:(General/NSString *)s
{
    [itemTitle release];
    itemTitle = [s retain];
    itemRect.size = [itemTitle sizeWithAttributes: nil];
	
	[self calculateMaxSize];
	
    if (itemRect.size.width > maxSize.width)
        itemRect.size.width = maxSize.width;
}

- (void)calculateMaxSize 
{
	maxSize = General/self superview] frame].size;
	maxSize.width -= itemRect.origin.x + 5;
	maxSize.height -= itemRect.origin.y + 5;
}

- (void)awakeFromNib
{ 
	itemRect.origin = [[NSMakePoint(5, 5);   
	[self calculateMaxSize];
	
    [self setString: @"Hello World"];
}

-(void)drawRect:(General/NSRect)r
{
	General/[[NSColor whiteColor] set];
    General/NSRectFill(r);
    
    if (mEditor == nil) {
        General/[[NSColor textBackgroundColor] set];
        General/NSRectFill(itemRect);
        
        General/[[NSColor textColor] set];
        General/NSMutableParagraphStyle *style = General/[[[NSMutableParagraphStyle alloc] init] autorelease];
        [style setLineBreakMode:General/NSLineBreakByTruncatingMiddle];
        General/NSMutableAttributedString *truncatedMiddle = General/[[NSMutableAttributedString alloc] initWithString:itemTitle];
        [truncatedMiddle addAttribute:General/NSParagraphStyleAttributeName 
								value:style 
								range:General/NSMakeRange(0, [itemTitle length])];
								
		if ([itemTitle isEqualToString:General/NSLocalizedString(@"no value", nil)]) {
			[truncatedMiddle addAttribute:General/NSForegroundColorAttributeName
									value:General/[NSColor grayColor]
									range:General/NSMakeRange(0, [itemTitle length])];
		}
        
        [truncatedMiddle drawInRect:itemRect];
		
    } else {
        General/NSResponder *resp = General/self window] firstResponder];
        if ([[self window] isKeyWindow] &&
            [resp isKindOfClass:[[[NSView class]] &&
            [(General/NSView *)resp isDescendantOf:self]) {
           
			General/[NSGraphicsContext saveGraphicsState];
           
			
				[self setFocusRingType:General/NSFocusRingTypeNone];
				
				General/NSRect outerRect = [mEditor frame];
				outerRect.size.width += 2;
				outerRect.size.height += 4;
				outerRect.origin.x -= 1;
				outerRect.origin.y -= 2;
				
				// Shadow for line
				General/NSShadow *shadow = General/[[NSShadow alloc] init];
				[shadow setShadowOffset:General/NSMakeSize(0, -2)];
				[shadow setShadowBlurRadius:4.0];
				[shadow setShadowColor:General/[NSColor colorWithDeviceWhite:0.5 alpha:0.3]];
				[shadow set];
				
				General/[[NSColor colorWithCalibratedRed:0.2226 green:0.46875 blue:0.83593 alpha:1.0] set];
				General/NSFrameRect(outerRect);

				// A sort of nil-shadow to avoid restoring the graphics state already
				[shadow setShadowOffset:General/NSZeroSize];
				[shadow setShadowBlurRadius:0];
				[shadow setShadowColor:General/[NSColor clearColor]];
				[shadow set];
				
				// Shrink outerRect to avoid drawing over line
				outerRect.size.width -= 2;
				outerRect.size.height -= 2;
				outerRect.origin.x += 1;
				outerRect.origin.y += 1;
				General/[[NSColor whiteColor] set];
				General/NSRectFill(outerRect);	
				
				[shadow release];
				shadow = nil;
            General/[NSGraphicsContext restoreGraphicsState];
        }
    }
}

- (void)fixEditor
{
    [mEditor setFrameSize:General/NSMakeSize(maxSize.width, 10000)];
    [mEditor sizeToFit];
		// Uncomment the following two lines to resize from centre
		//General/NSRect r = [mEditor frame];
		//[mEditor setFrameOrigin:General/NSMakePoint(General/NSMidX(itemRect) - r.size.width / 2, r.origin.y)];
    [self setNeedsDisplay:YES];
}

- (void)startEditing:(id)sender
{
	[self calculateMaxSize];
    mEditor = (General/NSTextView *)General/self window] fieldEditor:YES forObject:self];
    [mEditor setDelegate:self];
    [mEditor setHorizontallyResizable:YES];
    [mEditor setVerticallyResizable:YES];
    [mEditor setFrameSize:[[NSMakeSize(maxSize.width, 10000)];
    General/mEditor textContainer] setContainerSize:[[NSMakeSize(maxSize.width, 10000)];
    General/mEditor textContainer] setHeightTracksTextView:NO];
    [[mEditor textContainer] setWidthTracksTextView:NO];
    [mEditor setString:itemTitle];
    [mEditor selectAll:self];
    [mEditor setFrameOrigin:itemRect.origin];
    [self addSubview:mEditor];
    [[self window] makeFirstResponder:mEditor];
    [self fixEditor];
}

- (void)textDidChange:([[NSNotification *)notification;
{
    [self fixEditor];
}

- (void)textDidEndEditing:(General/NSNotification *)aNotification
{
    // you have to copy the string because it's mutable and gets reused!
	if (General/[aNotification object] string] isEqualToString:@""]) {
		[self setString:[[[NSString stringWithString:@"no value"]];
	} else {
		[self setString:General/[NSString stringWithString:General/aNotification object] string];
	}
    General/self window] makeFirstResponder:nil];
    [mEditor removeFromSuperview];
    mEditor = nil;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:([[NSEvent *)theEvent
{
    General/NSPoint p = [self convertPoint: [theEvent locationInWindow] fromView: nil];
    if (mEditor != nil) {
        General/self window] makeFirstResponder: nil];
    }
    if ([[NSPointInRect(p, itemRect)) {
        if ([theEvent clickCount] > 1) {
				[self startEditing:self];
        } else {
            General/NSSize offset = General/NSMakeSize(p.x - itemRect.origin.x,
                                       p.y - itemRect.origin.y);
            while (theEvent = General/self window] nextEventMatchingMask:
                [[NSLeftMouseDraggedMask|General/NSLeftMouseUpMask]) {
                if ([theEvent type] == General/NSLeftMouseDragged) {
                    General/NSPoint p = [self convertPoint: [theEvent locationInWindow]
                                          fromView: nil];
                    [self setNeedsDisplayInRect: itemRect];
                    itemRect.origin.x = p.x - offset.width;
                    itemRect.origin.y = p.y - offset.height;
                    [self setNeedsDisplayInRect: itemRect];
                    [self setNeedsDisplayInRect: General/NSMakeRect(0,0,100,20)];
                    
                }
                else break;
            }
        }
    }
}

@end
