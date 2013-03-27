

The architecture of General/DocumentBasedApplications:


* An General/NSDocumentController owns as many General/NSDocument objects as necessary for the currently running application.  General/NSDocumentController very rarely needs to be subclassed.

* Each General/NSDocument owns one or more General/NSWindowController objects.  General/DocumentOriented apps must have at least one General/NSDocument subclass.

* Each General/NSWindowController owns a single General/NSWindow.  General/NSWindowController objects are frequently subclassed, except in extremely simple apps.

* General/NSWindow usually does not need to be subclassed, if you are following the General/ModelViewController architecture.  Most important custom window behavior can be implemented by a delegate.


The default General/NSDocumentController creates instances of your General/NSDocument subclass in response to user actions, such as choosing File -> New from the menu.  General/NSDocumentController knows the name of your subclass from the "Document Types" settings in the "Application Settings" tab of General/ProjectBuilder's "Edit Active Target" pane.  The information in this pane ends up in your application bundle's Info.plist.  You need to define at least one Document Type, and set its General/NSDocumentClass to the name of your General/NSDocument subclass.

[add information about when documents and window controllers are released]

[add information about how a document creates its window controllers]

[add information about how a window controller loads a General/NibFile containing its window]

For more information on this topic refer to:

/Developer/Documentation/General/ReleaseNotes/General/NSDocumentFAQ.html

...and the reference page for General/NSDocument.

To add a page to the list below, create a new page and put the following anywhere within it (or add to an existing page):

    \\%\\%BEGINENTRY\\%\\%General/DocumentBasedApplications\\%\\%ENDENTRY\\%\\% 

You do **not** need to edit
*this* page.

Here are some pages that discuss matters related to General/DocumentBasedApplications.

[Topic]