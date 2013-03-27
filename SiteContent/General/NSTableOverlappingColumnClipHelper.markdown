
Describe General/NSTableOverlappingColumnClipHelper here.

I dont know what the title means and this is my problem. 
I have just coded my first application, and im leaning as i go, and the final hurdle is to alow my program to be saved.

I have an General/NSTableView which uses an General/NSDictionary instance  (wrapped in another object) as its datasource.
I have just performed an General/NSKeyedArchiver on the General/NSDictionary, the replacing the  General/NSDictionary  with the object returned by General/NSKeyedUnarchiver.

Running the program it crashes. I test the instance of General/NSDictionary throuout the program and its OK until it reaches this point....

- (id) tableView:(General/NSTableView *) aTableView
objectValueForTableColumn:(General/NSTableColumn *) aTableColumn
			 row:(int) rowIndex
{ 

General/NSLog(@"dictTest %@",myDict);

//rest of code	
}

And here the output of the log is "General/NSTableOverlappingColumnClipHelper" ?
A quick search on google, and on here, reveals nothing about "General/NSTableOverlappingColumnClipHelper". Anybody come across this before?

What does it mean?

----

It might mean that you have a memory management problem.  Your object may have been deallocated, and the space it occupied reused for something random (in this case, an object of some private class used by the General/AppKit).