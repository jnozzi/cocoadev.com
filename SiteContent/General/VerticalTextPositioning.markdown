I have searched everywhere and found little information on positioning text vertically. I have a [[NSButton]] as an example. How could I position the text at the top of the button (vertically) as opposed to the center? I am using an Attributed String to position it horizontally, but have found no similar attribute for vertical positioning. Any help or pointers in the right direction. I have a feeling I am going to need to subclass [[NSButton]] and do it myself. Has anyone done this before?

----

There is no mechanism for setting the vertical position of text in an [[NSButton]]. You will have to subclass [[NSButtonCell]], since it is what's actually responsible for drawing the button. Note also that this is not standard Mac OS X UI. You may have a very, very good reason for changing the standard appearance of one of the most basic controls, but if you ''don't'' then you really shouldn't change it. Many users (myself included) shy away (read "run away screaming") from foreign, clunky-looking applications with strange buttons. Makes them wonder what else doesn't work as expected.

----

Thanks, [[NSButtonCell]] was an alternative. Has anyone done vertical spacing on a [[NSButtonCell]] before, and if so are there examples? I did some searching around and found people talking about it, but not much more. Also, yep, I have a good reason for wanting to change it :P... A very good reason dealing with an animation and enlarging a button and moving the text up.

----

It's not "an alternative" ... it's the only way you can accomplish your goal.

----
Yes, I know, Sorry, I meant that I was holding [[NSButtonCell]] as an alternative if I could not do what I wanted to with [[NSButton]]; which as stated above, would seem impossible. Therefore I will be using [[NSButtonCell]]... I will post my code for it here when I am done as there seem to be no examples of this in case anyone else wants to use it.

----

As promised, here is some code for a [[NSButtonCellEnhanced]].... Note it might not compile, but the overall code does work. I just had to strip out other parts as my cell does a lot more then just move text around :)

[[NSButtonCellEnhanced]].h
<code>
#import <Cocoa/Cocoa.h>
typedef enum {
	[[TopLeft]],
	[[TopRight]],
	[[TopCenter]],
	[[BottomLeft]],
	[[BottomRight]],
	[[BottomCenter]],
	[[LeftCenter]],
	[[RightCenter]],
	Center
} [[IMBTextPosition]];

@interface [[NSButtonCellEnhanced]] : [[NSButtonCell]] {
	[[NSMutableDictionary]] ''displayText;
}
- (void)setAttributedTitle:([[NSAttributedString]] '')aString;
- (void)setAttributedTitle:([[NSAttributedString]] '')aString atLocation:([[IMBTextPosition]])location;
- (void)setAttributedTitles:([[NSDictionary]] '')allStrings;
- (void)removeAttributedTitle:([[NSAttributedString]] '')aString atLocation:([[IMBTextPosition]])location;
- (void)clearAttributedTitles;
- ([[NSDictionary]] '')getAttributedTitles;
@end
</code>

<code>
#import "[[NSButtonCellEnhanced]].h"


@implementation [[NSButtonCellEnhanced]]
-init {
	if(self = [super init]) {
		displayText = [[[[NSMutableDictionary]] alloc] init];
	}
	return self;	
}
-(void)dealloc {
	[displayText release];
	[super dealloc];
}

- (void)setAttributedTitle:([[NSAttributedString]] '')aString {
	[self setAttributedTitle:aString atLocation:Center];
}

- (void)setAttributedTitle:([[NSAttributedString]] '')aString atLocation:([[IMBTextPosition]])location {
	[displayText setObject:aString forKey:[[[NSNumber]] numberWithInt:location]];	
}
- (void)setAttributedTitles:([[NSDictionary]] '')allStrings {
	[displayText release];
	displayText = [allStrings retain];
}
- (void)removeAttributedTitle:([[NSAttributedString]] '')aString atLocation:([[IMBTextPosition]])location {
	[displayText removeObjectForKey:[[[NSNumber]] numberWithInt:location]];
}
- (void)clearAttributedTitles {
	[displayText removeAllObjects];
}
-([[NSDictionary]] '')getAttributedTitles {
	return displayText;
}


