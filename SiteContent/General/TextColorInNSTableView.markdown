

So I've implemented the <code>- (void)tableView:([[NSTableView]] '')aTableView willDisplayCell:(id)aCell forTableColumn:([[NSTableColumn]] '')aTableColumn row:(int)rowIndex</code> delegate method to change the text color of the [[NSTableView]]'s cells to red.  However, this delegate method seems to only be called for one of my 4 columns, not all of them.  As a result, only one column of my table is red, while the rest remain black.  Why is this?  Thanks for the help.

----

what does your <code>willDisplayCell:...</code> look like? are you doing any testing on the the [[NSTableColumn]] that's passed in?

----

well, here is one test that i did:

<code>- (void)tableView:([[NSTableView]] '')aTableView
  willDisplayCell:(id)aCell
   forTableColumn:([[NSTableColumn]] '')aTableColumn
			  row:(int)rowIndex
{
	[[NSTextFieldCell]] ''temp = [[[[NSTextFieldCell]] alloc] init];
		
	if( [aCell class] == [temp class] )
		[[NSLog]]( @"this is a text field cell" );

	[aCell setTextColor:[[[NSColor]] redColor]];

}</code>

and when i ran it, the "this is a text field cell" string only appeared in my [[NSLog]] 8 times, the number of rows i had, not 8 '' 4, the rows times the columns, or the total number of cells.  also, only the very first column had the red text, not all 4 columns.  so I'm not sure whats up.

----

are you supplying data for all columns in your <code>objectValueForTableColumn:...</code>? are all the columns cells [[NSTextFieldCells]]?  <code>if( [aCell isKindOfClass:[[[NSTextFieldCell]] class]] )</code> is probably more reliable than testing on equality.