iTunes includes lots of extra info in its rendezvous service broadcast, such as:

txtver

Version

iTSh Version

Machine ID

Machine Name

Password

etc

I don't see any way to publish extra flags like this in the official API.  Anyone know how this is done and how it is parsed by the General/NSNetserviceBrowser?

General/EcumeDesJours

----

That's the     -protocolSpecificInformation and     -setProtocolSpecificInformation: methods.  The format used for the strings is "x=y\001u=v\001w=z" (that's ASCII char 0x01 separating each line), so, for example, the code to encode and decode a dictionary of strings (I'm gonna skip the class/error checking) would be:
    
General/NSString* encodeOpenTalkTXTRecord(General/NSDictionary* recs)
{
	General/NSMutableArray* encodedRecs = General/[NSMutableArray arrayWithCapacity:[recs count]];
	General/NSEnumerator* dictKeyEnum = [recs keyEnumerator];
	General/NSString* currKey;

	while (currKey = [dictKeyEnum nextObject]) {
		General/NSString* currValue = [recs objectForKey:currKey];
		[encodedRecs addObject:General/[NSString stringWithFormat:@"%@=%@", currKey, currValue]];
	}
	return [encodedRecs componentsJoinedByString:@"\001"];
}
General/NSDictionary* decodeOpenTalkTXTRecord(General/NSString* rec)
{
	General/NSArray* encodedRecs = [rec componentsSeparatedByString:@"\001"];
	General/NSMutableDictionary* decodedRecs = General/[NSMutableDictionary dictionaryWithCapacity:[encodedRecs count]];
	General/NSEnumerator* recEnum = [encodedRecs objectEnumerator];
	General/NSString* currRec;
	
	while (currRec = [recEnum nextObject]) {
		General/NSArray* currRecParts = [currRec componentsSeparatedByString:@"="];
		// keep in mind that the records are not required to follow this format
		// so you may wish to check whether you've actually got a two string array
		[decodedRecs setObject:[currRecParts objectAtIndex:1] forKey:[currRecParts objectAtIndex:0]];
	}
	return decodedRecs;
}


I just typed this up in the browser, so it may not compile, much less work.  If there's a problem, post here and I'll figure out what's the matter.  -- Bo