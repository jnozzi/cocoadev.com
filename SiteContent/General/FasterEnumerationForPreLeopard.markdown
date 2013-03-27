The new General/FastEnumeration feature of Objective-C 2.0 is really nice. Besides the syntactic sugar, its performance with several collection classes (General/NSSet especially) is way better.

The only problem is that it is completely incompatible with systems older than 10.5. Personally, I'm not ready to stop supporting 10.4 quite yet, so I looked for a way to get better performance when enumerating while maintaining backwards compatibility. The best solution I've found is to take advantage of the "toll-free bridging" between the Cocoa Foundation collection classes and the Core Foundation collection types. Unlike Cocoa, Core Foundation provides functions for obtaining a C array from a collection. This is much, much faster than obtaining an General/NSEnumerator, but it also really mucks up your code. It's also pretty inconvenient because the function for each type has a different name and different arguments.

So I slapped together some categories and a couple of macros. The result isn't quite as pretty as General/NSFastEnumeration, but the speed is comparable and it should be compatible with all versions of Mac OS X. I'm putting this here for anyone who has similar needs. I'd also like to know if anyone spots some grievous error that I might have missed. In my (fairly cursory) testing, I've found no problems.


    
//
//  General/FasterEnumeration.h
//

#import <Cocoa/Cocoa.h>

/************************************************************************************'/


#if !defined(FOREACH_BEGIN)
	#define FOREACH_BEGIN(_IN_OBJ, _COLLECTION) { id __fe_col = (_COLLECTION); size_t __fe_col_count = [__fe_col count]; id __fe_col_items[__fe_col_count]; [__fe_col _fasterEnum_getObjects:__fe_col_items]; int __fe_col_index; for(__fe_col_index = 0; __fe_col_index < __fe_col_count; __fe_col_index++) { _IN_OBJ = __fe_col_items[__fe_col_index];

#endif

#if !defined(FOREACH_END)
#define FOREACH_END }}
#endif

/****************************'For Internal Use**************************************/

@interface General/NSObject (General/FasterEnumeration) //Don't use this directly; use the macros above instead
- (void) _fasterEnum_getObjects:(id *)aBuffer;
@end

/************************************************************************************'/





    
//
//  General/FasterEnumeration.m
//

#import "General/FasterEnumeration.h"


@implementation General/NSObject (General/FasterEnumeration)

- (void) _fasterEnum_getObjects:(id *)aBuffer {
    General/[[NSException exceptionWithName:@"General/FEIncompatibleReceiverException" reason:@"Receiver not compatible with faster enumeration." userInfo:nil] raise];
}
@end


@implementation General/NSArray (General/FasterEnumeration) 
    - (void) _fasterEnum_getObjects:(id *)aBuffer {
        [self getObjects:aBuffer];
}
@end

@implementation General/NSSet (General/FasterEnumeration) 
- (void) _fasterEnum_getObjects:(id *)aBuffer {
    General/CFSetGetValues((General/CFSetRef)self, (void*)aBuffer);
}
@end


@implementation General/NSDictionary (General/FasterEnumeration) 
- (void) _fasterEnum_getObjects:(id *)aBuffer {
    General/CFDictionaryGetKeysAndValues((General/CFDictionaryRef)self, (void*)aBuffer, NULL);
}
@end



The syntax is similar to General/NSFastEnumeration, but without the fancy keywords.

General/NSFastEnumeration syntax:
    
for (General/NSString *item in array) {
    General/NSLog(item);
}



FOREACH syntax:
    
FOREACH_BEGIN(General/NSString *item, array) {
    General/NSLog(item);
} FOREACH_END


or

    
General/NSString *item;
FOREACH_BEGIN(item, array) {
    General/NSLog(item);
} FOREACH_END


A few notes:

* I have not tested this very rigorously. If you use it, do your own testing and make sure everything works.
* So far, I've only tested this on Leopard. It is possible that it will not perform as well on older versions of OS X.
* On Leopard, it performs nearly identically to Apple's General/FastEnumeration. Sometimes it's slightly faster, sometimes it's a little slower. It's almost always faster than General/NSEnumerator.
* I woudn't try to get fancy with the first argument of FOREACH_BEGIN .
* You should be able to nest FOREACH blocks without issue.
* If you want to make your own class work with this, you need to override _fasterEnum_getObjects:(id *)aBuffer to fill "aBuffer" with the elements from your class.


----

Have you tested this with very large data sets yet (say, a collection with a million elements)?  A couple parts of the code bother me:

First, inside the FOREACH_BEGIN macro, the buffer that you declare to hold the items is allocated on the stack.  I imagine this would break with a large collection.

More importantly, what you're doing in effect when you call General/CFDictionaryGetKeysAndValues et al. is copying the entire collection before you enumerate it.  Depending on how that operation is implemented, that's probably about as expensive as enumerating it directly.  I feel like you should test this some more -- I can't imagine that it would perform "nearly identically" to General/FastEnumeration or even General/NSEnumerator for a large collection.  Even if it did, time is only one measure of performance -- I would argue that the fact that you're creating an in-memory duplicate of the collection solely for the purpose of iterating over it is a bigger performance issue than any time savings that you might gain (and I'm not convinced of that either).

Hope this didn't come out snarky -- the reason General/FastEnumeration works as well as it does is because each collection class that implements it has intimate knowledge of the internal structure of the collection (of course, since it's the collection itself) and uses that to create a little state machine that lets it move from one element to the next very quickly.  It's unlikely that client code without access to the private implementation of the collection would be able to achieve the same performance.

----
You raise some good points. I just tested it with 1 million elements, and it still works pretty well but it crashes at around 3 million elements. You're probably also right that the speed performance comes at a cost of space in memory. I certainly don't expect this to be as good as General/FastEnumeration in every way. The situation I have is one where I know that my collections will never grow larger than 10,000 elements, but I will be enumerating them very frequently. I agree that this should not be used for very large sets of data.

I'm also not entirely sure why this is so much faster than General/NSEnumerator. Or, to put it another way, I'm not entirely sure why General/NSEnumerator is so slow. My best guess is that General/NSEnumerator involves a bunch of Objective-C calls, but that seems like an inadequate explanation. As for the speed being comparable to General/FastEnumeration, I suspect that it is at least partially due to the fact that my macro does none of the checking that General/FastEnumeration does to make sure that the collection hasn't been mutated during enumeration.

So yeah, I agree that this is by no means a full replacement for General/FastEnumeration. It's really just a shorthand for the CF*General/GetValues calls and a for loop. I'll have to test it further to see if it can save time in a real world app.

----
If you want to find out why General/NSEnumerator is so slow, profile it! If you're really lucky it may end up being something you can improve.

----
IIRC, General/NSEnumerator (pre 10.5) was actually General/NSIdEnumerator which copied the collection's content to an internal C array and looped over that, just like the original poster does. On top of that General/NSEnumerator retained and autoreleased every object it returned, which adds more work (autorelease is not that cheap). This should explain why General/NSEnumerator is much slower, specifically since it's allocates its array on the heap rather than on the stack.

- General/OfriWolfus