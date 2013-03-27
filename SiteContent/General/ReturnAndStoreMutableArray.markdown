

I'm trying to arrange some General/XmlFileReading (using the General/CocoaDev.com page, of course), to save and retrieve an array I have.  However, the General/XCode Documentation says that "the array representation must contain only property list objects (General/NSString, General/NSData, General/NSArray, or General/NSDictionary objects)."  So what can I do in order to save this information?  Thanks.

----

General/NSMutableArray is a subclass of General/NSArray, so it can be stored in a property list with no problem. When you reload it, you'll need to convert it to a mutable form with     mutableCopy. If you have custom objects, you have to implement General/NSCoding for them