-(void)drawTitlesWithFrame:([[NSRect]])frame inView:([[NSView]]'')controlView {
	[[NSEnumerator]] ''enumerator = [displayText keyEnumerator];
	id textPosition;
	id drawObject;
	[[NSSize]] contentBoundaries;
	while ((textPosition = [enumerator nextObject])) {
		int textPositionValue = [textPosition intValue];
		drawObject = [displayText objectForKey:textPosition];
		contentBoundaries = [drawObject size];
		switch (textPositionValue) {
			case [[TopLeft]]:
				if([drawObject isKindOfClass:[[[NSAttributedString]] class]]) {
					[([[NSAttributedString]]'')drawObject drawAtPoint:[[NSMakePoint]](0,(frame.size.height-contentBoundaries.height))];
				}
				break;
			case [[TopRight]]:
				if([drawObject isKindOfClass:[[[NSAttributedString]] class]]) {
					[([[NSAttributedString]]'')drawObject drawAtPoint:[[NSMakePoint]](frame.size.width-contentBoundaries.width,frame.size.height-contentBoundaries.height)];
				}
				break;
			case [[TopCenter]]:
				if([drawObject isKindOfClass:[[[NSAttributedString]] class]]) {
					[([[NSAttributedString]]'')drawObject drawAtPoint:[[NSMakePoint]]((frame.size.width-contentBoundaries.width)/2,(frame.size.height-contentBoundaries.height))];
				}
				break;
			case [[LeftCenter]]:
				if([drawObject isKindOfClass:[[[NSAttributedString]] class]]) {
					[([[NSAttributedString]]'')drawObject drawAtPoint:[[NSMakePoint]](0,(frame.size.height-contentBoundaries.height)/2)];
				}
				break;
			case [[RightCenter]]:
				if([drawObject isKindOfClass:[[[NSAttributedString]] class]]) {
					[([[NSAttributedString]]'')drawObject drawAtPoint:[[NSMakePoint]]((frame.size.width-contentBoundaries.width),(frame.size.height-contentBoundaries.height)/2)];
				}
				break;
			case Center:
				if([drawObject isKindOfClass:[[[NSAttributedString]] class]]) {
					[([[NSAttributedString]]'')drawObject drawAtPoint:[[NSMakePoint]]((frame.size.width-contentBoundaries.width)/2,(frame.size.height-contentBoundaries.height)/2)];
				}
				break;
			case [[BottomLeft]]:
				if([drawObject isKindOfClass:[[[NSAttributedString]] class]]) {
					[([[NSAttributedString]]'')drawObject drawAtPoint:[[NSMakePoint]](0,0)];
				}
				break;
			case [[BottomRight]]:
				if([drawObject isKindOfClass:[[[NSAttributedString]] class]]) {
					[([[NSAttributedString]]'')drawObject drawAtPoint:[[NSMakePoint]]((frame.size.width-contentBoundaries.width),0)];
				}
				break;
			case [[BottomCenter]]:
				if([drawObject isKindOfClass:[[[NSAttributedString]] class]]) {
					[([[NSAttributedString]]'')drawObject drawAtPoint:[[NSMakePoint]]((frame.size.width-contentBoundaries.width)/2,0)];
				}
				break;
			default:
				break;
		}
	}
}


// Overrideing this method prevents annoying 'Button' text
- ([[NSRect]])drawTitle:([[NSAttributedString]]'')title withFrame:([[NSRect]])cellFrame inView:([[NSView]]'')controlView {
	return cellFrame; 
}

- (void)drawBezelWithFrame:([[NSRect]])cellFrame inView:([[NSView]] '')controlView {
	[self drawTitlesWithFrame:cellFrame inView:controlView];
}

</code>



Hope it helps out other people

QUICK NOTE: You might want to put in an offset on the text close the either side of the button as its smushed right up against the side on some buttons as the actual button image does not always fill the entire button frame (especially with rounded or round buttons). Just play with it to see what I mean.