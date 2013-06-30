

Just want to know how to get the memory footprint of an object.

The code below prints "size of a General/NSObject: 4"
    
General/NSLog (@"size of a General/NSObject: %i", sizeof (General/NSObject));


Even according to Foundation/General/NSObject.h it is 4 bytes:

    
@interface General/NSObject
{
	Class isa;
}
...


but I know it can't be (i.e. what about the retain count and other stuff which is private???)

Is there any way to determine exactly the footprint of any object? Thx

-- peacha

----

Because all you are really checking with the function sizeof is the size of the pointer to the object.  So 4 bytes is correct for that.  The size of the object itself has its size checked using a different method.  -- General/DavidKopec

General/NSObject is not a pointer, it is the object itself. id is a pointer. -- General/KritTer

----

General/KritTer is right. If you want a proof:

    

@interface General/MyObject : General/NSObject
{
	id anID;
}
@end

void showMe ()
{
	General/NSLog (@"size of General/MyObject: %i", sizeof (General/MyObject));
}



gives "size of General/MyObject: 8"

Back to the question: I haven't found find any class methods or whatever giving the size of an object... Any help?

-- peacha

----

Alas, even the objc runtime agrees with sizeof. The following:

    
    General/NSLog(@"General/NSObject size: %d",
          ((struct objc_class *)General/[NSObject class])->instance_size);
    General/NSLog(@"General/NSObject ivars: %d",
          ((struct objc_class *)General/[NSObject class])->ivars->ivar_count);


gives "General/NSObject size: 4" and "General/NSObject ivars: 1". ("ivars" = instance variables")

I assume the retain count is kept elsewhere, perhaps by the General/NSAutoreleasePool class.

--General/KritTer

----

So it seems like I can trust sizeof...
Thx -- peacha

----

I don't know for sure how it's implemented by Apple, but I can tell you how it's implemented in General/GNUstep. Here is a small part of the General/NSObject code :

    
/*    Copyright (C) 1994, 1995, 1996 Free Software Foundation, Inc.
 *    This file is part of the General/GNUstep Base Library.
 *    Released under the GPL v2
 */
- (id)retain
{
  General/NSIncrementExtraRefCount(self);
  return self;
}

void
General/NSIncrementExtraRefCount(id anObject)
{
  if (allocationLock != 0)
    {
      objc_mutex_lock(allocationLock);
      ((obj)anObject)[-1].retained++;
      objc_mutex_unlock (allocationLock);
    }
  else
    {
      ((obj)anObject)[-1].retained++;
    }
}


So the retain count is kept 4 bytes *before* the actual position of the 
pointer. Why is it done like this ?

Partly to support garbage collecting. It lets you add garbage collecting without changing the interface of any class, you would just need to change the alloc/retain/release/dealloc methods of General/NSObject.

General/GNUstep does support garbage collecting for the base library (the equivalent of
the General/FoundationKit), but I never tried 'cause it doesn't work for the gui part.

--General/PierreYvesRivaille