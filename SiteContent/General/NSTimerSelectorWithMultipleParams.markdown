

Hi,

I am trying to create an General/NSTimer whose selector is a method which has multiple parameters (one of which being the actual timer).  How is this done?
Here is the code I've got so far:

    
...
- (id)init
{
	[super init];
	
	blinkTimer = General/[NSTimer scheduledTimerWithTimeInterval:1.0 
                                                                             target:self
                                                                          selector:@selector(playMovie:BLINK) 
                                                                          userInfo:nil 
                                                                           repeats:YES];
	
	return self;
}
...
- (BOOL)playMovie:(General/NSTimer *)timer ofType:(unsigned)type
{
	General/NSLog(@"Playing a %d movie", type);
	
	return true;
}
...


I'm getting a "parse error before numeric constant" message when I try to compile.

Thanks for the help.

---- 

The message which General/NSTimer sends must have the following signature: - (void) doSomething: (General/NSTimer *) aTimer, that is, it takes one and only one argument. To pass additional parameters, you use the userInfo argument when you create the timer. It can be any object or even a collection of objects (General/NSDictionary, General/NSArray, General/NSIndexSet, etc), and in your case I guess it should be General/NSNumber. In your -playMovie: implementation you use [timer userInfo] to get the necessary parameter(s). And, by the way, -playMovie: should not return anything - it's void.

---- 

OK I see, I got that to work.  But I have another problem.  What I am trying to do is have different timers with different intervals all call the same method, with a different parameter each time.  It works fine with a single timer, but when I add extra ones, I get an error. 
Here is the code:

    
...
- (id)init
{
	[super init];

	blinkInterval = General/[[NSNumber alloc] initWithInt:2.0];
	stretchInterval = General/[[NSNumber alloc] initWithInt:5.0];
	
	[self initTimers];
	
	return self;
}


- (void)initTimers
{
        blinkTimer = General/[NSTimer scheduledTimerWithTimeInterval:[blinkInterval doubleValue]
                                                                             target:self
                                                                          selector:@selector(playMovie:) 
                                                                          userInfo:BLINK
                                                                           repeats:YES];
        stretchTimer = General/[NSTimer scheduledTimerWithTimeInterval:[stretchInterval doubleValue]
                                                                             target:self
                                                                          selector:@selector(playMovie:) 
                                                                          userInfo:STRETCH
                                                                           repeats:YES];
}
...


And this is what I get when looking in the debugger window (I think it's a stack trace):
    
#0	0xfffeff10 in objc_msgSend_rtp
#1	0x9295f994 in -General/[NSCFTimer initWithFireDate:interval:target:selector:userInfo:repeats:]
#2	0x9295f800 in +General/[NSTimer scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:]
#3	0x000317f8 in -General/[MyController initTimers] at General/MyController.m:36
#4	0x000316bc in -General/[MyController init] at General/MyController.m:17


Thanks again.

----

What are STRETCH and BLINK? What is the error you get in the debugger console when this happens?

----

That is a stack trace, yes. I'd recommend you read General/CocoaIntroduction and get to know how Objective-C and C in general work.

----

I figured out what it is.  It had nothing to do with the timer, STRETCH and BLINK are #defined ints in the header file and I was getting a warning about not casting them to pointers before passing them to the function.  

----

The problem is that ints aren't objects. General/NSTimer is trying to retain them, but it explodes because you're saying "pretend 3 is a full-blown General/NSObject subclass" in your code. Use General/NSNumber to pass the values through.

Today's lesson is: never ignore warnings. They are there for a reason, and they usually mean that something is wrong with your code. When you get to the point of posting a question, make *sure* you include any warnings you don't understand. You may not be able to resolve them but you definitely shouldn't ignore them.

----

What the previous respondent said:  **Never** ignore warnings!  The warnings aren't saying *Cast those integers to a pointer before passing them in.*  They're saying *This parameter must be an General/NSDictionary.*  In particular, a {{userInfo}} will **always** be an General/NSDictionary, so you'll need to create an General/NSDictionary containing the additional data you want to associated with your General/NSTimer, and pass *that* as the {{userInfo}} when creating it.

----
A minor correction: an General/NSTimer's     userInfo can be any object, not just an General/NSDictionary.

----
Do you mean that my General/NSTimer should be initialized in the following way?
    
...
enum {
    BLINK=1,
    STRETCH,
    OTHER
}
...
stretchTimer = General/[NSTimer scheduledTimerWithTimeInterval:[stretchInterval doubleValue]
									target:self
								     selector:@selector(playMovie:) 
								     userInfo:General/[[NSNumber alloc] initWithInt:STRETCH] 
								     repeats:YES];
...

Is that efficient?  It seems like there's some useless overhead by adding that General/NSNumber.

----
It doesn't matter if it's efficient or not: you don't have a choice in the matter. You have to pass an object (or nil for no object) there, not an unwrapped number. See General/PrematureOptimization for reasons why you shouldn't worry about the overhead.

Also, userInfo should be autoreleased to avoid a memory leak: use General/[NSNumber numberWithInt:STRETCH] instead of General/[[NSNumber alloc] initWithInt:STRETCH]. The timer will retain it as necessary.

----
OK I see.  The last thing I would like to do with this timer is to re-set its interval.  I don't see a setTimeInterval method in the class, so does that mean I have to create a new General/NSTimer each time I want to change the timeInterval?  Also, when I create the new General/NSTimer over the old one, do I have to call [myTimer release] first?  

    
stretchTimer = General/[NSTimer scheduledTimerWithTimeInterval:10.0
                                                                         target:self
                                                                      selector:@selector(playMovie:) 
                                                                      userInfo:General/[NSNumber numberWithInt:STRETCH]
                                                                       repeats:YES];
// later...
[stretchTimer release];
stretchTimer = General/[NSTimer scheduledTimerWithTimeInterval:25.0
                                                                         target:self
                                                                      selector:@selector(playMovie:) 
                                                                      userInfo:General/[NSNumber numberWithInt:STRETCH]
                                                                       repeats:YES];



-Thanks.

----
Yes, you'll need to make a new timer. As to whether to release the old one, see General/MemoryManagement. Timers are like any other object and they follow the same rules of memory management as the rest. You'll want to do     [timer invalidate] to stop it from firing, though.

----
Do I want it to stop firing?  If I don't call     [timer invalidate], won't it just keep firing using the new General/NSTimer with the new interval?  Or will it fire both timers because the reference to the old General/NSTimer is maintained in the run loop?