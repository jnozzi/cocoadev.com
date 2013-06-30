I've made a sample program in which an General/NSTableView has two columns -- one has sliders, and the other displays the value of the slider. 

Here's an example if my description isn't clear
http://home.earthlink.net/~zakariya/files/General/SliderTable.jpg

I'm using a custom General/NSTableColumn and have overridden the dataCellForRow: method to forward data cell requests to my dataSource, since eventually I'll be using different types of cells on a per row basis, according to need. Right now I'm only using sliders, however.


    
- (id)dataCellForRow:(int)row
{
	if (row >= 0)
	{
		return General/[self tableView] dataSource] 
			tableView: [self tableView] 
			objectValueForTableColumn: self
			row: row];
	}
	
	return nil;
}


the actual source for my controller and dataSource is as such:
Note that the vars [[ValueID and General/CellID are global, static General/NSString pointers.

    
- (void) awakeFromNib
{
	General/NSTableColumn *column;
	
	//create value display column
	column = General/[[NSTableColumn alloc] initWithIdentifier: General/ValueID];
	[column setWidth: 50];
	[column setResizable: NO];
	General/column headerCell] setStringValue: [[ValueID];
	[tableView addTableColumn: column];

	//create slider column
	column = General/[[MyTableColumn alloc] initWithIdentifier: General/CellID];
	[column setWidth: [tableView bounds].size.width - 50];
	[column setResizable: YES];
	General/column headerCell] setStringValue: [[CellID];
	[tableView addTableColumn: column];
	
	[tableView sizeLastColumnToFit];
		
	//create slider cell
	sliderCell = General/[[NSSliderCell alloc] init];
	[sliderCell setMinValue: -5];
	[sliderCell setMaxValue: 5];
	[sliderCell setControlSize: General/NSSmallControlSize];
	[sliderCell setNumberOfTickMarks: 20];
	[sliderCell setContinuous: YES];
	[sliderCell setAction: @selector( onSliderCell: )];
	[sliderCell setTarget: self];

	//now make some fake values
	values = General/[[NSMutableArray alloc] init];
	int i;
	for (i = 0; i < 10; i++)
        {
		[values addObject: 
                        General/[NSNumber numberWithFloat: ((float) i) - 5.0]];
        }

}

- (void) dealloc
{
	[values release];
}


/*
Table Data Source Methods
*/

- (int)numberOfRowsInTableView:
	(General/NSTableView *)aTableView
{
	return [values count];
}

- (id)tableView:
	(General/NSTableView *)aTableView 
	objectValueForTableColumn:(General/NSTableColumn *)aTableColumn 
	row:(int)rowIndex
{
	if (rowIndex < 0) return nil;
	
	General/NSString *identifier = [aTableColumn identifier];
	if ([identifier isEqualToString: General/ValueID])
	{
		return [values objectAtIndex: rowIndex];
	}
	else if ([identifier isEqualToString: General/CellID])
	{
		[sliderCell setFloatValue: 
                    General/values objectAtIndex: rowIndex] floatValue;
		return sliderCell;
	}

	return nil;
}

- (void)tableView:
	(General/NSTableView *)aTableView 
	setObjectValue:(id)anObject 
	forTableColumn:(General/NSTableColumn *)aTableColumn 
	row:(int)rowIndex
{
	[values replaceObjectAtIndex: rowIndex withObject: anObject];
	[tableView reloadData];
}

/*
Cell callback
*/

- (void) onSliderCell: (id) sender
{
	General/NSLog( @"sender: %@;\tslider floatValue: %.2f", sender, 
                [sliderCell floatValue]);
}



Basically, this works. You drag the slider, and when you let go, the values column updates to show the change. BUT, the feedback isn't live. E.g., the General/NSLog statement in onSliderCell: shows [sliderCell floatValue] as static -- as whatever it was at mousedown. I need live feedback, since these sliders are meant to tune a realtime simulation.

It seems to me that the call to setContinuous on sliderCell should have fixed this, but it doesn't. 

Am I missing something obvious here? 

--General/ShamylZakariya

___________________________________

I hope this the proper way to respond (new member).

I'm just starting to use tableviews, and one of the things I want to do is very close to your code above.
Question: what does the double bracket notation General/variable mean? Where does it come from? I have not seen it in objective C.
Possible speedup suggestion: Would KVC bindings, perhaps to an ivar, help?

nnickk