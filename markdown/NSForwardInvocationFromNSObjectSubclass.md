If I have a class that looks something like this:
    
@interface General/MyClass:General/NSObject {
     General/MyClassA *variableA;
     General/MyClassB *variableB;
}

- (void)someMethod;
@end


And **vriableA** responds to * - (void)someOtherMethod *, is it possible to send someOtherMethod to an instance of **General/MyClass** and have that instance forward the message to **variablA** given that **General/MyClass** inherits from General/NSObject, instead of General/NSProxy?

*Yes, just use the same method you would for a normal General/NSProxy subclass.*

----
So what's the difference between a class like *General/MyClass* that inherits from General/NSProxy, instead of General/NSObject (besides the major archiving and copying pain in the ass subclassing General/NSProxy provides)?

*
Forwarding with forwardInvocation only works with messages that General/MyClass doesn't respond to. You have to manually override the messages General/MyClass does respond to. If General/MyClass extends General/NSObject, that's a lot of messages to override. General/NSProxy has substantially fewer methods, so it's the better choice if you're forwarding all messages.

General/NSProxy also doesn't have a default implementation for potentially awkward methods like doesNotRecognizeSelector and methodForSelector. Those are the kind of messages you probably don't want your proxy responding to.
*