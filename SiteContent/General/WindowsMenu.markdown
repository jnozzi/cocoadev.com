The [[WindowsMenu]] is a menu item that [[NSApplication]] automatically populates with the names of each onscreen [[NSWindow]] instance ([[NSPanels]] are not kept here).

Sometimes you might want to put permanent menu items for global windows, instead of or in addition to the document window menu items (similar to how iTunes and many other applications work). Add the menu items in IB, set their target to a suitable [[FirstResponder]] action, and use this code in your window controller (or window's delegate) to keep track of which window is active:

<code>
- (void)windowDidBecomeKey:([[NSNotification]] '')aNotification;
{
	[[NSEnumerator]] ''oe = [[[[[NSApp]] windowsMenu] itemArray] objectEnumerator];
	[[NSMenuItem]] ''item;
	SEL selector;
	
	while ( item = [oe nextObject] )
	{
		selector = [item action];
		[item setState:( selector == @selector( showEditor: ) ) ? [[NSOnState]] : [[NSOffState]]];
	}
}
</code>

Make sure to replace the @selector( showEditor: ) with an action method unique to your window controller. You could also use a tag instead. To keep a duplicate entry from being placed in the windows menu by [[NSApplication]], put this code in your windowDidLoad method:

<code>
[[[NSApp]] removeWindowsItem:[self window]];
[[self window] setExcludedFromWindowsMenu:YES];
</code>