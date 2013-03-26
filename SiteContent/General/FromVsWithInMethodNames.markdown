

Something that always trips me up is when to use 'from' and when to use 'with' in constructor method names. If I have a class <code>[[MySomething]]</code>, I have trouble deciding between <code>+([[MySomething]] '')somethingWithString:([[NSString]] '')aString</code> and <code>+([[MySomething]] '')somethingFromString:([[NSString]] '')aString</code>. I vaguely think if the string (or whatever) is somehow incorporated into the returned object as an ivar, or in some other way, the method name should use 'with'. If the passed-in object is only used as a reference to build the object that will be returned, I use 'from'. I don't suppose it really matters too much, but having a consistent naming convention is especially important in an API as verbose as Cocoa can be.

Does anyone have any hard & fast rules about which to use when?

----

That sounds about right. I use "from" when converting from other types.

----

When in doubt, see what Apple does.

A cursory search through a few headers reveals ''no'' use of "From" in this context, so I would suggest avoiding it to be consistent.

In particular, there are lots of methods where the passed-in object is only used as a reference to build the returned object, such as <code>+stringWithString:</code>, <code>+stringWithFormat:</code>, <code>+stringWithContentsOfURL:</code>, <code>+numberWithInt:</code>, etc. which all use "With".

----

There are functions that use from.. <code>[[NSSelectorFromString]]()</code>, <code>[[NSStringFromRange]]()</code> et al. And [[NSCalendar]] has a <code>- ([[NSDate]] '')dateFromComponents:([[NSDateComponents]] '')comp</code>