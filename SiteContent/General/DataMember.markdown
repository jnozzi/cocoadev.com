

A [[DataMember]], also [[InstanceVariable]] or ivar, is a data variable which is a part of [[AnObject]]. 

It can be many things, from something as simple as an integer:

<code>
int oneDataMember;
</code>

Through more complex things like strings:

<code>
char'' anotherDataMember;
</code>

Up to complex things like selectors:

<code>
SEL'' aSelector;
</code>

And advanced things like objects:

<code>
id someObject;
[[NSString]] '' stringObject;
</code>

A [[DataMember]] is sometimes also referred to as an [[InstanceVariable]] (or "ivar" for short) because it is a variable that only exists within an instance of a class.