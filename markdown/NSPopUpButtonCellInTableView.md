Hi,

I am using General/XCode and I have some problems putting General/NSPopUpButtonCell in talbe view. I've used Interface Builder to set one of my columns data cell to General/NSPopUpButtonCell. Then in tables view data source method tableView:objectValueForTableColumn:row: I return General/NSPopUpButtonCell initialiazed using initTextCell:pullsDown:. I add few items to it. Unfortunately when I launch my program all General/NSPopUpButtonCells are emtpy. What could be wrong???

----

For one thing, -tableView:objectValueForTableColumn:row: doesn't want you to return a cell, it wants something like an General/NSString or General/NSNumber instance.

That said, I've had problems with General/NSPopUpButtonCell in a table view too; I can't seem to set its title.

-- General/RobRix

----

To use an General/NSPopUpButtonCell in a table view:

1) Set the column's data cell to an General/NSPopUpButtonCell by dragging an General/NSPopUpButtonCell from the Data palette onto the column header of the column you want to be a popup button.  Note that column headers must be visible for this to work (on the attributes inspector for the General/NSTableView, make sure display -> Column Headers is checked)

2) Instantiate an General/NSMenu by going to the Classes tab of the *.nib window, finding General/NSMenu, and then select "Instantiate General/NSMenu" in the Classes menu.  (Alternately, press Option-Open Apple-I)

3) Double click on the General/NSMenu instance in the instances tab of the *.nib window.  This will create a tiny window, into which you can drag General/NSMenuItem instances from the Menus palette.  The window size will expand as items are placed inside.  You can then manipulate this menu like any other.

4) Select the General/NSPopUpButtonCell.  It will appear as a small triangle in the upper right corner of the column header.  (Remember, the column headers still need to be visible; they can be set to invisible after all this is done).  Then control drag to the General/NSMenu instance--either the instances menu of the *.nib window, or the titlebar of the window that displays the menu contents.  Set the "menu" outlet of the General/NSPopUpButtonCell to your General/NSMenu instance.

There!  It's done!

Also keep in mind that the -tableView:objectValueForTableColumn:row: and -tableView:setObjectValue:forTableColumn:row: both expect and return (respectively) General/NSNumber instances which correspond to which # menu item is to be, or was, selected.