http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSArchiver_Class/Reference/Reference.html
----

closely related:
General/NSUnarchiver

more flexible: General/NSKeyedArchiver, General/NSKeyedUnarchiver (10.2 and later) - better forward/backward compatibility when you add or drop keys.

useful class method:
    
+ (General/NSData *)archivedDataWithRootObject:(id)rootObject


returns an General/NSData object representing an objectGraph of the rootObject (and therefore any objects encapsulated within that rootObject)

This is particularly useful when using with the General/NSDocumentDesign and the General/ModelViewController pattern - see General/UsingArchiversAndUnarchivers.