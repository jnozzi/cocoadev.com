General/CSCoroutine is an implementation of General/CoRoutine**'s for Cocoa. It provides a proxy object and General/NSObject category for easily setting up coroutines, and switching between them.

There are only a few methods that are considered public:

*     -General/[NSObject newCoroutine] and     -General/[NSObject newCoroutineWithStackSize:(size_t)stacksize] create a new General/CSCoroutine object (which is not autoreleased!), with either the default or the specified stack size. To start the coroutine, you send it any message. This can only be done once.
*     -General/[CSCoroutine switchTo] switches program flow into this coroutine from another one. It is probably not a good idea to call this from inside the coroutine itself.
*     -General/[CSCoroutine returnFrom] switches program flow from the coroutine to the one that last called it.
*     +General/[CSCoroutine returnFromCurrent] switches program flow from the currently running coroutine to the one that last called it.
*     +General/[CSCoroutine mainCoroutine] returns the General/CSCoroutine object for the initial program stack, i.e. the normal program.
*     +General/[CSCoroutine currentCoroutine] returns the General/CSCoroutine object for the currently running coroutine.


There's a simple example available at General/CSCoroutineTest.

There are a number of issues with the current implementation:

* The compiler complains when you try to send a message to the proxy object. This seems non-sensical, but I have no idea how to prevent it. If you know, tell me!
* 64-bit code is not supported at all. I'd be happy is somebody would help implement this.
* Exception handling is tricky. The standard Objective-C exception handling uses a separate stack for @try/@catch blocks, which is not swapped out when the coroutine code swaps the regular stacks. This means exceptions work in some circumstances and not in others. Figuring out what works and what doesn't requires really known what you're doing. Throwing exceptions across different coroutines should work, but nesting @try/@catch blocks in different coroutines is very tricky to get right. It would perhaps be possible to replace the default exception handling functions to fix these problems, but I'm not enough of a hacker to pull that off, I fear.

Another problem is that the library keeps track of a pointer to the currently running coroutine, and this pointer will be wrong if an excpetion is thrown across coroutines. To work around this, one has to save the current coroutine using +General/[CSCoroutine currentCoroutine] before entering exception-catching code, and restoring it with +General/[CSCoroutine setCurrentCoroutine] immediately after catching an exception. See the General/CSCoroutineTest for an example.
* The General/MallocDebug code seems to choke when presented with anything but the default stack, and should not be used on General/CSCoroutine code. Perhaps it is possible to work around this, too, but I don't know how.
* The code should be thread safe, and it is possible to have a coroutine jump threads during its lifetime. However, make sure that the same coroutine is not invoked in several threads at the same time!
* The default stack size is entirely arbitrary. I am not sure what would be a good value to use.


A big thanks goes to the authors of General/LibCoroutine, which although it turned out not to be suitable for this project, provided me with enough hints to implement it myself. -- General/WAHa

----

Update on September 4, 2007: Fixed stack alignment and exception problems. Bypassed the use of General/NSInvocation entirely, as it was causing a lot of trouble. Should work a lot better now, and faster too. -- General/WAHa

Update on September 12, 2007: Figured out what was causing problems with thread jumping: Returning to the coroutine that created another coroutine is not a good idea if that coroutine is now running on a different thread. Therefore, the semantics of     returnFrom were changed so that it returns to the coroutine that last called the current one, not the one that created it. This should make thread conflicts less likely. -- General/WAHa

Update on September 18, 2007: Now supports Leopard. Also removed the note about the code being immature, because I have now been testing it in real-world apps and worked out most the immediately obvious problems. -- General/WAHa

Update on October 10, 2007: Added +General/[CSCoroutine setCurrentCoroutine:] call to restore the current coroutine pointer after an exception. See notes above, and General/CSCoroutineTest.

----

The source code follows. First,     General/CSCoroutine.h:

    
#import <Foundation/Foundation.h>
#import <setjmp.h>
#import <objc/objc-class.h>

@interface General/CSCoroutine:General/NSProxy
{
	id target;
	size_t stacksize;
	void *stack;
	BOOL fired;

	General/CSCoroutine *caller;
	jmp_buf env;

	SEL selector;
	marg_list arguments;
	int argsize;

	General/NSInvocation *inv;
}
+(General/CSCoroutine *)mainCoroutine;
+(General/CSCoroutine *)currentCoroutine;
+(void)setCurrentCoroutine:(General/CSCoroutine *)curr;
+(void)returnFromCurrent;

-(id)initWithTarget:(id)targetobj stackSize:(size_t)stackbytes;
-(void)dealloc;

-(void)switchTo;
-(void)returnFrom;
@end

@interface General/NSObject (General/CSCoroutine)
-(General/CSCoroutine *)newCoroutine;
-(General/CSCoroutine *)newCoroutineWithStackSize:(size_t)stacksize;
@end


Second,     General/CSCoroutine.m:

    
#ifndef MAC_OS_X_VERSION_MIN_REQUIRED
#define MAC_OS_X_VERSION_MIN_REQUIRED MAC_OS_X_VERSION_10_1
#endif
#ifndef MAC_OS_X_VERSION_MAX_ALLOWED
#define MAC_OS_X_VERSION_MAX_ALLOWED MAC_OS_X_VERSION_10_4
#endif
#import "General/CSCoroutine.h"
#import <pthread.h>
#import <objc/objc-runtime.h>


@interface General/NSProxy (Hidden)
-(void)doesNotRecognizeSelector:(SEL)sel;
@end

static pthread_key_t currkey,mainkey;

static void General/CSCoroutineFreeMain(General/CSCoroutine *main) { [main release]; }

