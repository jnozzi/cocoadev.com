General/CCDProgressIndicator is a simple subclass for drawing rounded progress bars.

    
// General/CCDProgressIndicator.h
#import <General/AppKit/General/AppKit.h>

typedef enum {
    General/CCDProgressIndicatorSquareBezel  = General/NSTextFieldSquareBezel,
    General/CCDProgressIndicatorRoundedBezel = General/NSTextFieldRoundedBezel
} General/CCDProgressIndicatorBezelStyle;


@interface General/CCDProgressIndicator : General/NSProgressIndicator
{
    General/NSTextFieldCell *textCell;
    General/NSImage *scratch;
}

- (void)setBezelStyle:(General/CCDProgressIndicatorBezelStyle)style;
- (General/CCDProgressIndicatorBezelStyle)bezelStyle;
@end

    
// General/CCDProgressIndicator.m
#import "General/CCDProgressIndicator.h"

@implementation General/CCDProgressIndicator

- (id)initWithCoder:(General/NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setBezeled:YES];
        textCell = General/[[NSTextFieldCell alloc] initTextCell:@""];
        [textCell setControlSize:[self controlSize]];
        [textCell setDrawsBackground:NO];
        [textCell setBezeled:YES];
        
        scratch = General/[[NSImage alloc] initWithSize:[self bounds].size];
        [scratch setFlipped:YES];

        // yuck.
        General/[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay:) name:General/NSWindowDidBecomeMainNotification object:[self window]];
        General/[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay:) name:General/NSWindowDidResignMainNotification object:[self window]];
    }

    return self;
}

- (void)dealloc
{
    General/[[NSNotificationCenter defaultCenter] removeObserver:self];
    [textCell release];
    [scratch release];
    [super dealloc];
}

- (void)setBezelStyle:(General/CCDProgressIndicatorBezelStyle)style
{
    [textCell setBezelStyle:style];
    [self setNeedsDisplay:YES];
}
- (General/CCDProgressIndicatorBezelStyle)bezelStyle
{
    return [textCell bezelStyle];
}

- (void)drawRect:(General/NSRect)rect
{
    if ([self bezelStyle] == General/NSTextFieldRoundedBezel && [self style] == General/NSProgressIndicatorBarStyle) {
    General/NSImage *progress = General/[[NSImage alloc] initWithSize:rect.size];
    General/NSImage *textImage = [progress copy];
    General/NSRect tRect = rect;
        tRect.origin.x += 2;
        tRect.size.width -= 4;
        tRect.size.height -= 4;
        
    [progress setFlipped:YES];
    [textImage setFlipped:YES];

    [textImage lockFocus];
    [textCell drawWithFrame:rect inView:General/[NSView focusView]];
    [textImage unlockFocus];

    [progress lockFocus];
    [super drawRect:rect];
    [progress unlockFocus];
    
    [scratch setSize:rect.size];
    [scratch lockFocus];
        General/[[NSColor whiteColor] set];
        General/NSRectFill(rect); // clear scratch of any previous drawing
    [progress drawAtPoint:General/NSMakePoint(0,0) fromRect:tRect operation:General/NSCompositeSourceOver fraction:0.8];
    [textImage drawAtPoint:General/NSMakePoint(0,0) fromRect:rect operation:General/NSCompositeDestinationAtop fraction:1];
    
    [scratch unlockFocus];
    
    // draw it all
    [scratch drawAtPoint:General/NSMakePoint(0,0) fromRect:rect operation:General/NSCompositeSourceOver fraction:1];
    [progress release];
    [textImage release];
    } else [super drawRect:rect];
}

@end

----
1/16; Don't know how I overlooked it but *scratch* wasn't being cleared before, now it is.

4/8; General/CCDImageCategory wasn't needed, as described on its page.