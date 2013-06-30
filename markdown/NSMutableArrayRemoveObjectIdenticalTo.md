**When removing a set of selected objects from a mutable array, check for object identity, not simply equality, w.r.t. the base array**

----

Here's a familiar class for implementing a simple table view, given in its entirety; I made a slight modification to it to use an General/NSIndexSet
when deleting multiple records from the table. If all the records are unique, things work fine, but if two records contain dictionaries
with identical content, all records with that content will be deleted, ignoring whether they were selected before deletion.

I expected that the enumerator for adding the objects to a temp array before deleting will only add the objects that I selected.

    
#import <Cocoa/Cocoa.h>

@interface General/BTVController: General/NSObject
{
	General/IBOutlet General/NSTextField *addressField;
	General/IBOutlet General/NSTextField *emailField;
	General/IBOutlet General/NSTextField *firstNameField;
	General/IBOutlet General/NSTextField *lastNameField;
	General/IBOutlet General/NSTableView *tableView;
	
	General/NSMutableArray *records;
}

- ( General/NSMutableDictionary * ) createRecord;

- ( General/IBAction ) addRecord: ( id ) sender;
- ( General/IBAction ) deleteRecord: ( id ) sender;
- ( General/IBAction ) insertRecord: ( id ) sender;
 
@end


    
#import "General/BTVController.h"

@implementation General/BTVController

- ( id ) init
{
	if ( self = [ super init ] )
	{
		records = [ [ General/NSMutableArray alloc ] init ];
	}
	
	return self;
}

- ( void ) dealloc
{
	[ records release ];
	[ super dealloc ];
}

- ( General/NSMutableDictionary * ) createRecord
{
	General/NSMutableDictionary *theRecord = [ General/NSMutableDictionary dictionary ];
	[ theRecord setObject: [ firstNameField stringValue ] forKey: @"firstName" ];
	[ theRecord setObject: [ lastNameField stringValue ] forKey: @"lastName" ];
	[ theRecord setObject: [ addressField stringValue ] forKey: @"address" ];
	[ theRecord setObject: [ emailField stringValue ] forKey: @"email" ];
	return theRecord;
}

- ( General/IBAction ) addRecord: ( id ) sender
{
	[ records addObject: [ self createRecord ] ];
	[ tableView reloadData ];
}

- ( General/IBAction ) deleteRecord: ( id ) sender
{
	General/NSEnumerator *enumerator;
	General/NSMutableArray *tempArray;
	General/NSIndexSet *set;
	id tempObject;
	int i = 0;
	
	enumerator = [ records objectEnumerator ];
	tempArray = [ General/NSMutableArray array ];
	set = [ tableView selectedRowIndexes ];
	
	while ( tempObject = [ enumerator nextObject ] )
	{
		if ( [ set containsIndex: i ] )
			[ tempArray addObject: [ records objectAtIndex: i ] ];
		i += 1;
	}
	
	[ records removeObjectsInArray: tempArray ];

	[ tableView reloadData ];
}

- ( General/IBAction ) insertRecord: ( id ) sender
{
	int index = [ tableView selectedRow ];
	if ( index >= 0 )
		[ records insertObject: [ self createRecord ] atIndex: index ];
	[ tableView reloadData ];
}

// General/NSTableDataSource methods

- ( int ) numberOfRowsInTableView: ( General/NSTableView * ) aTableView
{
	return [ records count ];
}

- ( id ) tableView: ( General/NSTableView * ) aTableView
	objectValueForTableColumn: ( General/NSTableColumn * ) aTableColumn row: ( int ) rowIndex
{
	id theRecord, theValue;
	
	theRecord = [ records objectAtIndex: rowIndex ];
	theValue = [ theRecord objectForKey: [ aTableColumn identifier ] ];
	
	return theValue;
}

// General/NSTableDataSource method that we implement to edit values directly in the table...

- ( void ) tableView: ( General/NSTableView * ) aTableView setObjectValue: ( id ) anObject
	forTableColumn: ( General/NSTableColumn * ) aTableColumn row: ( int ) rowIndex
{
	id theRecord;
	
	theRecord = [ records objectAtIndex: rowIndex ];
	[ theRecord setObject: anObject forKey: [ aTableColumn identifier ] ];
}

@end


----

    

- ( General/IBAction ) deleteRecord: ( id ) sender
{
        General/NSEnumerator *enumerator;
        General/NSMutableArray *tempArray;
        General/NSIndexSet *set;
        id tempObject;
        int i = 0;

        enumerator = [ records objectEnumerator ];
        tempArray = [ General/NSMutableArray array ];
        set = [ tableView selectedRowIndexes ];

        while ( tempObject = [ enumerator nextObject ] )
        {
                if ( [ set containsIndex: i ] )
                        [ tempArray addObject: [ records objectAtIndex: i ] ];
                i += 1;
        }

        [ records removeObjectsInArray: tempArray ];

        [ tableView reloadData ];
}


Why are you using an object enumerator when you are stepping the variable "i" to do the same thing?

    
    int count = [records count];
    while (count--) {
        if ([set containsIndex:count]) [tempArray addObject:[records objectAtIndex:count]];
    }


Actually the better thing to do would be this;

    
    if ([set count]) {
        int i = [set firstIndex];
        do
              [tempArray addObject: [records objectAtIndex:i]];
        while        ((i = [set indexGreaterThanIndex:i]) != General/NSNotFound);
    }



----

I expect it's because you're removing based on equality, not identity. Try going through the array of objects to remove and use     removeObjectIdenticalTo: