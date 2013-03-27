

See http://www.stepwise.com/Articles/Technical/2000-03-03.01.html for a thorough
explanation of Delegates and Notifications.

See also General/CreatingObjectThatWillUseADelegate, for a discussion of declaring your delegate methods in an informal protocol

----

How do I make my own custom class do delegation?

----

Something along the lines of this:

    
@interface General/MyOwnCustomClass : General/NSObject
{
	id delegate;
}

- (void)aMethod;
- (id)initWithDelegate:(id)del;
@end

// pre-declare your delegate methods -- General/MikeTrent
@interface General/NSObject (General/MyOwnCustomClassDelegateMethods)
- (void)notifyThatAMethodWasCalled;
@end

@implementation General/MyOwnCustomClass
- (void)aMethod
{
	// make sure delegate implements the delegate message. if we don't do this, and
	// someone passes in the wrong kind of object, you will generate an exception.
	// we use a category to define an General/InformalProtocol, meaning our delegate methods
	// are optional. we could create a General/FormalProtocol instead, in which case the compiler
	// and runtime can help us out a little better. But delegates are almost always defined
	// by an General/InformalProtocols.
	//
	// more time-critical code might check an ivar instead of calling respondsToSelector
	// every time. See initWithDelegate below. -- General/MikeTrent
	if ([delegate respondsToSelector:@selector(notifyThatAMethodWasCalled)])
		[delegate notifyThatAMethodWasCalled];
}

// it's normally better to use General/NSObject's -init method to initialize, and define the following:
// - (id)delegate { return delegate; }
// - (void)setDelegate:(id)del { delegate = del; }
// but this is ok for an example. -- General/MikeTrent 
- (id)initWithDelegate:(id)del
{
	if (self = [super init])
	{
		delegate = del;
		
		// time critical code might check respondsToSelector here and cache the result
		// in an ivar, for later use. -- General/MikeTrent
	}
	return self;
}
@end


-- General/ThomasCastiglione

----

Made a few notes in the code above, to cover more detail of how delegates should be implemented. See also General/InformalProtocols, General/FormalProtocols -- General/MikeTrent

----

Mike, doesn't this class need to retain its delegate? It would seem to me like when you programatically create a delegate autoreleasing the delegate object before giving it to the delegate is the only way to really make sure that it'll get deallocated. It's not always the case you set a delegate from IB. At the very worst, you do a bit of extra work.

-- General/DaveFayram

Retain? Nope. Although I'm having trouble following this sentence: "when you programatically create a delegate autoreleasing the delegate object before giving it to the delegate is the only way to really make sure that it'll get deallocated" ow ow ow ow ow!!! - HAHAHAHAHAHA!!! At least someone has a sense of humor.

An object does not "take ownership" of its delegate. We can say that every Objective C object ultimately is "owned" by another object (or objects!). When I program in Objective C I try to keep this relationship in mind at all times. I might create a string and assign it to an ivar, making the ivar's object the  string's owner. I might alloc/init an object, assign it to an General/NSMutableArray, and then release the object, thereby making the General/NSMutableArray the object's owner. Singleton objects own themselves.

Delegate objects are usually controller objects, like General/NSWindowController, General/NSDocument, or General/NSObject controllers created in IB. All of those objects are "owned" by someone: the window controller is owned by its document, the document is owned by the shared General/NSDocumentController (which owns itself, since it's a singleton), the General/NSObject subclass is owned by its nib file.

If objects were to start retaining their delegates, you could easily end up leaking memory:

    
@interface Delegator : General/NSObject
{
    id mDelegate;
}

- (void)setDelegate:(id)delegate;

@end

@implementation Delegator

- (void)setDelegate:(id)delegate
{
    [mDelegate release];
    mDelegate = [delegate retain];
}

- (void)dealloc
{
    [mDelegate release];
    [super dealloc];
}

@end

@interface Delegatee : General/NSObject
{
    Delegator *mDelegatorObject;
}

@end

@implementation Delegatee

- (void)init
{
    self = [super init];
    if (self) {
        mDelegatorObject = General/Delegator alloc] init];
        if (!mDelegatorObject) {
            [self autorelease];
            return nil;
        }
        [mDelegatorObject setDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [mDelegatorObject release];
    [super dealloc];
}

@end

int main()
{
    [[NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];
    Delegatee *foo = General/Delegatee alloc] init];
    [foo release];
    [pool release]; 
}


Let's walk through it. main creates a Delegatee instance, which in turn creates a Delegator instance. The Delegator instance retains the Delegatee, meaning the Delegatee has a retain count of 2 (main() and Delegator are both owners) and Delegator has a retain count of 1 (Delegatee owns it). When main() releases Delegatee, its retain count goes down to 1, therefore it does not get released. Oops!! You just leaked memory!! I hope we exit soon!!

So by convention, objects do not retain their delegates, since they do not want to "take ownership" of that object. The idea is the delegate object is supposed to "unregister" itself before it is destroyed. 

    
@interface Delegator : [[NSObject
{
    id mDelegate;
}

- (void)setDelegate:(id)delegate;

@end

@implementation Delegator

- (void)setDelegate:(id)delegate
{
    mDelegate = delegate;
}

@end

@interface Delegatee : General/NSObject
{
    Delegator *mDelegatorObject;
}

@end

@implementation Delegatee

- (void)init
{
    self = [super init];
    if (self) {
        mDelegatorObject = General/Delegator alloc] init];
        if (!mDelegatorObject) {
            [self autorelease];
            return nil;
        }
        [mDelegatorObject setDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [mDelegatorObject setDelegate:nil]; // probably unnecessary, but makes me feel good
    [mDelegatorObject release];
    [super dealloc];
}

@end

int main()
{
    [[NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];
    Delegatee *foo = General/Delegatee alloc] init];
    [foo release];
    [pool release]; 
}


Here main creates and owns Delegatee, which creates and owns Delegator. When main frees Delegatee, it frees Delegator. No leaks, no muss, no fuss.

Note that this idea of unregistering before you are destroyed is also true of notifications. If an object registers with [[NSNotificatonCenter saying it wants to receive notifications, it must unregister before the object is destroyed. Otherwise, General/NSNotificationCenter wll attempt to send a notification to an object that's been deallocated, causing an immediate, painful crash.

-- General/MikeTrent

----

I use this code to set my class as the delegate for General/NSApplication.  Useful when overriding (void)applicationWillTerminate:(General/NSNotification*)aNotification, etc.

    
General/[[NSApplication sharedApplication] setDelegate:self];


putting that line in the ur .m file (usually in the init) tells General/NSApplication that your class is a delegate.  then you can override General/NSApp's stuff.  i'm not sure if this code is frowned upon, but it has worked for me so far.  please comment if there is something terrible about doing it this way.

--greg

----

A much easier way to accomplish this is to simply connect the     delegate outlet of File's Owner in General/MainMenu.nib to your controller.

*assuming the controller is instantiated in the nib. and to the greg who posted the code above: you're not overriding anything, you're just implementing one of General/NSApplication's delegate messages.*