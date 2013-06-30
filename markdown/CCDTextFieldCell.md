The cell General/CCDTextField uses to get things done.

    
// General/CCDTextFieldCell.h
#import <General/AppKit/General/AppKit.h>
#import "General/CCDPTextView.h"
#import "General/NSBezierPathCategory.h"


@interface General/CCDTextFieldCell : General/NSTextFieldCell
{
        General/NSButtonCell *leftCell;
        General/NSButtonCell *rightCell;

        General/NSColor *labelColor;

        General/NSImage *scratch;
        BOOL isAnimating;
}

- (void)setLabelColor:(General/NSColor *)lColor;
- (General/NSColor *)labelColor;

- (void)setAnimating:(BOOL)animating;
- (BOOL)isAnimating;

// modeled after General/NSSearchFieldCell
- (void)setLeftButtonCell:(id)cell;
- (id)leftButtonCell;

- (void)setRightButtonCell:(id)cell;
- (id)rightButtonCell;

- (General/NSRect)leftButtonRectForBounds:(General/NSRect)bounds;
- (General/NSRect)rightButtonRectForBounds:(General/NSRect)bounds;


// These return the same rect.
- (General/NSRect)titleRectForBounds:(General/NSRect)bounds; // inherited from General/NSCell but never called
- (General/NSRect)textRectForBounds:(General/NSRect)bounds; // modeled after General/NSSearchFieldCell

- (General/NSRect)labelRectForBounds:(General/NSRect)bounds; // must support labels

@end


    
// General/CCDTextFieldCell.m
#import "General/CCDTextFieldCell.h"

@implementation General/CCDTextFieldCell

- (id)initTextCell:(General/NSString *)txt
{
    if (self = [super initTextCell:txt]) {
    
        leftCell = General/[[NSButtonCell alloc] initImageCell:nil];
        rightCell = General/[[NSButtonCell alloc] initImageCell:nil];

            [leftCell setButtonType:General/NSMomentaryChangeButton];
            [leftCell setBezelStyle:General/NSRegularSquareBezelStyle];
            [leftCell setBordered:NO];
            [leftCell setImagePosition:General/NSImageOnly];

            [rightCell setButtonType:General/NSMomentaryChangeButton];
            [rightCell setBezelStyle:General/NSRegularSquareBezelStyle];
            [rightCell setBordered:NO];
            [rightCell setImagePosition:General/NSImageOnly];

            scratch = General/[[NSImage alloc] initWithSize:[self cellSize]];
            [scratch setFlipped:YES];
    }

    return self;
}

- (void)dealloc
{
    [leftCell release];
    [rightCell release];
    [scratch release];
    [labelColor release];

    [super dealloc];
}

#pragma mark Setters/Getters
- (void)setLeftButtonCell:(id)cell
{
    [leftCell release];
    leftCell = [cell retain];
}
- (id)leftButtonCell
{
    return leftCell;
}

- (void)setRightButtonCell:(id)cell
{
    [rightCell release];
    rightCell = [cell retain];
}
- (id)rightButtonCell
{
    return rightCell;
}

- (void)setLabelColor:(General/NSColor *)lColor
{
    [labelColor autorelease];
    labelColor = lColor;
    [labelColor retain];
}
- (General/NSColor *)labelColor
{
    return labelColor;
}

- (void)setAnimating:(BOOL)animating
{
    isAnimating = animating;
}

- (BOOL)isAnimating { return isAnimating; }

#pragma mark Sizing
- (General/NSRect)textRectForBounds:(General/NSRect)bounds
{
    General/NSRect rect = General/NSInsetRect(bounds, 2, 2);
        rect.size.height = [super drawingRectForBounds:bounds].size.height;

    { // Modify the bounds rect so our text gets drawn between our cells...
        General/NSSize leftSize = [leftCell cellSize];
        General/NSSize rightSize = [rightCell cellSize];
        
        rect.origin.x += leftSize.width;
        rect.size.width -= leftSize.width;
        
        rect.size.width -= rightSize.width;
    
        // Deal with our rounded variation...
        if ([self bezelStyle] == General/NSTextFieldRoundedBezel) {
            if (leftSize.width == 1) {
                rect.origin.x += 5;
                rect.size.width -= 5;
            }
            if (rightSize.width == 1)
                rect.size.width -= 5;
        }

    }

    return rect;
}

- (General/NSRect)leftButtonRectForBounds:(General/NSRect)bounds
{
    General/NSRect leftRect = General/NSMakeRect(0,0,0,0);
        leftRect.size = [leftCell cellSize];
    return leftRect;
}

- (General/NSRect)rightButtonRectForBounds:(General/NSRect)bounds
{
    General/NSRect rightRect = General/NSMakeRect(0,0,0,0);

    rightRect.size = [rightCell cellSize];
    rightRect.origin.x = bounds.size.width - rightRect.size.width;

    return rightRect;
}

