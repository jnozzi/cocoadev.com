

In many General/ObjectOriented programming languages, General/ObjC among them, every object belongs to a class. That class defines what data the object can store, what methods the object can respond to, and how those methods should be implemented.

The General/RunTime creates a General/ClassObject for each class; this class object is the receiver of all class method messages.

In General/ObjC, every class is represented by a General/ClassObject, which can create a new General/InstanceObject, reply to a General/ClassMethod, and otherwise manage objects belonging to their class. To quote ABY, p. 18 (General/BookCocoaProgramming): "Classes are objects that describe instances." It does not get more succinct than that.

For example, the following describes a class of objects, General/MySimplePrinter, each of which can respond to the -print method, contain a string, and are created by the +printerWithMessage: General/ClassMethod.

    
@interface General/MySimplePrinter
{
    General/NSString *messageToPrint;
}
+(id)printerWithMessage:(General/NSString *)message;
-(void)print;
@end


To create such a printer, we would send the +printerWithMessage: message to the General/ClassObject, which is always represented by the class name. Note that the + in front of the message indicates it is a General/ClassMethod.

    
General/MySimplePrinter *printer = General/[MySimplePrinter printerWithMessage:@"Hello!"];


To get this printer to print, we would send it the -print message. Note that the - in front of the message indicates it is not a General/ClassMethod.

    
[printer print];


----

I am trying to figure out how the Class object works and am not able to find really any documentation on it.

Let's say you have a runtime class reference created by one of the following methods:

    
Class aClass = [myInstance class];
Class bClass = General/[MyClass class];
Class cClass = General/NSClassFromString(@"General/MyClass");


I thought I would be able to use any of these objects as if I was using the class name itself statically, eg:

    
id instanceA = General/[[MyClass alloc] init];
id instanceB = [bClass alloc] init];


My thought was that the two above would be the same, which it appears to be, but in other areas, it is not as expected:

    
if ([bClass isKindOfClass:General/[MyOtherClass class]) {
    // General/MyClass does inherit General/MyOtherClass, so this should be true, but it is not
}

// I also tried to call a class method, but this did not appear to work
[bClass myClassMethod];
// error in log: +General/[MyClass myClassMethod]: unrecognized selector sent to class 0xf8220


The weird thing is that the error message properly states the intended selector message being sent, '+' meaning a class method, and then General/[MyClass myClassMethod], exactly as expected.

I was able to get around my first problem above (isKindOfClass) by doing the following:

    
id obj = [bClass alloc];
if ([obj isKindOfClass:General/[MyOtherClass class]]) {
    // this evaluated to true, so [bClass alloc] worked as expected
}


For the time being I will just likely implement my methods as instance instead of class methods, but that is not really my preferred path in this case...

So, can anyone provide some insight into my issues with the Class object?

--General/PercyHanna
----
Although this is how objects work in General/ObjC, the Cocoa side of things makes an effort to hide it a little. As such,     General/[MyClass class] returns M<nowiki/>yClass, not the "metaclass" that M<nowiki/>yClass is a (singleton) instance of. (Why have this method at all? It helps hide dynamic subclasses, like those used for General/KeyValueObserving.)

The correct way to test class subclassing is to use     +isSubclassOfClass:, though of course it's better not to explicitly test inheritance whenever possible.

Calling a class method like that does indeed work; are you sure you really implemented     +myClassMethod?

General/JediKnil

----

Thanks General/JediKnil, the     +isSubclassOfClass: versus     -isKindOfClass: was the key.  My theory was that I was running the instance method     -isKindOfClass: on the Class object, since syntactically it appears more that you are running a method on an instance rather than a static class.  So in other words, the two lines below would be essentially the same:

    
General/[MyClass classMethod:...];
General/instanceOfMyClass class] classMethod:...];


Thanks again,
--[[PercyHanna