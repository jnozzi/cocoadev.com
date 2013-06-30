With the term "inspector panel/palette" i mean singleton General/NSPanel window with it's General/NSWindowController, Nib, what is used represent some aspects of active General/NSSDocument subclass or just the window as seen in Photoshop (for example layers panel), Pages (Inspector) and so on. To create that shiny, shaddow casting panel, use the same technique as for other singleton windows+controller+nib packs (think "Preferences..." window).

Here I'll try to describe how i set up synchronizing the document window with inspector panel.

So, I assume you have 
* General/NSDocument subclass (i'll call it General/MyDocument) with one or more General/NSWindowController(s), 
* the General/InspectorController (General/NSWindowController) with it's Nib and General/NSPanel (or General/NSWindow) inside.
* in General/AppDelegate method for (lazy-)initializing and showing General/InspectorController's window

1) add something along those lines in General/MyDocument's General/NSWindow's delegate:
    
- (void)windowDidBecomeMain:(General/NSNotification *)notification
{
	General/[[NSNotificationCenter defaultCenter] postNotificationName:General/MyDocumentDidChangeNotification object:self];
}

- (void)windowWillClose:(General/NSNotification *)notification
{
	//not interested in not-active document close notifications as they are not related to inspector panel
	if(General/[[NSDocumentController sharedDocumentController] currentDocument] == self) {
		General/[[NSNotificationCenter defaultCenter] postNotificationName:General/MyDocumentWillChangeNotification object:self];
	}
}

This will send notifications whenever window becomes main and closes. Those notifications the Inspector will observe.

2) somewhere in inspector's General/NSWindowController's init method add observers to notifications:
    
General/[[NSNotificationCenter defaultCenter] addObserver:self 
   selector:@selector(documentDidChange:) name:General/MyDocumentDidChangeNotification object:nil];

General/[[NSNotificationCenter defaultCenter] addObserver:self 
   selector:@selector(documentWillChange:) name:General/MyDocumentWillChangeNotification object:nil];


and notification callbacks:
    
- (void)documentDidChange:(General/NSNotification *)notification
{
	General/MyDocument *document = [notification object];
	[self setTargetDocument:document];
}

- (void)documentWillChange:(General/NSNotification *)notification
{
	[self setTargetDocument:nil];
}


Some more info General/MakingNibsTalkToEachOther, General/HasPantherChangedHowToDoNibs

-- General/ArnisVuskans

----