

This page can collect various [[UserInterface]] validation techniques.

----

The standard techniques differ according to what you are validating.

'''Menu Items'''

Write me!

'''Buttons and Other Controls'''

There is a page for [[ValidatingNSButtons]]; general UI validation principles apply

'''Toolbar Items'''

See [[NSToolbarSampleCode]] for one way to do it. See also [[ValidatingToolbarItems]] and [[ValidatingToolbarItemsInThreadedApp]].

----

Panther introduces [[CocoaBindings]], which can be used to validate controls (and maybe menus?).

A control's ''enabled'', ''editable'', and ''hidden'' bindings can be bound to model keys, which can be tested for nil, not nil, false, or true, or anything else you like if you write the appropriate [[NSValueTransformer]]. You can bind these multiple times; the final value will be OR'd in the case of ''hidden'' or AND'd for ''editable'' and ''enabled''.

Panther also introduces [[KeyValueObserving]], which is a cool validation technique on its own. You can use it to avoid calling validation methods or posting validation notifications.

You can observe any model or controller property, so long as changes to the property are surrounded (automatically or manually) by '''willChangeValueForKey:''' and '''didChangeValueForKey:'''. Register an observer and write the '''observeValueForKeyPath:ofObject:change:context:''' method.  This method should validate controls appropriately. You can validate on a per-key or per-object basis, or both. Your controller can observe changes to itself by calling <code>[self observeValueForKeyPath:@"property" ofObject:self�]</code>.

----

Panther also introduces [[KeyValueValidation]]. This works in conjunction with [[CocoaBindings]]. When a value needs to be validated, a model object method like ''-validateFoobaz:error:'' is called automatically (if it exists). It should return YES or NO (along with an autoreleased error string). See full documentation at http://developer.apple.com/documentation/Cocoa/Conceptual/[[KeyValueCoding]]/Concepts/Validation.html.

Although the above page says that the validation method can correct the data and return YES, this is deprecated, and [[CocoaBindings]] does not support it.

''What makes you say that? The July 2005 developer documentation still states that the validation method can correct the data and return YES, and I made it work with [[CocoaBindings]].''

----

There is an Apple page at http://developer.apple.com/documentation/Cocoa/Conceptual/[[UIValidation]]/index.html which discusses using the [[NSValidatedUserInterfaceItem]] protocol and <code>- (BOOL)validateUserInterfaceItem:(id <[[NSValidatedUserInterfaceItem]]>)anItem</code> but says only [[NSMenuItem]] and [[NSToolbarItem]] support it. How can I get it to work with other controls? Or is [[CocoaBindings]] the way to go? (I've successfully avoided learning much about them up until now...)

----

This may sound like a stupid question, but ... what exactly ''is'' user interface validation? I thought validating a control meant checking the value given by a user was valid, but that doesn't seem to make sense w.r.t. menu and toolbar items. I feel like I've missed out some <code>Basic GUI 101</code> course :)

''In this case, the <code>validUserInterfaceItem:</code> and other methods return <code>YES</code> if the specified user interface item should be enabled, and <code>NO</code> if it should not. An example case might be disabling the <code>Delete</code> menu item if nothing is selected. --[[JediKnil]]''

----

'''What follows used to be [[ValidatingNSButtons]], but it is more specific and related to using Bindings for user interface validation:'''

I have a button that needs to be enabled or disabled based on whether a string is non-nil (the string is a path for my app to process.) I know I could just call <code>setEnabled:</code> on it (and every other button that needs it), but I'd like to do it a better way... As far as I can tell, my options are:


* Use [[NSUserInterfaceValidations]]. Would I need to subclass [[NSButton]] for this? The docs at [http://developer.apple.com/documentation/Cocoa/Conceptual/[[UIValidation]]/index.html] are sketchy, to say the least.

* Use [[CocoaBindings]], with the button's enabled selector bound to my model's string property, and a [[NSIsNotNil]] [[NSValueTransformer]]. Unfortunately, this doesn't work. The button never gets enabled when my string gets set. Do I need to register the button as an observer for it to track state changes in my model?


----

Are you retrieving the string from a text field? If so, it will not return nil; instead, it will return a blank [[NSString]]. That explains why the bindings does not work. Sorry, I don't know enough about bindings or [[NSUserInterfaceValidation]] to help you further. Have you looked into making your own value transformer to see if it's a blank string? -- [[RyanBates]]

Okay, after doing a little testing I see my theory was not correct. Bindings work correctly with the [[NSIsNotNil]] value transformer, but it does not take effect until the user finishes editing the text field - this is probably not what you want, and a custom value transformer will not fix this problem. You will probably have to do it manually. -- [[RyanBates]]

----

I fixed it... Eventually the string will come from a [[NSOpenPanel]], but for now I'm just setting an instance variable myself. My problem was I was doing it directly, rather than going through a KVC-compliant accessor.

----

You are not supposed to bind the "enabled" property to anything but a boolean controller attribute, for example -canInsert or -canRemove or similar (or set of similar using the extended "enabled<n>" additional bindings). Do not expect correct behaviour when binding to an attribute that returns an object.

''Yes, but should it not matter if you have a value transformer which spits out a boolean?''

My thoughts exactly. It works, anyway, whether or not it's supposed to.