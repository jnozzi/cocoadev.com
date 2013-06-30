I want to change the action of the menu option "New Document" to call a method written by me. But I need my method to call the action assigned by Interface Builder and, after that, do other things. So I need to call the method "newDocument" of General/FirstResponder, but don't know how to get the first responder.

Thanks in Advance.

----
    
General/[NSApp sendAction:@selector(newDocument:) to:nil from:self];


See http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSApplication.html for more info.

--General/AllanOdgaard