General/NSTableColumn is the class used by General/NSTableView to display a column of data cells, including the header cell at the top. Most of the stuff you would do with General/NSTableColumn has been referenced on other pages, mostly about General/NSTableView. *(If anyone can find these pages, please add them here)*

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Objc_classic/Classes/General/NSTableColumn.html
----


I am calling setBackgroundColor in dataCellForRow overide function in my subclass General/MyTableColumn as following:

    
/* General/MyTableColumn.m */

-(id)dataCellForRow:(int)row
{
    id theCell = [super dataCellForRow:row];
    if([theCell respondsToSelector:@selector(setBackgroundColor:)])
    {
        if(row%2)
            [theCell setBackgroundColor:General/[NSColor grayColor]];
        else
            [theCell setBackgroundColor:General/[NSColor whiteColor]];
    }
    return theCell;
}



But for some reason, the colors won't reflect on the tableview.  Can someone tell me what I am doing wrong here?  Thanks.

----

Check out:      - (void)tableView:(General/NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(General/NSTableColumn *)aTableColumn row:(int)rowIndex - That's the method you should be doing this in. ;-) Adding: Read the docs, this is a delegate method of General/NSTableView - this should go in the table's delegate and its - the table view's - delegate should be set.