I'm new to General/NSNotifications, and I need a place to start.

----

Try one of the General/CocoaBooks.  They pretty much all cover it.

----

It's fairly simple - all the info you need to start is at [http://developer.apple.com/documentation/Cocoa/Conceptual/Notifications/index.html]
----
Please can someone tell me how to write a General/NSNotification that when text changes in a General/NSTextView it changes something else.

implement     - (void)textDidChange:(General/NSNotification *)aNotification in your text view's delegate (an object's delegate is automatically registered for its notifications), or register for General/NSTextDidChangeNotification in any other object and point it at a method of your own.

----
I spent time trying to get notifications to an General/NSTextField delegate using textDidChange, and it never worked. Then I tried adding
    (void) controlTextDidChange:(General/NSNotification *)notification
to my delegate and that was called for each keydown in the General/NSTextField. 
----

textDidChange is apparently a method General/NSTextField itself implements as delegate of a General/FieldEditor. controlTextDidChange is the way to go. See http://www.cocoadev.com/index.pl?General/NSTextFieldDelegate.