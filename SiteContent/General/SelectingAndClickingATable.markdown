when a user single-clicks the row in the table, an action is invoked.  elsewhere, i have <code>[tableView selectRowIndexes:[[[NSIndexSet]] indexSetWithIndex:variable] byExtendingSelection:NO];</code>, which selects the appropriate row.  however, I want to invoke that same single-click action.  how do i do that?

----
I would guess <code>[[tableView target] performSelector:[tableView action] withObject:tableView];</code> This is the usual way that actions are sent by subclasses of [[NSView]]. --[[JediKnil]]