I am trying to merge three column headers into one within a General/NSTableView. The three columns contain cells of type General/NSButtonCell and a size of 14x14. If would like to show a common header for the three columns with the title "Actions". I have been reading documentation about General/NSTableHeaderCell, but I really do not know where to start. Can anyone help?

----
Customizing a table view in this way is probably easier done by creating your own subclass of General/NSCell and using it in a single column. I've never heard of anyone actually combining table headers into one, and General/NSTableHeaderCell is rarely used directly anyway.
----

----
Would this General/NSCell have three General/NSButton inside?

Thanks for your help.
----
You'd probably find it easier to use an General/NSMatrix of three General/NSButtonCells.