

I had a need to display an interface as either a sheet or a stand-alone window depending on the context it's used it.

However it seems that the window gets permanently modified when displayed as a sheet and will no longer display its titlebar (and associated window controls) when displayed as a window later.

So I decided instead to create (in IB) a blank window ("mySRwindow"), a blank panel ("[[SRWindowPanel]]") and a customView with the interface ("panelContentView") and switch in/out the view into the panel and window as needed.

I setup the code as follows:
<code>
When showing as window:

	// restores the view as needed and shows the window
	[mySRwindow setContentView:panelContentView];
	[mySRwindow makeKeyAndOrderFront:nil];

When showing as a sheet:
..
...
	[[[SRWindowPanel]] setContentView:panelContentView];
	[[[NSApp]] beginSheet:[[SRWindowPanel]] modalForWindow:[[[NSApp]] keyWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];

</code>

-Seb