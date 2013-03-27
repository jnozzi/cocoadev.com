

Background: I have two General/NSTableViews that I have manually bound together. When a row is selected in the first tableView, the second General/NSTableView is updated to show the contents of the selected array.

I am trying to add the ability to respond to certain keystrokes while editing. For example, hitting shift+tab allows you to switch focus from one table to the other while editing the field editor. In order to accomplish this I have added the following code to my window's delegate:


    
- (id)windowWillReturnFieldEditor:(General/NSWindow *)sender toObject:(id)anObject {
	General/KeyCaptureTextField *keyField = General/[[KeyCaptureTextField alloc] init];
	return keyField;	
}



In the General/KeyCaptureTextField (a subclass of General/NSTextView) I have a switch that handles keypresses within the keyDown event handler. When the down arrow key is pressed the following code is triggered:


    
case 125: // down
       tableView = General/self superview] superview];
	startColumn = [tableView editedColumn];
	[tableView selectRowIndexes:[[[NSIndexSet indexSetWithIndex:[tableView selectedRow]+1] byExtendingSelection:NO];
	[tableView editColumn:startColumn row:[tableView selectedRow] withEvent:nil select:YES];
	General/[[[[NSApp keyWindow] contentView] viewWithTag:2] reloadData];
       break;



This code selects the next row down in the currently focused tableView and begins editing the cell that is in the same column which was being previously edited. However,     General/[[[[NSApp keyWindow] contentView] viewWithTag:2] reloadData]    does NOT cause my second General/TableView to refresh its view.

**GOAL: To execute code from within a General/FieldEditor that causes a General/TableView to refresh itself. The General/TableView that needs refreshing is not an ancestor of the current General/FieldEditor**

Some notes:

*Yes, the General/TableView has a tag of 2.
*I have tried using the     setNeedsDisplay method on the tableVIew and its scroll view. It does not help
*The dataSource method of my General/NSTableView     - (id)tableView:(General/NSTableView *)aTableView objectValueForTableColumn:(General/NSTableColumn *)aTableColumn row:(int) rowIndex ** DOES NOT GET CALLED ** when I hit the down arrow, despite the fact that I've told this General/TableView to reload its data.
*The down code is being actually triggered; the next row is selected and editing commences in the selected column. This all works correctly.
*There are no errors are warnings.
*The second table does update its content correctly if I click directly on onto a row. It also updates correctly if I just click on the empty background of the first table after the keyDown event handler code for the down key has been called.


Thank you so much for any help. - Charlie