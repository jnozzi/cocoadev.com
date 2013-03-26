''This discussion assumes knowledge of the [[VisitorPattern]]. Check out the [[PortlandPatternRepository]] or the [[GangOfFour]] book for more info on the actual pattern.''

The [[VisitorPattern]] and [[ObjectiveC]]: Since [[ObjC]] does not support method overloading, proper implementation of the [[VisitorPattern]] is not possible. By proper, I mean that the pattern cannot be implemented without introspection hacks or by making it less powerful than it could be.

One version that can be implemented is the one that the discussion below led to: instead of encoding which method that will be called on the visitor in the type of the argument, it can be encoded in the name of the method to call.

Say that we have a visitor class (<code>Visitor</code>) and a number of visitable classes (which are not known to the visitor). The visitable classes all implement the method <code>acceptVisitor:</code>, which takes an argument that is the visiting object.

In a stronly typed language the visitor and visitables would implement some kind of protocol to formalize the visitor-visitable relation, but since this is [[ObjC]], we'll do it informally, although using formal protocols or abstract base classes never hurts, in my opinion. 

The visit''ed'' object is supposed to call a method on the visit''or'', but which? If all visitors would call the same, the outcome would be pointless, since the visit''or'' would still not know about the type of the visit''ed'' object. As I said earlier, the solution is to encode the type in the message that the visit''ed'' object sends to the visit''or'': if the visit''ed'' object is of the type <code>Leaf</code> then it could send <code>visitLeaf:</code> and send itself along as argument, or if it's a <code>Parent</code> it could send <code>visitParent:</code>, Foo would send <code>visitFoo:</code>, and so on.

The implementation for <code>acceptVisitor:</code> of the class <code>Leaf</code> could be this:

    - (void)acceptVisitor:(id)visitor {
        [visitor visitLeaf:self];
    }

There is still one more problem, though. What happens if the visit''or'' doesn't know about the type of a visit''ed'' object? The visit''or'' would not respond to the message, and everything would crash and burn. The visit''ed'' object must check if the visit''or'' responds to the correct message, and else if it responds to the message that the superclass of the object would send and so on (but this can be tedious and would not always work), and it cannot just return if it the visit''or'' doesn't respond to either, there must also be a default message to send. If it's guaranteed that all visit''ed'' objects inherit from an abstract superclass, the default message would be the message that class would send, otherwise it could be anything, as long as it's documented somewhere. A good name would perhaps be <code>visitUnknown:</code>.

So the complete implementation of the method above could be something like this:

    - (void)acceptVisitor:(id)visitor {
        if ( [visitor respondsToSelector:@selector(visitLeaf:)] ) {
            [visitor visitLeaf:self];
        } else {
            // if all fails, resort to the default
            [visitor visitUnknown:self];
        }
    }

Using this method the [[VisitorPattern]] can be implemented, although I must say that it's a quite ugly hack. It's a hell of a lot better than using a swich/case or if/elseif, though. For me, it's just a little bit too much informality in it, but it seems that it cannot be helped.

--[[TheoHultberg]]/Iconara

A side note from above:

(TODO: is it possible to do <code>[super respondsToSelector:@selector(acceptVisitor)]</code>, I have noticed that [[ObjC]] somtimes is a bit dodgy when it comes to using <code>super</code>)

