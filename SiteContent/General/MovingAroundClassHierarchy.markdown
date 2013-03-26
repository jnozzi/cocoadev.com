Ho hum,

I was wondering how you can go about sending a message to a super->super class? I need to decode something with [[NSCoder]],  but must call the objects [super->super initWithCoder:coder], and not the super's. The [super->super call] and [[super super] call] do not work. Aside: how can I send a message to a specific class in the hierarchy? In C++ you could make sure that specific method implementations were called like this: [[BaseClassName]]::[[MemberFunc]](Args); So how do I do this in Objective-C?

----

You can use <code>+[[[NSObject]] instanceMethodForSelector:]</code> to retrieve a particular method implementation.  That addresses both of your questions.  However, you should not do this as a matter of course.  You ought to have a ''really'' special situation on your hands before you think about doing this.

Why don't you want to call <code>[super initWithCoder:]</code>?  I bet there's a better solution than what you're going for. "Unfourtunately not, this hack is necessary to make an old C api cocoa friendly. Thanks for the help"

----

Also, thinking of <code>super</code> as an object isn't a good idea.  <code>super</code> is a keyword.  <code>[self someMethod]</code> is equivalent to <code>objc_msgSend(self, @selector(someMethod))</code> while <code>[super someMethod]</code> is equivalent to <code>objc_msgSendSuper(''super-context'', someMethod)</code>.  Insofar as super is an object, it's the same object as self.  

----

Another way of doing this would be to add the call to your super's super as a method of your super, via a category:

<code>@implementation [[MySuperClass]] ([[BypassRedefinedCoderCategory]])
-(id) initUsingSuperclassImplementationWithCoder:([[NSCoder]] '')coder
    {
    return [super initWithCoder:coder];
    }
@end

// Somewhere in your code
self = [super initUsingSuperclassImplementationWithCoder:coder]
</code>

I assume your subclass is primarily trying to alter the superclass' use of coders?