I am having a problem with an General/NSTableView not responding to reloadData (and similar methods) after the initial load.  

I'm using an array controller binding and it seems to work fine on the initial call to [myTableView reloadData] (in awakeFromNib)
My General/NSLog spits out the expected row count and row/column data from inside my 

    
- (int)numberOfRowsInTableView:(General/NSTableView *)aTableView
and
tableView:(General/NSTableView *)aTableView objectValueForTableColumn:(General/NSTableColumn *)aTableColumn row:(int)rowIndex

and my General/TableView is filled in as expected.

However, if I update my General/NSMutableArray dataSource, and call [myTableView reloadData] (in setAry),
My General/NSLog spits out the expected row count and row/column data from inside my numberofRowsInTableView and objectValueForTableColumn calls, but the table does not update (still has the data from the awakeFromNib).
This is true even if the number of objects in the array changes (including being zero).

Here's a sampling of my (not so) clever code:

    
- (id)initWithAry:(General/NSMutableArray *)ary
{
    id me = nil;
    do
    {
        me = [self init];
        if (! me)
            break;  // NOTE: I never hit this
        
           myObjAry = ary;

    } while (false);
    return me;
}


    
- (void)awakeFromNib
{
    //[myTableView reloadData];
    [myTableView setNeedsDisplayInRect: [myTableView rectOfColumn:0] ]; 
    [myTableView setNeedsDisplayInRect: [myTableView rectOfColumn:1] ]; 
}



    
- (void)setAry:(General/NSMutableArray *)ary
{
    // Having a problem displaying updates to the table (the awakeFromNib() call updates the table,
    // but calls directly to setAry() do not.....even though General/NSLog's in the delegates show the correct data 

    
    // Tried this to update the table, but it just clears out the rows (as expected)
    // but the next call doesn't re-add them (even though the delegates are able to General/NSLog the correct info)
    //[myObjAry removeAllObjects];
    //[myTableView reloadData];

    // update the dataSource for the table view with new data
    myObjAry = ary;
    
    //these General/MethodX's all produce the same results:
    //  * OK when called from awakeFromNib() (ie first time the table is filled),
    //  * no General/TableView update when called directly (even though delegates are called and are able to show (via General/NSLog) the updated myAry)
    //    (ie. on all subsequent table reloads)
    
    // Method1, 
    //[myTableView reloadData];
    
    // Method2
    [myTableView setNeedsDisplayInRect: [myTableView rectOfColumn:0] ]; 
    [myTableView setNeedsDisplayInRect: [myTableView rectOfColumn:1] ]; 
    
    // Method3
    //[myTableView reloadDataForRowIndexes:General/[[NSIndexSet alloc] initWithIndexesInRange:(General/NSRange){0,                      2}]
    //                                columnIndexes          :General/[[NSIndexSet alloc] initWithIndexesInRange:(General/NSRange){0, [myAry count]}]];
}



    
- (int)numberOfRowsInTableView:(General/NSTableView *)aTableView
{
    return [myObjAry count]; // General/NSLog shows the expected count
}



    
- (id)tableView:(General/NSTableView *)aTableView objectValueForTableColumn:(General/NSTableColumn *)aTableColumn row:(int)rowIndex
{
    id retObj=nil;
    if ([myObjAry count])
    {
        General/MyObj *myObj = [myObjAry objectAtIndex:rowIndex];
        if ([aTableColumn identifier] == @"General/ObjectName")
        {
            retObj =[myObj name]; // General/NSLog here shows that we have the expected data in myObj
        }
        if ([aTableColumn identifier] == @"General/ObjectValue")
        {
            retObj = General/[[NSNumber alloc] initWithInt:[myObj val]];  // General/NSLog here shows that we have the expected data in myObj
           [retObj autorelease];
        }
    }
     return retObj;
}


Other Notes:

* toggling the column header (to sort columns) doesn't update the data in the Table

* calling setNeedsDisplay on the General/NSTableView superviews doesn't update the data in the Table

* editting the data in table causes the data to be updated in the table (and reloadData doesn't overwrite this edited tableview data)