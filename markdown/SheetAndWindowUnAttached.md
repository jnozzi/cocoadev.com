I have a document based application.  When it runs, a main menu window comes up with a few options for the user (New, Load, Quit, etc.)  I want the user to define a few properties everytime a new document is created (whether it is done from the File Menu or the actually window).  So what I have is a sheet that is displayed from an General/NSPanel from the General/MyDocument nib file.  I display this sheet in the:

- (void)windowControllerDidLoadNib:(General/NSWindowController *) aController

method of General/MyDocument.h using:

General/[NSApp beginSheet:newStudioPanel modalForWindow:mainWindow
modalDelegate:self
didEndSelector:NULL
contextInfo:nil];

newStudioPanel being the General/NSPanel and the mainWindow being the General/NSWindow of the Document.

When I create a new Document, the document window (mainWindow) appears, and the sheet comes up but not as a sheet for the window.  It isn't attached, but behind the document window.

---

I have this problem, too

I have found http://www.pnelsoncomposer.com/writings/General/NewbieFAQ.html , see section 20
----
See the example at http://www.stepwise.com/Articles/2006/eb1/index.html