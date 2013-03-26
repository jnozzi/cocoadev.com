Will this work if  'id' could be any obj-c class. -- JP

<code>
in .h

[[NSMutableDictionary]] ''ivar_attributes;

in .m

- (void)setAttribute:([[NSString]] '')key to:(id)value
{
    [[CFDictionarySetValue]](([[CFMutableDictionaryRef]])ivar_attributes, (const void '')key, (const void '')value);
}
</code>

----

It seems like [ivar_attributes setObject:value forKey:key]; would work fine, so I don't quite see the point of using [[CoreFoundation]] at all.  OTOH, I don't see any problem with what you're trying.  What's the catch? -- Bo

----

No catch, just theoretically. Unfortunatly I can't test it myself right now(Using a HP laptop) -- JP

----

[[CoreFoundation]] is apparently slightly faster than regular message-sends when you can use it, so hey. But yeah, looks like it should work. -- [[RobRix]]

Yeah, it avoids a message send, and probably a little wrapper code.  But I'd imagine the savings are pretty small.  It's best to measure and see if that's your problem before contorting a bunch of code.  (OTOH, it's always good to be versed in CF as well as cocoa techniques) ++[[MarkDalrymple]]

One should also be sure to run a proper speed test: message sends speed up after the first attempt, due to Apple's code doing some internal caching. -- [[KritTer]]