

**Question**: It's been almost a year since this page was updated. The docs now state:
"Note that General/NSPersistentDocument does not support some standard document behavior, in particular General/NSPersistentDocument does not support file wrappers."
(http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSPersistentDocument.html)

Does this mean it's impossible to use file wrappers, or just that a little extra work is needed? Has anyone done this successfully?

----

I have a Core Data document-based application I'm working on. I'd like to have it save and retrieve its data as a package. I've already checked the "Package" checkbox in the target's settings for my file type (I have a custom extension defined, etc) saved as an XML store type. This all works just fine (even with 'package') checked as-is, right out of the box. That is, it saves and opens the data (which is still saved as a regular file - the package checkbox is apparently ignored).

The goal, obviously, is to modify my project to save the applicaton's data file as a package and load the main data from an XML file within the package. Say:     /Users/me/My File.myext/General/ProjectData.xml - any extraneous supporting files get stored under the package's ./Content folder.

The basic steps as I see them, according to the documentation, are simple:


*Define a file type for your main package file format in your target, check the 'Package' checkbox.
*In the General/NSPersistentDocument subclass, override     - (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)url ofType:(General/NSString *)fileType error:(General/NSError **)error and modify the URL file path to append "/General/ProjectData.xml" (or whatever), then pass the modified URL to super. *** See code example**


----
**Relevant Documentation**

From: http://developer.apple.com/releasenotes/Cocoa/General/AppKit.html

'File package support (where potentially multiple persistent stores are inside a file wrapper) is left to subclasses where managing different stores can be done by hand through the coordinator.'

From: http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSPersistentDocument.html#//apple_ref/doc/uid/TP30001179-CJBCBBCB

- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)url ofType:(General/NSString *)fileType error:(General/NSError **)error

*"You can override this method to customize creation of a persistent store for a given document or store type. In a subclass of General/NSPersistentDocument, this also allow you to access store files inside a file wrapper by appending path information to the URL and then invoking the superclass?� method."*

----

The     -(BOOL)configurePersistentStoreCoordinatorForURL:ofType:error: method should be overridden as follows (as a basic example):

    
- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)url 
        ofType:(General/NSString *)fileType error:(General/NSError **)error
{
	// Append persistent store path to url
	NSURL * storePath = [NSURL fileURLWithPath:General/url path] 
                            stringByAppendingPathComponent:@"[[ProjectData.xml"]];
	
	// Pass storePath to super, return result
	return [super configurePersistentStoreCoordinatorForURL:storePath 
                            ofType:fileType error:error];
}


According to the documentation, the above should work. The problem is that when you save, you get the following error:     "The document "Untitled" could not be saved as "Test 1.myext". Invalid file name.".

----

**Update** - Evidently, according to this post [ http://www.cocoabuilder.com/archive/message/cocoa/2005/5/24/136816 ], there is an unspecified problem with Core Data and packages / bundles. This is apparently a 'known issue', but little is 'known' about it publicly beyond that. Peachy. According to Mmalcolm Crawford on the cocoa-dev mailing list, "... the way that General/NSDocument works and the way General/NSPersistentDocument wants to work such that you should not expect to be able to create an application based on General/NSPersistentDocument that uses file wrappers."

Hopefully more information about this will be forthcoming soon - this is a huge deal-breaker for my using Core Data for this otherwise perfectly suited project.

----

I tried something that seems to work for me when I created a new test project to play around with this, though there may be other issues that I'm overlooking...

    

- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)url 
        ofType:(General/NSString *)fileType error:(General/NSError **)error
{
	// Append persistent store path to url
	General/NSString * filePath = General/url path] stringByAppendingPathComponent:@"[[ProjectData.cdtpack"];
	BOOL isDir;
	if (!General/[[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:&isDir] && isDir) {
		General/[[NSFileManager defaultManager] createDirectoryAtPath:[url path] attributes:nil];
	}
	
	NSURL * storeURL = [NSURL fileURLWithPath:filePath];
	
	// Pass storePath to super, return result
	return [super configurePersistentStoreCoordinatorForURL:storeURL 
                            ofType:fileType error:error];
}



