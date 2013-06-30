http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSNotification.html
----

General/NSNotification objects encapsulate information so that it can be broadcast to other objects by an General/NSNotificationCenter object. An General/NSNotification object (referred to as a notification) contains a name, an object, and an optional dictionary. The name is a tag identifying the notification. The object is any object that the poster of the notification wants to send to observers of that notification (typically, it is the object that posted the notification). The dictionary stores other related objects, if any. General/NSNotification objects are immutable objects.


Basically - you are handed these objects when you receive a notification - the original poster of the notification can put objects into an General/NSDictionary , you can get this dictionary  using the userInfo: method.