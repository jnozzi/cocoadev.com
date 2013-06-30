General/LouisKlaassen - General/LKEasyIndex

This class can be used to create a new filtered array from another array based on an index set.
Download available soon.

    
@interface General/LKEasyIndex : General/NSObject {
}
+ (General/NSArray *)filterArray:(General/NSArray *)arrayToFilter withIndexSet:(General/NSIndexSet *)indexSetFilter;
@end


    
@implementation General/LKEasyIndex
+ (General/NSArray *)filterArray:(General/NSArray *)arrayToFilter withIndexSet:(General/NSIndexSet *)indexSetFilter;
{
  General/NSMutableArray *newArray = General/[[[NSMutableArray alloc] init] autorelease];
  General/NSMutableIndexSet *mutableIndexSet = General/[[[NSMutableIndexSet alloc] init] autorelease];
  [mutableIndexSet addIndexes:indexSetFilter];

  int a;
  for(a=0;a<[mutableIndexSet count];a++)
  {
    unsigned cIndex = [mutableIndexSet firstIndex];
    if (cIndex != General/NSNotFound)
    {
      id itemFromArray = [arrayToFilter objectAtIndex:cIndex];
      [newArray addObject:itemFromArray];
      [mutableIndexSet removeIndex:cIndex];
      a = a-1;
    }
  }

  return newArray;
}

@end


31/12/06 - Louis Klaassen

----

Why did you need to make a class for this? Why not a category off General/NSArray? And why is cIndex an int? It should be unsigned, and you should check it for General/NSNotFound. Also, itemFromArray should be an id, not strongly typed as an General/NSString. See http://theocacao.com/document.page/66 for a better implementation.

----

Thanks for spotting out the General/NSString thing, and suggesting that I check for General/NSNotFound. I did not know the int required it to be unsigned. It worked perfectly as an int. Is there a reason for this? I also plan to add more features to the class at a later times for various index set situations. If something rises, and a solution is found - it is added to this class. 

----

It'll work perfectly as unsigned int, but the point is that it doesn't make sense for it to be signed. When will you have a negative index in an array? The difference is that as it was written it was not future-proof. A signed int, when it goes past 2^31 - 1, will suddenly find itself at -(2^31). On current 32-bit systems it is unlikely you'll ever encounter an array with more than 2 billion entries in it, so the bug won't be encountered until later (and chances are if they update the General/NSArray class to support huge arrays, they'll just make its counters into long longs) but an unsigned int is marginally more "correct" in principle, than a signed int and is conveniently only a few characters more to type :-)

-General/DanielPeebles

----

Ahhhhh. That clears things up! Thankyou :D

----
Note that OS X v10.4 already provides this functionality with the General/NSArray method     -objectsAtIndexes:. 
----

I am *so* not looking forward to these questions once Apple changes the General/APIs to use General/NSInteger and General/NSUInteger. ("How large is an General/NSUInteger?" "We don't know. Depends on the computer!")

----
The sizes of char, short, int, long, and long long already depend on the computer, so it's not like those will be any different. If you want precise sizes then you need to use the provided types such as uint32_t.
----
:'( Waaaaaaaahhhhhaaahaaaaa Since WHEN!!!!??!!? I simply cannot believe that I missed that -- General/NSArray already has that function.
Shall we delete this page then?
----
The size of long, int etc is not dependant on the computer but the data model. See http://developer.apple.com/macosx/64bit.html for more info on LP64 data model used by OS X.