I didn't override anything else, other than changing my Info.plist:

    

<key>General/CFBundleDocumentTypes</key>
	<array>
		<dict>
			<key>General/CFBundleTypeExtensions</key>
			<array>
				<string>cdtpack</string>
			</array>
			<key>General/CFBundleTypeMIMETypes</key>
			<array>
				<string>application/octet-stream</string>
			</array>
			<key>General/CFBundleTypeName</key>
			<string>cdtpack</string>
			<key>General/CFBundleTypeRole</key>
			<string>Editor</string>
			<key>General/LSTypeIsPackage</key>
			<true/>
			<key>General/NSDocumentClass</key>
			<string>General/MyDocument</string>
			<key>General/NSPersistentStoreTypeKey</key>
			<string>XML</string>
		</dict>
	</array>



Anything that I'm missing, or would this actually, possibly work??

Update: I've been playing with the files that my example app generated, and it's kind of funny; these two things happen:

1. Both the package (the directory) and the file inside (actual data) are stored with the same extension.
2. Attempting to open the file inside the package with the app will fail. If you delete that file, then the package will fail... so you have to have both.

The "General/ProjectData" file can go without an extension, or a different extension, but the first time I tried it, it wouldn't work. Now it does. Weird.

I'm hoping that I'll be able to add saving methods for adding a folder or two and putting the files and other resources in it. Let me know if there are any other issues.

----

What makes you think that if Apple engineers themselves aren't able to get this working correctly (so much so that they later state outright that it's broken) that you're going to be able to fix it with a few lines of code? The problems you're describing sound like "an unspecified problem with Core Data and packages" to me ... If they're saying it can't be done because support for this is broken, nobody's going to be able to explain or help you with any problems you encounter trying to get it to work.

----

If you'd actually READ what I wrote, you'd notice that I didn't say those were problems; I was simply pointing out observations I had made, like an experiment; merely vocalizing what I've found. Even if Apple's engineers say it "won't work", there are a number of people who would like to see such functionality work. Considering that I did nothing to spite you, what's prompting your angry tone??

----

Found some information in a Ruby Cocoa blog.


*http://acaro.wordpress.com/2007/07/09/packages-and-core-data-documents/
*http://acaro.wordpress.com/2007/07/19/core-data-persistent-packages-revisited/


The analysis made by the author is pretty much what most of us have done.  The solution looks quite complete and well thought.  People commenting there found the solution there useful as well.

-- General/BillSo

----

Has anyone tested to see if this works as originally advertised in Leopard?


----
I wrote this code: a  direct subclass of General/NSDocument, not General/NSPersistentDocument.
Masa http://www.oneriver.jp

    
//
//  General/MyDocument.h
//  General/CoreDataDocument
//
//  Created by Masatoshi Nishikata on 07/12/22.
//  Copyright __MyCompanyName__ 2007 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface General/MyDocument : General/NSDocument
{
	General/NSPersistentStoreCoordinator *persistentStoreCoordinator;
    General/NSManagedObjectModel *managedObjectModel;
    General/NSManagedObjectContext *managedObjectContext;
	
	NSURL* persistentStoreURL;
}
- (id)init;
- (General/NSString *)windowNibName;
- (void)windowControllerDidLoadNib:(General/NSWindowController *) aController;
- (General/NSData *)dataRepresentationOfType:(General/NSString *)aType;
- (BOOL)loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)aType;
- (General/NSManagedObjectModel *)managedObjectModel ;
- (General/NSPersistentStoreCoordinator *) persistentStoreCoordinator ;
- (General/NSManagedObjectContext *) managedObjectContext ;
-(NSURL*)xmlURLInPackage:(NSURL*)packageURL;
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(General/NSString *)typeName error:(General/NSError **)outError;
- (void)saveToURL:(NSURL *)absoluteURL ofType:(General/NSString *)typeName forSaveOperation:(General/NSSaveOperationType)saveOperation delegate:(id)delegate didSaveSelector:(SEL)didSaveSelector contextInfo:(void *)contextInfo;
-(void)clearDirtyStateForURL:(NSURL*)url;
- (void)setMetadataValue:(id)value forKey:(General/NSString*)key ;
- (id)metadataValueForKey:(General/NSString*)key ;
-(void)writePackageContentsForURL:(NSURL*)packageURL;
- (void) dealloc ;

