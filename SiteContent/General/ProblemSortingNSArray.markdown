I am a beginner at this so sorry in advance for dificulties explaining this.

I have an [[NSMutableArray]] with just numbers, and I have been trying to find out how to sort them.  I used the addObject method and added [[NSNumbers]].  Is there anyway I can sort them before displaying the information on a table or textview?

Thanks,

Darwin

----

It ''is'' possible to sort a ''mutable'' array in-place, using the following selectors:
<code>
� sortUsingDescriptors: 
� sortUsingFunction:context: 
� sortUsingSelector: 
</code>
So, for example, assuming that the objects you have inserted into the array respond to the <code>compare:</code> selector, you can sort a mutable array using <code>[myArray sortUsingSelector:@selector(compare:)];</code>. 
The relevant page at Apple's website is:
http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/[[NSMutableArray]].html

----

I initially posted a silly answer. I removed some of it, but here some of what I wrote, because it is complementary.

You can get a new [[NSArray]] with the following

<code>sortedArray=[unsortedArray sortedArrayUsingSelector:@selector(compare:)];</code>

<code>sortedArray</code> will be an <code>[[NSArray]]</code> except if you do:

<code>
sortedArray=[[[NSMutableArray]] arrayWithArray:
     [unsortedArray sortedArrayUsingSelector:@selector(compare:)] ];
</code>

Also, <code>sortedArray</code> will be a DIFFERENT object, i.e. different pointer, even if you do:

<code>
theArray=[[[NSMutableArray]] arrayWithArray:
     [theArray sortedArrayUsingSelector:@selector(compare:)] ];
</code>

, in which case you would want to be careful with retain counts for the original theArray.

----