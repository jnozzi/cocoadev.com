Apple's Cocoa docs don't describe the keys and values that can be used for attributes. Take a look at General/NSAttributedString.h for a list of keys and value types. I'm pasting them here, hope this doesn't violate copyright...

*I believe they're listed in the docs for General/NSTextStorage,*

**Nope, they're under General/NSAttributedString Additions: http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSAttributedString.html **

    
/* Predefined character attributes for text. If the key is not in the dictionary, then use the default values as described below.
*/
APPKIT_EXTERN General/NSString *General/NSFontAttributeName;             /* General/NSFont, default Helvetica 12 */
APPKIT_EXTERN General/NSString *General/NSParagraphStyleAttributeName;   /* General/NSParagraphStyle, default defaultParagraphStyle */
APPKIT_EXTERN General/NSString *General/NSForegroundColorAttributeName;  /* General/NSColor, default blackColor */
APPKIT_EXTERN General/NSString *General/NSUnderlineStyleAttributeName;   /* int, default 0: no underline */
APPKIT_EXTERN General/NSString *General/NSSuperscriptAttributeName;      /* int, default 0 */
APPKIT_EXTERN General/NSString *General/NSBackgroundColorAttributeName;  /* General/NSColor, default nil: no background */
APPKIT_EXTERN General/NSString *General/NSAttachmentAttributeName;       /* General/NSTextAttachment, default nil */
APPKIT_EXTERN General/NSString *General/NSLigatureAttributeName;         /* int, default 1: default ligatures, 0: no ligatures, 2: all ligatures */
APPKIT_EXTERN General/NSString *General/NSBaselineOffsetAttributeName;   /* float, in points; offset from baseline, default 0 */
APPKIT_EXTERN General/NSString *General/NSKernAttributeName;             /* float, amount to modify default kerning, if 0, kerning off */
APPKIT_EXTERN General/NSString *General/NSLinkAttributeName;		 /* ??? id <General/NSTextLink>; link */

-- General/WayneAndrewLee

See Apple documentation at http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSAttributedString_Class/index.html

----

Those are the attributes the system will recognize and do something with. You can assign any object and any key for an attribute - it's just a dictionary, after all. 

----

General/NSAttributedString is a schizophrenic class; the basics are implemented in Foundation, but then a lot of stuff is added via categories in General/AppKit. In order to find out everything, you need to read the docs for the class in both sections. The General/AppKit section has all of the officially-recognized attributes; look for "General/NSAttributedString Additions" in the General/AppKit list of classes.

*I'd call it 'well-designed' not schizophrenic. The basics are implemented in Foundation, and then the stuff that makes sense to be in General/AppKit is in General/AppKit.*

Just to clearify things a bit. General/NSAttributedString is a class that can associate "attributes" to subranges of a string. That is it. Now, the Application Kit uses General/NSAttributedStrings to represent formatted text. "Font" doesn't mean anything to foundation. That is why the part of the class that deals with fonts, colors, baselines, hyperlinks, and all other manners of human-string interaction is in the Application Kit. The Application Kit has a text system that can layout an attributed string on the screen and to do so, it has you key the string with attributes that mean something to it ... that is why the key names are in the application kit. Jon H.
----

see General/NSAttributedStringInPractice for concrete usage examples

General/EcumeDesJours

----

I was wondering if you pass and General/NSAttributedString with newlines in it, to drawAttributedString:atPoint (I think that's right), in an General/NSView, will it draw it properly? (ie. drawing each line correctly). I am at work right now, so I cant try this. Just wondering if anyone has tried this.

*It works as expected from my experience.*

*it's just     drawAtPoint:. the message is sent to the string, which already knows its attributes.*

The General/NSString method is     drawAtPoint:withAttributes:, as General/NSString has no attributes of its own, and it needs some to draw itself.

----

If you bind a General/NSTextView attributedString value to a General/NSAttributedString, then your bound value apparently always needs to return a non-nil value. I was returning a nil value in some cases (when I want the General/NSTextView to be empty), but OS X kept giving me the exception:

   -General/[NSBigMutableString replaceCharactersInRange:withString:] called with nil argument

Note I wasn't directly calling replaceCharactersInRange, the OS was after getting the bound value nil. If you link against the Tiger SDK, then an exception is thrown. Pre-Tiger and a warning is just logged. Returning an empty General/NSAttributedString instead of nil avoids the exception and warning. --General/MattBendiksen

----
i heard that we can have rotated text using General/NSAtrributedString so i want to know How to layout  the text in circular fashion using General/NSAttributedString??? i couldn't modify circleview example because we canot apply cut,copy etc to text. even cursor will not be visible.

----
There are two separate questions there. One, can you draw rotated text? Sure, and the example shows you how. Two, can you *edit* rotated text? The answer is no, at least not without basically rewriting the Cocoa text system. Nothing standard on OS X even supports *vertical* text layout, and that's something that's actually practical and useful for many popular human languages.

----

I wouldn't go as far as to say it requires a rewrite of the entire text system. Basically if you can construct a mapping between a point on the screen and a character offset, you can edit the text. Accepted, it isn't supported by General/NSTextView etc by default, but it wouldn't be hard to accomplish. You'd have to draw the selection highlight, cursor, etc yourself, but all the actual editing and layout can be handled by the standard text system classes. Another way of looking at it is that the real edition is done offscreen, and what you see onscreen is a transformed version of it. You just need to implement that transformation in both directions and you can edit the text directly. --General/GrahamCox

----

Could one use an attributed string to correctly draw mathematics such as definite integrals?