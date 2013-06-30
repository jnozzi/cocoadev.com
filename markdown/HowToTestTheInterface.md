

When you are in Interface Builder you can always test your interface by selecting the "Test Interface" menu item of the "File" menu (or hit cmd-R).  This allows you to see if all the interface components are working like you hope.
To stop testing the interface: File>Quit General/NewApplication.

However, certain interface elements like General/NSTableView, General/NSView and General/NSPopUpButton need to have dynamic information placed into them by your application at runtime. Unless you instantiate a standard General/NSObjectController and/or General/NSArrayController and use the General/CocoaBindings system, you'll need to compile and run your application to test these.

Go back to General/HowToProgramInOSX