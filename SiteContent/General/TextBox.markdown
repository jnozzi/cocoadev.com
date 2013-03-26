Hard to describe, pretty easy to use. If you need a box with some text in it, give this a whirl.

screenshots..
http://homepage.mac.com/ryanstevens/expanded1.jpg
http://homepage.mac.com/ryanstevens/expanded2.jpg
http://homepage.mac.com/ryanstevens/collapsed.jpg

Oooh, cool!

----
[[TextBox]].h
----
<code>
#import <Cocoa/Cocoa.h>

@class [[TBTitleCell]];

@interface [[TextBox]] : [[NSBox]]
{
    [[TBTitleCell]] ''titleCell;
    BOOL isCollapsed;
}

// textView and contentView are the same thing, interchangable.
- ([[NSTextView]] '')textView;

// the height that -textView needs for its content
- (float)contentHeight;

- (BOOL)isCollapsed;


// title image...
- (void)setImage:([[NSImage]] '')img;
- ([[NSImage]] '')image;

// attributed title...
- (void)setAttributedTitle:([[NSAttributedString]] '')attedTitle;
- ([[NSAttributedString]] '')attributedTitle;


// titles set this way are given an 11pt label font w/ a truncating tail attribute.
// if this isn't what you want you can use -setAttributedTitle: or just modify the code
- (void)setTitle:([[NSString]] '')title;
- ([[NSString]] '')title;


- (id)titleCell;
- (void)sizeToFit;
- ([[NSRect]])titleRect;
- ([[NSRect]])disclosureRect;

- (void)mouseDown:([[NSEvent]] '')theEvent;

@end

@interface [[TBTitleCell]] : [[NSBrowserCell]] { BOOL mouseIsDown; }
- ([[NSColor]] '')highlightColorInView:([[NSView]] '')controlView;
- (void)drawInteriorWithFrame:([[NSRect]])cellFrame inView:([[NSView]] '')controlView;
- (BOOL)startTrackingAt:([[NSPoint]])startPoint inView:([[NSView]] '')controlView;
- (void)stopTracking:([[NSPoint]])lastPoint at:([[NSPoint]])stopPoint 
              inView:([[NSView]] '')controlView mouseIsUp:(BOOL)flag;
@end
</code>

[[TextBox]].m
----
<code>
#import "[[TextBox]].h"

@implementation [[TextBox]]

- (void)dealloc
{
    [titleCell release];
    [super dealloc];
}

- (id)initWithCoder:([[NSCoder]]'')coder {
    if (self = [super initWithCoder:coder]) {

    { // content/textView...
        [[NSTextView]] ''textView = [[[[NSTextView]] alloc] initWithFrame: [[NSMakeRect]](0,0,10,10)];
        
        [textView setVerticallyResizable:YES];
        [textView setEditable:YES];
        [textView setSelectable:YES];
        [textView setDrawsBackground:NO];
        [textView setTextContainerInset:[[NSMakeSize]](0,6)];
        
        [self setContentView:textView];
    }
        
        { // titleCell...
            titleCell = [[[[TBTitleCell]] alloc] initImageCell:nil];
            [titleCell setWraps:YES];
            [titleCell setLeaf:YES];
            [titleCell setAllowsMixedState:YES];
            [self setTitle:[super title]];
            [super setTitle:@" "];
        }
        
        isCollapsed = YES;
        [self setTitlePosition:[[NSBelowTop]]];
        [self setContentViewMargins:[[NSMakeSize]](6,0)];
        [self setNeedsDisplay:YES];

    }
    return self;
}

- (void)setImage:([[NSImage]] '')img
{
    [[self titleCell] setImage:img];
    [self setNeedsDisplay:YES];
}

- ([[NSImage]] '')image
{
    return [[self titleCell] image];
}

- (void)setAttributedTitle:([[NSAttributedString]] '')attedTitle
{
    [titleCell setAttributedStringValue:attedTitle];

    [self setNeedsDisplay:YES];
}

