

I'm drawing a string in my custom General/NSView subclass with the General/[NSString drawAtPoint:General/NSPoint] method.

This works great... but I need to know how wide the resulting string will be in pixels, so that I can abbreviate it if necessary (it's going in some kind of simple graphical container). How can I find out whether the drawn string will be too long?

Counting characters in the string is not going to cut it really due to proportionally spaced fonts etc. I can't be sure that I'll be cutting the string off at the right point. Although this is the only way I know of off the top of my head.

----

Use General/NSAttributedString then you can use its     -size method to get the General/NSSize of it, using whatever font you want.

    
General/NSAttributedString *astr = General/[[NSAttributedString alloc] initWithString:@"someString"];
General/NSSize strSize = [astr size]; // contains the size of astr

[astr drawAtPoint:somePoint]; // can use same method for drawing

[astr release];


----

There's also the General/NSString method     -sizeWithAttributes: and a code snippet in General/BetterTruncatingStringsInTableView that demonstrates how to abbreviate a string to fit.  -- Bo

----

----

**Find the center of a drawn string**

I have drawn an General/NSString * to a custom view using - drawAtPointWithAttributes and would like to find the center of the string. Is this possible?

The code looks like this:

    [text drawAtPoint:center withAttributes:attribs];

--General/JohnDevor

----
General/NSStringDrawing.h
- (General/NSSize)sizeWithAttributes:(General/NSDictionary *)attrs;

See also: General/DynamicallySizingScalingText