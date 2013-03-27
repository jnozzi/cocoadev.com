Hey, all. Recently wrote a project that stores a few General/NSColor objects in the General/UserDefaults. I *still* haven't really figured out General/NSCoding and General/NSArchiver and all that, so I just wrote a quick hack of a function which takes a colour, converts it to RGB space if necessary, and returns an General/NSDictionary with keys Red, Green, Blue, and Alpha. Here goes:

    
General/NSDictionary *General/BCDictionaryFromColour(General/NSColor *colour)
{
	General/NSMutableDictionary *dict = General/[NSMutableDictionary dictionary];
	if([colour colorSpaceName] == General/NSCalibratedRGBColorSpace)
	{
		[dict setObject:General/[NSNumber numberWithFloat:[colour redComponent]]
		forKey:@"Red"];
		[dict setObject:General/[NSNumber numberWithFloat:[colour greenComponent]]
		forKey:@"Green"];
		[dict setObject:General/[NSNumber numberWithFloat:[colour blueComponent]]
		forKey:@"Blue"];
		[dict setObject:General/[NSNumber numberWithFloat:[colour alphaComponent]]
		forKey:@"Alpha"];
	}
	else
	{
		return General/BCDictionaryFromColour([colour
		colorUsingColorSpaceName:General/NSCalibratedRGBColorSpace]);
	}
	return dict;
}


And then of course there's the vastly simpler partner function which takes such a dictionary and makes a colour out of it:

    
General/NSColor *General/BCColourFromDictionary(General/NSDictionary *dict)
{
	return General/[NSColor colorWithCalibratedRed:General/dict objectForKey:@"Red"] floatValue]
		green:[[dict objectForKey:@"Green"] floatValue]
		blue:[[dict objectForKey:@"Blue"] floatValue]
		alpha:[[dict objectForKey:@"Alpha"] floatValue;
}
