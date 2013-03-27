

An nil targeted action is an General/ActionMethod attached to a control but whose target is unknown until runtime. Nil targeted actions are created by adding actions to the General/FirstResponder proxy in General/InterfaceBuilder and connecting them to controls. Most often menu items are connected to nil targets.

The benefit of nil targeted actions is: rather than being directly connected to a particular object (class instance) such that only that object can respond the messages, a nil target action works through the General/ResponderChain starting with the object which has the 'key' focus. In practical terms, each object in your UI could implement the same General/ActionMethod suited to its own needs. The Objective-C runtime would then invoke the method belonging to the current first responder ie, the one with the key focus.

----

This is the thing that makes the Cut, Copy and Paste menu items work correctly regardless of the object that has the focus. -- l0ne aka General/EmanueleVulcano

To respond to General/NilTargetedAction, an General/NSView has to be able to become first responder, which is done in General/NSView subclasses by implementing the method     -(BOOL)acceptsFirstResponder and have it return **YES**.

----

To send a General/NilTargetedAction from code use General/NSApplication's      - (BOOL)sendAction:(SEL)anAction to:(id)aTarget from:(id)sender  (or General/UIApplication's      - (BOOL)sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(General/UIEvent *)event on iOS) with a nil target.