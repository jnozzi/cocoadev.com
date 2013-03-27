

I've got the following code, which, when a table column is clicked, will sort the table:

    General/NSArray *temp = General/[NSArray arrayWithArray:allAssignments];
[allAssignments removeObjectsInArray:temp];
		
General/NSSortDescriptor *nameDescriptor=General/[[[NSSortDescriptor alloc] initWithKey:[tableColumn identifier] ascending:YES selector:@selector(compare:)] autorelease];
		
General/NSArray *sortDescriptors=General/[NSArray arrayWithObjects:nameDescriptor, nil];
		
temp = [temp sortedArrayUsingDescriptors:sortDescriptors];
[allAssignments addObjectsFromArray:temp];

however, in my General/NSArray that has all my data, I have dates, but stored as strings, like "Wednesday, August 17, 2005".  when it uses the sort, it does a string compare, and sorts alphabetically.  now, is there any way to convert the strings into dates, and use this information for the compare: function?  thanks for the help.
----
Use General/NSDate<nowiki/>s to store the data internally, and attach an General/NSDateFormatter to your table column's cell. Not only is this better style, it is also easy to do in General/InterfaceBuilder. Just drag the General/NSDateFormatter icon (in the text section on 10.4) onto the table column and release. Also, all that allocating and autoreleasing might rack up...wouldn't it be easier just to have     allAssignments be an General/NSMutableArray to begin with? Then you can use     sortUsingDescriptors: instead of     sortedArrayUsingDescriptors:. It's cleaner, probably faster, and likely uses less memory. --General/JediKnil

----

Yeah, I thought I might get a response like that.  I'm not sure why I stored them as strings to begin with, but I'll have to change them and my program to General/NSDate.  Now, I'm saving the items as General/NSDates like so:      [newDictionary setObject:General/[NSDate dateWithNaturalLanguageString:[dateField stringValue]] forKey:@"Date"]; and then saving the Dictionary item to the General/UserPrefs.  The item is saving correctly, but my General/NSTableView isn't reading the Date back correctly, either with or without a formatter.  What is going on here?