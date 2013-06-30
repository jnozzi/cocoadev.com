[http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSParagraphStyle_Class/index.html]

General/NSParagraphStyle and its subclass General/NSMutableParagraphStyle encapsulate the paragraph or ruler attributes used by the General/NSAttributedString classes.

----

To get a usable mutable paragraph style, you have to create a mutable copy of the General/NSParagraphStyle object returned by     General/[NSParagraphStyle defaultParagraphStyle]. Then make your changes to that object and put it in your string's attributes.

e.g. to get centered text:

    
General/NSMutableParagraphStyle *centeredStyle = General/[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
[centeredStyle setAlignment:General/NSCenterTextAlignment];

General/NSDictionary *attrs = General/[NSDictionary dictionaryWithObjectsAndKeys:General/centeredStyle copy] autorelease], [[NSParagraphStyleAttributeName, nil];

[centeredStyle release];

General/NSAttributedString *centeredString = General/[[NSAttributedString alloc] initWithString:@"This is\ncentered" attributes:attrs];

