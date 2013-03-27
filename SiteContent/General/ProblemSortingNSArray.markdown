I am a beginner at this so sorry in advance for dificulties explaining this.

I have an General/NSMutableArray with just numbers, and I have been trying to find out how to sort them.  I used the addObject method and added General/NSNumbers.  Is there anyway I can sort them before displaying the information on a table or textview?

Thanks,

Darwin

----

It *is* possible to sort a *mutable* array in-place, using the following selectors:
    
� sortUsingDescriptors: 
� sortUsingFunction:context: 
� sortUsingSelector: 

So, for example, assuming that the objects you have inserted into the array respond to the     compare: selector, you can sort a mutable array using     [myArray sortUsingSelector:@selector(compare:)];. 
The relevant page at Apple's website is:
http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSMutableArray.html

----

I initially posted a silly answer. I removed some of it, but here some of what I wrote, because it is complementary.

You can get a new General/NSArray with the following

    sortedArray=[unsortedArray sortedArrayUsingSelector:@selector(compare:)];

    sortedArray will be an     General/NSArray except if you do:

    
sortedArray=General/[NSMutableArray arrayWithArray:
     [unsortedArray sortedArrayUsingSelector:@selector(compare:)] ];


Also,     sortedArray will be a DIFFERENT object, i.e. different pointer, even if you do:

    
theArray=General/[NSMutableArray arrayWithArray:
     [theArray sortedArrayUsingSelector:@selector(compare:)] ];


, in which case you would want to be careful with retain counts for the original theArray.

----