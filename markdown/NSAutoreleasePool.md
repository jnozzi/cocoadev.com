Apple's documentation: http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSAutoreleasePool_Class/

We have some features concerning the General/AutoReleasePool as well as General/AutoRelease and General/MemoryManagement in general, or General/AutoReleasePoolAndException.

----

I'm convinced that General/NSAutoreleasePool is a bad name. There is absolutely nothing "auto" about it. The behavior you saw is completely expected. Autoreleased objects get placed in the pool. When the pool is released, the objects inside it are also released. That's all there is to it. It's an extremely simple mechanism.

If you want to release the objects in the pool earlier, release the pool earlier. For a long-running loop like you have, do something like this:
    
while(long loop)
{
    General/NSAutoreleasePool *innerPool = General/[[NSAutoreleasePool alloc] init];
    ...code goes here...
    [innerPool release];
}

Alternatively, you can do something like this inside the loop (like at the end):
    
    [pool release];
    pool = General/[[NSAutoreleasePool alloc] init];

-- General/MikeAsh

I've had to do that in my numerical simulations, as when you do something like General/[NSNumber numberWithDouble:39.2], then add it to an array...then release the array - that number is still autoreleased  And if you do thousands of iterations...Blegh.  And having me code all the init/release around the array entries is crazy (there's no temp vars as it is now - they're created in the General/NSArray creator.  So yeah, do a temp pool - all allocations are always to the last pool created - but also know that it will take some time to release the pool (on my computer, about 2-3 sec for 40MB of allocation). -- General/DanKeen

*The amount of time required to release a bunch of memory doesn't depend at all on the amount of memory occupied; rather, it depends on the number of objects allocated. It's entirely possible that a bunch of General/NSNumbers occupying 40MB would take a long time to deallocate, because there would be millions of objects, but a single General/NSData instance that holds 40MB of data will deallocate almost instantly. Autorelease has a very small amount of overhead compared to release, so autoreleasing will generally not noticeably increase the amount of time required to deallocate a bunch of objects. What it will do is cause the deallocations to all happen at the same time, instead of being spread out over time. -- General/MikeAsh*

----

Under particular circumstances, memory may be much more important than performance, so you can ignore the overhead of the free cycle. But, what this tells you is that for tight code you should stick with C or C++ and just wrap it with Cocoa. However, keep in mind that the most-recent General/NSAutoreleasePool is used.

*But, what this tells me is that for tight code I'll stick with C++ and just wrap it with Cocoa* 

Hmmm ... Yes, keeping Objective-C out of performance critical datapaths is good advice in general. But personally I keep all of my General/QuickTime code, and tight code in general, in C. Good ol' ANSI C -- it always works. YMMV. -- General/MikeTrent

----
I must respectfully disagree. It's frequently difficult to know what the critical data paths are in advance. Even if you do know them, writing in Objective-C first with an eye on clarity, then rewriting in C if needed is frequently easier, faster to implement, and results in faster code than trying to do it all in C the first time through. This depends on your personal style and knowledge, of ocurse. The great thing about Objective-C is that it's easy to drop bits of it as needed, so you don't have to worry about writing yourself into a slow corner. -- General/MikeAsh