- ([[NSAttributedString]] '')attributedTitle
{
    return [[self titleCell] attributedStringValue];
}

- (void)setTitle:([[NSString]] '')title
{
    [[NSMutableParagraphStyle]] ''truncateStyle = [[[[NSMutableParagraphStyle]] alloc] init];
        [truncateStyle setLineBreakMode:[[NSLineBreakByTruncatingTail]]];
    
    [[NSDictionary]] ''dict = [[[NSDictionary]] dictionaryWithObjectsAndKeys:[[[NSFont]] labelFontOfSize:11], [[NSFontAttributeName]], truncateStyle, [[NSParagraphStyleAttributeName]], nil];
    [[NSAttributedString]] ''aTitle = [[[[NSAttributedString]] alloc] initWithString:title attributes:dict];
    
    [self setAttributedTitle:aTitle];
    [aTitle release];
    [truncateStyle release];
}

- ([[NSString]] '')title
{
    return [[self titleCell] stringValue];
}

// This seems to work well enough...
- (void)sizeToFit
{
    [[NSRect]] frame = [self frame];
            
       [super sizeToFit];

    if (!isCollapsed) {
        frame.size.height = 30+[self contentHeight];
        [self setFrame:frame];
        [[self textView] setFrameOrigin:[[NSMakePoint]](8,3)];
    } else {
        frame.size.height = 26;
        [self setFrame:frame];
    }
}

- ([[NSTextView]] '')textView { return [self contentView]; }
- (BOOL)isCollapsed { return isCollapsed; }

- (void)drawRect:([[NSRect]])aRect
{
    id cell = [self titleCell];

        // First make sure everything is sized properly..
        [self sizeToFit];
        [super drawRect:aRect]; // draw super
    
    // draw the titleCell..
    [cell drawWithFrame:[self titleRect] inView:self];

        // Draw a separator line as needed...
        if (![self isCollapsed]) {
            [[NSRect]] lineRect;

                lineRect.origin.y = [self titleRect].origin.y - 3;
                lineRect.origin.x = aRect.origin.x + 4.5;
                lineRect.size.width = aRect.size.width - 9;
                lineRect.size.height = 0.3;

            [[[[[NSColor]] blackColor] colorWithAlphaComponent:0.9] set];
            [[NSRectFillUsingOperation]](lineRect, [[NSCompositeSourceOver]]);
        }
}

- (void)mouseDown:([[NSEvent]] '')theEvent
{
    [[NSPoint]] loc = [theEvent locationInWindow];
    [[NSRect]] hotRect = [self disclosureRect];
    id cell = [self titleCell];
    
    loc = [self convertPoint:loc fromView:nil];

    if ([[NSMouseInRect]](loc, hotRect, YES)) {
        // let the cell know that it's pressed...
        if (![cell trackMouse:theEvent inRect:[self disclosureRect] ofView:self untilMouseUp:NO]) {
            // let the cell know that it can stop displaying as if it were pressed..            
            [cell stopTracking:[[NSZeroPoint]] at:[[NSZeroPoint]] inView:self mouseIsUp:YES];
            return; // didn't hit the disclosure part of the cell, do nothing.
        }

            // we're toggling and should display the intermediate step..
            [cell setState:[[NSMixedState]]];
            [self display];

            if ([self isCollapsed]) isCollapsed = NO;
             else {
                isCollapsed = YES;
                [self display];
            }
    }

    // we've displayed the intermediate step and toggled the box,
    // let the cell know that it can stop displaying as if it were pressed..
    [cell stopTracking:[[NSZeroPoint]] at:[[NSZeroPoint]] inView:self mouseIsUp:YES];
    
    // setup the titleCell..
    if (isCollapsed) [cell setState:[[NSOffState]]];
    else [cell setState:[[NSOnState]]];

    [[self superview] setNeedsDisplay:YES];
    [super mouseDown:theEvent];
}

