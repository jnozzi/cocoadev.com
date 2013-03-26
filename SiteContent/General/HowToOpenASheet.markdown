To open a sheet you need to have two things, the window the sheet will be attached to and the window that's the sheet's contents.

To open the sheet:
<code>
[[[NSApp]] beginSheet:aSheet
         modalForWindow:aWindow
         modalDelegate:aWindow
         didEndSelector:nil
         contextInfo:nil];
</code>

Where aSheet is the sheet you want to display and aWindow is the window it will be attached to.

To close the sheet:
<code>
[[[NSApp]] endSheet:aSheet];
[aSheet orderOut:nil];
</code>

Where aSheet is the sheet.

The usage of sheets is described in Mac OS X Human Interface Guidelines.

-- [[MatPeterson]]