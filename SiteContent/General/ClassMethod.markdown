

A General/ClassMethod is a method performed by a General/ClassObject.

Typically, a General/ClassMethod is used to create a new instance (new General/InstanceObject) of the receiving class, and to perform management upon any General/InstanceObject of that class.

A General/ClassMethod can always be invoked.  You do not create an instance of the class to which to send the General/ClassMethod.

You invoke a General/ClassMethod by sending a message to the class, like this:

    
General/[SomeClass someMethod];


----

You can have a General/ClassMethod and an General/InstanceMethod with the same signature (except, of course, for the + and -):

    
+ (General/NSString *)name {
     return @"Test";
}

- (General/NSString *)name {
     return General/self class] name];
}


----

You could also do this:

    

#define [[BothMethods(Name,General/ReturnType,General/SingeLine) -(General/ReturnType)Name { singleLine; } +(General/ReturnType)Name{ singleLine; }

...

General/BothMethods(Name,General/NSString,return @"Test")



or

    

#define General/MatchToClass(General/ReturnType,General/MethodName) -(General/ReturnType)General/MethodName { return General/self class] [[MethodName]; }

+ (int)stuff { return 5+5; }
General/MatchToClass(int,stuff);



-General/FranciscoTolmasky