[http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Protocols/General/NSTableDataSource.html]

Informal protocol implemented by objects acting as a data source for an General/NSTableView to provide the table view with data to display. There are two methods that you **must** implement, and a few more optional methods that can be used to customize your table view's behavior.

The required two:

----

    - (NSI<nowiki/>nteger)numberOfRowsInTableView:(General/NSTableView *)aTableView

*Returns the number of records managed for aTableView by the data source object. An General/NSTableView uses this method to determine how many rows it should create and display* You typically return     [myTableViewArray count] here.

----

    - (id)tableView:(General/NSTableView *)aTableView objectValueForTableColumn:(General/NSTableColumn *)aTableColumn row:(NSI<nowiki/>nteger)rowIndex

*Returns an attribute value for the record in aTableView at rowIndex. aTableColumn contains the identifier for the attribute, which you get by using General/NSTableColumn�s identifier method.* A standard format is to store table view data as an General/NSArray of General/NSDictionaries, with the dictionary keys being the same as the identifiers for your table columns. So you'd return     General/myTableViewArray objectAtIndex: rowIndex] objectForKey:[aTableColumn identifier here.

----

**
NOTE CAREFULLY the advantages of using General/KeyValueCoding in accessing the ivars in the data source; this will go a long way toward making your table access methods crisp and clean
**

see also General/NSTableViewTutorial

To handle your table data with far less "glue" code, learn how to use General/CocoaBindings (for which, see the excellent tutorial at:

http://www.cocoadevcentral.com/articles/000080.php