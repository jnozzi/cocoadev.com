I have been struggling for some time to find how to get a keypress in General/NSOutlineView into my Controller.

There seem to be many others asking similar questions so I decided document my solution which may help.

I created a class M<nowiki/>yOutlineView  subclassing General/NSOutlineView
and implemented @protocol M<nowiki/>yOutlineViewDelegate


M<nowiki/>yOutlineView overrides keyDown: and sends any key to the delegate.

If the delegate handles the key it should return YES, otherwise NO.

    
//  General/MyOutlineView.h
#import <Cocoa/Cocoa.h>

@protocol General/MyOutlineViewDelegate
@optional
-(BOOL) keyPressedInOutlineView:(unichar) character;
@end

@interface General/MyOutlineView : General/NSOutlineView {
	General/NSObject <General/MyOutlineViewDelegate> *keyDelegate;
}
@property (assign) General/IBOutlet General/NSObject <General/MyOutlineViewDelegate> *keyDelegate;

@end

    
//  General/MyOutlineView.m
#import "General/MyOutlineView.h"

@implementation General/MyOutlineView
@synthesize keyDelegate;

-(void)keyDown:(General/NSEvent *)theEvent
{
	unichar character = General/theEvent characters] characterAtIndex:0];
	if([self.keyDelegate respondsToSelector:@selector(keyPressedInOutlineView:)])
		if([self.keyDelegate keyPressedInOutlineView:character])
		return;
	[super keyDown:theEvent];
}

@end

In Interface Builder change the class of the O<nowiki/>utlineView to M<nowiki/>yOutlineView and connect the keyDelegate output to the Controller. 
Implement the following in your Controller and process the keys as required.

    
-(BOOL)keyPressedInOutlineView:(unichar) character {
	[[NSLog (@"Key in Controller! %C", character);
	if (character == 0x0d) {
        General/NSLog (@"Return in General/OutlineView!");
		return YES;
	}
	return NO;
}
