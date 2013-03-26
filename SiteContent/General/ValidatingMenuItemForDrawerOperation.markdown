Does anybody know of a better way in a document-based app?

The only way I could figure out to do it for this simple example was (using [[NSNotificationCenter]]):

<code>
- ( void ) drawerStateChanged: ( [[NSNotification]] '' ) notif
{
	[[NSDrawerState]] st = [ controlsDrawer state ];
	id drawerMenuItem;
	
	if ( st == [[NSDrawerOpenState]] || st == [[NSDrawerOpeningState]] )
	{
		drawerMenuItem = [ [ [ [ [ [[NSApplication]] sharedApplication ] mainMenu ] 
			itemWithTitle: @"Window" ] submenu ] itemWithTitle: @"Open Drawer" ];
		[ drawerMenuItem setTitle: @"Close Controls Drawer" ];
	}
	else
	{
		drawerMenuItem = [ [ [ [ [ [[NSApplication]] sharedApplication ] mainMenu ] 
			itemWithTitle: @"Window" ] submenu ] itemWithTitle: @"Close Drawer" ];
		[ drawerMenuItem setTitle: @"Open Controls Drawer" ];
	}
}
</code>

----

Use something like

<code>

-(BOOL)validateMenuItem:([[NSMenuItem]] '')anItem
{
    if ( [ anItem action ] == @selector( toggleControlsDrawer: ) ) 
    {
        if ([controlsDrawer state] == [[NSDrawerOpenState]] ||
              [controlsDrawer state] == [[NSDrawerOpeningState]])
        {
            [anItem setTitle:@"Close Controls Drawer"];
        else
        {
            [anItem setTitle:@"Open Controls Drawer"];
        }
    }

    return YES; //or do other stuff here to enable/disable items
}

</code>