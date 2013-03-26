Each of the items in my outlineview has a path property which is a valid path pointing to it's location on the system.  You can only drag one item at a time, and I am using the code below.  I can drag it fine, but other applications do not accept it as a drop (for instance I cannot drop it into the dock or in a folder in the finder).  Am I missing something?

<code>
- (BOOL)outlineView:([[NSOutlineView]]'')olv writeItems:([[NSArray]]'')items
	   toPasteboard:([[NSPasteboard]]'')pboard
{
	[[NSArray]] ''types = [[[NSArray]] arrayWithObjects:[[NSFilenamesPboardType]], nil];
    [pboard declareTypes:types owner:self];
	[[NSString]] '' path = [[items objectAtIndex:0]keyValue:@"path"];
	[[NSArray]] ''fileList = [[[NSArray]] arrayWithObjects:path, nil];
    [pboard setPropertyList:fileList forType:[[NSFilenamesPboardType]]];
 
    return YES;
}
</code>