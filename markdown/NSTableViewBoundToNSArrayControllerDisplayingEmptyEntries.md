Greetings, Everyone!

I'm having some difficulties using Panther's Controller layer with General/NSTableViews. I have a window with a table view in it, and an General/NSArray instance variable in the General/NSWindowController class. I have an General/NSArrayController instance accessing my instance variable, and I have bound the General/NSTableView to the General/NSArrayController via the content and selection indexes keys. It correctly loads the objects, however, when they are displayed, they appear empty. I can select these empty rows, but they appear nonexistent when deselected. It just looks like there is no text in the cell, even though the cell exists.  I have verified the existence of my strings in the instance variable, and all objects in the array instance variable are General/NSStrings, so I don't understand why this would be. Has anyone experienced similar difficulties, or can anyone offer a suggestion?

Thanks a bunch,
-- General/EliotSimcoe

----

Instead of linking the General/NSArrayController to an array instance variable, specify the object class that the array is going to hold (using IB Attributes). The controller will create and manage the array for you. After you specify the class, specify the class keys (variables/methods) so the controller knows how to access that class. After the keys are set you can set up each table column to a different key. Here's a tutorial which I suggest you take a look at:

http://developer.apple.com/documentation/Cocoa/Conceptual/General/ControllerLayer/Tasks/ccwithbindingsplus.html

Note: This tutorial is building on a previous tutorial which can be found here:

http://developer.apple.com/documentation/Cocoa/Conceptual/General/ControllerLayer/index.html

Hope that helps.

-- General/RyanBates

----

Typically, one would not bind the General/NSTableView to the General/NSArrayController directly. One would bind the "value" key of each General/NSTableColumn to the appropriate model path of the General/NSArrayController. For example, bind General/NSTableColumn's "value" binding to the General/NSArrayController's "name" model key path. �General/DustinVoss

----

To fix this problem, simply go into your tableColumns binding, and in the Null Placeholder, type something like (no title) or (untitled) or something, that will be displayed instead of the empty blank entries.