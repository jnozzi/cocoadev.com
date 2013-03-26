

Here's a tip for debugging. Use [[NSLog]] calls instead of printf calls since [[NSLog]] can print out objects. Also override - ([[NSString]] '')description for your class objects so that you can get something more meaningful than objectclass<address> when calling [[NSLog]] like so.

<code>
[[NSLog]](@"%@", self);
</code>

-- [[DaveHenderson]]

'''Note:''' the description method should only be used for debugging purposes.  If you want a textual representation of an object for display, create a different method, stringForDisplay or something. (Example place where you'll run into trouble if you use description for more than debugging: any object that you observe with [[KeyValueObserving]] will not have the description method you expect.  Well, unless you expect the description method to be other than the one implemented on the original class.)  http://goo.gl/[[OeSCu]]

----
Yup. See my extensive notes in [[NSLog]]. Also see [[NSGeometry]].h for some information on [[NSStringFromRect]], [[NSStringFromSize]], and [[NSStringFromPoint]] which are handy for [[AppKit]] programmers.

-- [[MikeTrent]]

----

As a follow-up to the [[NSLog]] tip, in your subclasses implement the description method even if you don't use [[NSLog]]. Because when you are debugging it is much nicer to get something other than a memory address in response to print object(po).
<code>
'''(gdb) po myController'''
<[[MyController]]: 0xb00050>
</code>

versus
<code>
'''(gdb) po myController'''
Hello, World!
</code>

-- [[DaveHenderson]]

----

I'm a bit stumped here. I have implemented a very ordinary model class with a description method

<code>
 - ( [[NSString]] '' ) description {
return [ [[NSString]] stringWithFormat: @"%f", [ [ props objectForKey: @"dataItem1" ] floatValue ] ];
}
</code>

<code>props</code> is an [[NSDictionary]] containing (among others) the listed key, whose value is implemented as an [[NSNumber]]. It is the only ivar in my model class, and KVC-compliant accessors have been implemented for it.

I invoke this 'passively' by logging each new object in a loop that enumerates an array containing a collection of these objects, but I get only the id values of the model objects in the run console (returned by the default description method which I wanted to override with the above method). If I rename the description method to <code>foo</code>, and invoke <code>[ modelObject foo ]</code> in the enumeration, the logging works fine. This follows exactly the example that Hillegass shows in his book.

''KVO's evil dynamic subclassing overrides -description to hide the fact that the subclass exists, but in fact this only works properly if you're using [[NSObject]]'s default implementation, and it will break a custom -description method. I'm not aware of a workaround other than renaming the method as you've done.''

Do you mean that, by using <code>objectForKey:</code>, I have unwittingly signed a pact with the devil??? (BTW, thank you for answering my question!!) I do not actually ''need'' to use the <code>description</code> method. I could just as easily give it a name like <code>stringValue</code> in the public interface, but thought that <code>description</code> would make the object conform more to expected behaviors. BTW2, do you mean KVC rather than KVO?

''No, I mean KVO as in key-value observing, so my comments only apply if you're using that. This could happen if you're using bindings, for example. And yes, using -description is a good idea except for the fact that KVO breaks it, and I personally think this is a flaw in KVO.''

That is correct: I ''am'' using KVO to bind the keys in <code>props</code> to some [[NSTableView]] columns.

'''The deal (as described above) is that description should only be used for debugging.  Also, opinions may vary on the 'evilness' of KVO's dynamic subclassing.  I'd tend to describe it as 'awesome'.'''

''Dynamic subclassing is cool. Overriding -description just to cover it up (and breaking custom -description methods in the process) is not cool.''

'''Well, that was fixed for Tiger, I believe. :-) '''

----
" the description method should only be used for debugging purposes�"

This is wrong; if you want to differentiate between debugging and readable descriptions, define -debugDescription and -description separately.

'''No, it is the case that description should only be used for debugging.  I'm not sure if I can find the documentation, but I have this on the authority of the Cocoa frameworks group at Apple.  It's a shame that there is a separate debugDescription method.'''

If this is true, then they really must fix the documentation to say so explicitly. Not only does [[NSObject]]'s version not say anything about it, but a lot of other objects have very explicit documentation, such as, "formatted as a property list", which could encourage somebody to rely on its exact output format for non-debugging purposes.

Apple technote: http://developer.apple.com/technotes/tn2004/tn2124.html

''"Note: print-object actually calls the debugDescription method of the specified object. [[NSObject]] implements this method by calling through to the description method. Thus, by default, an object's debug description is the same as its description. However, you can override debugDescription if you want to decouple these; many Cocoa objects do this."''

However, I agree that the canon for returning an object as string is -[id stringValue]