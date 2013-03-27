http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSValue_Class/

An General/NSValue object serves as an object wrapper for a standard C or Objective-C data item, allowing it to be stored in a collection object such as an General/NSArray or General/NSDictionary.

General/NSValue is NOT a property list format - you can't write one to disk in General/NSUserDefaults, for example. Use the various General/NSStringFrom* foundation functions to do this. (General/NSNumber, a subclass of General/NSValue, IS a property list format.)

----
[http://developer.apple.com/documentation/Cocoa/Conceptual/General/ObjectiveC/4objc_runtime_overview/chapter_4_section_6.html] has a list of the return types for objCType, to determine the type of data a General/NSValue contains.

----

The above link is no longer working. [http://developer.apple.com/documentation/Cocoa/Conceptual/General/ObjectiveC/Articles/chapter_13_section_9.html] appears to be the new location. Probably a better practice to just use @encode() anyway, I'd assume.

----

What's the difference between these two creation methods?

    
+ (General/NSValue *)value:(const void *)value withObjCType:(const char *)type;
+ (General/NSValue *)valueWithBytes:(const void *)value objCType:(const char *)type;


The documentation for the two are nearly identical, save for the second that has this very odd line "This method is equivalent to value:withObjCType:, which is part of Cocoa. "

----

General/GNUstep docs say the second one is a " Synonym for value:withObjCType:." I dunno...

----

These functions are identical. In fact the first one calls the second one, which makes valueWithBytes perform better :-)