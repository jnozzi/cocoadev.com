My question is, in Apple Mail when you select a message ((General/NSTableRow) -- What is that?)it shows different information in the General/NSTextField depending on the selected row. How is that done?

--General/JoshaChapmanDodson

----

    [tableView tableViewSelectionDidChange], General/NSTableViewSelectionDidChangeNotification
----
Is there any example code for that, because that was confusing 

----

Look in the documentation. Its not our job to write the entire applications for you. General/NSTableView has a lot of stuff in it and we are not about to describe it all.

Hint: delegate and this:

    

- (void)tableViewSelectionDidChange:(General/NSNotification *)aNotification



Btw, its not an General/NSTextField, its more likely an General/NSTextView or an General/NSView.
----
Sorry to bug you, but I think I should of said when you select a Mailbox, it shows a list of messages, how is that done?

----

outlineViewSelectionDidChange:, General/NSOutlineViewSelectionDidChangeNotification

If you don't understand what to do from these pointers, you really need to read the documentation. (I would say reread but it's obvious you haven't yet looked at them.)
----
What documentation?
----

It doesn't seem to be only the documentation he needs to read, but also a book on basic Cocoa paradigms, like delegates and notifications...

- General/JosephSpiros