**Question: How do I get mouse position changes during a drag and drop operation in a table view ?**

**Answer:**
The following method is called whenever the drag destination changes to a different row in the table view:
See http://developer.apple.com/documentation/Cocoa/Conceptual/General/TableView/Tasks/General/UsingDragAndDrop.html

-tableView:validateDrop:proposedRow:proposedDropOperation:

----
A more general technique that works for all views is the following:
-draggingUpdated:
http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Protocols/General/NSDraggingDestination.html

-draggingUpdated: is part of an informal protocol.  Informal protocols are described here:
http://developer.apple.com/documentation/Cocoa/Conceptual/General/ObjectiveC/General/LanguageOverview/chapter_3_section_7.html