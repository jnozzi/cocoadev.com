This is a Foundation Framework function used to convert the name of a method into the actual selector, which you can then use to test if a certain object has that method  which you want to call (using the General/NSObject method respondsToSelector).

Prototype:

SEL General/NSSelectorFromString(General/NSString *aSelectorName)

Apple Docs: http://developer.apple.com/documentation/Cocoa/Conceptual/General/ObjectiveC/3objc_language_overview/chapter_3_section_6.html#//apple_ref/doc/uid/20001424/TPXREF128  (scroll to General/NSSelectorFromString)

*The pages seems to have moved. Is it the new address?* http://developer.apple.com/documentation/Cocoa/Conceptual/General/ObjectiveC/General/LanguageOverview/chapter_4_section_6.html#//apple_ref/doc/uid/20001424-BAJHIAGB

A simple example:

    
SEL method;

method = General/NSSelectorFromString(@"setObject:");


Here we are assuming we have an object that has the method setObject:, note that the colons ":" must be included at the end of the string if and only if the method takes an argument.  If it doesn't, leave off the colon.

----

Use General/NSStringFromSelector to go the other way.