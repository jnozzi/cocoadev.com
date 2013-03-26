I have a [[NSTableView]] that I want to behave like the Dock when items are dragged out of it - the item disappears in a puff of smoke and is removed from the view. Any pointers on how to do that?
----
Have a look at the [[NSShowAnimationEffect]] function.

----

OK, I've done some work and got this ''looking'' right, but it's not actually doing anything. I drag the row out of the table view and I get the poof effect, but the drag snaps back and the row doesn't get removed. Here's my code:

<code>
@implementation [[MyTableViewSubclass]]

- (unsigned int)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
    return [[NSDragOperationDelete]];
}
- (void)draggedImage:([[NSImage]] '')anImage endedAt:([[NSPoint]])aPoint operation:([[NSDragOperation]])operation
{
    if ( ![[NSMouseInRect]]([[self window] convertScreenToBase:aPoint], [self bounds], NO) ) //is outside views bounds
    {
	[[NSShowAnimationEffect]]([[NSAnimationEffectDisappearingItemDefault]],
			      aPoint, [[NSZeroSize]], nil, nil, nil);
	
	[[self dataSource] tableView:self deleteRows:[self selectedRowIndexes]];
    }
}
@end

---

@implementation [[MyTableViewDatasource]]

- (BOOL)tableView:([[NSTableView]] '')tableView writeRows:([[NSArray]] '')rows toPasteboard:([[NSPasteboard]] '')pboard
{
    return YES;
}

- (BOOL)tableView:([[NSTableView]] '')sender deleteRows:([[NSIndexSet]] '')rows
{
    unsigned i = [rows firstIndex];
    
    while (i < [rows lastIndex]) 
    {
        int curRow = i;
        [tvArray removeObjectAtIndex:curRow];
	i = [rows indexGreaterThanIndex: curRow];
    }
    
    [sender reloadData];
    return YES;
}

@end
</code>

This has 2 (unrelated, I think) problems

1. It will only work if the row is selected, not simply clicked and dragged out of the view

2. It's not working anyway! Nothing is removed from the table after <code>reloadData</code>. Do I need to actually write the rows to the pasteboard in <code>- (BOOL)tableView: writeRows: toPasteboard:</code> even if I'm just going to immediately delete them?


The following [[NSView]] methods look like what I need, but I'm not sure how to implement them?

<code>- (BOOL)dragFile:([[NSString]] '')fullPath fromRect:([[NSRect]])aRect slideBack:(BOOL)slideBack event:([[NSEvent]] '')theEvent</code>

<code>- (void)dragImage:([[NSImage]] '')anImage at:([[NSPoint]])imageLoc offset:([[NSSize]])mouseOffset event:([[NSEvent]] '')theEvent pasteboard:([[NSPasteboard]] '')pboard source:(id)sourceObject slideBack:(BOOL)slideBack</code>

Any help is appreciated.

-John

----

If the row is not selected, you get the row that is being dragged via writeRows:([[NSArray]] '')rows. This alleviates problem number one. I prefer to always use that array, rather than using the selected row, as you probably noticed with your issues.

As for number two, remove the item you are dragging immediately as the drag starts. If the row is dropped back on the table, put it back in place. That is the way the dock works, and I am assuming that is how you want it. -- [[MatPeterson]]

----


I'm having a heck of a time figuring this out. Can anyone post an example of this?

----

Simply add this to your [[NSTableView]] subclass:

- (void)dragImage:([[NSImage]] '')anImage at:([[NSPoint]])imageLoc offset:([[NSSize]])mouseOffset
	event:([[NSEvent]] '')theEvent pasteboard:([[NSPasteboard]] '')pboard source:(id)sourceObject slideBack:(BOOL)slideBack {
	// Prevent slide back.
	[super dragImage:anImage at:imageLoc offset:mouseOffset event:theEvent pasteboard:pboard source:sourceObject slideBack:NO];
}

[[JulianCain]]