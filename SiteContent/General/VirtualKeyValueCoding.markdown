This technique is an alternative to [[NSValueTransformer]], though both techniques will apply to non-overlapping subsets of situations.

Advantages:

*Code is very easy to add (much easier than [[NSValueTransformer]])
*Can combine several ivars into one
*Better encapsulation (this is a very minor advantage)


Limitations:

*Read-only (no setter is possible) ----> actually not true, see '''Note 1''' below!
*Can't be reused in several classes, like [[NSValueTransformer]]


What is it? Many of you are already using it and some may not realize it exists (e.g. I have seen it mentioned on Wil Shipley's blog and some people seemed unaware of that possibility). [[VirtualKeyValueCoding]] is just an attempt to give it a name, and to propose a alternative to the wild idea of [[BindToSelfKey]].

To better explain it, an example is best, and we might as well use the example from the Apple docs on KVO. Imagine you have a class with 2 ivars, "firstName" and "lastName". You want your GUI to display the "Full Name", e.g. "John Doe". What you do is add a method to your class:

<code>
- ([[NSString]] '')fullName
{
    return [[[NSString]] stringWithFormat:@"%@ %@",[self firstName],[self lastName]];
}
</code>

This creates a "virtual" key-value pair, in that there is no ivar behind it.
Now, if you add the key <code>fullName</code> in your GUI bindinds, it will display the correct string, but will not update it automatically when the <code>firstName</code> or <code>lastName</code> changes. Let's suppose changes in these 2 "real" ivars do trigger notifications for KVO (in [[NSObject]], this is automatically done for you). All you need now is to add this line to your <code>+initialize</code> method:

<code>
+ (void)initialize
{
    [self setKeys:[[[NSArray]] arrayWithObjects:@"firstName",@"lastName",nil]
    triggerChangeNotificationsForDependentKey:@"fullName"];
}
</code>

----
'''Note 1:''' I'd just like to note that there's often no reason it can't be bi-directional. If you implement a <code>-setFullName:</code> method that parses the resulting string and sets <code>firstName</code> and <code>lastName</code> from it (and you set up the dependent key business for them) then you should be able to have it work as full-blown KVC but without a single backing ivar.