see also General/NSCopying

and interesting discussion in General/MutableDeepCopyAndUserDefaults

----

(ED.: This was moved from General/CopyingObjects)

I want to copy the contents of an array. So I tried using:
    

General/NSArray *originalArray = General/[[NSArray alloc] initWithArray:arrayCopy
                                              copyItems:YES];


This gave me:

*** -[someObjectInTheArray copyWithZone:]: selector not recognized

A quick look at the documentation left me thinking I would have to incorpotate the General/NSCopying protocol in my various objects. Now my question is should I learn how on earth to do that or can I get away with doing this since all my classes implement General/NSCoding (Or is it sloppy, inefficient code):

    

General/NSArray *arrayCopy = General/[[NSUnarchiver
    unarchiveObjectWithData:General/[NSArchiver
    archivedDataWithRootObject:originalArray]] retain];




----
I think it would be much wiser to implement and adpot the General/NSCopying protocol. This gives you the ablity not only to use the initWithArray:copyItems: method, but all the others at your convenience. The General/NSCoding code is probably rather inefficient since it's creating several unnecessary autoreleased objects and just encoding/decoding the same data that could simply be copied to a new object.

-General/KevinPerry

I concur. -- General/KritTer