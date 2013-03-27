Recently I needed to bind an General/NSTextCell General/NSTableView column to a to-many property of a General/CoreData entity.  After banging my head against the wall for a bit when Cocoa refused to bind to the relationship as it can't possibly be KVC-compliant, I came up with the idea of using an General/NSValueTransformer to transform the set to a string.  Here's my value transformer:

    %
// General/CDSetToStringTransformer.h
#import <Cocoa/Cocoa.h>

@interface General/CDSetToStringTransformer : General/NSValueTransformer
{
	General/NSString *_keyPath;
}

- (id)initWithKeyPath:(General/NSString *)keyPath;

- (General/NSString *)keyPath;
- (void)setKeyPath:(General/NSString *)keyPath;

@end

// General/CDSetToStringTransformer.m
#import "General/CDSetToStringTransformer.h"

@implementation General/CDSetToStringTransformer

+ (Class)transformedValueClass
{
	return General/[NSString class];
}

+ (BOOL)allowsReverseTransformation
{
	return NO;
}

- (id)initWithKeyPath:(General/NSString *)keyPath
{
	if(self = [super init])
		[self setKeyPath:keyPath];
	
	return self;
}

- (void)dealloc
{
	[self setKeyPath:nil];
	
	[super dealloc];
}

- (General/NSString *)keyPath
{
	return _keyPath;
}

- (void)setKeyPath:(General/NSString *)newKeyPath
{
	newKeyPath = [newKeyPath copy];
	[_keyPath release];
	_keyPath = newKeyPath;
}

- (id)transformedValue:(id)value
{
	General/NSSet *sourceSet = (General/NSSet *)value;
	if([sourceSet count] == 0)
		return General/[NSNull null];
	
	General/NSString *result;
	General/NSEnumerator *objectEnum = [sourceSet objectEnumerator];
	result = General/objectEnum nextObject] valueForKeyPath:[self keyPath;
	
	id currentObject;
	while(currentObject = [objectEnum nextObject])
		result = [result stringByAppendingFormat:@", %@", [currentObject valueForKeyPath:[self keyPath]]];
	
	return result;
}

@end


Put the instantiation in the proper place (I'm using     + General/[AppDelegate initialize]).  Initialize the transformer using     - General/[CDSetToStringTransformer initWithKeyPath:], where keyPath is the key path *relative to each object in the set* that you want to coalesce into one string.

Beware that this class is not localized, but localization should be trivial.