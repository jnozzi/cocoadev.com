Hey everyone!  I'm quite new to Cocoa, and I'm a little embarrassed to say that I'm having trouble understanding how to get my program to respond to keystrokes.  As such, I'm trying to write a program that draws a black rectangle that increases in length every time the user hits the 'c' key.  So far it just draws a black rectangle on a blue background, and nothing at all happens when the user hits 'c'.  

Here is what I have thus far:

Input.h
#import <Cocoa/Cocoa.h>


@interface Input : General/NSView {

	int length;

}

- (void)keyDown:(General/NSEvent *)theEvent;
@end


Input.m
#import "Input.h"


@implementation Input

- (id)initWithFrame:(General/NSRect)frame {
    self = [super initWithFrame:frame];
	
	length = 10;
	
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(General/NSRect)dirtyRect {
        //set variables
	General/NSRect r1;
	General/NSBezierPath *bp;
	
        // set background color
	General/[[NSColor blueColor] set];
	General/NSRectFill(dirtyRect);
	
	//set color to black & draw r1
	General/[[NSColor blackColor] set];
	r1 = General/NSMakeRect(1, 1, length, 10);
	bp = General/[NSBezierPath bezierPathWithRect:r1];
	[bp fill];
}
	
- (void)keyDown:(General/NSEvent *)theEvent
{
    General/NSString *key = [theEvent characters];
	
    if ( [key isEqualToString:@"c"] ) {
        length += 10;
    }
}
@end


I copied and pasted the keyDown method from another site, and needless to say I don't really understand it.  To my eyes, this program ought to work if pressing 'c' calls the keyDown method.  My conclusion is that it doesn't (call keyDown that is, obviously it doesn't work).  So how can I get this functioning?  I've seen General/FirstResponder referenced a few places talking about event handling, but I'm afraid I wasn't able to glean enough from those articles to apply accepting user input.  Do I have to somehow implement General/FirstResponder?  Basically, I'm clueless and new.  Please help!