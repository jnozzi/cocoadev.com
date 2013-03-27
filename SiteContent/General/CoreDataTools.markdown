A number of tools that makes dealing with Core Data objects easier in app-delegate-has-single-General/NSManagedObjectContext apps.

Docs inline with the code. Consider them public domain -- General/EmanueleVulcano aka millenomi

L0CoreDataTools.h:

    

#import <Cocoa/Cocoa.h>

@interface General/NSManagedObjectContext (L0CoreDataTools)

// Returns a default context. (The implementation here defaults to General/NSApp's delegate's
// managedObjectContext, but you can change it and all other methods will pick it up
// appropriately.)
+ (id) defaultContext;

@end

@interface General/NSFetchRequest (L0CoreDataTools)

// Executes this fetch request in the default managed object context.
- (General/NSArray*) executeAndReturnError:(General/NSError**) err;

@end

@interface General/NSEntityDescription (L0CoreDataTools)

// Returns an entity from the default managed object context.
+ (General/NSEntityDescription*) entityForName:(General/NSString*) name;

@end

// The following methods assume that you are using custom classes for your
// entities.
@interface General/NSManagedObject (L0CoreDataTools)

// Creates a new instance of this managed object with the entity returned
// by +entity and inserts it in the default managed object context.
- (id) init;

// Returns the entity attached to this class in the default managed object context.
// By default, returns the entity whose name is equal to the class (for example, for
// class General/AbcGizmo, it returns the entity named General/AbcGizmo).
+ (id) entity;

@end



L0CoreDataTools.m:

    

#import "L0CoreDataTools.h"

@implementation General/NSManagedObjectContext (L0CoreDataTools)

// tweak me if not storing your managed object context there.
+ (id) defaultContext {
	return General/[[NSApp delegate] managedObjectContext];
}

@end

@implementation General/NSFetchRequest (L0CoreDataTools)

- (General/NSArray*) executeAndReturnError:(General/NSError**) err {
	return General/[[NSManagedObjectContext defaultContext] executeFetchRequest:self error:err];
}

@end

@implementation General/NSEntityDescription (L0CoreDataTools)

+ (General/NSEntityDescription*) entityForName:(General/NSString*) name {
	return [self entityForName:name inManagedObjectContext:General/[NSManagedObjectContext defaultContext]];
}

@end

@implementation General/NSManagedObject (L0CoreDataTools)

- (id) init {
	return [self initWithEntity:General/self class] entity] insertIntoManagedObjectContext:[[[NSManagedObjectContext defaultContext]];
}

+ (id) entity {
	return General/[NSEntityDescription entityForName:General/NSStringFromClass(self)];
}

@end