- (id)titleCell { return titleCell; }

- ([[NSRect]])titleRect
{
[[NSRect]] titleRect = [super titleRect];

    titleRect.size.width = [self frame].size.width - 24; // keep it from running over the disclosureRect
        
        // margins..
        titleRect.origin.x -= 2;
        titleRect.origin.y -= 2;

    return titleRect;
}

- ([[NSRect]])disclosureRect
{ // kinda cheesy but it works well enough...
    return [[NSMakeRect]](([self frame].size.width-18),[self titleRect].origin.y,14,22);
}

- (float)contentHeight
{ // yanked from the docs..
    [[NSTextStorage]] ''textStorage = [[self textView] textStorage];
[[NSTextContainer]] ''textContainer = [[[[[NSTextContainer]] alloc] 
        initWithContainerSize: [[NSMakeSize]]([[self textView] frame].size.width, FLT_MAX)] autorelease];
[[NSLayoutManager]] ''layoutManager = [[[[[NSLayoutManager]] alloc] init] autorelease];

[layoutManager addTextContainer:textContainer];
[textStorage addLayoutManager:layoutManager];

(void)[layoutManager glyphRangeForTextContainer:textContainer];

return [layoutManager usedRectForTextContainer:textContainer].size.height;
}

@end


// If you really need them, you can construct the image files fairly easily.
[[NSString]] ''triDown = @"<4d4d002a 0000014c 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 21212128 3e3e3e6f 4040407e 3f3f3f7a 3f3f3f7a 3f3f3f7b 3f3f3f7d 3f3f3f6f 21212128 05050506 38383854 3f3f3f7e 3f3f3f7a 3f3f3f7a 3f3f3f7b 3f3f3f7e 38383855 06060607 00000000 16161619 3e3e3e70 4040407e 3f3f3f7a 3f3f3f7e 3e3e3e70 16161619 00000000 00000000 00000000 31313142 3f3f3f7f 3f3f3f7b 3f3f3f7f 31313142 00000000 00000000 00000000 00000000 0a0a0a0b 3d3d3d66 3f3f3f81 3d3d3d66 0a0a0a0b 00000000 00000000 00000000 00000000 00000000 2525252d 3f3f3f76 2525252e 00000000 00000000 00000000 00000000 00000000 00000000 02020203 3535354c 02020203 00000000 00000000 00000000 000d0100 00030000 00010009 00000101 00030000 00010009 00000102 00030000 00040000 01ee0103 00030000 00010001 00000106 00030000 00010002 00000111 00040000 00010000 00080115 00030000 00010004 00000117 00040000 00010000 0144011a 00050000 00010000 01f6011b 00050000 00010000 01fe011c 00030000 00010001 00000128 00030000 00010002 00000152 00030000 00010001 00000000 00000008 00080008 0008000a fc800000 2710000a fc800000 2710>";
[[NSString]] ''triDownPressed = @"<4d4d002a 0000014c 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 2a2a2a36 3c3c3c9b 363636b1 373737ad 373737ad 373737ad 363636b1 3c3c3c9b 2a2a2a36 08080809 3f3f3f77 353535b3 373737ad 373737ad 373737ad 353535b3 3f3f3f77 08080809 00000000 1e1e1e23 3c3c3c9e 353535b2 383838ad 353535b1 3c3c3c9e 1d1d1d22 00000000 00000000 00000000 3a3a3a5b 343434b4 363636af 343434b4 3a3a3a5b 00000000 00000000 00000000 00000000 0e0e0e0f 3f3f3f91 333333b8 3e3e3e90 0e0e0e0f 00000000 00000000 00000000 00000000 00000000 2f2f2f3f 393939a6 2f2f2f3f 00000000 00000000 00000000 00000000 00000000 00000000 04040405 3d3d3d6a 04040405 00000000 00000000 00000000 000d0100 00030000 00010009 00000101 00030000 00010009 00000102 00030000 00040000 01ee0103 00030000 00010001 00000106 00030000 00010002 00000111 00040000 00010000 00080115 00030000 00010004 00000117 00040000 00010000 0144011a 00050000 00010000 01f6011b 00050000 00010000 01fe011c 00030000 00010001 00000128 00030000 00010002 00000152 00030000 00010001 00000000 00000008 00080008 0008000a fc800000 2710000a fc800000 2710>";

