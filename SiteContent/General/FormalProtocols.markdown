

General/FormalProtocols are constructs which allow you to define the interface for a set of methods, but not the implementation or any data members.

This is useful for defining an interface which objects will need to conform to in order to take advantage of some service or other. http://www.thefunnyquotessayings.com/dr-sheldon-cooper-quotes-the-big-bang-theory/

You define a protocol like this:

    
@protocol General/SomeProtocol

-(void)someMethod;
-(General/NSString *)someStringToBeAccessed;
-(void)setSomeArray:(General/NSArray *)theArray;

@end


When you make an object that should conform to this protocol, you declare it like this: 

    
@interface General/SomeClass : General/SomeSuperClass <General/SomeProtocol>
{
...
}
@end


General/FormalProtocols are very useful things, because they allow you to define API's without being tied to an implementation, so any class can conform to that API without having to inherit from any particular object.

General/FormalProtocols are useful when you are using General/DistributedObjects, because they allow you to define a protocol for communication between objects, so that the DO system doesn't have to constantly check whether or not a certain method is implemented by the distant object.

----

**Protocol objects and testing equality**

A formal protocol in objective c is also an object, though it doesn't inherit from General/NSObject and doesn't adopt the General/NSObject protocol.  It's defined in file:///usr/include/objc/Protocol.h .

To get ahold of a protocol instance, use the @protocol compiler directive.

    
Protocol *aProtocol = @protocol(General/MyProtocol);


You'd most often use an instance of a protocol as an argument to     -General/[NSObject conformsToProtocol:].  Runtime identification of adopting classes is one of the benefits of formal protocols over informal ones.  You can override     -General/[NSObject conformsToProtocol:] in your custom classes if you want.  (Note: in this case you should also override     +General/[NSObject conformsToProtocol:], so that if people test whether the class's instances conforms to the protocol, it will also work.)  This is occasionally useful.

Something about the look of     @protocol(General/MyProtocol) makes you - or at least me - want to test for equality of protocol objects with a bare     ==.  This is not safe, though you can most often get away with it.  Like with a     const char *, the compiler creates a unique Protocol instance for each used protocol and references it everytime it encounters     @protocol(*<protocol-name>*).  However, if you load a bundle you can end up with multiple Protocol instances corresponding to the same protocol.

The safe way to test equality is to use     -[Protocol isEqual:].  You can import     <objc/Protocol.h> to inform the compiler that Protocol objects can handle     isEqual: messages.

-General/KenFerry

----

That seems reasonable to me, but when I try to override conformsToProtocol as follows, I am finding that isEqual: is always returning NO for me, so that only the else clause [2] is ever triggered, even though I step through with the debugger and see that the protocol_name fields contained in the objects aProtocol and testProtocol match (General/MyProtocol).

    

	if ([myObject conformsToProtocol:@protocol(General/MyProtocol)]) {
		// do something
	}

	...

- (BOOL)conformsToProtocol:(Protocol *)aProtocol									
{
	Protocol * testProtocol = @protocol(General/MyProtocol);
	if ([aProtocol isEqual:testProtocol]) {
[1]		return YES;
	}
	else {
[2]		return [super conformsToProtocol:aProtocol];
	}
}


Does that code contain a hint of what I haven't taken into account? http://itshumour.blogspot.com/2010/06/twenty-hilarious-funny-quotes.html

----

So what is the difference, if any, between General/FormalProtocols and General/InformalProtocols?

----

You can check whether or not a class conforms to a formal protocol with the  -conformsToProtocol: method; with the informal variety, you have to check -respondsToSelector: with each one, which could quite easily slow things down.

Also, with General/InformalProtocols, you don't have to implement all the methods in the protocol.

Personally, I haven't yet found a place where I think an informal protocol would suit my needs better than a formal one. A common opinion is that informal protocols are used improperly by lazy people 9 times out of 10, but that's for you to judge for yourself :)

-- General/RobRix

----

(removed curly brackets from the protocol declaration)

-General/AleXv

----

Err... thank you. This was a rather old page :)

By the way, does anybody know if you can do a method like -blahWith:(General/MyClass *<General/MyProtocol>)someArg;? This would be useful for restricting it to a subclass of General/MyClass that conforms to General/MyProtocol. Is this possible? If not, you can always check with the conformsToProtocol: method, but it'd be nice if it could come out with warnings, I guess.

