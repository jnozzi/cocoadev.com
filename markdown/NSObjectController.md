 

**See:** http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSObjectController_Class/index.html

----

General/NSObjectController is a controller class compatible with General/CocoaBindings. Properties of the content object of an instance of this class can be bound to user interface elements to access and modify their values.

By default the content object of an General/NSObjectController instance is General/NSMutableDictionary. This allows you to use a single General/NSObjectController instance to manage many different properties referenced by key value paths. The default content object class can be changed by calling setObjectClass:, which subclassers must override.