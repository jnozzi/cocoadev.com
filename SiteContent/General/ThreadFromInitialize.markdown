How do I start thread off the class initialize method, with [[NSThread]]?

It is clear, that I can't just use
[[[NSThread]] detachNewThreadSelector:@selector(thread) toTarget:self withObject:nil];

because there is no any self here.

I can use pthread_create, but it doesn't looks like cocoa-path, yeah?

Is there any solution, except pthread_create?

// [[SuperCat]]

----

There ''is'' self in a class method, self is the class. It is perfectly fine to use [[NSThread]] in that way from a class method, if the selector you give it corresponds to a class method.

----

Hmm, I don't understand either the question or the answer here, despite being pretty comfortable in cocoa.  Can you explain more clearly what you're trying to do?  What message would you send if you weren't trying to do it in a new thread?

Ah, I think I see.  I'm guessing that you are trying to call a method +[[[MyClass]] thread].  A class is an object like any other, and in a class method, <code>self</code> refers to the class object.  You can get ahold of the class object for <code>[[MyClass]]</code> with the message <code>[[[MyClass]] class]</code>.  So you may be okay to use the form that you wrote above, or you may need to say

<code>[[[NSThread]] detachNewThreadSelector:@selector(thread) toTarget:[[[MyClass]] class] withObject:nil];</code>

depending on whether you are trying to call this <code>thread</code> method from a class method or an instance method.

----

All is working good, there was mistyping in declaration. Sorry.