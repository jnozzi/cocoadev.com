

I would like to create a custom General/NSOutlineView where I would control the look of the items but I don't know where to start to accomplish this. Also, can I use a custom General/NSView as an item? Where can I find some info/tutorial/code sample to learn how to do this? Do I have to create my own custom view or I can start with General/NSOutlineView and tell it how to display its items?

----

Subclass General/NSCell, override its drawWithFrame method to do your custom drawing, and do a setDataCell on the table column in which you want the custom cell to be located.

-General/TylerStromberg

----

Do I need to set a General/NSCell for every item? If so, where/when do I use setDataCell?

----

You should call setDataCell: on the General/NSTableColumn which you want to modify. General/NSTableView (and therefore General/NSOutlineView as well) uses a single General/NSCell to draw each row in a column. So, you just have to give the column in question an instance of the General/NSCell you want it to use. You can access the relavent table column using:

    
General/NSTableColumn *column = General/outlineView tableColumns] objectAtIndex:0] // or whatever index you need

or, you can use:
    
[[NSTableColumn *column = [outlineView tableColumnWithIdentifier:@"yourIdentifierHere"]; // change the identifier appropriately


I hope that helps!

- General/MattBall