http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Miscellaneous/AppKit_Functions/Reference/reference.html#//apple_ref/c/func/General/NSRunAlertPanel
(http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Functions/General/AppKitFunctions.html) is also dead
(http://developer.apple.com/techpubs/macosx/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Functions/General/AppKitFunctions.html) is dead


General/NSRunAlertPanel
This function creates an attention panel. 

int General/NSRunAlertPanel(General/NSString *title, General/NSString *msg, General/NSString *defaultButton, General/NSString *alternateButton, General/NSString *otherButton, ...)

Returns :

* General/NSAlertDefaultReturn
* General/NSAlertAlternateReturn
* General/NSAlertOtherReturn


Creates an attention panel that alerts the user to some consequence of a requested action; the panel may also let the user cancel or modify the action. General/NSRunAlertPanel runs the panel in a modal event loop.

The first argument is the title of the panel, which should be at most a few words long. The default title is "Alert". The next argument is the message that's displayed in the panel. It can use printf-style formatting characters; any necessary arguments should be listed at the end of the function's argument list (after the otherButton argument). For more information on formatting characters, see the man page for printf.

There are arguments to supply titles for up to three buttons, which will be displayed in a row across the bottom of the panel. The panel created by General/NSRunAlertPanel must have at least one button, which will have the symbol for the Return key; if you pass a nil title to the other two buttons, they won't be created. If nil is passed as the defaultButton, "OK" will be used as its title.

General/NSRunAlertPanel not only creates the panel, it puts the panel on screen and runs it using the runModalFor: method defined in the General/NSApplication class. This method sets up a modal event loop that causes the panel to remain on screen until the user clicks one of its buttons. General/NSRunAlertPanel then removes the panel from the screen list and returns a value that indicates which of the three buttons the user clicked: General/NSAlertDefaultReturn, General/NSAlertAlternateReturn, or General/NSAlertOtherReturn. (If an error occurred while creating the panel, General/NSAlertErrorReturn is returned.) For efficiency, General/NSRunAlertPanel creates the panel the first time it's called and reuses it on subsequent calls, reconfiguring it if necessary. 
------------------------------------------------------------------------

----

See General/NSAlert. [http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSAlert.html]

*The General/NSAlert class, which was introduced in Mac OS X v10.3, supersedes the functional Application Kit API for displaying alerts (General/NSRunAlertPanel, General/NSBeginAlertSheet, and so on). The former API is still supported, but you are encouraged to use the General/NSAlert class for your application�s alert dialogs.*