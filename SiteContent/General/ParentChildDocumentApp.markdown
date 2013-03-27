I'm trying to figure out how to get documents in a Doc-based app to have a parent child relationship.  In my project, I have a General/ProjectDoc and a General/TextDoc.  I want the General/ProjectDoc to be the parent of the General/TextDoc.

The problem is when I create a new General/TextDoc, I don't have a way for it to be able to find it's parent General/ProjectDoc.  When a new General/TextDoc is created, I want it to find current active General/ProjectDoc and become it's child.

The program is set up with the two Documents (General/ProjectDoc and General/TextDoc), two window controllers (General/MainWindowController, General/TextWindowController), and three NIB files (General/MainMenu, General/MainWindow, General/TextWindow).  The two controllers own the last two nibs.General/ProjectDoc keeps track of and creates all the General/NSWindowController objects.  It only adds the General/MainWindowController to itself though.  So General/MainWindowController is loaded with General/MainMenu.nib and General/TextWindowController is loaded with General/TextWindow.nib.  What I want is for any new General/TextDoc to look up the General/TextViewController for the current General/ProjectDoc and add the controller to the General/TextDoc.  The FAQ on General/NSDocument says that passing General/WindowControllers around is the way to get a file browser/inspector app which is part of what I'm doing.

Something I tried doing was having an outlet of General/NSWindow type in the General/TextWindowController which would point to the window in General/MainWindow.  From there I added some code in the makeWindowControllers method of General/TextDoc to create a temp windowController, use the outlet in that windowController to get the mainWindow in the General/MainWindow.nib, call on General/NSDocumentController's documentFromWindow to get the parent General/ProjectDoc, add the General/ParentDoc's General/TextWindowController to the General/TextDoc, and finally free up the temp variable.  That didn't work because the outlet from the controller to the window didn't work.  IB would allow me to make the connection, but then if I tried to open the nib in the same session, IB would just crash out.  If I opened the nib on a different session, it would revert the nib back to not having the outlet connected.  Is there something odd about having outlets from one nib file to another?

I was also thinking about calling General/NSApplication's mainWindow but I don't know what window that's going to return.  The doc says it returns the mainWindow to the application but I don't know what that is.

mark

----
I am not sure there is just one way to do it, so I won't go into a detailed idea of what I would do, but here are a couple of possibilities:

*use General/NSNotifications to let the General/ProjectDoc know about the new General/TextDoc
*use a General/NSApplication delegate
*look into General/NSDocumentController (subclass it?? is is worth it?)

Then figure out the rest, you will learn a lot...

Also, I really believe you cannot connect two objects in 2 separate nibs. I did not even know that IB would let you do that. --General/CharlesParnot

----
Perhaps your problem might be solved by rethinking your project's design, and what the various windows/documents are intended to achieve.

Are General/ProjectDocs and General/TextDocs genuinely different sorts of documents (ie: totally distinct, and independently-useful bundles of information)? Or are General/TextDocs merely subcomponents of a General/ProjectDoc, with no reason for existing outside their General/ProjectDoc?

Since you're talking about a parent-child relationship, it's probably not the first option, so I don't think you really need separate subclasses of General/NSDocument.

Instead, I suggest that only your General/ProjectDoc be a subclass of General/NSDocument, and that it have sole responsibility for managing:

*the usual functions of an General/NSDocument, like saving to disk, loading from disk and so on;
*the overall structure of the project (ie: how many General/TextDocs there are, what they're called, how they're arranged with respect to one another, etc); and
*internal access to the subcomponents of the project for other (specific) editing classes, namely General/TextDocs.

You could then refactor your General/TextDocs as General/NSWindowControllers. The advantage of this approach is that Cocoa's document-based architecture already allows for multiple General/NSWindowControllers to be attached to a single document dynamically (in the makeWindowControllers method, for example), and the window outlet in General/NSDocument itself allows you to keep track of the "main" window.

Cheers

Tom