[[NSString]] ''triRight = @"<4d4d002a 0000014c 00000000 21212128 05050506 00000000 00000000 00000000 00000000 00000000 00000000 00000000 3e3e3e6e 38383854 16161619 00000000 00000000 00000000 00000000 00000000 00000000 3f3f3f7d 3f3f3f7e 3f3f3f70 30303042 0a0a0a0b 00000000 00000000 00000000 00000000 3f3f3f7a 3f3f3f7a 3f3f3f7e 3f3f3f80 3d3d3d66 2525252d 02020203 00000000 00000000 3f3f3f7a 3f3f3f7a 3f3f3f7a 3f3f3f7c 3f3f3f81 3f3f3f76 3535354c 00000000 00000000 3f3f3f7a 3f3f3f7a 3f3f3f7e 3f3f3f7f 3d3d3d66 2525252d 03030304 00000000 00000000 4040407d 3f3f3f7f 3e3e3e70 30303042 0a0a0a0b 00000000 00000000 00000000 00000000 3e3e3e6f 38383855 16161619 00000000 00000000 00000000 00000000 00000000 00000000 21212128 05050506 00000000 00000000 00000000 00000000 00000000 00000000 000d0100 00030000 00010009 00000101 00030000 00010009 00000102 00030000 00040000 01ee0103 00030000 00010001 00000106 00030000 00010002 00000111 00040000 00010000 00080115 00030000 00010004 00000117 00040000 00010000 0144011a 00050000 00010000 01f6011b 00050000 00010000 01fe011c 00030000 00010001 00000128 00030000 00010002 00000152 00030000 00010001 00000000 00000008 00080008 0008000a fc800000 2710000a fc800000 2710>";
[[NSString]] ''triRightPressed = @"<4d4d002a 0000014c 00000000 2a2a2a36 08080809 00000000 00000000 00000000 00000000 00000000 00000000 00000000 3d3d3d9b 3f3f3f77 1e1e1e23 00000000 00000000 00000000 00000000 00000000 00000000 363636b1 343434b3 3c3c3c9e 3a3a3a5b 0d0d0d0e 00000000 00000000 00000000 00000000 373737ad 383838ad 353535b2 343434b4 3e3e3e90 2f2f2f3f 04040405 00000000 00000000 373737ad 363636ad 373737ac 363636af 333333b8 393939a6 3d3d3d6a 00000000 00000000 363636ad 373737ad 353535b2 343434b4 3f3f3f91 2f2f2f3f 04040405 00000000 00000000 363636b1 353535b3 3b3b3b9d 3a3a3a5b 0e0e0e0f 00000000 00000000 00000000 00000000 3c3c3c9b 3f3f3f78 1d1d1d22 00000000 00000000 00000000 00000000 00000000 00000000 2a2a2a36 08080809 00000000 00000000 00000000 00000000 00000000 00000000 000d0100 00030000 00010009 00000101 00030000 00010009 00000102 00030000 00040000 01ee0103 00030000 00010001 00000106 00030000 00010002 00000111 00040000 00010000 00080115 00030000 00010004 00000117 00040000 00010000 0144011a 00050000 00010000 01f6011b 00050000 00010000 01fe011c 00030000 00010001 00000128 00030000 00010002 00000152 00030000 00010001 00000000 00000008 00080008 0008000a fc800000 2710000a fc800000 2710>";

