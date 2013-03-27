

General/RetainingAndReleasing are the procedures for managing an object's General/RetainCount; understanding the way they work is crucial to making sure your application uses proper General/MemoryManagement. Several specific examples are outlined in General/RetainReleaseTips.

In Java you're free to create as many objects as you like and simply drop all references on them when you're done with them.
The General/GarbageCollection system will notice and sooner or later come to clean up the data you've left behind.
General/ObjC is more strict about General/MemoryManagement than Java. This means that you have to take a little more responsibility for your objects.

General/ObjC General/MemoryManagement does not automatically detect which objects are ready to be thrown away. Instead you have to declare that explicitly.

Every object has a General/RetainCount that goes up by one when the object gets a     retain message.
It goes down by one when the object gets a     release message.
When the General/RetainCount reaches 0, the object will call     [self dealloc], thereby releasing the object's memory.

I can tell the system that I need General/AnObject by sending it a     retain message. If I do, I must send it a     release message when I don't need it anymore.

Scenario 1:
When I create General/AnObject with the     alloc method, I'm implicitly sending that object a     retain message. That means it has a General/RetainCount of 1.
I am held responsible for sending it a     release message when I no longer need the object, and everyone else will assume that I do so.
That's part of the Social Contract of Cocoa. When I do, the General/RetainCount will become 0 and sooner or later the General/GarbageCollection will come to get the thing.

(The     copy message also increments the General/RetainCount, so it should be considered equivalent to a     retain message, at least as it affects the General/RetainCount)

Scenario 2:
Now suppose you need to use General/AnObject that you get from My_Class (e.g. a method of My_Class somehow supplies you with General/AnObject
that it creates by the procedure outlined in Scenario 1.

Since you have no prior knowledge of, and more importantly, *no control over* the lifetime that General/AnObject
has by virtue of its creation in My_Class, you claim control by sending it a     retain message, and its General/RetainCount becomes 2. 

When you later send General/AnObject a     release message (because you are done with it and want to let the system know you no longer need it) 
General/AnObject will *not necessarily* be deallocated! Your     release message simply decreases the General/RetainCount by 1.
If My_Class was not finished with General/AnObject, it would still have a General/RetainCount of 1 because I would not have sent it my own     release message,
and General/AnObject will not be deallocated.
Likewise, if I should send MY     release message to General/AnObject before YOU are done with it, I would still only decrease the     retain count by 1.
If you are still using the object, your own retention of General/AnObject should suffice to leave it usable to you until you are done with it.

Simply put: An object is ONLY deallocated when it has received equal numbers of     retain and     release messages, thus zeroing its General/RetainCount.

Scenario 3:
You can also choose to General/AutoRelease an object:

If you create an object within a method, you typically will want to dispose of it within the scope of that method (see bookkeeping remarks below).
However, if you also want to     return the object from that method you are faced with what is referred to in topic General/AutoRelease as a "conundrum".
If you just     release the object before you     return from the method, the object pointer that is returned will be garbage.
If you     return from the method before you     release the object, that     release message will never
be sent to the object, and will at best cause you bookkeeping problems if you try to balance it with a     release message someplace else,
and will cause General/MemoryLeak<nowiki/>s if you don't deal with it at all.

To make it possible to     release objects you're     returning, the General/AutoReleasePool was introduced.
The technical niceties of General/AutoReleasePool are fairly complicated, but from the programmer's perspective, it looks like this:
When you send an object the     autorelease message, it is added to the local General/AutoReleasePool (technically, the most recently-created
one in the current thread, discussed in more detail under General/AutoReleasePool).

At some point (not specified, but currently the next iteration of the General/RunLoop) the General/AutoReleasePool in which that object is listed will be destroyed and all the objects in it get a     release message. 
Other methods thus have time to     retain the object if they still need it.

Most methods that     return objects use General/AutoRelease,
so if you get an object back from such a method, you should generally     retain it if you want to keep it.

The     autorelease message should not be used casually where a     release message is more appropriate.

Keep in mind that the General/AutoRelease machinery adds some
overhead, and could impose a performance penalty in extreme circumstances (e.g., a tight loop that creates thousands of     autoreleased objects.)

Sample code dealing with specific what-ifs can be found in the topic General/RetainReleaseTips.

The heading External Articles under General/MemoryManagement contains links to several good basic
explanations of these principles, several of which are at the General/StepWise site.

There you can also read about nasty things called General/RetainCycles and hints on how to avoid them.
In General/MultiThreading apps General/RetainCycles can be a real headache, so if you're that far along, see the topic of
General/WeakReferences that Ken Case from General/TheOmniGroup came up with.