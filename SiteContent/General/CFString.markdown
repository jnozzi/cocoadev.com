General/CFString is the General/CoreFoundation version of General/NSString, and is used in much the same way. Like many other basic General/CoreFoundation types, General/CFString is toll-free bridged with General/NSString, which means that you can safely cast a     General/CFStringRef to an     General/NSString * and vice versa.

Simple examples of calling various General/CFString functions can be found at
http://www.carbondev.com/site/?page=General/CFString
----
Panther provides two functions for escaping and unescaping XML and HTML entities:


*General/CFStringRef General/CFXMLCreateStringByEscapingEntities(General/CFAllocatorRef allocator, General/CFStringRef string, General/CFDictionaryRef entitiesDictionary)
*General/CFStringRef General/CFXMLCreateStringByUnescapingEntities(General/CFAllocatorRef allocator, General/CFStringRef string, General/CFDictionaryRef entitiesDictionary)


Unfortunately, General/CFXMLCreateStringByEscapingEntities is buggy, as described at http://www.cocoabuilder.com/archive/message/cocoa/2004/11/2/120728 .

To verify one of the bugs, run this code:

    
General/NSString* a = @"one < two";
General/NSString* b = (General/NSString*)General/CFXMLCreateStringByEscapingEntities(kCFAllocatorDefault, (General/CFStringRef)a, NULL );
General/NSLog( @"String \"%@\" became \"%@\"", a, b );


In Panther this yields 
    
2005-04-12 16:39:35.313 testFoundation[561] String "one < two" became "one &lt;"


Note that the final "two" is chopped off.

----
On OS X 10.4.2 at least, this particular bug seems to be fixed:
String "one < two" became "one &lt; two"
I haven't checked on any other bugs