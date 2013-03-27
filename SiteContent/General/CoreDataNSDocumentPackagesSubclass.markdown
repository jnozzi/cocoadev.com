Moved from General/FolderBasedDocuments... A (possible) method to have General/CoreData-based documents that are folders

I followed the above instructions to create an app that would open packaged documents, and then modified the General/MyDocument class so that the document has a managedObjectContext just like an General/NSPersistentDocument would. Let me know what you think. A bug that I've found is that it doesn't show the black dot in the close button when there are unsaved changes. Other than that, it seems to work for me... Here's the code:

    

//
//  General/MyDocument.h
//  General/CDDocTest
//
//  Last updated by Jason Terhorst on 2/7/07.
//  Copyright Jason Terhorst 2007 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface General/MyDocument : General/NSDocument
{
	General/NSPersistentStoreCoordinator *persistentStoreCoordinator;
    General/NSManagedObjectModel *managedObjectModel;
    General/NSManagedObjectContext *managedObjectContext;
	
	General/NSString * resourceFileName;
}

- (General/NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (General/NSManagedObjectModel *)managedObjectModel;
- (General/NSManagedObjectContext *)managedObjectContext;

@end



//  General/MyDocument.m
//  General/CDDocTest
//
//  Last updated by Jason Terhorst on 2/7/07.
//  Copyright Jason Terhorst 2007 . All rights reserved.
//

#import "General/MyDocument.h"

@implementation General/MyDocument

- (id)init
{
    self = [super init];
    if (self) {
		
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		
		resourceFileName = General/[[self displayName] copy] stringByDeletingPathExtension] retain];
		
    }
    return self;
}

