Hi,

Is there a way to allocate a class based just on its name?

What I would like to do is something like:

General/CustomObject *myObj = (General/CustomObject *)General/@"className" alloc] init];

where className is the name of a sub-class of [[CustomObject;

Any suggestions?

Regards,

Huibert Aalbers

----

Yes. See General/NSClassFromString

Also check out Apple's documentation on the Objective-C Runtime: 
http://developer.apple.com/documentation/Cocoa/Reference/General/ObjCRuntimeRef/index.html#//apple_ref/doc/uid/TP40001418
also
http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Functions/General/FoundationFunctions.html#//apple_ref/doc/uid/20000055-180572

----

Thanks a lot, this was very useful. Maybe there should be a reference to this in the Memory management section.

----

Loading classes at run-time isn't related to memory management. Memory management deals specifially with keeping track of allocated memory, and knowing when to release that memory.