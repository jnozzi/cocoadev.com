add this method as a category or subclass method of General/NSOutlineView

    
- (General/NSArray *)selectedItems
{
	General/NSIndexSet *selectedRowsIndexSet = [self selectedRowIndexes];
	int i;
	
	General/NSMutableArray *itemsArray = General/[NSMutableArray array];
	while ((i = [selectedRowsIndexSet indexGreaterThanIndex:i]) != General/NSNotFound) {
		[itemsArray addObject:[self itemAtRow:i]];
	}
	
	return itemsArray;
}
