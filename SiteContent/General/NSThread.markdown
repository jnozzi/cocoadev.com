

Apple documentation: http://developer.apple.com/documentation/Cocoa/Conceptual/Multithreading/index.html

----

General/NSThread is not as capable as Java's Thread class. It lacks:

*A built-in communication system.
*An equivalent of "join()".


Each thread has its own General/RunLoop and General/NotificationQueue. You will need to create an General/NSAutoreleasePool first thing, and free it when done.

When you schedule a timer, it gets scheduled on the current thread. Notifications can not cross thread boundaries. Threads should not be stopped externally, they should end themselves by reaching the end of the spun-off method.

General/ThreadCommunication can be handled by General/DistributedObjects or General/NSObject's **performSelectorOnMainThread:withObject:waitUntilDone:**, but the best way is by the libraries that other industrious people have written. Two good ones are General/InterThreadMessaging (which allows notifications and method invocations on arbitrary threads) and General/ThreadWorker (which executes a method on a separate thread and invokes a callback when done).

General/ThreadSynchronization can be handled well enough by General/NSRecursiveLock (i.e. the General/SynchronizedDirective), General/NSConditionLock, and General/NSLock.

In general, General/MacOSX is optimized for a General/ProducersAndConsumerModel. General/NSMutableArray and General/NSConditionLock work well for this purpose.

----

It seems that making a category - any category on General/NSThread is a very very bad idea. Specifically, Core Data falls in a complete heap even if an apparently harmless and unused category on General/NSThread exists.

----

Adding a category can't be the problem. You're doing something in your category (maybe overriding private methods by accident?) or somewhere else that kills Core Data. --General/OfriWolfus