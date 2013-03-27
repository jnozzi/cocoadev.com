----

I've left my starter code here, but would suggest interested programers checkout:

http://s.sudre.free.fr/Software/General/DevPotPourri.html

first. It implements the entire Mail.app search text field behavior.

- Jesse

----

Here's some starter code for creating a Mail.app like search field (rounded, magnifying glass, close button...). But it doesn't really work! I've seen a number of questions regarding this, hopefully we can get this fully functional, will probably save many people lots of time.

So here's my start, (I?ve come to the conclusion that I don?t really understand General/NSCell?s yet) I would encourage people to clean it up and make it as "cocoa" as possible, I'm looking for a working well done search field, I don't really care if it follows the design of my current partial solution. This code seems to draw mostly correctly, but I can?t seem to get mouse events and so can?t make the close button work. Also I haven?t added a popup menu for when the magnifying glass is clicked on, I don?t need that for my app, but it would still be nice to see how to do it.

I've provided a project builder project along with image resources for this code at: http://www.hogbay.com/software/General/SearchTextAreaExample.zip

    

//
//  General/SearchFieldCell.h
//
//  Created by Jesse Grosjean on Thu Nov 21 2002.
//

#import <Cocoa/Cocoa.h>


@interface General/SearchFieldCell : General/NSTextFieldCell {
    BOOL _showCancelButton;
}

- (General/NSRect)textRectForFrame:(General/NSRect)frame;

@end

//
//  General/SearchFieldCell.m
//
//  Created by Jesse Grosjean on Thu Nov 21 2002.
//

#import "General/SearchFieldCell.h"


@implementation General/SearchFieldCell

static General/NSImage *leftSearchCapImage = nil;
static General/NSImage *middleSearchImage = nil;
static General/NSImage *rightSearchCapImage = nil;
static General/NSImage *rightSearchStopCapImage = nil;
static General/NSImageCell *_leftCapCell;
static General/NSImageCell *_middleCell;
static General/NSImageCell *_rightCapCell;
static General/NSImageCell *_rightStopCapCell;
static float textOffset = 2.5; // yuck why do i use this?

+ (void)initialize {
    leftSearchCapImage = General/[[NSImage imageNamed: @"General/LeftSearchCap"] retain];
    middleSearchImage = General/[[NSImage imageNamed: @"General/MiddleSearch"] retain];
    rightSearchCapImage = General/[[NSImage imageNamed: @"General/RightSearchCap"] retain];
    rightSearchStopCapImage = General/[[NSImage imageNamed: @"General/RightSearchStopCap"] retain];
    _leftCapCell = General/[[NSImageCell alloc] initImageCell:leftSearchCapImage];
    _middleCell = General/[[NSImageCell alloc] initImageCell:middleSearchImage];
    _rightCapCell = General/[[NSImageCell alloc] initImageCell:rightSearchCapImage];
    _rightStopCapCell = General/[[NSImageCell alloc] initImageCell:rightSearchStopCapImage];
    [_leftCapCell setImageAlignment:General/NSImageAlignLeft];
    [_middleCell setImageScaling:General/NSScaleToFit];
    [_rightCapCell setImageAlignment:General/NSImageAlignRight];
    [_rightStopCapCell setImageAlignment:General/NSImageAlignRight];
}

- (id)initTextCell:(General/NSString *)text {
    if (self = [super initTextCell:text]) {
        _showCancelButton = [text length] > 0;
    }
    return self;
}

- (BOOL)showsFirstResponder {
    return NO;
}

- (BOOL)wraps {
    return NO;
}

- (BOOL)isScrollable {
    return YES;
}

- (General/NSText *)setUpFieldEditorAttributes:(General/NSText *)textObj {
    return [super setUpFieldEditorAttributes:textObj];
}

- (void)selectWithFrame:(General/NSRect)aRect 
                 inView:(General/NSView *)controlView 
                 editor:(General/NSText *)textObj 
               delegate:(id)anObject 
                  start:(int)selStart 
                 length:(int)selLength {

    [super selectWithFrame:[self textRectForFrame:aRect]
                    inView:controlView
                    editor:textObj
                  delegate:anObject
                     start:selStart
                    length:selLength];
}

- (void)drawInteriorWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView {
    General/NSRect textRect = [self textRectForFrame:cellFrame];
    General/NSRect middleRect = textRect;
    middleRect.origin.y -= textOffset;
    middleRect.origin.x -= 1;
    middleRect.size.width += 2;

    if ([super showsFirstResponder] && General/controlView window] isKeyWindow]) {
        [[[NSGraphicsContext saveGraphicsState];
        General/NSSetFocusRingStyle(General/NSFocusRingOnly);
        [_leftCapCell drawWithFrame:cellFrame inView:controlView];
        [_rightCapCell drawWithFrame:cellFrame inView:controlView];
        [_middleCell drawWithFrame:middleRect inView:controlView];
        General/[NSGraphicsContext restoreGraphicsState];
    }
    
    [_leftCapCell drawWithFrame:cellFrame inView:controlView];
    [_rightCapCell drawWithFrame:cellFrame inView:controlView];
    [_middleCell drawWithFrame:middleRect inView:controlView];
    
    if (_showCancelButton) {
        [_rightStopCapCell drawWithFrame:cellFrame inView:controlView];
    } else {
        [_rightCapCell drawWithFrame:cellFrame inView:controlView];
    }
    [super drawInteriorWithFrame:textRect inView:controlView];
}

- (void)editWithFrame:(General/NSRect)aRect 
               inView:(General/NSView *)controlView 
               editor:(General/NSText *)textObj 
             delegate:(id)anObject 
                event:(General/NSEvent *)theEvent {

    [super editWithFrame:[self textRectForFrame:aRect] 
                  inView:controlView 
                  editor:textObj 
                delegate:anObject 
                   event:theEvent];
}

- (General/NSRect)textRectForFrame:(General/NSRect)frame {
    frame.origin.x += [leftSearchCapImage size].width;
    frame.origin.y += textOffset;
    frame.size.width -= [leftSearchCapImage size].width;
    frame.size.width -= [rightSearchCapImage size].width; 
    return frame;
}

- (General/NSMenu *)menuForEvent:(General/NSEvent *)anEvent 
                  inRect:(General/NSRect)cellFrame ofView:(General/NSView *)aView {
    return [super menuForEvent:anEvent inRect:cellFrame ofView:aView];
}

- (void)resetCursorRect:(General/NSRect)cellFrame 
                 inView:(General/NSView *)controlView {

    [super resetCursorRect:[self textRectForFrame:cellFrame]
                    inView:controlView];
}

- (void)setStringValue:(General/NSString *)string {
    [super setStringValue:string];
    _showCancelButton = [string length] > 0;
}

// can't seem to get any mouse tracking to work.
- (BOOL)trackMouse:(General/NSEvent *)theEvent 
            inRect:(General/NSRect)cellFrame 
            ofView:(General/NSView *)controlView 
       untilMouseUp:(BOOL)untilMouseUp {

    General/NSLog(@"tracking");
    return [super trackMouse:theEvent 
                      inRect:cellFrame 
                      ofView:controlView 
                untilMouseUp:untilMouseUp];
}

- (BOOL)startTrackingAt:(General/NSPoint)startPoint inView:(General/NSView *)controlView {
    General/NSLog(@"start tracking");
    return [self startTrackingAt:startPoint inView:controlView];
//    return NO;
}

@end



----

You could probably subclass General/CCDTextField and/or General/CCDTextFieldCell and add some search-specific stuff pretty easily.