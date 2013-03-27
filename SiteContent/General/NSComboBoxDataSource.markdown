General/NSComboBox Data Source - Populate General/NSComboBox from text file.

Basically, I want to populate an General/NSComboBox with the data from a text file.  The code I have is:

    
- (General/IBAction)populate:(id)sender
{
	General/NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];
	
	General/NSString *string;
	General/NSString *filename = @"dataSource.txt";
	
	string = General/[NSString stringWithContentsOfFile: filename];
	
	General/NSArray *array = [string componentsSeparatedByString:@"\n"];
	
	int visibleItems = [array count] - 1;
	
	[testCombo setUsesDataSource: YES];
	[testCombo setNumberOfVisibleItems: visibleItems];
	[testCombo addItemsWithObjectValues: array];
	
	[pool release];
}


The text file looks something like this:

    
dataItem1
dataItem2
dataItem3
....
etc


I have a button set to run the method "populate" when it is pressed, but ... it literally does nothing.  Any help pointing me in the right direction would be greatly appreciated.

Thanks,
Jason

----

Hm, I think setUsesDataSource should be NO.

----

Use the debugger, do some legwork. You can get far more specific than "it literally does nothing". Step through the method line by line, see where it's going wrong. Not only will you be able to give us more information, but you'll probably find out enough to solve the problem on your own.