(''
It don't know about super being dodgy, but the above does have a bug.  <code>[super respondsToSelector:]</code> invokes the superclass's implementation of respondsToSelector, which is likely the same as the current class's.  It does ''not'' check if the superclass implements the method.'')

'''Try <code>[[[self class] superclass] instancesRespondToSelector:@selector(acceptVisitor:)]]]</code>. --[[JediKnil]].'''

''True, true, but it reads right, doesn't it? "if super responds to selector"... anyway, changed now. --Theo''

''Edit: selector names need colons on them to match the messages being sent. Fixed.''

'''
That doesn't work either.  Suppose you have a superclass that implements the method and does something, and a subclass that implements the method and does something.  Say you have an instance of the subclass. When the implementation in the superclass is called, [self class] is still the subclass, so you still don't know whether a superclass of the superclass implements acceptVisitor.

I don't think there's a way to dynamically determine what you'd like to determine.  Make a base implementation that does nothing and always call the super implementation from any override of acceptVisitor:. 

Alternatively you could replace [self class] with the known name of the class in which you're writing the method.
'''

''Yupp, you're right. But that just proves the point, visitor is hopeless in [[ObjC]]... I have removed the super-calls now. Having a base class which would guarantee some behaviour (for example always calling <code>visitUnknown:</code> would probably be the best thing (but would just complicate this example). --Theo''

[snip, all wrong, never mind] Using [[[MySuperclassHere]] class] with [[JediKnil]]'s code should work fine, though, even though you'd have to remember to change it if you changed your class structure. -- [[MikeAsh]]

''How would it? Even if the superclass was statically named, the correct code wouldn't run, would it? <code>self</code> would still point to the instance of the subclass, unless we made a new instance, but that would defeat the purpose of the [[VisitorPattern]]. --Theo''


If this is the implementation in class Leaf:

    - (void)acceptVisitor:(id)visitor {
        if ( [visitor respondsToSelector:@selector(visitLeaf:)] ) {
            [visitor visitLeaf:self];
        else if ([[Leaf superclass] instancesRespondToSelector:@selector(acceptVisitor:)])
            [super acceptVisitor:visitor];
        else 
            [visitor visitUnknown:self];
    }

and this is the implementation in class [[InteriorNode]]:

    - (void)acceptVisitor:(id)visitor {
        if ( [visitor respondsToSelector:@selector(visitInteriorNode:)] ) {
            [visitor visitInteriorNode:self];
        else if ([[[[InteriorNode]] superclass] instancesRespondToSelector:@selector(acceptVisitor:)])
            [super acceptVisitor:visitor];
        else 
            [visitor visitUnknown:self];
    }

then it works (I think), and continues to work if more subclasses are introduced. -Ken

''I should try the code, but I can't right now. I'm pretty sure though that <code>super</code> refers to the same thing in both methods, or does <code>super</code> work differently from <code>self</code>? --Theo''

Yeah, they work differently.  <code>self</code> is an object, and there's nothing special as far as messaging it is concerned. <code>super</code> is a keyword, and messages to super use <code>objc_msgSendSuper</code> instead of <code>objc_msgSend</code>.  If you message super, the runtime only looks for implementations attached to classes starting above the class that the current implementation is attached to.  
----

'''Discussion'''

The [[VisitorPattern]] (http://c2.com/cgi/wiki?[[VisitorPattern]]<code></code>) seems to be impossible to implement in [[ObjC]] because of the lack of [[MethodOverloading]] (which in turn is not possible because of the dynamic runtime). Could someone direct me in the right direction on how to solve a typical [[VisitorPattern]] problem (without resorting to if-else-if:s and swiches)?

My problem: I have an abstract syntax (a DOM tree), which I want to pretty-print. I would like to have a class with lots of visit-methods and apply the visitor pattern to my nodes, so that I can do [node accept:self] and end up in the right visit-method and append a string based on the visited node. It's dead easy in Java, but I can't think of a way of doing it in [[ObjC]] without resorting to if-else-if or switch-case.

--[[TheoHultberg]]/Iconara

----

I would think that you can either name the methods in the visitor class for <code>visitXYZ:</code> (XYZ being the name of the node) or, instead of the visitor pattern, create a category with the method which you then implement for each node (similar to how you'd extend all the classes with the method if you were not using the visitor pattern, but due to open classes and categories you won't need to subclass and you can keep the implementation of all methods in one place).

--[[AllanOdgaard]]

----

Ah, I feel a bit stupid, I have stared myself blind at the elegance of using overloaded methods with the visitor pattern, not realising that it's not so important. Of course, naming the <code>visitXYZ:</code>  will do fine. Thanks for nudging me in the right direction.

--[[TheoHultberg]]/Iconara


----

First, a deliberately inflammatory sentence: '''this is a way of avoiding using categories'''. An alternative is to add, via categories, a <code>-prettyPrint</code> method to each node type, and call it at each node of the tree. The visitor object, if still needed (e.g. for storing how deep the indentation has reached), can be passed as an optional parameter.

    - (void)deepCallMethod:(SEL)selector withVisitor:(id)visitor {
        for (...) { // Walk the tree, by whatever means
            [node performSelector:selector withObject:visitor]; // Visit each node
        }
    }
    
    [tree deepCallMethod:@selector(prettyPrint:) withVisitor:NULL];

Java and C++ do not have categories: the [[VisitorPattern]] acts in their stead. We cannot therefore transplant it into [[ObjC]] without thought. Consider:

* Each <code>visitXYZ:</code> method must by design be tightly coupled to the <code>XYZ</code> class, but only loosely to the visitor class; this suggests they should be methods of the <code>XYZ</code>, not visitor, class.
* Categories respect inheritance, which lack of overloading denies the [[VisitorPattern]], evil code hacks notwithstanding. (One should not have to mimic the inheritance hierarchy in code!)


I will stop now, and see what objections people raise.

-- [[KritTer]]

----

If any description of how to use a visitor claims that the visitor is some optional parameter, then you are missing the point.  The visitor is a clever way to pull complicated and usually unrelated code out of tree-like data structures.  The visitor has pre and post visit methods called on it with the node as an argument so that it can evaluate the tree in exactly the way it is designed to but requires no other code.  For example, this is commonly how compilers do semantic analysis on an abstract syntax tree representation of a compilation unit.  It also allows for plug-ins to be easily written for the compiler since the plug-in is just another set of visitors which, together, extract some useful data from the abstract representation of the data structure.

----

I think you may have missed ''my'' point. Categories are also a way of pulling complicated code out of an unrelated compilation unit. They also allow for plug-ins to easily be written since [[ObjC]] allows categories to be added at runtime. If you want pre- and post-visit methods, try the following:

    - (void)deepCallWithPre:(SEL)pre post:(SEL)post visitor:(id)visitor {
        for (i = 0; i < maxNodes; ++i) {
            if ([node[i] respondsToSelector:pre])
                [node[i] performSelector:pre withObject:visitor]; // call pre
            if ([node[i] respondsToSelector:@selector(-deepCallWithPre:post:visitor:)])
                [node[i] deepCallWithPre:pre post:post visitor:visitor]; // walk tree
            if ([node[i] respondsToSelector:post])
                [node[i] performSelector:post withObject:visitor]; // call post
        }
    }
    
    [tree deepCallWithPre:@selector(myPreVisitMethod:)
                     post:@selector(myPostVisitMethod:)
                  visitor:visitor];

-- [[KritTer]]

----

I'm not so sure that post-visit and pre-visit could be considered a part of the [[VisitorPattern]], they are a part of a traversal. The [[VisitorPattern]] is about dynamically discovering types (oversimplification, perhaps). Traversal is more like a basic algorithm. True, traversal + visitor is very powerful, but the visitor part is for discovering the type. 

I think I agree with [[KritTer]] that categories take the place of the [[VisitorPattern]], in many respects. 

--Theo

----

Let's not forget that patterns are a general solution to a general set of problems and need to be considered in context. The Gang of Four patterns are very C++ oriented, which also makes them useful for Java. They're useful for Objective-C, but Kritter's right that we can use categories to separate the accumulation logic from our domain objects as an alternative to Visitor.

I'm glad Kritter pointed that out, I hadn't really considered categories for that purpose before.

That pattern should go on the [[ObjCDesignPatterns]] page.

--[[TerryWilcox]]