@end


#import "General/MyDocument.h"

#define CORE_DATA_XML_FILENAME @"General/CoreData.xml"

#define PACKAGE_TYPE @"General/CoreDataPackage"
#define XML_TYPE @"XML"


@implementation General/MyDocument

- (id)init
{
    self = [super init];
    if (self) {
		
		persistentStoreCoordinator = nil;
		managedObjectModel = nil;
		managedObjectContext = nil;
		persistentStoreURL = nil;
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (General/NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of General/NSWindowController or if your document supports multiple General/NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"General/MyDocument";
}

- (void)windowControllerDidLoadNib:(General/NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	
	
	[self setUndoManager:General/self managedObjectContext] undoManager;
}

- (General/NSData *)dataRepresentationOfType:(General/NSString *)aType
{
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the new Tiger API -dataOfType:error:.  In this case you can also choose to override -writeToURL:ofType:error:, -fileWrapperOfType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    return nil;
}

- (BOOL)loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)aType
{
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the new Tiger API readFromData:ofType:error:.  In this case you can also choose to override -readFromURL:ofType:error: or -readFromFileWrapper:ofType:error: instead.
    
    return YES;
}

#pragma mark -


- (General/NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    General/NSMutableSet *allBundles = General/[[NSMutableSet alloc] init];
    [allBundles addObject: General/[NSBundle mainBundle]];
    [allBundles addObjectsFromArray: General/[NSBundle allFrameworks]];
    
    managedObjectModel = General/[[NSManagedObjectModel mergedModelFromBundles: [allBundles allObjects]] retain];
    [allBundles release];
    
    return managedObjectModel;
}



- (General/NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	//(A) temporary
	
	if( persistentStoreURL == nil )
	{
		General/NSFileManager *fileManager;
		General/NSString *tempFolder = General/NSTemporaryDirectory();

		fileManager = General/[NSFileManager defaultManager];
		
		if ( ![fileManager fileExistsAtPath:tempFolder isDirectory:NULL] ) {
			[fileManager createDirectoryAtPath:tempFolder attributes:nil];
		}
		
		persistentStoreURL = [NSURL fileURLWithPath: [tempFolder stringByAppendingPathComponent: General/[NSString stringWithFormat: @"com_pukeko_oneriver_coredata_document_%x_%x_%x.xml", time(NULL) ,self, General/NSApp ]]];

		[persistentStoreURL retain];
		
		
	}
	
	// (B) load

	General/NSError *error;

	persistentStoreCoordinator = General/[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	if (![persistentStoreCoordinator addPersistentStoreWithType:General/NSXMLStoreType configuration:nil URL:persistentStoreURL options:nil error:&error]){
		General/[[NSApplication sharedApplication] presentError:error];
	}    
	return persistentStoreCoordinator;

	
	
	
}


/**
Returns the managed object context for the application (which is already
														bound to the persistent store coordinator for the application.) 
 */

- (General/NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    General/NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = General/[[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}



-(NSURL*)xmlURLInPackage:(NSURL*)packageURL
{
	General/NSString* path = [packageURL path];
	path = [path stringByAppendingPathComponent:CORE_DATA_XML_FILENAME];
	return  [NSURL fileURLWithPath: path] ;
	
	
}
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(General/NSString *)typeName error:(General/NSError **)outError
{
	if( [typeName isEqualToString:PACKAGE_TYPE] )
	{
		persistentStoreURL = General/self xmlURLInPackage: absoluteURL] retain];
		
		return [[[[NSFileManager defaultManager] fileExistsAtPath:[persistentStoreURL path]];
		
	}else if( [typeName isEqualToString:XML_TYPE] )
	{
		persistentStoreURL = [absoluteURL retain];
		return General/[[NSFileManager defaultManager] fileExistsAtPath:[persistentStoreURL path]];
	}
	
	return NO;
}
- (BOOL)saveToURL:(NSURL *)absoluteURL ofType:(General/NSString *)typeName forSaveOperation:(General/NSSaveOperationType)saveOperation error:(General/NSError **)outError

{
	
	
	
	General/NSDictionary* dict = [self metadataDictionary];
	if( dict )
	{
		General/NSEnumerator* en = [dict keyEnumerator];
		General/NSString* key;
		while( key = [en nextObject] )
		{
			[self setMetadataValue:[dict objectForKey:key] forKey:key];
		}
	}
	
	//-------
	
	
	
	
	
	
	
	if( [typeName isEqualToString:PACKAGE_TYPE] )
	{
		
		if( !General/self xmlURLInPackage: absoluteURL] isEqualTo: persistentStoreURL] ) //Save as, etc
		{
			
			// migrate
			
			if (![[self managedObjectContext] save:outError]) {
				
				return NO;
			}
			
			
			// create package
			if( [[[[NSFileManager defaultManager] fileExistsAtPath:[absoluteURL path]] )
			{
				if( !General/[[NSFileManager defaultManager] removeFileAtPath:[absoluteURL path]  handler:nil] )
				{
					
					return NO;
					
				}
			}
			
			
			if( !General/[[NSFileManager defaultManager] createDirectoryAtPath:[absoluteURL path]
															attributes:nil] )
			{
				
				return NO;
				
			}
			
			
			if( !General/self persistentStoreCoordinator]
				migratePersistentStore:[[self persistentStoreCoordinator] persistentStoreForURL:persistentStoreURL] 
								 toURL:[self xmlURLInPackage:absoluteURL] options:nil withType:[[NSXMLStoreType error:outError] )
			{
				
				return NO;
				
			}
			
			
		}else // Overwrite
		{
			
			if (!General/self managedObjectContext] save:outError]) {
				
				return NO;
			}
		}
		
		/*  SAVE OTHER CONTENTS IN PACKAGE HERE */
		[self writePackageContentsForURL:absoluteURL];
		
		
		
		[self clearDirtyStateForURL:absoluteURL];
		
		return YES;
		
	}else if( [typeName isEqualToString:XML_TYPE] )
	{
		
		if( ![absoluteURL isEqualTo: persistentStoreURL] )
		{
			
			// migrate
			
			if (![[self managedObjectContext] save:outError]) {
				
				return NO;
			}
			
			
			// check existing file
			if( [[[[NSFileManager defaultManager] fileExistsAtPath:[absoluteURL path]] )
			{
				if( !General/[[NSFileManager defaultManager] removeFileAtPath:[absoluteURL path]  handler:nil] )
				{
					
					return NO;
					
				}
			}
			
			
			
			if( !General/self persistentStoreCoordinator]
				migratePersistentStore:[[self persistentStoreCoordinator] persistentStoreForURL:persistentStoreURL] 
								 toURL:absoluteURL options:nil withType:[[NSXMLStoreType error:outError] )
			{
				
				return NO;
				
			}
			
			
		}else
		{
			
			if (!General/self managedObjectContext] save:outError]) {
				
				return NO;
			}
		}
		
		[self clearDirtyStateForURL:absoluteURL];
		
		return YES;
		
	}
	
	return NO;
}

-(void)clearDirtyStateForURL:(NSURL*)url
{
	[[self windowForSheet] setDocumentEdited:NO];
	[self updateChangeCount:2];
	[persistentStoreURL release];
	persistentStoreURL = [[self xmlURLInPackage:url] retain];
	
	[self setFileURL: url];

}

- (void)setMetadataValue:(id)value forKey:([[NSString*)key {
	
    General/NSPersistentStoreCoordinator *psc = General/self managedObjectContext] persistentStoreCoordinator];
    id pStore = [psc persistentStoreForURL:persistentStoreURL];

	[[NSMutableDictionary *metadata = General/[psc metadataForPersistentStore:pStore] mutableCopy] autorelease];
	
	[metadata setObject:value forKey:key];
	[psc setMetadata:metadata forPersistentStore:pStore];
	
}

- (id)metadataValueForKey:([[NSString*)key {
	
    General/NSPersistentStoreCoordinator *psc = General/self managedObjectContext] persistentStoreCoordinator];
    id pStore = [psc persistentStoreForURL:persistentStoreURL];
	
	return [[psc metadataForPersistentStore:pStore] valueForKey: key];
	
}

-(void)writePackageContentsForURL:(NSURL*)packageURL
{
	/*  SAVE OTHER CONTENTS IN PACKAGE HERE 
	 
	 However, there is a problem. Spotlight detects everytime you write a file in the package.
	 
	 
	 */
	
	
}

- ([[NSDictionary*)metadataDictionary {
	
	return nil;
}


- (void) dealloc {
	
    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
	[persistentStoreURL release], persistentStoreURL = nil;
	
    [super dealloc];
}
@end



----
I took example code above, cleaned it to my liking, replaced references to obsolete API
Added revert functionality (After revert the changes to the document don't get registered, so closing document window does not result in Save as dialog box and change gets lost; manual saving works)

-Sergei G-

    

    #import <Cocoa/Cocoa.h>

    @interface Document : General/NSDocument {
        General/NSManagedObjectModel *managedObjectModel;
        NSURL* persistentStoreURL;
    }

    @property (strong, nonatomic) General/NSManagedObjectContext *managedObjectContext;

    @end

    #import "Document.h"

    static General/NSString *General/SqliteFileName = @"data.General/SQLite";
    static General/NSString *General/SqliteFileExt = @"General/SQLite";
    static General/NSString *General/PackageType = @"mytype";

    @implementation Document

    @synthesize managedObjectContext;

    - (id)init {
        self = [super init];
        if (self) {
            managedObjectModel = nil;
            managedObjectContext = nil;
            persistentStoreURL = nil;
        
            // Add your subclass-specific initialization here.
            // If an error occurs here, send a [self release] message and return nil.
        }
        return self;
    }

    - (General/NSString *)windowNibName {
        // Override returning the nib file name of the document
        // If you need to use a subclass of General/NSWindowController or if your document supports multiple General/NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
        return @"Document";
    }

    - (void)windowControllerDidLoadNib:(General/NSWindowController *) aController {
        [super windowControllerDidLoadNib:aController];
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
        [self setUndoManager:General/self managedObjectContext] undoManager;
    }

    #pragma mark -
    #pragma mark Obsolete API
    - (General/NSData *)dataRepresentationOfType:(General/NSString *)aType {
        // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    
        // For applications targeted for Tiger or later systems, you should use the new Tiger API -dataOfType:error:.  In this case you can also choose to override -writeToURL:ofType:error:, -fileWrapperOfType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        return nil;
    }

    - (BOOL)loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)aType {
        // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    
        // For applications targeted for Tiger or later systems, you should use the new Tiger API readFromData:ofType:error:.  In this case you can also choose to override -readFromURL:ofType:error: or -readFromFileWrapper:ofType:error: instead.
        return YES;
    }

    #pragma mark -

    /**
     Creates if necessary and returns the managed object model for the application.
     */
    - (General/NSManagedObjectModel *)managedObjectModel {
        if (managedObjectModel) {
            return managedObjectModel;
        }
    
        NSURL *modelURL = General/[[NSBundle mainBundle] General/URLForResource:@"Document" withExtension:@"momd"];
        managedObjectModel = General/[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
        return managedObjectModel;
    }

    - (General/NSPersistentStoreCoordinator *) createPersistentStoreCoordinator {
        General/NSError *error = nil;
        // check if peresistent store url is set
        if (persistentStoreURL == nil) {
            // create temporary
            General/NSLog(@"Creating temporary presistentStoreURL");
            General/NSFileManager *fm = General/[NSFileManager defaultManager];
            General/NSString *tempFolder = General/NSTemporaryDirectory();
            if (![fm fileExistsAtPath:tempFolder isDirectory:NULL]) {
                if (![fm createDirectoryAtURL: [NSURL fileURLWithPath: tempFolder isDirectory: YES] withIntermediateDirectories: NO attributes: nil error: &error]) {
                    General/[[NSApplication sharedApplication] presentError:error];
                    return nil;
                }
            }
            General/NSString *fileName = General/[NSString stringWithFormat: @"myd_%x_%x_%x.%@", time(NULL) ,self, General/NSApp, General/SqliteFileExt];
            persistentStoreURL = [NSURL fileURLWithPath: [tempFolder stringByAppendingPathComponent: fileName]];
        }
    
        // load
        General/NSPersistentStoreCoordinator *persistentStoreCoordinator = General/[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
        General/NSLog(@"initializing psc with url %@", persistentStoreURL.path);
        if (![persistentStoreCoordinator addPersistentStoreWithType:General/NSSQLiteStoreType configuration:nil URL:persistentStoreURL options:nil error:&error]){
            General/[[NSApplication sharedApplication] presentError:error];
            return nil;
        }
        General/NSLog(@"initialized psc");
        return persistentStoreCoordinator;
    }

    /**
     Returns the managed object context for the application (which is already
     bound to the persistent store coordinator for the application.) 
     */

    - (General/NSManagedObjectContext *) managedObjectContext {
        if (managedObjectContext != nil) {
            return managedObjectContext;
        }
    
        General/NSPersistentStoreCoordinator *coordinator = [self createPersistentStoreCoordinator];
        if (coordinator != nil) {
            managedObjectContext = General/[[NSManagedObjectContext alloc] init];
            [managedObjectContext setPersistentStoreCoordinator: coordinator];
        }
        return managedObjectContext;
    }

    -(NSURL*)sqlStoreURL:(NSURL*)packageURL {
        General/NSString* path = [packageURL path];
        path = [path stringByAppendingPathComponent:General/SqliteFileName];
        return [NSURL fileURLWithPath: path] ;
    }

    - (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(General/NSString *)typeName error:(General/NSError **)outError {
        General/NSLog(@"EP readFromURL %@", absoluteURL.path);
        bool result = NO;
        if ([typeName isEqualToString:General/PackageType]) {
            // file request is by package/bundle extension .mytype; look for sql file inside
            persistentStoreURL = [self sqlStoreURL: absoluteURL];
            result = General/[[NSFileManager defaultManager] fileExistsAtPath:[persistentStoreURL path]];
        } else if ([typeName isEqualToString:General/NSSQLiteStoreType]) {
            // sqlite file has been specified directly; unlikely (?)
            persistentStoreURL = absoluteURL;
            result = General/[[NSFileManager defaultManager] fileExistsAtPath:[persistentStoreURL path]];
        }
        General/NSLog(@"presistent store url is set to %@", persistentStoreURL.path);
        return result;
    }

    #pragma mark -
    #pragma mark Save Support

    - (General/NSString*) describeSaveOperation:(General/NSSaveOperationType)op {
        General/NSString *result;
        if (op == General/NSSaveOperation) { // 0
            result = @"General/NSSaveOperation";
        } else if (op == General/NSSaveAsOperation) { // 1
            result = @"General/NSSaveAsOperation";        
        } else if (op == General/NSSaveToOperation) { // 2
            result = @"General/NSSaveToOperation";        
        } else if (op == General/NSAutosaveInPlaceOperation) { // 4
            result = @"General/NSAutosaveInPlaceOperation";        
        } else if (op == General/NSAutosaveElsewhereOperation) { // 3
            result = @"General/NSAutosaveElsewhereOperation";        
        } else {
            result = @"Unexpected";
        }
        return result;       
    }

    -(void)clearDirtyStateForURL:(NSURL*)url {
        General/self windowForSheet] setDocumentEdited:NO];
        [self updateChangeCount:[[NSChangeCleared];
        persistentStoreURL = [self sqlStoreURL:url];
        [self setFileURL: url];
    }

    -(void)writePackageContentsForURL:(NSURL*)packageURL {
        /*  SAVE OTHER CONTENTS IN PACKAGE HERE 
         * However, there is a problem. Spotlight detects everytime you write a file in the package.
         */
    }

    - (BOOL)saveToURL:(NSURL *)absoluteURL ofType:(General/NSString *)typeName forSaveOperation:(General/NSSaveOperationType)saveOperation error:(General/NSError **)outError {
        General/NSLog(@"EP saveToURL %@", absoluteURL.path);
        General/NSLog(@".. ofType %@", typeName);
        General/NSLog(@".. forSaveOperation %@", [self describeSaveOperation:saveOperation]);
    
        if ([typeName isEqualToString:General/PackageType]) {
            // Save as, etc
            General/NSLog(@"processing package type");
            if(General/self sqlStoreURL: absoluteURL] isEqualTo:persistentStoreURL]) {
                // Overwrite existing file
                [[NSLog(@"overriding existing file with simple save");
                if (!General/self managedObjectContext] save:outError]) {
                    return NO;
                }
            } else {
                // migrate existing file to new location
                // save current content
                [[NSLog(@"migrating to new file (saving current content)");
                if (!General/self managedObjectContext] save:outError]) {
                    return NO;
                }
                // create package
                [[NSFileManager *fm = General/[NSFileManager defaultManager];
                if ([fm fileExistsAtPath: [absoluteURL path]]) {
                    if (![fm removeItemAtURL: absoluteURL error: outError]) {
                        return NO;
                    }
                }
                if (![fm createDirectoryAtURL: absoluteURL withIntermediateDirectories: NO attributes: nil error: outError]) {
                    return NO;
                }
                // actual db migration
                General/NSLog(@"actual migration");
                General/NSPersistentStoreCoordinator *psc = General/self managedObjectContext] persistentStoreCoordinator];
                if (![psc migratePersistentStore:[psc persistentStoreForURL:persistentStoreURL] 
                                           toURL:[self sqlStoreURL:absoluteURL] options:nil withType:[[NSSQLiteStoreType error:outError] ) {
                    return NO;
                }
            }
            /*  SAVE OTHER CONTENTS IN PACKAGE HERE */
            [self writePackageContentsForURL:absoluteURL];
            [self clearDirtyStateForURL:absoluteURL];
            return YES;
        }
        return NO;
    }

    - (General/NSPersistentStore*) store {
        General/NSPersistentStoreCoordinator *psc = General/self managedObjectContext] persistentStoreCoordinator];
        [[NSArray *stores = [psc persistentStores];
        if (stores.count == 1) {
            General/NSPersistentStore *s = [stores objectAtIndex:0];
            //        General/NSLog(@"Persistent store %@", [s.URL absoluteString]);
            return s;
        } else {
            General/NSLog(@"Stores count is not one, but %ld", stores.count);
            return nil;
        }
    }
    /*
     The revert method needs to completely tear down the object graph assembled by the document. In this case, you also want to remove the persistent store manually, because General/NSPersistentDocument will expect the store for its coordinator to be located at the document URL (instead of inside that URL as part of the file wrapper).
     */
    - (BOOL)revertToContentsOfURL:(NSURL *)absoluteURL ofType:(General/NSString *)typeName error:(General/NSError **)outError {
        General/NSLog(@"EP revertToContentsOfURL for: %@", self.fileURL.path);
        General/NSLog(@"revert to: %@", absoluteURL.path);
        General/NSLog(@"removing persistent store %@", self.store.URL.path);
    
        persistentStoreURL = [self sqlStoreURL: absoluteURL];
        General/NSLog(@"managedObjectContext = nil");
        self.managedObjectContext = nil;
        General/NSLog(@"super revertToContentsOfURL");
        return [super revertToContentsOfURL:absoluteURL ofType:typeName error:outError];
    }

    @end

