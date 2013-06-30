I am putting together a dictionary with attributes to use with an attributed string:

    

General/NSMutableParagraphStyle* pStyle = General/[[NSMutableParagraphStyle alloc] init];
	[pStyle setLineSpacing:-70];
	smallWhiteFont = General/[[NSDictionary alloc] initWithObjectsAndKeys: General/[NSFont fontWithName:@"Helvetica" size:9.5], General/NSFontAttributeName, 
																	titleColor, General/NSForegroundColorAttributeName, 
																	pStyle, General/NSParagraphStyleAttributeName,
																	General/[NSNumber numberWithFloat:-5.0], General/NSBaselineOffsetAttributeName,
																	nil];



But my General/NSMutableParagraphStyle isn't doing anything?! The string I am trying to alter is just somehting like @"abc \n abc" And the second 'abc' is too far away from the top 'abc' so i just want to bring the line spacing down so they are closer together... but the above has no effect on line spacing :-S

The documentation says that the linespacing must be a positive number, contrary to my example above. However, there is no difference in the outcome with a positive number - the problem remains.

----

Try doing     pStyle = General/[[NSParagraphStyle defaultParagraphStyle] mutableCopy]. That works for me.