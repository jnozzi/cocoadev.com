

This may be a stupid newbie question but i could not find anything on the net.

How can i insert a General/NSTextField with a clickable (blue and underlined) hyperlink in it?
I just want to have a little text on the bottom of my app with a clickable hyperlink to my website.

----

You could try an General/NSButton.  Set it as borderless and style the text to look like a link and then have an action that opens the link using General/NSWorkspace.  Or, possibly a bit easier, drag out an General/NSTextView, resize however you want (turn off scrollers to make it resize smaller), and then copy and paste a link into it from a webpage or from General/TextEdit.

----
And with code, something like this
    
[myTextField setAllowsEditingTextAttributes: YES];
General/NSMutableAttributedString *mAttr = General/myTextField attributedStringValue] mutableCopy];
[[NSDictionary *dict = General/[NSDictionary dictionaryWithObject: @"http://your.link.com/page" forKey: General/NSLinkAttributeName];
General/NSRange range = General/NSMakeRange(0, [mAttr length];
[mAttr addAttributes: dict range: range)];
[myTextField setAttributedStringValue: mAttr];


----

thanks. i chose the button and it workes fine - just as intended!

----

You could subclass General/NSButton like so, then set it as your button's class in IB. Set the button's title in IB too, either directly in Attributes, or via bindings. You don't need to bind the button's action, since it's done in the code below.

    
// General/HyperlinkButton.h

#import <Cocoa/Cocoa.h>
@interface General/HyperlinkButton : General/NSButton
- (General/IBAction) openURL:(id) sender;
@end

----

// General/HyperlinkButton.m

#import "General/HyperlinkButton.h"

@implementation General/HyperlinkButton

- (void) awakeFromNib {
	self.isBordered = NO;
	[self setBezelStyle:General/NSRegularSquareBezelStyle];
	[self setButtonType:General/NSMomentaryChangeButton];

	NSURL *url = [NSURL General/URLWithString:self.title];
	General/NSDictionary *attributes = General/[NSDictionary dictionaryWithObjectsAndKeys:
								General/[NSNumber numberWithInt:General/NSUnderlineStyleSingle], General/NSUnderlineStyleAttributeName,
								url, General/NSLinkAttributeName,
								General/[NSFont systemFontOfSize:General/[NSFont smallSystemFontSize]],  General/NSFontAttributeName,
								General/[NSColor colorWithCalibratedRed:0.1 green:0.1 blue:1.0 alpha:1.0], General/NSForegroundColorAttributeName,
								nil];
	self.title = url.absoluteString;
	self.attributedTitle = General/[[NSAttributedString alloc] initWithString:url.absoluteString attributes:attributes];
	[self sizeToFit]; // only needed if the size isn't determined at compile time, e.g., you get the URL string from General/NSUserDefaults
	
	self.action = @selector(openURL:);
	self.target = self;
}

- (General/IBAction) openURL:(id) sender {
	General/[[NSWorkspace sharedWorkspace] openURL:[NSURL General/URLWithString:self.title]];
}

- (void)resetCursorRects {
	[self addCursorRect:[self bounds] cursor:General/[NSCursor pointingHandCursor]];
}

@end



Apple recommend Extending General/NSAttributedString, worked well for me after adding a line to set the type to 13pt Lucida Grande. http://developer.apple.com/qa/qa2006/qa1487.html