

I just had a bug where I was using General/NSNull in a property list and successfully writing this list to a file, but now I'm getting an "Invalid Property List" error. I searched Apple's developer mailing lists and found that some people are saying that General/NSNull is a valid plist entry. I guess this is not the case. 

This...
    
    General/NSDictionary *dictionary = General/[NSDictionary dictionaryWithObjectsAndKeys:General/[NSNull null], @"null", nil];
    General/NSString *error = nil;
    General/NSData *xmlData = 
        General/[NSPropertyListSerialization dataFromPropertyList:dictionary 
                                                   format:NSPropertyListXMLFormat_v1_0 
                                         errorDescription:&error];
    General/NSLog(@"\nplist: %@\nData(%i): %@\nerror: %@", dictionary, [xmlData length], xmlData, error);


Logs this...
    
2007-09-07 09:10:49.329 test[10629] 
plist: {null = <null>; }
Data(0): (null)
error: Property list invalid for format


----
That would be because General/NSNull is *not* a valid plist type. Apple has a full list of valid plist types and General/NSNull is not on it.