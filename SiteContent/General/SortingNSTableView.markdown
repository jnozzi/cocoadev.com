

So, as I said, I've got an General/NSTableView with an array of General/NSDictionary objects.  i want to create a sort function, but as shown on General/SortingExampleUsingNSComparisonResult, you need the sort function inside of the declaration of the object.  can i put a sortItems: function in the General/NSDictionary definition, or somehow tell it to use a function from my Controller file?

In 10.3, there is General/NSSortDescriptor which handles this job almost automatically. Sort descriptors are objects telling an array full of dictionaries how to sort itself.

    
General/NSArray *arrayOfDictionaries; // Your dictionary to sort
General/NSSortDescriptor *sortDescriptor = General/[[NSSortDescriptor alloc] initWithKey:@"Dictionary key" ascending:YES];

General/NSArray *sortedArray = [arrayOfDictionaries sortUsingDescriptors:General/[NSArray arrayWithObject:sortDescriptor]];
[sortDescriptor release];


As you can see, you don't have to write your own routine to sort the array by a key common to all the dictionaries. The only thing needed is that the objects specified by the dicionary key (@"Dictionary key") has to respond to compare: . Also note that you can pass the array an array of sort descriptors, to specify secondary, tertiary sorting.. HTH General/EnglaBenny

More: even better, I forgot that you can specify sort descriptors in Interface Builder! Having done that, sorting is really easy:

    
- (void)tableView:(General/NSTableView *)tableView didClickTableColumn:(General/NSTableColumn *)tableColumn {
	// Sort the table
	General/NSSortDescriptor *sortDesc = [tableColumn sortDescriptorPrototype];
	if(sortDesc == nil)
		return;
	General/NSArray *sortDescriptors = General/[NSArray arrayWithObject:sortDesc];
	[dropContentsArray sortUsingDescriptors:sortDescriptors];
	[self setHasChanged:YES];
}


----

okay, great, I did the second option, using IB and the column clicking.  however, there is an option in IB for Ascending or Descending.  i want it to switch back and forth between the two when clicking the column.  IB already has this, kinda, with the Indicator Image switching back and forth between up and down arrows.  but is there anyway to get the sort to change?  this was my idea:

    
- (void)tableView:(General/NSTableView *)tableView didClickTableColumn:(General/NSTableColumn *)tableColumn {
	
	General/NSSortDescriptor *tempDesc = [tableColumn sortDescriptorPrototype];
	General/NSSortDescriptor *sortDesc = General/[NSSortDescriptor alloc];
	if(sortDesc == nil)
		return;

	if( [tableView indicatorImageInTableColumn:tableColumn] == General/[NSImage imageNamed:@"General/NSDescendingSortIndicator"] ) {
		sortDesc = General/[NSSortDescriptor initWithKey:[tempDesc key] ascending:YES];
		[tableView setIndicatorImage:General/[NSImage imageNamed:@"General/NSAscendingSortIndicator"] inTableColumn:tableColumn];
	}
	else if( [tableView indicatorImageInTableColumn:tableColumn] == General/[NSImage imageNamed:@"General/NSAscendingSortIndicator"] ) {
		sortDesc = General/[NSSortDescriptor initWithKey:[tempDesc key] ascending:NO];
		[tableView setIndicatorImage:General/[NSImage imageNamed:@"General/NSDescendingSortIndicator"] inTableColumn:tableColumn];
	}

	General/NSArray *sortDescriptors = General/[NSArray arrayWithObject:sortDesc];
	[dropContentsArray sortUsingDescriptors:sortDescriptors];
	[tableView reloadData];

}


so basically, the sort descriptor in the IB table is copied, and the appropriate ascending/descending direction is applied, based on the image that is in the table column.  this, however, doesn't work.  does anyone else have any ideas?

The image comparisons certainly won't work; General/[NSImage imageNamed:@"General/NSDescendingSortIndicator"] probably creates a new instance that won't have the same address as the indicator image... Try saving the sorting direction in your data source. Also note that General/NSSortDescriptor has a method named -General/[NSSortDescriptor reversedSortDescriptor] General/EnglaBenny

----

I think that's what the following table view dataSource method is for:

    

- (void)tableView:(General/NSTableView *)aTableView sortDescriptorsDidChange:(General/NSArray *)oldDescriptors;



So, basically, you get rid of the tableView:didClickTableColumn: method and use the tableView:sortDescriptorsDidChange: method instead. When the app is running, and you click on one of the column headers, it has the effect of changing the sort descriptors. So, you could use the following method to give sorting functionality:

    

- (void)tableView:(General/NSTableView *)tableView sortDescriptorsDidChange:(General/NSArray *)oldDescriptors {
	General/NSArray *newDescriptors = [tableView sortDescriptors];
	[myDataSourceArray sortUsingDescriptors:newDescriptors];
	[tableView reloadData];
}



This seems to handle setting the correct image (up or down arrow) and highlighting the correct column all automatically. -- Mark Douma