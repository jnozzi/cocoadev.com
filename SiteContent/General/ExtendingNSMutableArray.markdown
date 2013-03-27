This is strange (to me) .. I'm extending the General/NSMutableArray class, which in a simple example only overrides the count method.  But I'm getting the following runtime exception:

<General/NSInvalidArgumentException> *** -count only defined for abstract class.  Define -General/[IndexableMutableArray count]!

    
General/IndexableMutableArray.h:
@interface General/IndexableMutableArray : General/NSMutableArray
{
}

@end

General/IndexableMutableArray.m:

@implementation General/IndexableMutableArray

- (unsigned)count {
    General/NSLog(@"General/IndexableMutableArray:count");
    return [super count];
}
@end


What's wrong here??  Anyone?  :)

----
See General/ClassClusters for the question and General/TextFormattingRules for how to make your code not look terrible.

----
Excellent. Sorry for noobing out. Thanks for the tips.