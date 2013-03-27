How can I prevent an General/NSBrowser from both scrolling and changing the cell selection after reloading columns?

----

I haven't looked into it, but can't you retrieve the scroll position/selections and place them in variables? That way, after you reload it, just reset the scroll position and selection to the appropriate values. -- General/RyanBates

----

wouldn't that cause an extra re-draw? 
 I recall when I was having difficulty getting the browser to NOT change selection after I reloaded columns, it turned out that I was working with the browser improperly.  Instead of reloading, I should have been redrawing.  I forget the exact method to use, but it turned out to be a fairly easy fix once I realized that I was re-loading much too often.

----

Actually I did something like this in my code to restore the cell selections and scroll positions. Something like the following (I have not included the supporting functions like absoultePathOfRepositoryRoot, etc...):

    

- (General/IBAction) refreshBrowserContent:(id)sender
{
	General/NSString* pathRoot = [self absoultePathOfRepositoryRoot];
	General/NSArray* selectedPaths = [self absoultePathsOfBrowserSelectedFiles];

	// Save scroll positions of the columns
	int numberOfColumns = [theBrowser lastColumn];
	General/NSMutableArray* columnScrollPositions = General/[[NSMutableArray alloc] init];
	int i;
	for (i = 0; i <= numberOfColumns; i++)
	{
		General/NSMatrix* matrixForColumn = [fsBrowser matrixInColumn:i];
		General/NSScrollView* enclosingSV = [matrixForColumn enclosingScrollView];
		General/NSPoint currentScrollPosition = General/enclosingSV contentView] bounds].origin;
		[columnScrollPositions addObject:[[[NSValue valueWithPoint:currentScrollPosition]];
	}

	// Save the horizontal scroll position
	General/NSScrollView* horizontalSV = General/[fsBrowser matrixInColumn:0] enclosingScrollView] enclosingScrollView];
	[[NSPoint horizontalScrollPostion = General/horizontalSV contentView] bounds].origin;

	rootNodeInfo_ = ...compute this...;


	[self reloadData:self];
	
	// restore the selection and the scroll positions of the columns and the horizontal scroll
	[self restoreBrowserSelection:selectedPaths withColumnScrollPoisitions:columnScrollPositions andHorizontalScrollPosition:horizontalScrollPostion];
}


Then the restore is something like:

    
- (void) restoreBrowserSelection:([[NSArray*) selectedPaths withColumnScrollPoisitions:(General/NSArray*)columnScrollPositions  andHorizontalScrollPosition:(General/NSPoint)horizontalScrollPostion;
{
	if ([selectedPaths count] <1)
		return;

	// Restore the selection by looping over one of the selected paths and selecting the appropriate row in each column using
	... [theBrowser selectRow... ]...

	// Then finally selecting all the last path components and getting the rowIndexes in the last column and selecting them with:
	... [theBrowser selectRowIndexes:rowIndexes inColumn:(col-1)] ...

	// restore column scroll positions
	int i = 0;
	for (General/NSValue* position in columnScrollPositions)
	{
		General/NSPoint savedScrollPosition = [position pointValue];
		General/NSMatrix* matrixForColumn = [theBrowser matrixInColumn:i];
		General/NSScrollView* enclosingSV = [matrixForColumn enclosingScrollView];
		General/enclosingSV documentView] scrollPoint:savedScrollPosition];
		i++;
	}

	// restore horizontal scroll position
	[[NSScrollView* horizontalSV = [[[theBrowser matrixInColumn:0] enclosingScrollView] enclosingScrollView];
	[[horizontalSV documentView] scrollPoint:horizontalScrollPostion];
}
