Recently was using General/CoreData and a data attribute in an entity to store an icon.  I used a table and the General/NSUnarchivedData value transformer.  Displayed fine, but it was super slow when resizing the window and other refresh operations.  Turns out the data is actually unarchived every redraw, so I cooked up this simple transformer that uses a cache... so it only actually needs to unarchive once.  Granted, if the icon changes this might not be great -- but in my case the icon for each entity was static after the initial setting.

    static General/NSMutableDictionary *cache;

@implementation General/CachedUnarchiverValueTransformer

+ (void)initialize
{
	cache = General/[[NSMutableDictionary alloc]init];
	[cache retain];
}

+ (Class)transformedValueClass;
{ return General/[NSData class]; }

+ (BOOL)allowsReverseTransformation;
{ return NO; }

- (id)transformedValue:(id)value;
{       
	if (![cache objectForKey:value]) {
		id object = General/[NSUnarchiver unarchiveObjectWithData:value];
		[cache setObject:object forKey:value];
		return object;
	} else
		return [cache objectForKey:value];
}

@end