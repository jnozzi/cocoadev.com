

Part of the iPhone [[UIKit]] framework. Subclass of [[UIView]].

Analogous to [[NSControl]]. [[UIControl]] does not, however, implement setTarget: and setAction: methods like [[NSControl]] does: It has a single method

  %%BEGINCODESTYLE%%- (void)addTarget:(id)target action:(SEL)action forEvents:(int)eventMask;%%ENDCODESTYLE%%

which lets one control have multiple targets, and call back in response to different events. The event mask appears to be the same as [[NSEvent]]'s mask enum.

<code>
        /'' from http://ellkro.jot.com/[[WikiHome]]/iPhoneDevDocs/[[UIControl]] ''/
        #define [[UIMouseDown]]                     1
        #define [[UIMouseDragged]]                1<<2  //within active area of control
        #define [[UIMouseExitedDragged]]     1<<3  //move outside active area 
        #define [[UIMouseEntered]]                  1<<4 //move crossed into active area
        #define [[UIMouseExited]]                   1<<5 //move crossed out of active area
        #define [[UIMouseUp]]                   1<<6 //up within the active area
        #define [[UIMouseExitedUp]]              1<<7 //up outside active area
        /'' end from http://ellkro.jot.com/[[WikiHome]]/iPhoneDevDocs/[[UIControl]] ''/

	[[UIValueButton]]'' button = [[[[UIValueButton]] alloc] initWithFrame:rect];
	
	[button addTarget:self action:@selector(buttonDown:) forEvents:1 /'' mouse down ''/];
	[button addTarget:self action:@selector(buttonUp:) forEvents:(1<<6) /'' mouse up ''/];
</code>