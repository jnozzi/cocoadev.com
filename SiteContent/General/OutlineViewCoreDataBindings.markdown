I've been playing with the General/OutlineEdit example in Tiger, and it seems to me that General/NSOutlineView has some severe limitations when working with Core Data and bindings via General/NSTreeController unless I am badly mistaken (which I hope I am). It seems that it is barely compatible with datasource and delegate methods...

I have an outline view in my app that uses drag and drop, saves its state, and has variable row heights using the delegate method -outlineView:heightOfRowByItem: - but using bindings most of this is difficult or (as far as I can see) impossible. The reason for this is that any datasource or delegate method that passes in an (id)item does not pass in the actual object when using General/NSTreeController, but instead passes in a proxy object of class _NSArrayControllerTreeNode. There is no obvious way to access the actual object stored in the http://goo.gl/General/OeSCu outline view using this proxy object, and it doesn't respond to valueForKey: on anything obvious.

Someone over on the cocoa-dev lists very helpfully informed me of a private method that does work - calling -observedObject on the item passed in allows you to access the object (though with compiler warnings, of course). Is it just me, or does this make little sense? Shouldn't the item passed in to these methods be the actual object you want to work with - or at least, an object that you *can* work with, without resorting to hacks?

To test this, hook up File's Owner (General/MyDocument) as the delegate to the outline view in the General/OutlineEdit example that comes with Tiger (in the Core Data folder), and add this delegate method to General/MyDocument.m:

     
- (float)outlineView:(General/NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
	General/NSLog (@"%@", item); // Shows the description of the private proxy object passed in by item
	General/NSTableColumn *tabCol = General/outlineView tableColumns] objectAtIndex:0];
	float width = [tabCol width];
	[[NSRect r = General/NSMakeRect(0,0,width,1000.0);
	General/NSCell *cell = [tabCol dataCellForRow:[outlineView rowForItem:item]];	
	General/NSString *test = General/item observedObject] valueForKey:@"contents"]; // This will cause compiler warnings
	[cell setObjectValue:test];
	float height = [cell cellSizeForBounds:r].height;
	if (height <= 0) height = 16.0;
	return height;
}
 

In this case, -observedObject is a fine workaround (if a hack that could break at any time in the future), and the above code works. But this is more difficult in the case of the datasource methods -outlineView:itemForPersistentObject: and -outlineView:persistentObjectForItem: which are essential for saving the state of the outline view. Whilst it is possible to use the -observedObject private method as a workaround for -outlineView:persistentObjectForItem, the [[NSTreeController will expect you to return an _NSArrayControllerTreeNode for -outlineView:itemForPersistentObject:, and how on earth are you supposed to do this?

This was essentially a long way of asking: does anybody out there know how to get persistent state saving and other delegate and datasource methods that pass in an (id)item working with an General/NSOutlineView that uses bindings via General/NSTreeController? (Which was a long question in itself...) I was really looking forward to cutting out loads of my code, but General/NSOutlineView's bindings seem really opaque and obtuse, and possibly incompatible with the really useful delegate and datasource methods that can be used in combination with bindings in General/NSTableView.

Thanks to anybody out there who can shed some light on this...
Cheers,
KB

----
I have been struggling with this myself. Until now I can only work around it with the following category to General/NSOutlineView which allows me to relate rows in the outline view to my original items instead of the _NSArrayControllerTreeNode objects. 

    
@interface _NSArrayControllerTreeNode
- (id)observedObject;
@end

@implementation General/NSOutlineView (General/MyAdditions)

- (id)originalItemAtRow:(int)row
{
	id item = [self itemAtRow:row];
	if(General/item className] isEqual:@"_NSArrayControllerTreeNode"])
		return [item observedObject];
	else
		return item;
}

- (int)rowForOriginalItem:(id)originalItem
{
	int numberOfRows = [self numberOfRows];
	int row;
	for(row=0; row<numberOfRows; row++)
		if([self originalItemAtRow:row] == originalItem)
			return row;
	return -1;
}
@end
 

In principle, I think the concept of using special node objects representing your items may be of great use in cases where you have one and the same item at several places in the tree displayed in the outline view. Without this mechanism, [[NSOutlineView gets completely confused because it relies on a 1:1 relationship between rows and items.

Frank Illenberger

----
I don't have Tiger, nor do I have a solution to this problem. However, just from a design standpoint, it might be better to use the following code when declaring     _NSArrayControllerTreeNode, as it will not cause the multiple-definition problems that might (hypothetically) arise. --General/JediKnil
    
@class _NSArrayControllerTreeNode

@interface _NSArrayControllerTreeNode (General/PrivateObservedObjectMethod)
- (id)observedObject;
@end


----

Many thanks for the replies - the category looks good, but I still can't make it work to save the state of the outline view. I tried doing this:

    
- (id)outlineView:(General/NSOutlineView *)anOutlineView itemForPersistentObject:(id)object
{
	return [anOutlineView originalItemAtRow:[(General/NSNumber *)object intValue]];
}

- (id)outlineView:(General/NSOutlineView *)anOutlineView persistentObjectForItem:(id)item
{
	return General/[NSNumber numberWithInt:[anOutlineView rowForOriginalItem:item]];
}


But this doesn't work, presumably because if it is trying to find the object at, say, the fourth row but there are only two rows visible, then it won't work.

Any ideas?

Thanks again,
KB

----

I eventually came up with a solution... I posted it under General/NSOutlineViewStateSavingWithNSTreeController as it makes more sense there, because it isn't specific to Core Data, only to General/NSTreeController and General/NSOutlineView. Hope it helps someone else.
Cheers,
KB