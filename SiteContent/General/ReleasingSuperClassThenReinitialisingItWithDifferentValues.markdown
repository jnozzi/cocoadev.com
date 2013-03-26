I want to release the superclass of a class. And then from one of the subclass's methods re-initialise it but with different values. Moveover, if A is the super class and B is the subclass. I want to release A from inside a B method calls. Something like this:

<code>

@interface A : [[NSObject]]
{
   int value;
}
- (A'') initWithValue:(int)aValue;
@end

@interface B : A
{
  
}
- (void) setValue:(int)aValue;
@end

@implementation B
- (void) setValue:(int)aValue
{
    [super release];
    super = [[A alloc] initWithValue:aValue];
}
@end

</code>

I am having problems using the 'super' keyword in this scheme. I cannot assign it a value.

The reason I want to do this is build a Mutable version (class B) of an existing class (class A). So I only want the subclass to have the -set: method. And I don't want to make any changes to the existing Non-mutable class (class A).

This approach might be undesirable but it is possible?

Cheers,

-- DJF

----
This does not make any sense whatsoever, I'm afraid. <code>super</code> is not a separate object. It is the ''same'' object as <code>self</code>. The only difference is that if <code>super</code> is the target of a message send, the dispatch is performed a bit differently. But it doesn't make any sense to reassign <code>super</code> because it's just <code>self</code>. Likewise releasing <code>super</code> is just releasing <code>self</code>.

If you are going to create this along this design, then you will probably need to make it a has-a relationship rather than an is-a relationship, so have A as an ivar instead of as your superclass.

----
Yes; going off of what the previous poster said, you might as well have A as an instance variable...but also, if A is something like [[NSNumber]], you can cheat a bit by subclassing it and passing along messages to an actual value instance variable. --[[JediKnil]]
<code>
@interface [[MutableNumber]] : [[NSNumber]] {
    [[NSNumber]] ''value;
}
// Implement forwardInvocation: and methodSignatureForSelector:
// to forward messages to value
- (void)setIntegerValue:(int)newValue;
- (void)setDoubleValue:(double)newValue
// etc...
</code>

----
What you are trying to do is actually accomplished with "self", but only really possible in the init method:

<code>

@implementation B
- (void)initWithValue:(int)aValue
{
    [self release];
    
    self = [[A alloc] initWithValue:aValue];

    return self;
}
@end

</code>

Doing this at any other point is potentially disastrous because other people could still have a reference to the original object, and there is no way to notify them that it has changed.

----

Hi,

Thanks for your response! Yes I knew it was a bit of a screwy question from start; it's never a good idea to fight the language (or framework) one works with! The reason for doing this was one of lazyness, e.g. it was easier to create a 'new super' than it was to workout exactly what instance variables of the super class to update etc., in the end that's what I did.

Thank you to the first poster for explaining about <code>super</code> and <code>self</code> I didn't appreciate that they were that same object; the standard init methods make a lot more sense now!

Cheers,

--DJF