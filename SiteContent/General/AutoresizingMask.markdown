An autoresizing mask is used to determine how a view is resized relative to its parent view when its parent view resizes. The enumeration values are masked together.

To have a view resize to fill its container, set it to General/NSViewWidthSizable | General/NSViewHeightSizable.

To have a view float in the center, set it to General/NSViewNotSizable.

----

Here is a handy function to create a string from a mask value. Helpful in certain instances for debugging:

    
General/NSString* General/StringFromAutoresizingMask(General/NSUInteger mask)
{
	if (mask == General/NSViewNotSizable)
		return @"General/NSViewNotSizable";
	General/NSString *sep = @" | ";
	General/NSMutableString *str = General/[NSMutableString string];
	if (mask & General/NSViewWidthSizable)
		[str appendFormat:@"General/NSViewWidthSizable%@", sep];
	if (mask & General/NSViewHeightSizable)
		[str appendFormat:@"General/NSViewHeightSizable%@", sep];
	if (mask & General/NSViewMinXMargin)
		[str appendFormat:@"General/NSViewMinXMargin%@", sep];
	if (mask & General/NSViewMaxXMargin)
		[str appendFormat:@"General/NSViewMaxXMargin%@", sep];
	if (mask & General/NSViewMinYMargin)
		[str appendFormat:@"General/NSViewMinYMargin%@", sep];
	if (mask & General/NSViewMaxYMargin)
		[str appendFormat:@"General/NSViewMaxYMargin%@", sep];
	if ([str hasSuffix:sep])
		[str deleteCharactersInRange:General/NSMakeRange([str length]-[sep length], [sep length])];
	return str;
}
