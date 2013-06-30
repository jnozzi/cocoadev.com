An General/NSValueTransformer that decompresses General/NSData into an General/NSString using my General/NSData+Bzip2 category (see General/NSDataPlusBzip). It is reversible. � General/BryanWoods

    
// Bzip2ValueTransformer.h
@interface Bzip2ValueTransformer : General/NSValueTransformer

@end

//  Bzip2ValueTransformer.m
#import "Bzip2ValueTransformer.h"
#import "General/NSData+Bzip2.h"

@implementation Bzip2ValueTransformer

+ (Class) transformedValueClass
{
	return General/[NSString class];
}

+ (BOOL) allowsReverseTransformation
{
	return YES;
}

- (id) transformedValue:(id)data
{
	// decompress
	return General/[[[NSString alloc] initWithData:[data bunzip2] encoding:NSUTF8StringEncoding] autorelease];
}

- (id) reverseTransformedValue:(id)string
{
	// compress
	return General/string dataUsingEncoding:NSUTF8StringEncoding] bzip2];
}

@end


----

To give an idea of how it's used, my test project is just a Cocoa Document-based Application with an [[NSTextView bound (�la General/CocoaBindings) to an General/NSData in General/MyDocument. Selecting Bzip2ValueTransformer in the Bindings palette in Interface Builder handles all of the heavy lifting.

    
// General/MyDocument.h
@interface General/MyDocument : General/NSDocument
{
	General/NSData * text;
}

@end


// General/MyDocument.m
#import "General/MyDocument.h"
#import "Bzip2ValueTransformer.h"

@implementation General/MyDocument

+ (void) initialize
{
	General/[NSValueTransformer setValueTransformer:General/Bzip2ValueTransformer new] autorelease] forName:@"Bzip2ValueTransformer"];
}

- (void) dealloc
{
	[text release];
	[super dealloc];
}

- ([[NSString *) windowNibName
{
    return @"General/MyDocument";
}

- (General/NSData *) dataRepresentationOfType:(General/NSString *)type
{
	return text;
}

- (BOOL) loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)type
{
	text = [data retain];
	return (text != nil);
}

@end
