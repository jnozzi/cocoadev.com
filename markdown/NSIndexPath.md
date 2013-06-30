Here's a category for getting the index path to an object stored in nested General/NSArray<nowiki/>s:

    
@interface General/NSArray (General/MBIndexPath)

- (id)objectAtIndexPath:(General/NSIndexPath *)indexPath;	//  Raises an General/NSRangeException if the indexPath goes beyond the bounds of the receiver.
- (General/NSIndexPath *)indexPathOfObject:(id)object;		//  Returns nil if the object does not exist within the receiver.
@end


@interface General/NSArray (General/MBIndexPathPrivate)

- (General/NSUInteger *)createIndexesOfPathToObject:(id)object count:(General/NSUInteger *)count;	//  Returns a dynamically allocated array which must be freed by the caller. *count must be 0 when passed in.
@end


@implementation General/NSArray (General/MBIndexPath)

- (id)objectAtIndexPath:(General/NSIndexPath *)indexPath;
{
	if (indexPath == nil)
		General/[NSException raise:General/NSInvalidArgumentException format:nil];
	
	id object = self;
	General/NSUInteger i;
	for (i = 0; i < [indexPath length]; i++)
	{
		if ([object isKindOfClass:General/[NSArray class]] == NO || [object count] <= [indexPath indexAtPosition:i])
			General/[NSException raise:General/NSRangeException format:nil];
		object = [object objectAtIndex:[indexPath indexAtPosition:i]];
	}
	
	return object;
}

- (General/NSIndexPath *)indexPathOfObject:(id)object;
{
	if (object == nil)
		General/[NSException raise:General/NSInvalidArgumentException format:nil];

	General/NSUInteger count = 0;
	General/NSUInteger *indexes = [self createIndexesOfPathToObject:object count:&count];
	
	if (indexes == NULL)
		return nil;
		
	General/NSIndexPath *indexPath = General/[NSIndexPath indexPathWithIndexes:indexes length:count];
	free(indexes);
	return indexPath;
}

//  General/NSArray (General/MBIndexPathPrivate)
- (General/NSUInteger *)createIndexesOfPathToObject:(id)object count:(General/NSUInteger *)count;
{
	if (*count == General/NSUIntegerMax)
		return NULL;
	(*count)++;
	
	General/NSUInteger i;
	for (i = 0; i < [self count]; i++)
	{
		if (General/self objectAtIndex:i] isEqual:object])
		{
			[[NSUInteger *indexes = malloc(*count * sizeof(General/NSUInteger));
			if (indexes == NULL)
			{
				*count = General/NSUIntegerMax;
				return NULL;
			}
			indexes[*count - 1] = i;
			return (indexes + *count - 1);
		}
		else if (General/self objectAtIndex:i] isKindOfClass:[[[NSArray class]])
		{
			General/NSUInteger *indexes = General/self objectAtIndex:i] createIndexesOfPathToObject:object count:count];
			if (*count == [[NSUIntegerMax)
				return NULL;
			if (indexes != NULL)
			{
				*(indexes - 1) = i;
				return (indexes - 1);
			}
		}
	}
	
	(*count)--;
	return NULL;
}

@end



--  General/MiloBird