

Handling [[NSToolbar]] controls in a [[CocoaBindings]] context is not documented well. Neither available examples nor top-level documentation offer much help.

In dealing with tables and their constituent arrays of objects,
the simple available examples rely on [[NSButton]] objects bound to the add: and remove: methods of the array controller, which can be managed in IB.

But when you try to use [[NSToolbar]], there are no view objects available in the interface, and you cannot use the Bindings pane of the IB object inspector. Here's what happens if you have a separate window controller object that is the delegate of the toolbar:

It is not terribly difficult to set up the appropriate toolbar items to use your array controller's methods to deal with adding and deleting objects in the array:

You simply implement something in the toolbar delegate category (in my case, on the document's window controller class) like:
 
<code>
- ( [[NSToolbarItem]] '' ) toolbar: ( [[NSToolbar]] '' ) toolbar
	itemForItemIdentifier: ( [[NSString]] '' ) itemIdentifier willBeInsertedIntoToolbar: ( BOOL ) flag
.
.
.
	if ( [ itemIdentifier isEqualToString: @"[[AddItem]]" ] )
	{
		[ item setLabel: [[NSLocalizedString]]( @"Add Item", nil ) ];
		[ item setPaletteLabel: [ item label ] ];
		[ item setImage: [ [[NSImage]] imageNamed: @"Add" ] ];
		[ item setTarget: myArrayController ];
		[ item setAction: @selector( add: ) ];
    }
</code>

So far, so good, assuming only that you make an outlet to the array controller instance in IB.

But WAIT! The <code>validateToolbarItem</code> method no longer polls a [[NSToolbarItem]] if its target has been re-set to the [[NSArrayController]] object!!
So the following boilerplate code in the window controller class no longer works:

<code>
- ( BOOL ) validateToolbarItem: ( [[NSToolbarItem]] '' ) theItem
{
	if ( [ theItem action ] == @selector( remove: ) )
		return [ myTableView numberOfSelectedRows ] > 0;
	else
		return true;
}
</code>

The documentation says:

''
A toolbar item with a valid target and action is enabled by default. To allow a toolbar item to be disabled in certain situations, a toolbar item�s target can implement the validateToolbarItem: method.

Note: The [[NSToolbarItem]] validate method calls this method only if the item�s target has a valid action defined on its target and if the item is not a custom view item. If you want to validate a custom view item, then you have to subclass [[NSToolbarItem]] and override validate.
''

Therefore, you must implement the toolbar item validation in the [[NSArrayController]] by subclassing it.
Just add the following method to your [[NSArrayController]] subclass

<code>
- ( BOOL ) validateToolbarItem: ( [[NSToolbarItem]] '' ) theItem
{
	if ( [ theItem action ] == @selector( remove: ) )
		return [ [ self selectedObjects ] count ] > 0;
	else
		return true;
}
</code>

Note that you only need to use properties of the array controller itself, rather than inquire of the table view if any of its rows are selected.

''
Small improvement: use -canRemove to validate the item.
''