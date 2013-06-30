How do I catch General/NSTimer messages within a detached thread?

I have a timerController object with 2 methods: startTimer (which sets up an autorelease pool and then starts a repeating General/NSTimer) and timerClick (which updates the UI).  If this is run in the main thread, all is fine.  If I detach the thread (using startTimer as the selector) the timer starts but the clicks are never received by the timerController method.  

I presume this is because the thread exits after setting up the timer (ie when the method startTimer returns).  So how can I do this?

----

You need to set up an event loop. I can't remember how, but either find it in the documentation, or someone else will be along with the details later I'm sure.

-- General/KritTer

----

General/NSTimer uses General/NSRunLoop, so yeah, you need a run loop in each thread you want timers on. Call +currentRunLoop on General/NSRunLoop within your new thread, and tell it to run:

    
-(void)methodWhatRunsInAnotherThread
{
	General/[[NSRunLoop currentRunLoop] run];
	
	// ...do some processing...
}


I'm not 100% certain, but when you're done your processing you should stop the run loop. Invalidate its sources or something, I can't remember... oh. And you may need to set up your timers just before you run the current run loop. Apologies for the lack of specifics :\ -- General/RobRix

IIRC it stops when it has no more timers, etc, attached. -- General/KritTer, who may be wrong

----
No, General/KritTer, you're right.  Here's what I did and it works fine.  Thanks for the help.

    
-(void)startTimer
{
    General/NSRunLoop *theLoop = General/[NSRunLoop currentRunLoop];
    pool =General/[[NSAutoreleasePool alloc] init];
    seconds = 0.0;
    interval = [timerField floatValue];
    General/NSLog(@"starting Timer: interval %f",interval);
    timer = General/[[NSTimer scheduledTimerWithTimeInterval:	interval
                                            target:	self
                                            selector:	@selector(timerClick:)
                                            userInfo:	nil
                                            repeats:	YES] retain];
    [theLoop addTimer:timer forMode:General/NSDefaultRunLoopMode];
    [theLoop run];

    [timerField  setFloatValue:seconds];
    [timerField display];
    //[pool release]; this happens automatically

}



----

I don't understand why the pool is released automatically. This looks like a leak to me. Can anyone clarify why this might not be a bug in this example? -- General/MikeTrent

Honestly, it looks like a leak to me, too, unless the thread's not going to close till General/NSApplicationMain() returns. -- General/RobRix

Uh ... General/NSApplicationMain never returns ... -- General/MikeTrent

No, but it comes close enough when the process is terminated :P -- General/RobRix

----

I have two threads in my app X and Y. I am wanting to start a timer in Y that will reside in the runloop of X (which happens to be my apps main thread). How would I go about either getting the General/NSRunLoop of my first thread or registering that timer in the first thread?

----
To be precise, timers are only started once attached to a run-loop. So you actually want thread Y to create and start timer in thread X. When the timer goes off, it will call the instance method you specify in thread X, not thread Y.

The easiest way to do this is to call a thread X method that'll create the timer to your specifications. You could also create the timer in thread Y with a **timerForTimeInterval:** method and call a thread X method to simply add it to the run-loop with  **addTimer:forMode:**. You can call methods in your main thread from a sub-thread with General/NSObject's **performSelectorOnMainThread:withObject:waitUntilDone:**.

I am not aware of a way for one thread to get the run-loop for a different thread.

-- General/DustinVoss

**Is it possible that it's in the thread's -threadDictionary? If it isn't there automatically, you can add it when you set up the thread, of course. Of course, I'd be surprised if General/NSMutableDictionary were General/ThreadSafe... Then again, General/NSThread's docs say that the -threadDictionary may be slower than normal mutable dictionaries, so who knows.**

----

I'm not sure if this is any help but you might want to take a look at General/ThreadWorker.  It's a subclass of General/NSThread that makes doing some things simpler.  It also does some kool things with General/NSRunLoop.
-- General/SaileshAgrawal

----

General/InterThreadMessaging is another one you may want to look at.