- (General/NSRect)labelRectForBounds:(General/NSRect)bounds
{
    General/NSRect labelRect = [self textRectForBounds:bounds];
    if (![self isHighlighted]) { // guesses..
        labelRect.origin.x += 3;
        labelRect.origin.y += 2;
        labelRect.size.width -= 3;
    } else labelRect = [self rightButtonRectForBounds:bounds]; // mimic Finder?
    
    return labelRect;
}

- (General/NSRect)drawingRectForBounds:(General/NSRect)theRect
{
    return [self textRectForBounds:theRect];
}

#pragma mark Drawing
- (BOOL)showsFirstResponder { return NO; }
- (BOOL)drawsBackground { return NO; }

- (void)drawWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView
{
    General/NSImage *progress;
    General/NSRect pRect, lRect = [self labelRectForBounds:cellFrame];
    General/NSColor *lColor = [self labelColor];
    General/NSImage *superImage = General/[[NSImage alloc] initWithSize:cellFrame.size];
            [superImage setFlipped:YES];
            [scratch setSize:cellFrame.size];
            
            [superImage lockFocus]; // We want what would normally go in the controlView in an image instead.
            [super drawWithFrame:cellFrame inView:General/[NSView focusView]];
            [superImage unlockFocus];
 
    if ([controlView respondsToSelector:@selector(progressIndicator)]) { // grab the progress..
        General/NSProgressIndicator *indicator = [(General/CCDTextField *)controlView progressIndicator];
        pRect = General/NSOffsetRect([controlView bounds], 4, 4);
        progress = General/[[NSImage alloc] initWithSize:pRect.size];
        [progress setFlipped:YES];

            [progress lockFocus]; // draw the progress
            [indicator setFrameSize:pRect.size]; 
            [indicator drawRect:[indicator bounds]];   
            [progress unlockFocus];
    }

    [scratch lockFocus]; // composite..
        General/[[NSColor whiteColor] set];
        General/NSRectFill(cellFrame); // clear scratch of any previous drawing

     if (isAnimating) // progress..
        [progress drawAtPoint:General/NSZeroPoint fromRect:General/NSInsetRect(cellFrame, 2, 4) operation:General/NSCompositeSourceOver fraction:1];
    
    if (lColor) { // label..
        [lColor set];
        General/[NSBezierPath fillRoundRectInRect:lRect radius:90]; // no clue if this is right, wish it was a little rounder though.
    }
    
    [superImage drawAtPoint:General/NSZeroPoint fromRect:cellFrame operation:General/NSCompositeDestinationAtop fraction:1];
    [scratch unlockFocus];
    
    // draw it
    [scratch drawAtPoint:General/NSZeroPoint fromRect:cellFrame operation:General/NSCompositeSourceOver fraction:1];
    [super drawInteriorWithFrame:cellFrame inView:controlView];

    { // draw the left and right cells as needed
        [leftCell drawWithFrame:[self leftButtonRectForBounds:cellFrame] inView:controlView];
        [rightCell drawWithFrame:[self rightButtonRectForBounds:cellFrame] inView:controlView];
    }
}

#pragma mark Cursor
- (void)resetCursorRect:(General/NSRect)cellFrame inView:(General/NSView *)controlView
{
    [super resetCursorRect:[self textRectForBounds:cellFrame] inView:controlView];
}

#pragma mark Selection Handling
static id lastView;
 - (void)selectWithFrame:(General/NSRect)aRect inView:(General/NSView *)controlView editor:(General/NSText *)textObj delegate:(id)anObject start:(int)selStart length:(int)selLength
 {
     General/NSEvent *curEvent = General/[NSApp currentEvent];
     General/NSPoint mouseLoc= [controlView convertPoint:[curEvent locationInWindow] fromView:nil];
    
     if (![lastView isEqualTo:controlView]) {
        if ([curEvent type] == General/NSKeyDown)
            [super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
         else
             if (!General/NSPointInRect(mouseLoc, [self textRectForBounds:[controlView bounds]]))
                 [super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:0 length:General/self stringValue] length;
              else [super editWithFrame:aRect inView:controlView editor:textObj delegate:anObject event:curEvent];

            lastView = controlView;
            return;
     }

     if (!General/NSPointInRect(mouseLoc, [self textRectForBounds:[controlView bounds]])) {
         General/NSRange range = [(General/CCDPTextView*)textObj prvtSelectedRange];
         selStart = range.location;
         selLength = range.length;
         [super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength]; 
       return;
     }

    [super editWithFrame:aRect inView:controlView editor:textObj delegate:anObject event:curEvent];
}

@end


----
11/21; Added cursor handling and changed the default button highlighting.

11/25; Added the Selection Handling section.

11/29; Added the progress drawing.

12/2; Cleaned up some and added support for colored labels.

4/8; General/CCDImageCategory wasn't needed, as described on its page.