static General/CSCoroutine *General/CSMainCoroutine()
{
	General/CSCoroutine *main=(General/CSCoroutine *)pthread_getspecific(mainkey);
	if(!main)
	{
		main=General/[[CSCoroutine alloc] initWithTarget:nil stackSize:0];
		pthread_setspecific(mainkey,main);
	}
	return main;
}

static General/CSCoroutine *General/CSCurrentCoroutine()
{
	General/CSCoroutine *curr=(General/CSCoroutine *)pthread_getspecific(currkey);
	if(curr) return curr;
	else return General/CSMainCoroutine();
}

static General/CSCoroutine *General/CSSetCurrentCoroutine(General/CSCoroutine *new)
{
	General/CSCoroutine *curr=General/CSCurrentCoroutine();
	pthread_setspecific(currkey,new);
	return curr;
}

static void General/CSSetEntryPoint(jmp_buf env,void (*entry)(),void *stack,int stacksize)
{
	#if defined(__i386__)
	env[9]=(((int)stack+stacksize)&~15)-4; // -4 to pretend that a return address has just been pushed onto the stack
	env[12]=(int)entry;
	#else
	env[0]=((int)stack+stacksize-64)&~3;
	env[21]=(int)entry;
	#endif
}

@implementation General/CSCoroutine

+(void)initialize
{
	pthread_key_create(&currkey,NULL);
	pthread_key_create(&mainkey,(void (*)())General/CSCoroutineFreeMain);
}

+(General/CSCoroutine *)mainCoroutine { return General/CSMainCoroutine(); }

+(General/CSCoroutine *)currentCoroutine { return General/CSCurrentCoroutine(); }

+(void)setCurrentCoroutine:(General/CSCoroutine *)curr { General/CSSetCurrentCoroutine(curr); }

+(void)returnFromCurrent { General/[CSCurrentCoroutine() returnFrom]; }

-(id)initWithTarget:(id)targetobj stackSize:(size_t)stackbytes
{
	target=targetobj;
	stacksize=stackbytes;
	if(stacksize) stack=malloc(stacksize);
	fired=target?NO:YES;

	caller=nil;
	inv=nil;

	return self;
}

-(void)dealloc
{
	free(stack);
	[inv release];
	[super dealloc];
}

-(void)switchTo
{
	General/CSCoroutine *curr=General/CSSetCurrentCoroutine(self);
	caller=curr;
	if(_setjmp(curr->env)==0) _longjmp(env,1);
}

-(void)returnFrom
{
	/*General/CSCoroutine *curr=*/General/CSSetCurrentCoroutine(caller);
	if(_setjmp(env)==0) _longjmp(caller->env,1);
}



static void General/CSTigerCoroutineStart()
{
	General/CSCoroutine *coro=General/CSCurrentCoroutine();
	objc_msgSendv(coro->target,coro->selector,coro->argsize,coro->arguments);
	[coro returnFrom];
	General/[NSException raise:@"General/CSCoroutineException" format:@"Attempted to switch to a coroutine that has ended"];
}

-forward:(SEL)sel :(marg_list)args // Tiger forwarding
{
	if(fired) General/[NSException raise:@"General/CSCoroutineException" format:@"Attempted to start a coroutine that is already running"];
	fired=YES;

	selector=sel;
	arguments=args;
	Method method=class_getInstanceMethod([target class],sel);
	if(!method) { [self doesNotRecognizeSelector:sel]; return nil; }
	argsize=method_getSizeOfArguments(method);

	_setjmp(env);
	General/CSSetEntryPoint(env,General/CSTigerCoroutineStart,stack,stacksize);

	[self switchTo];
	return nil;
}



-(General/NSMethodSignature *)methodSignatureForSelector:(SEL)sel { return [target methodSignatureForSelector:sel]; }

static void General/CSLeopardCoroutineStart()
{
	General/CSCoroutine *coro=General/CSCurrentCoroutine();
	[coro->inv invoke];
	[coro returnFrom];
	General/[NSException raise:@"General/CSCoroutineException" format:@"Attempted to switch to a coroutine that has ended"];
}

-(void)forwardInvocation:(General/NSInvocation *)invocation
{
	if(fired) General/[NSException raise:@"General/CSCoroutineException" format:@"Attempted to start a coroutine that is already running"];
	fired=YES;

	inv=[invocation retain];
	[inv setTarget:target];

	_setjmp(env);
	General/CSSetEntryPoint(env,General/CSLeopardCoroutineStart,stack,stacksize);

	[self switchTo];
}

@end



@implementation General/NSObject (General/CSCoroutine)

-(General/CSCoroutine *)newCoroutine
{ return General/[[CSCoroutine alloc] initWithTarget:self stackSize:1024*1024]; }

-(General/CSCoroutine *)newCoroutineWithStackSize:(size_t)stacksize
{ return General/[[CSCoroutine alloc] initWithTarget:self stackSize:stacksize]; }

@end


----

Post any discussion here at the bottom of the page! -- General/WAHa

----
"The test program spews lots of warnings, though, because Apple seems to have decided to put a lot of useless warnings into General/NSLock which are triggered by entirely correct usage."

Unless I'm badly misunderstanding something, your test program is *not* using General/NSLock correctly. It is not allowed to lock an General/NSLock from one thread and unlock it in another. The way you're using General/NSLock to wait for another thread to finish is incorrect and not guaranteed to work at all. You should be using General/NSConditionLock for that sort of thing.

----

I see, I was assuming an General/NSLock was like your average semaphore, but apparently it is far less useful than that. The code did work just fine, but I've changed it to use General/NSConditionLock instead. -- General/WAHa

----
General/NSLock is equivalent to (and implemented with) pthread_mutex, and inherits this limitation from it. The code change looks good. One note, not really a problem, but if you're just signaling with an General/NSConditionLock then you can just do     [lock lock]; [lock unlockWithCondition:...];, there's no need to lock using the current condition.