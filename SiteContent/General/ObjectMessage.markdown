

An General/ObjectMessage is sent to General/AnObject and consists of the General/ReceiverObject (someObject in the following example), the General/InstanceMethod that is being called (doSomethingWithObject:andAnotherObject: in the example), and any arguments that are passed to it (theFirstObject and theSecondObject in the example). 

    
[someObject doSomethingWithObject: theFirstObject
                 andAnotherObject: theSecondObject];


usually just called "Message", but we can't make a link out of that and General/MessAge is just too, uh, mess-y

And, in fact, you can send an General/ObjectMessage to a General/ClassObject, since a class is an object in our neck of the woods.

see also General/MethodSignature

see also General/SeLector