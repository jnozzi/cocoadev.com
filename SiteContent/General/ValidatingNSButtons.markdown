[[NSButton]] is a subclass of [[NSControl]]. Any [[NSControl]] has methods for setting and finding its state. Check the superclass (in this case, of [[NSButton]]) when looking for a method that you don't see in the subclass with which you are working.

(the discussion that was here, which was about using bindings to try to validate a control from the contents of a string, was appended to [[ValidatingUserInterface]])

----

According to the Cocoa User Interface Validation documentation at http://developer.apple.com/documentation/Cocoa/Conceptual/[[UIValidation]]/index.html: "The protocols [[NSUserInterfaceValidations]] and [[NSValidatedUserInterfaceItem]] provide a standard way to validate user interface items�that is, to set their state as appropriate for the current application context".

Unfortunately, automatic user interface validation is provided only for menu items and toolbar items. '''[[HHValidatedButton]]''' implements interface validation in a [[NSButton]] subclass. It is a drop-in subclass of [[NSButton]]. It channels validation through validateButton: and validateUserInterfaceItem:. Available from: http://www.bernard-web.com/pierre/code.html