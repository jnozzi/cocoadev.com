I have a non-document app that displays its data (a mutable array of [[CustomObject]] instances) in a table view and
writes data from the model objects  (all of whose ivars are strings) in property list format as follows in the data source for the table:

<code>
- ( void ) saveData
{
	[[NSSavePanel]] ''saveRecords = [ [[NSSavePanel]] savePanel ];
	[ saveRecords setTitle: @"Save Data" ];
	
	// Save data as XML dictionary
	
	if ( [ saveRecords runModal ] == [[NSOKButton]] )
	{
		[[NSEnumerator]] ''en = [ dataArray objectEnumerator ];
		[[CustomObject]] ''obj;
		[[NSMutableArray]] ''records = [ [[NSMutableArray]] array ];
		
		while ( obj = [ en nextObject ] )
		{
			[[NSMutableDictionary]] ''record = [ [[NSMutableDictionary]] dictionary ];
			[ record setObject: [ obj data1 ] forKey: @"data1" ];
			[ record setObject: [ obj data2  ] forKey: @"data2" ];
			[ records addObject: record ];
		}
		[ records writeToFile: [ saveRecords filename ] atomically: YES ];
	}
}
</code>

The file gets written properly as far as I can tell. Inspecting it shows a Root object with  a number of dictionaries
corresponding to how many custom objects were saved. All of the fields in these dictionaries contain the strings
from the interface at the time the file was saved. Bottom line, the data ARE saved to the file.

The code for loading the data is:

<code>
- ( void ) loadData
{
	loadRecords = [ [[NSOpenPanel]] openPanel ];
	
	[ loadRecords beginSheetForDirectory: nil file: nil types: [ [[NSArray]] arrayWithObject: @"" ]
		modalForWindow: mainWindow modalDelegate: self
		didEndSelector: @selector( openPanelDidEnd: returnCode: contextInfo: ) contextInfo: nil ];
}

- ( void ) openPanelDidEnd: ( [[NSOpenPanel]] '' ) panel returnCode: ( int ) code contextInfo: ( void '' ) info 
{
	if ( code == [[NSOKButton]] )
	{
		[[NSString]] ''path = [ loadRecords filename ];
		[ dataArray release ];
		
		dataArray = [ [ [[NSMutableArray]] alloc ] initWithContentsOfFile: path ];
	}
		
	[ tableView reloadData ];
}
</code>

When I load the data, a number of rows in the table view are filled with stuff I can't see. I know it's there because
subsequent records added to the table are appended below these rows. What is it that I am so clueless about?

This very much follows the pattern of published examples I have seen online, except for using the Save and Open panels.

I have tried setting the <code>types</code> for my file in various ways, nothing seems to work.

Yes, of course I could have made my life ''much'' easier by adopting the document architecture - I am only trying to learn something here.

''In your save routine, <code>dataArray</code> contains custom objects, which you translate to [[NSDictionaries]]. When you load the file, you just set the array of dictionaries directly to <code>dataArray</code>, without translating back to your custom objects. Unless you're doing something very strange, you have to translate those dictionaries back, as the opposite of your translation step in <code>-saveData</code>.''

----

Absolutely correct. I uncovered the above problem when I tried to save a file loaded from the XML. That, of course, did not work.

The correct solution for openPanelDidEnd: is

<code>
- ( void ) openPanelDidEnd: ( [[NSOpenPanel]] '' ) panel returnCode: ( int ) code contextInfo: ( void '' ) info 
{
	if ( code == [[NSOKButton]] )
	{
		[[NSArray]] ''tempArray;			// array of [[NSDictionary]] when loading from XML file
		[[NSEnumerator]] ''en;			// to extract the strings from temp array
		[[NSDictionary]] ''dict;			// for dict objects extracted from temp array
		
		[[NSString]] ''path = [ loadRecords filename ];
		[ dataArray release ];
		
		dataArray = [ [ [[NSMutableArray]] array ] retain ];
		tempArray = [ [ [[NSArray]] alloc ] initWithContentsOfFile: path ];
		en = [ tempArray objectEnumerator ];
		while ( dict = [ en nextObject ] )
		{
			[[DSContact]] ''contact = [ [ [[DSContact]] alloc ] init ];
			[ customObj setData1: [ dict objectForKey: @"data1" ] ];
			[ customObj setData2: [ dict objectForKey: @"data2" ] ];
			[ dataArray addObject: contact ];
		}
	}
		
	[ tableView reloadData ];
}
</code>