

Panther adds a new Objective-C directive, <code>@synchronized()</code>. See http://developer.apple.com/documentation/Cocoa/Conceptual/[[ObjectiveC]]/[[LanguageOverview]]/chapter_4_section_9.html#//apple_ref/doc/uid/20001424-BCIFAFAI

The <code>@synchronized()</code> directive seems to work like Java's. It takes any [[ObjectiveC]] object, which acts as a mutex semaphore.

Apple's example:
<code>
Account ''account = [Account accountFromString:[accountField stringValue]];
double deposit_amount = [amountField doubleValue];
double balance;

// Get the semaphore.
id accountSemaphore = [Account semaphore];

@synchronized(accountSemaphore) {
    // Critical code.
    balance = [account balance] + deposit_amount;
    [account setBalance:balance];
}

[balanceField setDoubleValue:balance]
</code>

----

...must...resist...urge...to...scream... ::[[KritTer]] vents his anger at this irksome copying of one of the less sanitary sides of Java by scrunching his face and squinting oddly::

Okay, back now. It seems Apple have merely made it easier and simpler to add an [[NSRecursiveLock]] to an object, and to use it. That's not so bad, I guess. Provided people don't assume that because it's easier to do, it must be easy to do. (mutter mutter race conditions mutter mutter deadlocks mutter mutter...) -- [[KritTer]]

----

What I'm worried about is: you can use any object as the mutex. Does this mean all objects have a built-in [[NSRecursiveLock]] as in Java? �[[DustinVoss]]

----

In the free ADC TV session he briefly mentioned the synchronize keyword and said, that unlike Java, they did not have a mutex pr. object -- but this just left me puzzled... maybe I didn't hear it correctly...

----

Does this result in any performance benefit over using [[NSLocks]]?  --[[OwenAnderson]]

----

No performance benefit, but cleaner synchronization in code that uses [[ObjC]] exceptions. In my tests on 10.3.4, a [[NSLock]] is 4 times faster than @synchronized while a [[NSRecursiveLock]] is 2 times faster than @synchronized. - [[SynapticPulse]]

----

Implementation details: see <objc/objc-sync.h>. In particular, the comment for %%BEGINCODESTYLE%%objc_sync_enter()%%ENDCODESTYLE%% says "Allocates recursive %%BEGINCODESTYLE%%pthread_mutex%%ENDCODESTYLE%% associated with 'obj' if needed." Presumably the mutex is deallocated on %%BEGINCODESTYLE%%objc_sync_exit()%%ENDCODESTYLE%% if its count is 0, or on %%BEGINCODESTYLE%%-dealloc%%ENDCODESTYLE%%... either of which is horribly ugly. On the other hand, I assume it does the Right Thing with regards to %%BEGINCODESTYLE%%@try%%ENDCODESTYLE%% blocks. -- [[JensAyton]]

----

This implementation doesn't seem ugly to me. Are you are presuming the pthread_mutex is deallocated after every use, the mutex could very well be deallocated only when the semaphore is deallocated (in [[[NSObject]] dealloc]), or reused. (See source linked below.)

Also in my testing, it seems that if you "return" or "goto" outside the block while inside a @synchronized block the lock is relinquished (a good thing). This makes managing large blocks of synchronized code easy if you do any of this, without worrying about your locks. ~ [[TimothyHatcher]]

----

For implementation details see: http://darwinsource.opendarwin.org/10.3.8/objc4-237/runtime/objc-sync.m

From the GCC source this directive turns into:

<code>{
	id _eval_once = <sync semaphore>;
	@try {
		objc_sync_enter( _eval_once );
		/'' sync code goes here ''/ 
	}
	@finally {
		objc_sync_exit( _eval_once );
	}
}</code>

One limitation I recently ran into was with nested synchronized directives. You can't nest them, even if you are locking 2 different objects.

<code>@synchronized( obj1 ) {
	@synchronized( obj2 ) {
		/'' code ''/
	}
}</code>

The lock on obj1 is never released.

~ [[TimothyHatcher]]

''Nice catch. Did you file a bug?''

----
"The lock on obj1 is never released". Do you mean the lock remains locked, or the memory associated with it is not released ?
I'm using nested synchronized() calls (on different objects) and the app doesn't deadlock.
Did you notice the same problem in recent versions of the OS ? (ie 10.4.3 ?)

~ Nicolas

----

See also [[NSLockVsSynchronized]]