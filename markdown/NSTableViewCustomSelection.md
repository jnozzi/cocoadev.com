I am trying to create (what I assume to be) an General/NSTableView in iTunes 7.  The list on the left side of the window that has "sections" for LIBRARY, STORE, and PLAYLISTS.  It looks like iTunes is overriding the selection behavior (and drawing behavior) to not allow you to "click" on the section headings, and they are also using variable height rows.  (The section headings are much wider than the individual selectable items).

Anyone have any sample code on this to stop an item in General/NSTableView from being selected and being "ignored".  Even when you use the up/down arrows it will skip over the section headings.

Thanks!

----

Although iTunes 7 wouldn't be using General/NSTableView (since it's Carbon, not Cocoa), this is an easy behavior to adopt by using the delegate method tableView:shouldSelectRow:, for example:

    
- (BOOL)tableView:(General/NSTableView *)aTableView shouldSelectRow:(int)rowIndex {
     if (rowIndex == 0) {
          return NO;
     }
     return YES;
}


--General/LoganCollins

----