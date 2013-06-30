I have an app that is a General/NSView subclass.

What happens is that in the init method, an array is created by means of 
array = General/[NSMutableArray array];

When the program, in the drawRect method, attempts to access the array, it works once, but crashes with EXC_BAD_ACCESS afterwards.

The solution?

array = General/[[NSMutableArray array] retain];

The +array method returns an array to be autoreleased.

----

The shortest solution is General/[NSMutableArray new]. Such construction will create new array with retain count = 1. Using General/[[NSArray array] retain] will result in to unnecessary messages been sent: *autorelease* and *retain.* It also may increase a memory footprint of your app if you're creating a lot of such autoreleased objects in a loop.

-- General/DenisGryzlov

----
The most general solution is to read and understand General/MemoryManagement. This is not optional in Objective-C (yet). You *must* thoroughly understand General/MemoryManagement if you wish to write General/ObjC applications.

----
Another thing to look out for is having a nil at the end of     General/[NSArray arrayWithObjects:obj1, obj2, nil]. Without a nil, your array may work once or even twice and then fail suddenly. These kind of errors are hard to spot, so always check your init lists! --General/JeremyJurksztowicz