[[NSString]] ''triRightDown = @"<4d4d002a 0000014c 00000000 00000000 00000000 00000000 08080809 26262630 0c0c0c0d 00000000 00000000 00000000 00000000 00000000 06060607 3e3e3e6d 3d3d3d93 20202026 00000000 00000000 00000000 00000000 0d0d0d0e 3f3f3f77 323232b7 383838a9 2c2c2c3a 00000000 00000000 00000000 10101012 3f3f3f83 343434b6 373737ae 353535b2 3b3b3b5f 03030304 00000000 15151518 3e3e3e91 323232b9 363636b1 373737ae 343434b4 3f3f3f81 15151518 00000000 31313143 3f3f3f8a 3c3c3c9b 393939a5 353535b3 343434b5 373737ad 2c2c2c39 00000000 06060607 0f0f0f11 1e1e1e24 2c2c2c3a 3d3d3d69 3f3f3f8a 383838a9 3c3c3c64 00000000 00000000 00000000 00000000 00000000 01010102 1818181b 2a2a2a36 37373751 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 000d0100 00030000 00010009 00000101 00030000 00010009 00000102 00030000 00040000 01ee0103 00030000 00010001 00000106 00030000 00010002 00000111 00040000 00010000 00080115 00030000 00010004 00000117 00040000 00010000 0144011a 00050000 00010000 01f6011b 00050000 00010000 01fe011c 00030000 00010001 00000128 00030000 00010002 00000152 00030000 00010001 00000000 00000008 00080008 0008000a fc800000 2710000a fc800000 2710>";

@implementation [[TBTitleCell]]

// we don't allow highlighting..
- ([[NSColor]] '')highlightColorInView:([[NSView]] '')controlView { return nil; }

// draw a custom branchImage
- (void)drawInteriorWithFrame:([[NSRect]])cellFrame inView:([[NSView]] '')controlView
{
    if (![self isLeaf]) [self setLeaf:YES]; // get rid of the branchImage
    
    [super drawInteriorWithFrame:cellFrame inView:controlView];
    
    // draw the proper branchImage...
    [[NSData]] ''data;
    [[NSImage]] ''branchImage;
    [[NSRect]] cFrame = [controlView frame];
    
    switch([self state]) {
        case [[NSOnState]]:
            if (!mouseIsDown) data = [triDown propertyList];
            else data = [triDownPressed propertyList];
            break;
        case [[NSOffState]]:
            if (!mouseIsDown) data = [triRight propertyList];
            else data = [triRightPressed propertyList];
            break;
        case [[NSMixedState]]:
            data = [triRightDown propertyList];
            break;
    }
    
    branchImage = [[[[NSImage]] alloc] initWithData:data];
    [branchImage drawInRect:[[NSMakeRect]](cFrame.size.width-14,cFrame.size.height-17,9,9) fromRect:[[NSMakeRect]](0,0,9,9) operation:[[NSCompositeSourceOver]] fraction:1];
    [branchImage release];
}

- (BOOL)startTrackingAt:([[NSPoint]])startPoint inView:([[NSView]] '')controlView
{
    BOOL start = [super startTrackingAt:startPoint inView:controlView];
    mouseIsDown = YES;
    [controlView display];
    return start;
}

- (void)stopTracking:([[NSPoint]])lastPoint at:([[NSPoint]])stopPoint 
              inView:([[NSView]] '')controlView mouseIsUp:(BOOL)flag
{
    [super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
    mouseIsDown = NO;
    [controlView display];
}

@end
</code>
----
Fixed a leak in setTitle.
----

This should be more generic. If the contentView is not an [[NSTextView]] it falls apart. 

----

How did you generate the triangle image data strings? I'm going to assume you didn't figure that out by hand ;)

----

Like this...
<code>
[[NSImage]] ''triangleImage;
[[NSString]] ''dataString;

// initialize triangleImage with the triangle image here
...

dataString = [[triangleImage [[TIFFRepresentation]]] description];
</code>