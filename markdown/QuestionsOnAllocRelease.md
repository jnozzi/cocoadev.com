

I had a question on Object Creation and Disposal.

Here's a sample code:

    

int main(int argc, const char *argv[])
{
General/NSAutoreleasePool* pool = General/[[NSAutoreleasePool alloc] init];

// initialize General/NSArray* inArray

General/NSArray* outArray = firstFunc(inArray);

[outArray release];   // Is this allowed?

[pool release];
  
}

General/NSArray* firstFunc(General/NSArray* inArray) {

General/NSArray* outArray = General/[[NSArray alloc] init];

// Feed values into outArray

return outArray;

}



So my question is: Could I release outArray in the main() function although "alloc ... init" was used in the firstFunc()?

Along the same lines, I have another question. Here's the code:


    

int main(int argc, const char *argv[])
{
General/NSAutoreleasePool* pool = General/[[NSAutoreleasePool alloc] init];

for(i = 0; i<100; i++) {
General/NSArray* outArray = General/[[NSArray alloc] init];
}

[pool release];

}



As you can see from the code, I have not released outArray in each step of the for loop. I know that this would increase the memory footprint. But my question is whether if these allocated objects be eventually released by the "[pool release]" when it gets out of the "for loop"? Or is it a permanent memory leak?

Thanks,
Nevine 

----
You seem to not understand the Cocoa memory management conventions.  Rather rewrite the excellent available documentation, I will reference some of it starting with this link from the FRONT PAGE of General/CocoaDev:
http://www.cocoadev.com/index.pl?General/MemoryManagement

Directly from Apple: http://developer.apple.com/documentation/Cocoa/Conceptual/General/MemoryMgmt/index.html

Just because I can't resist, remember these rules for memory management:
Within any single Objective-C scope, if you alloc, retain, or copy it, it's your job to release or autorelease it. **Otherwise it isn't.**

In your code
    
int main(int argc, const char *argv[])
{
General/NSAutoreleasePool* pool = General/[[NSAutoreleasePool alloc] init];

// initialize General/NSArray* inArray
General/NSArray* outArray = firstFunc(inArray);

[outArray release];   // Is this allowed?

No!  Do you see the messages alloc, retain, copy or mutableCopy related to outArray in this block of code ? NO! Then you have absolutely no responsibility to release or autorelease outArray.
Do you see the messages alloc, retain, copy or mutableCopy related to pool in this block of code ? YES! Therefore you have to release or autorelease pool (as you do).
    

[pool release];
}



----
I have read the documentation and this is not how I program. I do use my release and autorelease the proper way. But as you said, I haven't understood memory allocation in it's entirety  and hence my naive queries. Thanks for clarifying some of them. 

Here's the reason I brought that question up. Check this code:

    

int main(int argc, const char *argv[])
{
General/NSAutoreleasePool* pool = General/[[NSAutoreleasePool alloc] init];

General/CFMutableArrayRef outArray = firstFunc();

General/CFArraySortValues(outArray, General/CFRangeMake(....), ..., NULL); 

General/CFRelease(outArray); // This works. Why?

[pool release];

}


General/CFStringRef General/IntegerCopyDescription(const void* value) {	
	return General/CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR("%d"), (intptr_t)value);
}

General/CFMutableArrayRef firstFunc() {

      General/CFArrayCallBacks	     callBacks = { 0, NULL, NULL, General/IntegerCopyDescription, NULL };
      General/CFMutableArrayRef outArray = General/CFArrayCreateMutable(kCFAllocatorDefault, 0, &callBacks);

      // Add values to outArray

      return outArray;
}


As you can see, outArray is being released in the main() function where it was not created. This code works; but because I did not write this piece of code, I am not sure why it works. Any help would be greatly appreciated. 

Also, what about the second question I asked in my previous message?
(I guess that would be a memory leak :) )

Thanks

----

It works because firstFunc() calls General/CFArrayCreateMutable().  The CF memory management rules say that any creation function (a function that returns a reference to a newly-created object and has the word "create" in it) is owned by the caller, and the caller is responsible for its release.

I'm a Cocoa guy myself, but it works the same in either.  In Cocoa, calling General/[[NSMutableArray alloc] init] will give you an General/NSMutableArray* that you must release on your own ([myMutableArray release]).  General/[NSMutableArray array], on the other hand, will give you an AUTORELEASED General/NSMutableArray that you must retain before using (myMutableArray = General/[[NSMutableArray array] retain]).  Then when you're done with the object you would release it.  The reference that the array method had created will then be taken care of by the autorelease pool.

Hope that clears it up, I found Apple's documentation on the matter to be far too sparse a treatment, until I switched back and forth between the CF documentation and the Cocoa docs, and really studied it.  Then I was able to understand it.

----
So does that mean that General/CFArrayCreateMutable() creates an autoreleased General/CFArrayRef and hence the reason why the calling function is able to General/CFRelease() it?
Or is it just that CF works differently from regular Cocoa objects? And by the way, how do you autorelease a General/CFArrayRef object?

Thanks for your help. It's helping me get a grip on memory management in Obj-C.
----
The Core Foundation has no concept of autorelease.  The original question specifically asked about General/NSArray and not General/CFArray.  When using Cocoa and Cocoa memory management conventions, the implementation of firstFunc() is responsible for autoreleasing outArray so that the caller of firstFunc() has no memory management responsibility for outArray.  When mixing straight Core Foundation with Cocoa conventions (irrespective of toll free bridging), which conventions to employ in which situations becomes muddy!

For correct Cocoa memory management, firstFunc (which incidentally doesn't follow Cocoa naming conventions) should have been coded as follows:
    
General/CFMutableArrayRef General/FirstFunc() 
{
      General/CFArrayCallBacks	     callBacks = { 0, NULL, NULL, General/IntegerCopyDescription, NULL };
      General/CFMutableArrayRef outArray = General/CFArrayCreateMutable(kCFAllocatorDefault, 0, &callBacks);

      // Add values to outArray

      // take advantage of toll free bridging to overcome lack of CF functionality
      return [(General/NSArray *)outArray autorelease];
}


And for the 10,000th time this has been stated in various forrums: autorelease does nothing magical.  All autorelease does is add the receiver to a collection of objects that will be sent a release message automatically at some later time.  The whole purpose of autorelease is to enable a function to return an object for which the caller has no memory management responsibility.

----
Thanks a lot. If I knew the difference in the way Cocoa objects and CF objects worked, I would have had no doubts in the first place. I'm glad you clarified them.

----

They work the same way. There are only **two** noteworthy differences between their memory management systems: a) there is no General/CFAutorelease function nor General/CFAutoreleasePoolRef type; and b) methods/functions use different keywords (alloc/copy/retain vs. create/copy/retain) to show a retain increment.