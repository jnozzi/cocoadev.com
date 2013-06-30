

Hi all,
I need to get from my General/NSApp the document controller because I need to create new documents programmatically (method -newDocument:): any idea (I can get the key window, but a window can't even give me its document :( )?...
Thx -- peacha

PS: Shouldn't there be a General/CocoaQuestions among the links at (at or on?) the home page and... couldn't we use the content found in General/CocoaSampleCode and General/CocoaDiscussions to make some tutorials like O' Reilly Net or Vermont Recipes???

----

Hi Peacha.

You can send the message     + sharedDocumentController to the class object for General/NSDocumentController to get what you want:
    
General/NSDocumentController *theDocumentController = General/[NSDocumentController sharedDocumentController];

// Now go wild.


Here's what the docs have to say about it:

**sharedDocumentController**

    + (id)**sharedDocumentController**

Returns the shared General/NSDocumentController instance. If one doesn't exist yet, it is created. Initialization reads in the document types from the General/NSTypes property list (in General/CustomInfo.plist), registers the instance for General/NSWorkspaceWillPowerOffNotifications, and turns on the flag indicating that document user interfaces should be visible. You should always obtain your application's General/NSDocumentController using this method.

See Also:     - setShouldCreateUI:

-- General/MichaelMcCracken