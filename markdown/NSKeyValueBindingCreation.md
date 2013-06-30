

Apple docs at: http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Protocols/NSKeyValueBindingCreation_Protocol/index.html#//apple_ref/doc/uid/TP40004171

This would appear to be the protocol that controls what shows up in General/InterfaceBuilder's General/BindingsInspector. All sub-classes of General/NSObject inherit this protocol.

An illuminating discussion on Apple's cocoa-dev mailing list yielded the following insight:

A binding name is not a KVC key at all. It is an identifier associated with an abstract property and a concrete object/KVC key combination. When you change a control's value, it looks in its binding table for what a "value" corresponds to in programmatic terms of object and KVC key. Binding names play a strictly internal role. When setting up KVO to see changes and using KVC to make changes, controls only use the object and KVC key.

----

I tried to create an General/NSView and call this protocol's **exposedBindings** method to get a list of bindings that General/NSView exposes, but I get 0 bindings back. I know it at least has a *hidden* binding. What gives?

�Ah, interesting. It does show the *hidden* binding when the General/NSView is actually part of a window. Earlier, when I tried a "naked" General/NSView (created in main() of a command-line app without a run loop), the binding didn't show up. Maybe I did it wrong last time, or maybe the exposed bindings can be contextual. �General/DustinVoss

----

When I call "exposedBindings" on an General/NSImageView object I get the following result:
(fontSize,  fontName, enabled, fontFamilyName, font, fontItalic, hidden, value, motionVectors, editable, fontBold)

What I don't understand is: 
- Where do the "font..." bindings come from? They are not present in General/InterfaceBuilder.
- How does the mysterious "value" binding work? The General/NSView subclasses do not respond to a key named "value" nor do they respond to a selector of that name.

 -- Frank Illenberger 

As to the "font" bindings, I'd guess that they are part of General/NSControl *(I'm fairly sure     value  is as well)*, and IB filters them out somehow (and by "somehow" I mean "they probably hard-coded it"). �General/DustinVoss