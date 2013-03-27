Here is a category that makes an General/NSArrayController a valid General/IKImageBrowserDataSource. Additionally, the example implementations of imageBrowser:moveItemsAtIndexes:toIndex: I�ve seen are buggy. The one below seems to work flawlessly.

Note that if you have the array controller�s arrangedObjects bound as the content of the General/IKImageBrowserView, you still need to set the array controller as the General/IKImageBrowserView�s dataSource and to implement imageBrowser:moveItemsAtIndexes:toIndex to get rearranging to work. Hopefully Apple will fix that�  � General/BryanWoods

    
// General/NSArrayController+General/IKImageBrowserDataSource.m

@implementation General/NSArrayController (General/IKImageBrowserDataSource)

- (General/NSUInteger) numberOfItemsInImageBrowser:(General/IKImageBrowserView *)browser
{
	return General/self arrangedObjects] count];
}

- (id) imageBrowser:([[IKImageBrowserView *)browser itemAtIndex:(General/NSUInteger)index
{
	return General/self arrangedObjects] objectAtIndex:index];
}

- (void) imageBrowser:([[IKImageBrowserView *)browser removeItemsAtIndexes:(General/NSIndexSet *)indexes
{
	return [self removeObjectsAtArrangedObjectIndexes:indexes];
}

- (BOOL) imageBrowser:(General/IKImageBrowserView *)browser moveItemsAtIndexes:(General/NSIndexSet *)indexes toIndex:(General/NSUInteger)index
{
	__block General/NSUInteger destination = index;
	[indexes enumerateIndexesUsingBlock:^(General/NSUInteger idx, BOOL * stop) {
			if(idx < index)
				--destination;
			else
				*stop = YES;
		}];
	
	General/NSArray * items = General/self arrangedObjects] objectsAtIndexes:indexes];

	[self willChangeValueForKey:@"arrangedObjects"];
	[self removeObjectsAtArrangedObjectIndexes:indexes];

	[items enumerateObjectsWithOptions:[[NSEnumerationReverse usingBlock:^(id item, General/NSUInteger idx, BOOL * stop) {
			[self insertObject:item atArrangedObjectIndex:destination];
		}];
	[self didChangeValueForKey:@"arrangedObjects"];

	[self performSelectorOnMainThread:@selector(setSelectionIndex:) withObject:(id)destination waitUntilDone:NO];

	return YES;
}


@end
