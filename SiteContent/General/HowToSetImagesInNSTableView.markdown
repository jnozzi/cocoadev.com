I have an General/NSTableView, two columns one with a General/NSString, the other with a General/NSImage. I need an action that changes the General/NSImage column, of a selected row from its original image to a new one.

----

Just change it in your data source, Josha
----
What do you mean?

----

You can react to the table view's selection changing (as described in the answer to your question of a few days ago) by changing the image you return for     - (id)tableView:(General/NSTableView *)aTableView objectValueForTableColumn:(General/NSTableColumn *)aTableColumn row:(int)rowIndex

You'd learn a lot more about Cocoa by actually writing this application yourself, instead of asking everyone here to write it for you.