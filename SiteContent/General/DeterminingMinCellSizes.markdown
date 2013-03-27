I have a tableView in which I want to enable variable row heights.  I am using the method - (float)tableView:(General/NSTableView *)tableView heightOfRow:(int)row, but once within that I can't find a way to determine the optimal size for the cell. 

Basically, the tableColumn has a set width, and each cell has a string value.  I want to determine how many lines of text the cell would use if it could be as big as it wants.  I can't for the life of me find any methods to this effect; it seems like everything is geared towards you telling the table and its cell everything.  I was shocked to find that there is no way to get the cellforrow:column:, which of course is impossible because unlike General/NSMatrix, the tablecolumn only has 1 cell.

I started writing a parser of sorts which was breaking up the cell's content string up with newlines, then determining how manay lines would be needed for each regular line based on characters, but of course that doesn't work because text is variable width.  The problems keep piling on.

therefore, Q:  Given a string, and a width, how can I find out how many units of height I will need to draw the text?  any help would be greatly, eternally appreciated.

----

Ok, here's how I got this to work, though it is probably not the ideal way.

    
 
 @interface myTableViewDelegate : General/NSObject 
 {
 	General/NSTextView *stuntDouble;
 }
 @end
 
 
 @implementation myTableViewDelegate
 
 - (void)awakeFromNib
 {
 	stuntDouble = General/[[NSTextView alloc] initWithFrame:General/NSInsetRect([self frame], 8, 0)];
 		[stuntDouble setMinSize:General/NSMakeSize(0,0)];
 		[stuntDouble setHorizontallyResizable:NO];
 		[stuntDouble setVerticallyResizable:YES];
 }
 
 - (float)tableView:(General/NSTableView *)tableView heightOfRow:(int)row
 {	
 	//If the row in question is not the selected row, defer to the standard one-line height
 	if ( !(General/[[[NSApp delegate] valueForKey:@"resultsController"] selectionIndex] == row) )
 		return General/[[[NSApp delegate] valueForKey:@"resultsTable"] rowHeight];
 	
 	//Otherwise, feed it to the textview and see what the suggested height is
 	[stuntDouble setString:General/[[[[[NSApp delegate] valueForKey:@"resultsController"] arrangedObjects] objectAtIndex:row] valueForKey:@"content"]];
 	[stuntDouble sizeToFit];
 	return [stuntDouble frame].size.height + 5; //My implementation is off, even with this correction, by about 10%
 }
 


----
Check out     cellSizeForBounds:. Send that to an General/NSTextFieldCell with the appropriate string and attributes set. (The table column's data cell would be a good choice.) Give it a bounds with the right width and a very large height. It will give you a size with the appropriate height for the bounds' width.

----
You know, I tried to get cellSizeForBounds to work for hours and couldn't find out how to make it return a non-zero value.  Not to mention the fact that I was getting infinite recursion due to my requesting the cellFrameAtRow which of course requests heightOfRow.  But, a good night's sleep later, and you're absolutely right.  The correct method is:

    
 - (float)tableView:(General/NSTableView *)tableView heightOfRow:(int)row
 {	
 	//If the row in question is not the selected row, defer to the standard one-line height
 	if ( !(General/[[[NSApp delegate] valueForKey:@"resultsController"] selectionIndex] == row) )
 		return General/[[[NSApp delegate] valueForKey:@"resultsTable"] rowHeight];
 	
 	//See if there is any text in the first place to be measuring (to avoid exceptions)
 	General/NSString *contentString = General/[[[[[NSApp delegate] valueForKey:@"resultsController"] arrangedObjects] objectAtIndex:row] valueForKey:@"content"];
 	if ( !contentString )
 		return General/[[[NSApp delegate] valueForKey:@"resultsTable"] rowHeight];
 
 	//Otherwise, feed it to the dataCell and see what the suggested height is
 	id cell = General/[[[[NSApp delegate] valueForKey:@"resultsTable"] tableColumnWithIdentifier:@"content"] dataCell];
 		[cell setStringValue:contentString];
 	General/NSRect tallRect = General/NSMakeRect(0, 0, General/[[[NSApp delegate] valueForKey:@"resultsTable"] frame].size.width, 10000); //Or 1000000000...
 	return [cell cellSizeForBounds:tallRect].height;
 }


As expected, this code is faster, more accurate, and has less sprawl (instance vars and associated checks and maintenance).  Plus, it's purdy.  Thanks a bunch!

----
Looks like you figured it out. I just have one more suggestion to make the code even purdier. Instead of referring to     General/[[NSApp delegate] valueForKey:@"resultsTable"] all over the place, you can just use that     tableView argument that the method receives. This will compactify the code (I love making up words) a bit and make it more generic in case you want to reuse it elsewhere.

On the subject of genericity, it probably would be a good idea to use the column's width rather than the table's width, in case you end up using a multicolumn table.