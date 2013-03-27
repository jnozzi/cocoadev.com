I got tired of having to build General/NSInvocation wrappers using the handleInvocation trick as seen in General/ThreadCommunication. What follows is an implementation for a trivial General/TrampolineObject that will automatically bounce any message it gets to the main thread.

    
#import "General/NSObject+Invocations.h"

//////////
@interface General/EGPerformOnMainThreadTrampoline : General/NSProxy {
	id object;
	BOOL waitUntilDone;
}

-(id)initWithObject:(id)inobject waitUntilDone:(BOOL)wait;
@end

@implementation General/EGPerformOnMainThreadTrampoline

-(id)initWithObject:(id)inobject waitUntilDone:(BOOL)wait
{
	object = [inobject retain];
	waitUntilDone = wait;

	return self;
}

-(void)dealloc
{
	[object release];
	[super dealloc];
}

- (void)forwardInvocation:(General/NSInvocation *)anInvocation 
{
	[anInvocation retainArguments];
	[anInvocation performSelectorOnMainThread:@selector(invokeWithTarget:)
							 withObject:object 
						  waitUntilDone:waitUntilDone];
}

-(General/NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    return [object methodSignatureForSelector:aSelector];
}

@end

@implementation General/NSObject (General/PerformOnMainThreadTrampoline)

-(General/NSProxy*)performOnMainThreadWaitUntilDone:(BOOL)wait
{
	return General/[[[EGPerformOnMainThreadTrampoline alloc] initWithObject:self waitUntilDone:wait] autorelease];
}

@end


    
@interface General/NSObject (General/PerformOnMainThreadTrampoline)
-(General/NSProxy*)performOnMainThreadWaitUntilDone:(BOOL)wait;
@end


You can then send messages like this:

    
General/object performOnMainThreadWaitUntilDone:NO] this:is a:complex message:0.5f];


Any comments or improvements would be welcome. You can use this code for anything without restriction, but it'd be nice if you'd credit the original author ([[ElliotGlaysher).

----

Also see the implementation of General/UKKMainThreadProxy from his General/UKKQueueWatcher distribution.  It's basically the same idea, a transparent category on General/NSObject that allows you to send any message you want to a given object on the main thread.

JKP