- ([[NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of General/NSWindowController or if your document supports multiple General/NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"General/MyDocument";
}

- (void)windowControllerDidLoadNib:(General/NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

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
	
    
    persistentStoreCoordinator = General/[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
    return persistentStoreCoordinator;
}

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

- (General/NSUndoManager *)undoManager {
    return General/self managedObjectContext] undoManager];
}

- (BOOL)isDocumentEdited
{
	if ([[self managedObjectContext] hasChanges])
		return YES;
	if ([[[self managedObjectContext] deletedObjects] count] > 0)
		return YES;
	if ([[[self managedObjectContext] insertedObjects] count] > 0)
		return YES;
	if ([[[self managedObjectContext] updatedObjects] count] > 0)
		return YES;
	
	return NO;
}

- ([[NSString *)applicationSupportFolder {
	
    General/NSArray *paths = General/NSSearchPathForDirectoriesInDomains(General/NSApplicationSupportDirectory, General/NSUserDomainMask, YES);
    General/NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : General/NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"General/CDDelegateTest"];
}



- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(General/NSString *)typeName error:(General/NSError **)outError
{
	
	// we use this to make sure to call the method to create a directory wrapper, then we save the store...
	BOOL success = [super writeToURL:absoluteURL ofType:typeName error:outError];
	
	if ([self fileURL] == nil)
		[self setFileURL:absoluteURL];
	
	if (success) {
		
		General/NSFileManager *fileManager;
		General/NSString *applicationSupportFolder = nil;
		NSURL *url, *finalurl;
		General/NSError *error;
		
		fileManager = General/[NSFileManager defaultManager];
		applicationSupportFolder = [self applicationSupportFolder];
		if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
			[fileManager createDirectoryAtPath:applicationSupportFolder attributes:nil];
		}
		
		url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: resourceFileName ]];
		finalurl = [NSURL fileURLWithPath: General/[self fileURL] path] stringByAppendingPathComponent: @"[[CDDocTest.xml"]];
		
		if (General/[[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
			if (General/[[NSFileManager defaultManager] removeFileAtPath:[url path] handler:nil]) {
				General/NSLog(@"existing file - removed successfully");
			}
		}
		
		General/NSLog(@"file url: %@", [url path]);
		
		if (General/persistentStoreCoordinator persistentStores] count] == 0) {
			
			if (![persistentStoreCoordinator addPersistentStoreWithType:[[NSXMLStoreType configuration:nil URL:url options:nil error:&error]){
				General/[[NSApplication sharedApplication] presentError:error];
			} else {
				General/NSError * error = nil;
				if (!General/self managedObjectContext] save:&error]) {
					[[[[NSApplication sharedApplication] presentError:error];
				}
			}			
		} else {
			General/NSError * error = nil;
			if (!General/self managedObjectContext] save:&error]) {
				[[[[NSApplication sharedApplication] presentError:error];
			}			
		}	
		
		if (General/[[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
			General/NSLog(@"file exists");
			if (General/[[NSFileManager defaultManager] copyPath:[url path] toPath:[finalurl path] handler:nil]) {
				General/NSLog(@"file was successfully copied");
			}
		}
		
		
		return YES;
	}
	
	return NO;
}

- (General/NSFileWrapper *)fileWrapperOfType:(General/NSString *)typeName error:(General/NSError **)outError
{
	General/NSFileWrapper * dirWrapper = General/[[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
	
	General/NSLog(@"file url: %@", General/self fileURL] path]);
	
	return dirWrapper;
	
}

- (BOOL)readFromFileWrapper:([[NSFileWrapper *)fileWrapper ofType:(General/NSString *)typeName error:(General/NSError **)outError
{
	NSURL *url, *originalurl;
	General/NSError *error;
	
	resourceFileName = General/[[self displayName] copy] stringByDeletingPathExtension] retain];
	
	originalurl = [NSURL fileURLWithPath: [[[self fileURL] path] stringByAppendingPathComponent: @"[[CDDocTest.xml"]];
	url = [NSURL fileURLWithPath: General/self applicationSupportFolder] stringByAppendingPathComponent: resourceFileName ;
	
	General/NSLog(@"file url: %@", [url path]);
	
	if (General/[[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
		if (!General/[[NSFileManager defaultManager] removeFileAtPath:[url path] handler:nil]) {
			General/NSLog(@"couldn't delete the file that's already there");
		}
	}
	
	if (General/[[NSFileManager defaultManager] fileExistsAtPath:[originalurl path]]) {
		General/NSLog(@"file exists");
		if ( !General/[[NSFileManager defaultManager] fileExistsAtPath:[self applicationSupportFolder] isDirectory:NULL] ) {
			General/[[NSFileManager defaultManager] createDirectoryAtPath:[self applicationSupportFolder] attributes:nil];
		}
		if (General/[[NSFileManager defaultManager] copyPath:[originalurl path] toPath:[url path] handler:nil]) {
			General/NSLog(@"file was successfully copied");
		}
	}
	
	persistentStoreCoordinator = [self persistentStoreCoordinator];
	if (General/persistentStoreCoordinator persistentStores] count] > 0)
		[[NSBeep();
	
	if (![persistentStoreCoordinator addPersistentStoreWithType:General/NSXMLStoreType configuration:nil URL:url options:nil error:&error]){
		General/[[NSApplication sharedApplication] presentError:error];
		General/NSLog(@"failed to load");
	} else {
		managedObjectContext = [self managedObjectContext];
		return YES;
	}
	
	return NO;
}

- (BOOL)revertToContentsOfURL:(NSURL *)absoluteURL ofType:(General/NSString *)typeName error:(General/NSError **)outError
{
	General/NSLog(@"reverting file");
	
	NSURL *url, *originalurl;
	General/NSError *error;
	
	persistentStoreCoordinator = [self persistentStoreCoordinator];
	General/NSArray * stores = [persistentStoreCoordinator persistentStores];
	if (![persistentStoreCoordinator removePersistentStore:[stores objectAtIndex:0] error:&error]) {
		General/[[NSApplication sharedApplication] presentError:error];
		General/NSLog(@"could not remove the current store");
		return NO;
	}	
	
	resourceFileName = General/[[self displayName] copy] stringByDeletingPathExtension] retain];
	
	originalurl = [NSURL fileURLWithPath: [[absoluteURL path] stringByAppendingPathComponent: @"[[CDDocTest.xml"]];
	url = [NSURL fileURLWithPath: General/self applicationSupportFolder] stringByAppendingPathComponent: resourceFileName ;
	
	if (General/[[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
		if (!General/[[NSFileManager defaultManager] removeFileAtPath:[url path] handler:nil]) {
			General/NSLog(@"couldn't delete the file that's already there");
		}
	}
	
	General/NSLog(@"file url: %@", [url path]);
	
	if (General/[[NSFileManager defaultManager] fileExistsAtPath:[originalurl path]]) {
		General/NSLog(@"file exists");
		if ( !General/[[NSFileManager defaultManager] fileExistsAtPath:[self applicationSupportFolder] isDirectory:NULL] ) {
			General/[[NSFileManager defaultManager] createDirectoryAtPath:[self applicationSupportFolder] attributes:nil];
		}
		if (General/[[NSFileManager defaultManager] copyPath:[originalurl path] toPath:[url path] handler:nil]) {
			General/NSLog(@"file was successfully copied");
		}
	}
	
	error = nil;
	
	if (![persistentStoreCoordinator addPersistentStoreWithType:General/NSXMLStoreType configuration:nil URL:url options:nil error:&error]){
		General/[[NSApplication sharedApplication] presentError:error];
		General/NSLog(@"failed to load");
		return NO;
	} else {
		managedObjectContext = [self managedObjectContext];
		return YES;
	}
	
	return NO;
}

- (void) dealloc {
	
    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
    [super dealloc];
}

@end



Could you perhaps post the complete project to make it easy to see what this does? I am interested in doing something like this in my application.