This is put onto the pasteboard by Safari (1.0, probably also earlier).

It contains (for a single link), a property list that represents an array containing two arrays.
Here's some code to get at it, for the common case, with minimal error checking:

<code>
if([[pboard types] containsObject:@"[[WebURLsWithTitlesPboardType]]"]){
	    pbArray = [pboard propertyListForType:@"[[WebURLsWithTitlesPboardType]]"];
	    [[NSArray]] ''[[URLarray]] = [pbArray objectAtIndex:0];
	    if([[URLarray]]){
		url = [[[URLarray]] objectAtIndex:0];
	    }else{
		url = @"";
	    }
	    [[NSArray]] ''titleArray = [pbArray objectAtIndex:1];
	    if(titleArray){
		title = [titleArray objectAtIndex:0];
	    }else{
		title = @"";
	    }
	    // just one of many fascinating uses!
	    replacement = [[[NSString]] stringWithFormat:@"<a href=\"%@\" title=\"%@\">%@</a>",
		url, title, title];
}
</code>
This code is from Blapp.