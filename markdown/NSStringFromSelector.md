Apple Docs: http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Functions/index.html (scroll to General/NSStringFromSelector) 

This provides a way to convert from a SEL to an General/NSString. You can use General/NSSelectorFromString to convert back. 

Prototype:

General/NSString *General/NSStringFromSelector(SEL aSelector);