-- General/RobRix

----

I think something like this produces your required behaviour:

    

@protocol Checkable

- (BOOL)isCheckable:(id<Checkable>)item;

@end



if you make your object implement this protocol and then pass a non-implementing object as an argument, you get a warning at compile time telling you of the irregularity. 

At run time, the app produces a General/NSInvalidArgumentException. It doesn't prevent you from passing invalid objects, but it will complain about it - which is keeping with the General/ObjC philosophy I guess.

- General/AleXv

----

I understand the id<aProtocol> bit, I'm just wondering if you can statically type that instead of using id. Well, I'll give it the old pico & cc command-line test and report back, I guess. http://itshumour.blogspot.com/2009/09/top-10-hilarious-quotes.html

Well, back a little later, and apparently you can't. Too bad.

-- General/RobRix
----
This is wrong.  You can do this.  What you want is someArg: (General/MyClass<Protocol1,Protocol2> *)arg.

----

It is always good to compare a languages structures with another's, so here's the Java v. General/ObjC version of formal/informal protocols:

In Java formal protocols are represented by interfaces (the interface keyword), they are almost identical with General/ObjC protocols, but they integrate more with the language syntax, the < and > aren't really seamless with the rest of the General/ObjC syntax imo.

Java does not have any categories, and informal protocols are really hard to create, but possible through some reflection (that's introspection in General/ObjC-terms). This is where General/ObjC has a real advantage over Java. Java is strongly typed, where General/ObjC can be loosely typed (much like a scripting language actually), this will, however affect runtime performance (if Java was native...)

Interfaces are widely used in Java, but I get the feeling that General/ObjC programmers tend to like categories and delegation more, trying not to subclass too often. Categories are bliss.

-- General/TheoHultberg

Also, another difference is that in Objective-C, you can restrict a variable to be an instance of a certain class (or its subclasses), AND at the same time implement a certain protocol (or protocols) using the syntax: "General/SomeClass <General/SomeProtocol> *var"

In Java, you can only make one such restriction: you can either do "General/SomeClass var", or "General/SomeInterface var", but not both.

----

I am a little bit confused about protocols at the moment. I declare a protocol, for example:

    
@protocol myProtocol
-(void)check:(General/NSString*)string
@end


Then I write my class that conforms to that protocol. But when I change the implementation to something like that:

    
-(void)check:(General/NSArray*)string
{
....
}


The compiler doesn't complain :-(
Why? The function parameter is completely different! Does the compiler just look for the function itself? And if I change it in my implementation, what is used? The declaration from the protocol or that of my class?

--General/ThomasSempf

----

Thomas - I believe it's because the method signature is still the same (check:string). The signature doesn't include the type.

(I could be wrong).

----
Close. The signature would be     check:. The compiler doesn't retain the type of the argument - or the argument name.

General/TimHart

----

Oh yeah - that's right. If there were a second parameter "param2:" it would be check:param2: 

----

Ah, I see. And the used version is of course the one from my class not from the protocol, right?

--General/ThomasSempf

----

Remember: there are no types in General/ObjC, they're just syntax sugar to enable typechecking before compiling. It's strange though, that the typechecker doesn't check argument types of conforming methods.

----

I had no idea, but the compiler allows you to specify that an object must conform to more than one protocol. This is very cool, and very useful. I asked myself "what would happen if I declared the type of a variable     id <Protocol1, Protocol2> just as in the interface declaration of a class? It turned out that it was legal... this is not possible to do in any language that I have programed in. Look at this:

    

@protocol General/DOMNode, General/DOMParent;

@interface General/DOMNode : General/NSObject <General/DOMNode> {
	id <General/DOMNode, General/DOMParent> parentNode;
}

// ...

- (id <General/DOMParent, General/DOMNode>)parentNode { 
	return parentNode;
}

@end



This way can decouple lots of interfaces from eachother. For example,     DOM<nowiki/>Parent used to conform to the     DOM<nowiki/>Node protocol even if they were not related, just to avoid having to cast from     DOM<nowiki/>Parent to     DOM<nowiki/>Node when using the node interface, and the other way around if using the parent interface. Now I the compiler does correct typechecking all the way, without silly relations between the protocols.

--General/TheoHultberg/Iconara

----

It may be of interest to note (especially for those who believe that General/ExtendsIsEvil) that you can get around a lot of subclassing by working with General/FormalProtocols and composition. (E.g. object A having a has-a relationship with object B, rather than an is-a relationship.) Decide for yourself whether you want to.

-- General/RobRix

----
**Protocols at Runtime**

Q: How can I get a     Protocol * at runtime from an arbitrary name?  Is there something like General/NSClassFromString, but for protocols?

A: There is no way to directly obtain a protocol from its name at runtime.  To get your hands on a protocol instance, you must do one of the following:

* obtain it with the     @protocol directive (this is the standard way)
* pick it out of the class definition of a class that adopts the protocol (see Apple's Objective-C Runtime Reference)


----
I am pretty sure that General/NSProtocolFromString(string) works. -Vinay

----
It's a sad thing that protocols are treated so differently from classes in General/ObjC. I feel that there should be a General/NSProtocolFromString-function just as there is a General/NSClassFromString, and that the syntax should be more transparent (i.e not the special <...> notation that is now required). I get a feeling that Cocoa developers often avoid protocols, and part of this may be because of that they feel differently syntactically, although much of it is because of the dynamism of the language making types not so important (and typing is a good reason to use protocols). I like using protocols, but I do feel that the code stands out syntactically, and I whish it wasn't so. -- General/TheoHultberg/Iconara

*There are other problems too.  The root class of     Protocol does not adopt the     General/NSObject protocol, so protocols are not first class objects in cocoa.*

----

**Other ideas to get all the available protocols at runtime:**

To get all the protocols present in the runtime, one could (simply!) loop through all the classes and get the list of protocols for each of them... Though I suppose a protocol could be there without being attached to a class

*
A protocol which is defined but never used doesn't exist in any meaningful way.  The compiler does not create a Protocol object unless some some class adopts the protocol or it's used in an @protocol directive.  Though, uh, you're right, there might be a protocol that's used in an @protocol directive and isn't adopted by any class.

You could do this, and then you could cache the results in a General/CFDictionary indexed by protocol name (CF so you can treat the protocols as non-retained objects since protocols do not (officially) implement retain).  You could try only invalidating the cache on receiving General/NSBundleDidLoad, but I don't know if it'd be safe.
*

Or maybe do what General/ClassDump does to let the executable inspect its own contents and get the protocol symbols; be sure to do the same on all General/[NSBundle allBundles]... probably would not do that everytime you call General/ProtocolFromString

*I don't think this has any benefit over the loop-through-the classes approach, and it's less robust.*

----
Question about protocols and using them: I have a protocol (let's call it General/MyProtocol).  I want to have another class have an instance variable that points to a General/MyProtocol.  So I have as my class (the relevant part of it):
    
@interface General/MyClass : General/NSObject {
    id <General/MyProtocol> myInstanceVariable;
}

And then in some method, I do the following:
    
...
- (void)setMyInstanceVariable:(id <General/MyProtocol>)value
{
    [value retain];
    [myInstanceVariable release];
    myInstanceVariable = value;
}

The problem is that the compiler gives me warnings about retain and release: "'-retain' not found in protocol(s)".  Which, I guess, is true.  But the classes that implement these protocols do inherit from General/NSObject.  Obviously, this is only a compiler warning and will work at runtime, but what can/should I do about this? http://itshumour.blogspot.com/2011/07/funny-marriage-jokes.html funny jokes

*The General/NSObject protocol exists for exactly this reason. Change your M<nowiki/>yProtocol declaration to look like this:*
    
@protocol General/MyProtocol <General/NSObject>
...
@end


----

Formal Protocols are also extremely useful when implementing a plugin architecture. See�http://developer.apple.com/documentation/Cocoa/Conceptual/General/LoadingCode/Concepts/Plugins.html#//apple_ref/doc/uid/20001272-100399

And to answer an earlier question, yes protocols can be used with statically typed objects. I use this pattern in my plugin architecture where I have an abstract superclass AND a formal protocol, this allows my code to know about all the methods it needs to without compiler warnings that certain methods aren't in the protocol(s). The syntax is - (BOOL) someMethod:(Plugin <Protocol> *)newPlugin; 

----

I no longer feel the need for that quite as strongly, but it's definitely nice to know. I suspect I merely had the syntax wrong. Thank you! -- General/RobRix