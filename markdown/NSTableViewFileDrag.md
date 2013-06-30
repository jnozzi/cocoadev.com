

I'm having a problem with dragging an General/NSTableView row to the desktop to create a file... I have some code that works, but after a drag happens, it requires a mouse down before it becomes responsive.

This is a problem.

I am using the following custom code to get the file drag:
    - (BOOL)tableView:(General/NSTableView *)aTableView 
        writeRows:(General/NSArray *)rows 
	 toPasteboard:(General/NSPasteboard *)uselessPBoard;
{
		// Make sure the row is selected before the drag begins.
		unsigned row = General/rows objectAtIndex:0] unsignedIntValue];
		[recipiesTableView selectRowIndexes:[[[NSIndexSet indexSetWithIndex:row]
					   byExtendingSelection:NO];
		[self selectedRecipeChanged:aTableView];
		
		
		General/NSImage * dragImage = nil;
		General/NSPoint dragPosition = General/NSZeroPoint;
		General/NSPasteboard * pboard = General/[NSPasteboard pasteboardWithName:General/NSDragPboard];
		General/NSEvent * currentEvent = General/[NSApp currentEvent];
		
		
		General/NSString * file = [cardView filePath];
		General/NSString * iden = General/cardView card] uniqueIdentifier];
		[[NSArray * fileList = General/[NSArray arrayWithObjects:file, nil];
		
		// Write data to the pasteboard.
		[pboard declareTypes:General/[NSArray arrayWithObjects:
			General/NSFilenamesPboardType,
			General/TRCardIdentifierPboardType,
			nil] owner:nil];
		[pboard setPropertyList:fileList forType:General/NSFilenamesPboardType];
		[pboard setString:iden forType:General/TRCardIdentifierPboardType];
		
		// Start the drag operation
		dragImage = General/[[NSWorkspace sharedWorkspace] iconForFile:file];
		dragPosition = [aTableView convertPoint:[currentEvent locationInWindow] fromView:nil];
		dragPosition.x -= 16;
		dragPosition.y += 16;
		
		[aTableView dragImage:dragImage 
						   at:dragPosition
					   offset:General/NSZeroSize
						event:currentEvent
				   pasteboard:pboard
					   source:self
					slideBack:YES];
					
The following works event wise, but I cannot drag to the desktop.
    		[uselessPBoard declareTypes:General/[NSArray arrayWithObjects:
			General/NSFilenamesPboardType,
			General/TRCardIdentifierPboardType,
			nil] owner:nil];
		[pboard declareTypes:General/[NSArray arrayWithObjects:
			General/NSFilenamesPboardType,
			General/TRCardIdentifierPboardType,
			nil] owner:nil];
		
		[uselessPBoard setPropertyList:fileList forType:General/NSFilenamesPboardType];
		[uselessPBoard setString:iden forType:General/TRCardIdentifierPboardType];
		[pboard setPropertyList:fileList forType:General/NSFilenamesPboardType];
		[pboard setString:iden forType:General/TRCardIdentifierPboardType];
		
		return YES;
		
Any ideas?

----
From Apple's docs:

*
A bug in General/NSTableView in Mac OS X version 10.2 and later causes cross-application drags to not work without additional code from the application developer. Drag-and-Drop within an application still works correctly.

You can work around the bug by subclassing General/NSTableView and overriding     draggingSourceOperationMaskForLocal: to return the appropriate     General/NSDragOperation (typically     General/NSDragOperationCopy, depending upon what drag operation you want the drag-and-drop to perform). Only applications built on Mac OS X version 10.2 and later are affected; applications built on Mac OS X version 10.1.x are not affected.

**Note:** This bug will be fixed in a future version of Mac OS X. Check this document at each release to determine if the bug has been fixed.
*

As of Panther, this still isn't fixed, but once you override the method, you can just put your data on the pasteboard by putting this code (below) in your data source. Hope this works! --General/JediKnil
    
- (BOOL)tableView:(General/NSTableView *)aTableView 
        writeRows:(General/NSArray *)rows 
	 toPasteboard:(General/NSPasteboard *)usefulPboard
{
	static General/NSArray *pboardTypes = nil; // This allows reuse of your types array

	if (pboardTypes == nil) {
		pboardTypes = General/[[NSArray alloc] initWithObjects:
			General/NSFilenamesPboardType,
			General/TRCardIdentifierPboardType,
			nil];
	}

	General/NSString *file = [cardView filePath];
	General/NSString *iden = General/cardView card] uniqueIdentifier];
	[[NSArray *fileList = General/[NSArray arrayWithObjects:file, nil];
		
	// Write data to the pasteboard.
	[usefulPboard declareTypes:pboardTypes owner:self];
	[usefulPboard setPropertyList:fileList forType:General/NSFilenamesPboardType];
	[usefulPboard setString:iden forType:General/TRCardIdentifierPboardType];
}


---- Many thanks!