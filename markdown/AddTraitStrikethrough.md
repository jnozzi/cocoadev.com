Is there still no easy way to create a menu item that adds strikethrough to text in a textView?

I see the option in the font panel, but I see no easy way to replicate it into a menu item in the Fonts menu of my app.

Anyone?

General/GarrettMurray

----

This page describes making an General/NSAttributedString with specific font styles - including strikethrough and underline:

http://developer.apple.com/documentation/Cocoa/Conceptual/General/AttributedStrings/Tasks/General/AccessingAttrs.html

Here's an excerpt taken from it:


*The underline attribute has only two values defined, General/NSNoUnderlineStyle and General/NSSingleUnderlineStyle, but these can be combined with General/NSUnderlineByWorkMask and General/NSUnderlineStrikethroughMask to extend their behavior. By bitwise-General/ORing these values in different combinations, you can specify no underline, a single underline, a single strikethrough, both an underline and a strikethrough, and whether the line is drawn for whitespace or not.


You can edit an General/NSView through the view's General/NSTextStorage object which is a subclass of General/NSMutableAttributedString.

Is this what you were looking for?

-- General/RyanBates

----

There's also a new attribute, General/NSStrikethroughStyleAttributeName, introduced in Panther that controls the same effect.  Anyhoo, here's a quick category on General/NSTextView that implements a strikethrough action method that works like the corresponding -bold: and -underline: methods.  There's 2 methods that are functionally identical (more or less), one using the Panther attribute and one using the Jaguar attribute mask. -- Bo
    
@implementation General/NSTextView (General/StrikeThrough)
// note: I tried to make these methods behave identically to how the 
// -bold: and -underline: action methods, even when they act kinda stupid.
- (General/IBAction)pantherOnlyStrikethrough:(id)sender
{
	// since this is an editing action,
	// it should only make a change if it's editable
	if (![self isEditable]) {
		return;
	}
	General/NSMutableDictionary* typAttrs = General/[self typingAttributes] mutableCopy] autorelease];
	if (!typAttrs) {
		// the typing attributes can be nil so create an empty dict if that's the case
		typAttrs = [[[NSMutableDictionary dictionaryWithCapacity:1];
	}
	unsigned int currStrikeStyle = General/typAttrs objectForKey:[[NSStrikethroughStyleAttributeName] unsignedIntValue];
	unsigned int newStrikeStyle = (currStrikeStyle == General/NSUnderlineStyleNone) ? General/NSUnderlineStyleSingle : General/NSUnderlineStyleNone;
	// set the typing attributes to the new style
	[typAttrs setObject:General/[NSNumber numberWithUnsignedInt:newStrikeStyle] forKey:General/NSStrikethroughStyleAttributeName];
	[self setTypingAttributes:typAttrs];
	// if there's text selected, change it to match too
	General/NSRange selection = [self selectedRange];
	if (selection.length > 0) {
		General/self textStorage] addAttribute:[[NSStrikethroughStyleAttributeName 
					value:General/[NSNumber numberWithUnsignedInt:newStrikeStyle] range:selection];
	}	
}

- (General/IBAction)jaguarCompatibleStrikethrough:(id)sender
{
	// since this is an editing action,
	// it should only make a change if it's editable
	if (![self isEditable]) {
		return;
	}
	General/NSMutableDictionary* typAttrs = General/[self typingAttributes] mutableCopy] autorelease];
	if (!typAttrs) {
		// the typing attributes can be nil so create an empty dict if that's the case
		typAttrs = [[[NSMutableDictionary dictionaryWithCapacity:1];
	}
	unsigned int currStrikeStyle = General/typAttrs objectForKey:[[NSUnderlineStyleAttributeName] unsignedIntValue];
	unsigned int newStrikeStyle = (currStrikeStyle & General/NSUnderlineStrikethroughMask) ? 
		(currStrikeStyle & (~General/NSUnderlineStrikethroughMask)) : (currStrikeStyle | General/NSUnderlineStrikethroughMask);
	// set the typing attributes to the new style
	[typAttrs setObject:General/[NSNumber numberWithUnsignedInt:newStrikeStyle] forKey:General/NSUnderlineStyleAttributeName];
	[self setTypingAttributes:typAttrs];
	// if there's text selected, change it to match too
	General/NSRange selection = [self selectedRange];
	// because the General/NSUnderline style is a compound style, we have to iterate over it
	// to avoid overwriting any plain underlining in the range
	while (selection.length > 0) {
		General/NSTextStorage* theText = [self textStorage];
		General/NSRange currRange;
		unsigned int currUStyle = General/theText attribute:[[NSUnderlineStyleAttributeName atIndex:selection.location
			longestEffectiveRange:&currRange inRange:selection] unsignedIntValue];
		unsigned int newUStyle = (currStrikeStyle & General/NSUnderlineStrikethroughMask) ? 
			(currUStyle & (~General/NSUnderlineStrikethroughMask)) : (currUStyle | General/NSUnderlineStrikethroughMask);
		[theText addAttribute:General/NSUnderlineStyleAttributeName value:General/[NSNumber numberWithUnsignedInt:newUStyle] range:currRange];
		selection = General/NSMakeRange(selection.location + currRange.length, selection.length - currRange.length);
	}
}
@end


----

Exactly what I was looking for, Bo, thanks a ton! --General/GarrettMurray