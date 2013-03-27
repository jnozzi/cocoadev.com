Apple documentation:

*http://developer.apple.com/documentation/General/CoreFoundation/Conceptual/General/CFCollections/Concepts/types.html
*http://developer.apple.com/documentation/General/CoreFoundation/Conceptual/General/CFCollections/Tasks/usingtrees.html
*http://developer.apple.com/documentation/General/CoreFoundation/Reference/General/CFTreeRef/index.html


----

General/CFTree is a General/CoreFoundation class to implement tree structures. It is not General/TollFreeBridged with a Cocoa class. It is unique among CF's collection classes in that an instance of General/CFTree does not represent the entire tree, but instead is one node of the tree.

Each instance of General/CFTree has a parent General/CFTree instance, a number of child General/CFTree instances, a pointer to the node's data, a retain callback, a release callback, and a description callback. A General/CFTree with no parent is the root node. The data pointer and callbacks are in a General/CFTreeContext struct.

You don't have to use the pointer as a pointer. You can put a long integer there if you like. But if you do use it as a pointer, you have five options to deal with the data's lifetime:

*You can use a built-in General/CoreFoundation type, such as General/CFNumber or General/CFData, or a bridged Cocoa equivalent. The retain, release, and description call-backs can be set to General/CFRetain, General/CFRelease, and General/CFCopyDescription respectively.
*You can store an General/ObjectiveC id, but you'll have to write C callbacks that call the object's **retain**, **release**, and **description** methods.
*You can keep an object pool. Everything that gets added to the tree goes in the pool, and the pool gets freed when you are done with the General/CFTree. You won't need to implement the retain or release call-backs.
*You add a reference count to the data, or make a wrapper that includes a reference count. You would then have to implement the retain and release callbacks.
*You can track lifetime separately somehow. You would have to implement the retain and release callbacks.


Parents retain children, but children do not retain parents. No cycles are allowed (i.e. a node's ancestor cannot be one of the node's children).

Operations include sorting children and applying a function to children. These operations are not recursive (i.e., they don't affect the children's children).

Simple example code of calling these functions can be found at
http://www.carbondev.com/site/?page=General/CFTree

----

I thought I remembered there being a multitude of General/CFTree Cocoa wrappers but when we were discussing it in #macdev today we couldn't find one.  I took the liberty of knocking one out and releasing it under the BSD licence for your programming pleasure.

Goto General/JKPTree for details.

JKP