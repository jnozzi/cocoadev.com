I am using and General/NSSCanner to scan out some quotes in a text view subclass, but the following code causes and endless loop and I cannot find the problem.

Can anyone help :-)?

    General/NSCharacterSet *charSet = General/[NSCharacterSet characterSetWithCharactersInString:@"\""];
General/NSScanner * theScanner = General/[NSScanner scannerWithString:[self string]];
[theScanner setCharactersToBeSkipped:General/[NSCharacterSet whitespaceCharacterSet]];	
	
BOOL inQuote = NO;
unsigned int quotePosition;
while ([theScanner isAtEnd] == NO) 
{
	if ([theScanner scanString:@"\"" intoString:NULL])
	{
			
		if (inQuote)
		{ 
			// We found a quote, except it's not working ;)
			General/NSLog([self substringWithRange:General/NSMakeRange(quotePosition,[theScanner scanLocation]-quotePosition)]);
		} else
		{
			inQuote = YES;
			quotePosition = [theScanner scanLocation];
		}
	}
[theScanner scanUpToCharactersFromSet:charSet intoString:nil];
}

----
Try adding     inQuote = NO; after your General/NSLog.
----
Thanks