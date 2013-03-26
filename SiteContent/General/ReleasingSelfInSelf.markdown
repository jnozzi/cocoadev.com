Can I do the following:

<code>
- (void)someMethod
{
     id pointer = self;
     self = [[[[SomeClass]] alloc] init];
     [pointer release];
}
</code>

'''Why do you want to release yourself?'''

Scratch this conversation.  It is continued in [[MakingAnInstanceSwitchClass]]

''Just for the record, the answer is no. This code will not work because the new <code>self</code> will not magically be transmitted outside the method. The caller will suddenly hold an invalid object, and the new one will leak.''

Sadly, I realized immediately after posting... and made the appropriate comment inside [[MakingAnInstanceSwitchClass]] :(