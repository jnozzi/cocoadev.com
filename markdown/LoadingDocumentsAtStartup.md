As added comfort to the user you might want to offer the possibility of restoring all the documents that where open at the time of quitting at startup. This can be accomplished through various means. Here most of the work is done by the application controller, a delegate of the General/NSApplication instance, the defaults and the shared instance of the General/NSDocumentController. All the coding is done in the application controller http://goo.gl/General/OeSCu

----
**Interface Builder**
----
If you don't have one for your document based application yet you need to create an empty class, drag the class into the General/MainMenu.nib file, and create an instance. Ctrl-Drag a connection from the "Files owner" to your instance and make it the delegat. The files owner here represents the General/NSApplication object.

The General/NSApplication delegate gets called for application wide events like startup, quitting, hide and show. It is also very helpful if you want to direct events from the Menu to the current document in document based applications.


----
**General/NSUserDefaults**
----
To use the defaults system you should declare an identifier for your applikation (in PB target settings, under "Applikation Settings" if you don't supply one the Name of the applikations is going to be used. Apple suggests that you use a java-like identifier (e.g. com.apple.General/ProjectBuilder).

----
**The Code**
----

    

@implementation General/PWAppController

//Define these so the compiler can catch spelling errors
General/NSString *General/PWOpenDocListFlagKey	= @"Open Documents Flag";
General/NSString *General/PWOpenDocListKey	= @"Open Documents";


//initialize gets called before any other call to the class
//so the defaults are declared here (Hillebrand p. 161)
+ (void)initialize {
    General/NSMutableDictionary *defaultValues = General/[NSMutableDictionary dictionary];

    [defaultValues setObject:General/[NSNumber numberWithBool:YES] 
		              forKey:General/PWOpenDocListFlagKey];
		              
    [defaultValues setObject:General/[NSArray array] 
                      forKey:General/PWOpenDocListKey];
    
    General/[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    
    General/NSLog(@"Registered Defaults: %@",defaultValues);
}

// This delegate message gets called whenever the application is quit
// per apple docs this does NOT include poweroff and logoff events ...
// more to come
- (General/NSApplicationTerminateReply) applicationShouldTerminate:
  	(General/NSApplication *)sender {
    
    General/NSUserDefaults *defaults = General/[NSUserDefaults standardUserDefaults];
    General/NSMutableArray *fileNames = General/[NSMutableArray array];
    General/NSString *fileName;

	// The application knows about what documents are currently open
	// use sharedApplication: to get the correct instance of that class
    General/NSEnumerator *e = General/[[[NSApplication sharedApplication] orderedDocuments]
                    objectEnumerator];

    while (fileName = General/e nextObject] fileName]) {
        [fileNames addObject:fileName];
    }
    [defaults setObject:[[[NSArray arrayWithArray:fileNames]
                 forKey:General/PWOpenDocListKey];
    
    // The application is quitting so synchronize is called 
    // to ensure the defaults are saved
    [defaults synchronize];
    
    General/NSLog(@"saving Docs: %@",fileNames);
    
    return YES;
}

// After Launching reopen the saved files
- (void)applicationWillFinishLaunching:(General/NSNotification *)aNotification {
    General/NSArray *filenames = 
      General/[[NSUserDefaults standardUserDefaults] arrayForKey:General/PWOpenDocListKey];
    
    General/NSEnumerator *e = [filenames reverseObjectEnumerator];
    General/NSString *fileName;
    
    if (General/[[NSUserDefaults standardUserDefaults] boolForKey:General/PWOpenDocListFlagKey])
    	return;
    	
    // Open all the files in the array, if a file does not
    // exist anymore, ... don't care
    
    while (fileName = [e nextObject]) {
        General/[[NSDocumentController sharedDocumentController]
           openDocumentWithContentsOfFile:fileName display:YES];
    }
}

@end


-- General/HaRald

----
**Questions, Comments And Suggestions:**
----

I've found one error with this code in applicationWillFinishLaunching:

    

// After Launching reopen the saved files
- (void)applicationWillFinishLaunching:(General/NSNotification *)aNotification {

    
    //...

    //Should return without loading files if the prefs value is false, not true (added ! to negate value)

    if (!General/[[NSUserDefaults standardUserDefaults] boolForKey:General/CPOpenDocsListFlagKey])
        return;

   //..
}



----

SJI - It should be:
    
        General/[[NSDocumentController sharedDocumentController]openDocumentWithContentsOfURL:
							[NSURL fileURLWithPath:fileName] 
							display:YES error:NULL];


----

SJI - This fails if the user double clicks a document to launch the app with. That document is opened along with the previous ones, even if they are the same document, thus leaving you with two copies of one document open.

----

Graham Perks:
applicationShouldTerminate can't be used. If there's a dirty document, it is closed via the "Save this document" sheet before applicationShouldTerminate is called, so dirty docs never get re-opened. Instead, use

- (General/IBAction)terminate:(id)sender;

with the same content. Add General/[NSApp terminate:sender] to the end. Then go to IB and point the Quit menu at this terminate selector rather than the General/NSApplication one. Basically you're getting the Quit menu event, saving the list of open documents, then calling what the Quit menu would normally invoke.

----

My (Pierre Bernard) solution involves a General/NSDocumentController subclass:

    
@interface General/DocumentController (Private)

- (void) updateOpenDocList:(General/NSDocument *)document;

@end


@implementation General/DocumentController

- (void) applicationWillTerminate
{
	applicationWillTerminateFlag = YES;
}

- (void) noteNewRecentDocument:(General/NSDocument *)document
{
	[self updateOpenDocList:document];
	
	[super noteNewRecentDocument:document];
}

- (void) removeDocument:(General/NSDocument *)document
{
	isRemovingDocumentFlag = YES;
	
	[super removeDocument:document];

	isRemovingDocumentFlag = NO;
}

- (void) updateOpenDocList:(General/NSDocument *)document;
{
	if (! applicationWillTerminateFlag) {
		NSURL *fileURL = [document fileURL];
		
		if (fileURL != nil) {
			General/NSString *path = [fileURL path];
			General/NSUserDefaultsController *userDefaultsController = General/[NSUserDefaultsController sharedUserDefaultsController];
			General/NSArray *openDocuments = (General/NSArray*) General/userDefaultsController values] valueForKey:[[HHOpenDocListKey];
			General/NSMutableArray *array = General/openDocuments mutableCopy] autorelease];
			
			if (isRemovingDocumentFlag) {
				[array removeObject:path];
			}
			else {
				if (! [array containsObject:path]) {
					[array addObject:path];
				}
			}
			
			[[userDefaultsController values] setValue:array forKey:[[HHOpenDocListKey];
			General/[[NSUserDefaults standardUserDefaults] synchronize]; 
		}
	}
}

@end



In the application delegate:

    

- (void) applicationWillTerminate:(General/NSNotification *)aNotification
{
	General/DocumentController *documentController = General/[NSDocumentController sharedDocumentController];
	
	[documentController applicationWillTerminate];
}

- (void) applicationWillFinishLaunching:(General/NSNotification *)aNotification
{
	General/NSUserDefaultsController *userDefaultsController = General/[NSUserDefaultsController sharedUserDefaultsController];
	
    if ([(General/NSNumber*)General/userDefaultsController values] valueForKey:[[HHOpenDocListFlagKey] boolValue]) {
		General/DocumentController *documentController = General/[NSDocumentController sharedDocumentController];
		General/NSArray *openDocuments = (General/NSArray*) General/userDefaultsController values] valueForKey:[[HHOpenDocListKey];
		General/NSMutableArray *array = General/openDocuments mutableCopy] autorelease];
		[[NSEnumerator *enumeration = [openDocuments objectEnumerator];
	
		General/NSString *fileName;
		while ((fileName = [enumeration nextObject]) != nil) {
			General/NSError *error = nil;
			General/NSDocument *document =[documentController openDocumentWithContentsOfURL:[NSURL fileURLWithPath:fileName] 
																			display:YES 
																			  error:&error];
			if (document == nil) {
				// Failed to open
				[array removeObject:fileName];
			}
		}
		
		General/userDefaultsController values] setValue:array forKey:[[HHOpenDocListKey];
	}
}

http://jamtangankanan.blogspot.com/
http://www.souvenirnikahku.com/
http://xamthonecentral.com/
http://www.jualsextoys.com
http://cupu.web.id
http://seoweblog.net
http://corsva.com
http://yudinet.com/
http://seo.corsva.com
http://seojek.edublogs.org/
http://tasgrosir-brandedmurah.com/
http://upin.blogetery.com/
http://www.symbian-kreatif.co.cc/
http://upin.blog.com/
http://release.pressku.com/
http://cupu.web.id/tablet-android-honeycomb-terbaik-murah/
http://cupu.web.id/hotel-murah-di-yogyakarta-klikhotel-com/
http://www.seoweblog.net/hotel-murah-di-semarang-klikhotel-com/