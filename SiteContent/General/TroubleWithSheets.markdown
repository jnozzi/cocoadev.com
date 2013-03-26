In the console when I try to invoke a sheet I get this warning:

2004-09-21 19:57:19.285 [[HarborMaster]][26862] ''''' -[[[NSView]] _setSheet:]: selector not recognized
2004-09-21 19:57:19.286 [[HarborMaster]][26862] ''''' -[[[NSView]] _setSheet:]: selector not recognized


What's wrong? The code I used:

<code>- ([[IBAction]])addItem:(id)sender
{
        [[[NSApp]] beginSheet: addSheet
                        modalForWindow: mainWindow
					
                        modalDelegate: self
                        didEndSelector: @selector(sheetDidEnd: returnCode: contextInfo:)
                        contextInfo: nil];}
</code>

----

Haha, nevermind - turns out I had addSheet connected to an [[NSSearchField]] instead of my [[NSPanel]].