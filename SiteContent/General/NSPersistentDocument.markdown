

General/NSPersistentDocument Core Data Tutorial - [http://developer.apple.com/documentation/Cocoa/Conceptual/General/NSPersistentDocumentTutorial/index.html]

----
**Questions**

How do I obtain a reference to the owner General/NSPersistentDocument from an entity? For instance, if I have an entity called "Foo" that, when a specific condition exists, has to notify the document itself so some action can be taken. How do I obtain the reference? http://goo.gl/General/OeSCu

----
There is no way to go directly from an entity or a managed object (which is probably what you're referring to when you say "entity" above) to an General/NSPersistentDocument.  In some ways, that's sort of like asking how to go from an General/NSObject or an General/NSArray to an General/NSDocument; they exist at different levels of abstraction.  What are you actually trying to accomplish?

----
I'm not the original poster, but I'm having a similar problem. Say I've got an Core Data document based application. I know that when my program starts, I begin with an instance of General/NSPersistentDocument, with which I can access the document's managed object context using the call [self managedObjectContext]. Now, suppose I've got another object, called General/FolderWatchdog, which gets assigned a folder and is supposed to index its contents, keep track of a few attributes, and watch for changes. It's this object, which is created by my General/NSPersistentDocument instance, that I want to be in charge of all the General/CoreData backend stuff.

From within the General/FolderWatchdog object, what is the best way to get and keep a reference to the managed object context of its owning General/NSPersistentDocument? Right now, I'm passing it with my General/FolderWatchdog's initialization message, which I call after an event trigger from my General/NSPersistentDocument. This works, and I suspect that this is what the original poster was trying to accomplish, but it seems to me like I'm doing this poorly. Should I be organizing things differently?

-peter


----
Hi, not an answer but my question seems related if anyone can help. I have an General/NSManagedObject that has a (transient) property to return the result of a fetch request. What I essentially want is something like Mail whereby the number of unread messages is indicated in an General/NSTableColumn. Using a single-document app I would just access General/[[NSApp delegate] managedObjectContext]. However, I have found the only equivalent in a document-based app to be [self managedObjectContext] where self references the General/NSManagedObject. However, when I use this and run a fetch request against this context, nothing is returned. Despite the poor method of loading the General/NSManagedObjectModel (see code, anyone know an alternative?) it does appear to load correctly.

Here's the code:

    
- (General/NSArray *)unreadMessages {
	General/NSManagedObjectContext*	managedObjectContext	= [self managedObjectContext];  //theoretically equivalent to General/[[NSApp delegate] managedObjectContext]
	General/NSManagedObjectModel* model				= General/[NSManagedObjectModel mergedModelFromBundles:nil]; //bad way of getting model; is there an alternative?
	
	General/NSDictionary * entities = [model entitiesByName];
	
	General/NSPredicate * predicate;
	predicate = General/[NSPredicate predicateWithFormat:@"messageDate > %@", dateInFuture]; //dateInFuture is an General/NSDate
	
	General/NSFetchRequest * fetch = General/[[NSFetchRequest alloc] init];
	General/NSSortDescriptor* sort = General/[[NSSortDescriptor alloc] initWithKey:@"messageTitle" ascending:YES];
	General/NSArray * sortDescriptors = General/[NSArray arrayWithObject: sort];
	
	[fetch setEntity: [entities valueForKey:@"Message" ]];	
	[fetch setPredicate: predicate];
	[fetch setSortDescriptors:sortDescriptors];
	
	General/NSArray * results = [managedObjectContext executeFetchRequest:fetch
											error:nil];

	[sort release];
	[fetch release];
	
	return results;     //number of unread messages can be counted using unreadMessages.@count in binding
}


Any help or advice would be greatly appreciated!
- Chris

----
*
Answered my own question here. It seems you can forego the General/NSManagedObjectModel althogether using the General/[NSEntityDescriptin entityForName:inManagedObjectContext].  Will leave this post here in case it is of use to anyone else
- Chris

    
// Fetch the document settings
	General/NSEntityDescription* entity	= General/[NSEntityDescription entityForName:@"General/DocumentSettings"
											  inManagedObjectContext:managedObjectContext];
	
	General/NSFetchRequest * fetch = General/[[NSFetchRequest alloc] init];
	
	[fetch setEntity: entity];
	General/NSError*	err	= General/[[NSError alloc] init];
	
	General/NSArray * results = [managedObjectContext executeFetchRequest:fetch
															error:&err];
	
	[fetch release];
	[err release];
	...

*

----

Don't know if this is the right place to ask that question, and I'd be glad to move it to a better place. Anyway : I'm building a coredata application, thanks to Interface Builder it is quite easy. I use a General/NSPersistentDocument as the main controller. But, when I launched the app, I want the last open document to be open, instead of new one. I've searched the Internet and cocoadev.com unsuccessfully...

Does anyone know about that ?

----

I use this, which works well for me.

    
    if (General/preferences valueForKey:@"[[ReopenRecentProject"] intValue] && General/[[[NSDocumentController sharedDocumentController] recentDocumentURLs] count] > 0)
    {
		if (General/[[[NSDocumentController sharedDocumentController] recentDocumentURLs] count] > 0 && General/[[NSFileManager defaultManager] fileExistsAtPath:General/[[[[NSDocumentController sharedDocumentController] recentDocumentURLs] objectAtIndex:0] path]])
			General/[[NSDocumentController sharedDocumentController] openDocumentWithContentsOfFile:General/[[[[NSDocumentController sharedDocumentController] recentDocumentURLs] objectAtIndex:0] path] display:YES];
    }


It checks the user prefs to see if the user wants the recent doc opened. If so, it looks in the document controller's recentDocumentURLs to see if there are any, if so, it grabs the top one and opens it if it exists. There's probably a better way, but this way has worked in a shipping app for two years. :-) Place it in your app delegate's     -applicationDidFinishLaunching: method somewhere.

----
General/OpeningLastDocumentAsDefault

This one took a while to get working properly. Basically I just created an General/NSObject in my interface builder General/MainMenu.nib called General/AppController and then made an instance of that the "delegate of File's Owner" Then I created the files for that class and put the following in that implementation file:

    
- (BOOL)applicationShouldOpenUntitledFile:(General/NSApplication *)theApplication
{
	NSURL * theURL = General/[[[NSDocumentController sharedDocumentController] recentDocumentURLs] objectAtIndex:0];
	General/NSError * outError;
	General/[[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:theURL display:YES error:outError];
    return NO;
}


You could easily drop in the preferences check or whatever and this seems to work pretty well. Note that the preferences in the previous example didn't discuss the how of creating the preferences object referenced, so I'm not doing that yet. If I figure that out I'll post it.
----
I think above method will open last opened document whenever the cmd+n is pressed.
----
Tested - cmd-n does not cause applicationShouldOpenUntitledFile to be called. -Kurt
----
Check for an empty recent file list! Jean-Nicolas
    

- (BOOL)applicationShouldOpenUntitledFile:(General/NSApplication *)theApplication
{
	
    General/NSArray* recentDocs = General/[[NSDocumentController sharedDocumentController] recentDocumentURLs] ;
   
    if ([recentDocs count]) {
        NSURL * theURL = [recentDocs objectAtIndex:0];
        General/NSError ** outError;
        General/[[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:theURL display:YES error:outError];
        return NO;
    } else 
        return YES;
}
