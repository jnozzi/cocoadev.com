Am I misunderstanding how validateToolbarItem gets called? The items are still connected to actions but the items don't get disabled!! 

<code>
- (BOOL)validateToolbarItem:([[NSToolbarItem]] '')theItem
{
    if ([[findField stringValue] isEqualToString:@""])
      {
	[[NSArray]] ''itemsToDisable = [[[NSArray]] arrayWithObjects:@"[[FindNext]]",@"[[FindPrevious]]",@"[[FindAll]]",NULL];

	return ![itemsToDisable containsObject:[theItem itemIdentifier]];
      }
    return YES;
}
</code>

'''[[NSToolbarItem]] addresses this, namely "...it is sent to the item's target, NOT to the toolbar delegate."'''

Moving the method to my items' target got it working.

----

'''Validating toolbar items with [[NSFontManager]]'''

I've created a few toolbar items that target a standard [[NSFontManager]] and I can't validate them. Subclassing didn't seem to work.

To validate these toolbar items I need to get the number of selected rows from a tableView (IB Outlet).

 -- [[GarrettMurray]]

----

Same problem as the opener. Just create your own controller class and target that from the toolbar, passing messages to [[NSFontManager]] as appropriate

''solved'' --[[GarrettMurray]]

----

You can use interface validation to change properties of toolbar items on the fly, as it were; see [[ChangeToolbarItemProperties]]