

A simple [[WorkerThread]] can be managed with [[NSObject]]'s <code>performSelectorOnMainThread:withObject:waitUntilDone:</code>. Arbitrary communication can be handled with [[DistributedObjects]] (see [[DistributedObjectsSampleCode]], or http://lachand.free.fr/cocoa/Threads.html ), or with the libraries that other industrious people have written.

Two good ones are [[InterThreadMessaging]] (which allows notifications and method invocations on arbitrary threads) and [[ThreadWorker]] (which executes a method on a separate thread and invokes a callback when done).

Some other solutions are below, and at the [[ObjectLibrary]] page.

----

Here's a simple technique for communicating between threads.

See [[ThreadWorker]] instead. It encapsulates the technique below into a single method. Use the technique below if you have more than a 'finish' method to invoke.

Let's say you have an object for which you wish to launch a worker thread (workerThread:) and have some method (workerThreadFinished) invoked when the worker thread finishes.

The interface might be:

<code>
@interface [[MyObject]]
{
	[[NSConnection]] ''_connection;
}

- (void)workerThread:([[NSArray]] '')ports;

- (void)workerThreadFinished;

@end
</code>

An implementation might be:

<code>
@implementation [[MyObject]]

- (void)dealloc
{
	[_connection release];
}

- (void)workerThread:([[NSArray]] '')ports
{
    [[NSConnection]] ''connection;
    [[NSAutoreleasePool]] ''pool = [[[[NSAutoreleasePool]] alloc] init];

    connection = [[[NSConnection]] connectionWithReceivePort:[ports objectAtIndex:0]
                                                sendPort:[ports objectAtIndex:1]];

    NS_DURING
    {
		// do my work

		[([[MyObject]] '')[connection rootProxy] workerThreadFinished];
    }
    NS_HANDLER
    {
    }
    NS_ENDHANDLER

    [pool release];
}

- (void)workerThreadFinished
{
	// this will happen in the main thread
}

- (void)doLaunchThread
{
    [[NSPort]] ''receive_port = [[[NSPort]] port];
    [[NSPort]] ''send_port = [[[NSPort]] port];

    [[NSArray]] ''ports = [[[NSArray]] arrayWithObjects:send_port, receive_port, NULL];

    _connection = [[[[NSConnection]] alloc] initWithReceivePort:receive_port sendPort:send_port];
    [_connection setRootObject:self];

	[[[NSThread]] detachNewThreadSelector:@selector(workerThread:) toTarget:self withObject:ports];	
}
</code>

The nice thing about this code is that you can send any message to the main thread as long as you do it through the root proxy.

It's all done using [[DistributedObjects]] (non-public ones). [[ThreadWorker]] illustrates another way to notify the main thread of worker thread completion without using [[NSConnection]] or [[DistributedObjects]].

----
In 10.2 [[NSObject]] gained a %%BEGINCODESTYLE%%- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait%%ENDCODESTYLE%%. [[NSNotification]] is also thread-safe and may be of use, but see [[NotificationsAcrossThreads]]

----

An extremely simple solution by [[JonathanJansson]].

In the work for on a port of DC++ to Mac OS X (on [[SourceForge]]) I needed a functions similar to [[PostMessage]]() in Windows. [[PostMessage]]() sends a message to the thread owning a window. This code is implemented as a category to [[NSObject]] and does not make any use of [[NSPort]]! The code sends a message that are taken care of in the main thread. An [[NSAutoreleasePool]] should be in place because of the way an [[NSInvocation]] is created. The [[NSInvocation]] also retain its objects because the sending side will probably release them before the message is actually delivered. 

A correction. It is not necesary to retain the invocation, performSelectorOnMainThread:withObject:waitUntilDone: retains both the argument and receiver and releases them when done. This technique is almost pointless if ony one argument is used. It only removes the need to specify waitUntilDone: .

It should be easy to send the handleInvocation: message to any run loop by using -[[[NSRunLoop]] performSelector:target:argument:order:modes:] on that run loop instead.

<code>
@implementation [[NSObject]] ( [[RunLoopMessenger]] )

- (void)mainPerformSelector:(SEL)aSelector withObject:(id)argument1 withObject:(id)argument2
{
	[[NSInvocation]] ''invocation;
	invocation = [[[NSInvocation]] invocationWithMethodSignature:[self methodSignatureForSelector:aSelector]];
	
	[invocation setSelector:aSelector];
	[invocation setArgument:&argument1 atIndex:2];
	[invocation setArgument:&argument2 atIndex:3];
	[invocation retainArguments];

	[self performSelectorOnMainThread:@selector(handleInvocation:) withObject:invocation waitUntilDone:NO];
}

- (void)handleInvocation:([[NSInvocation]] '')anInvocation
{
	[anInvocation invokeWithTarget:self];
}

@end
</code>

----

[[CHOMp]] (and I'm sure other HOM implementations) could be very easily extended to allow cross-thread invocation of arbitrary method calls. Using it would look like this:
<code>
[[obj performOnMainThreadWaitUntilDone:YES] complicatedMessageWithObject:foo withInt:bar withFloat:baz];
</code>
This would be a lot like DO, but easier to set up and more specific in what it can do. Anybody interested, or shall I go back to my cave? ;-)