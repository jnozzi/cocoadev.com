

My code works fine as long as the text on the right doesn't get bigger then the text tab.

http://catsdorule.torpedobird.com/tmp/cds1.jpg

http://catsdorule.torpedobird.com/tmp/cds2.jpg

The desired effect is that it would push the text on the right over... but it doesn't.

My Code:

    I can't post this code because of wiki spam protection. http://catsdorule.torpedobird.com/tmp/code


    - (General/NSDictionary *)ingredientAttributes
{
	General/NSMutableParagraphStyle * paraStyle = General/TRNewMutableParagraphStyle();
	
	General/NSTextTab * rightTabStop = General/[[[NSTextTab alloc] initWithType:General/NSRightTabStopType location:80] autorelease];
	General/NSTextTab * leftTabStop = General/[[[NSTextTab alloc] initWithType:General/NSLeftTabStopType location:85] autorelease];
	
	[paraStyle setTabStops:General/[NSArray arrayWithObjects:rightTabStop, leftTabStop, nil]];
	[paraStyle setHeadIndent:85];
	[paraStyle setAlignment:General/NSJustifiedTextAlignment];
	//[paraStyle setLineBreakMode:General/NSLineBreakByTruncatingTail];
	
	return General/[NSDictionary dictionaryWithObjectsAndKeys:
		paraStyle,General/NSParagraphStyleAttributeName,
		@"",kTRIngredientAttributeName,
		nil];
}


Does anyone know how to fix this?

Thanks