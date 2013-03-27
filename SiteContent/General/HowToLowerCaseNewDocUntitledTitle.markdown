There was a long thread on the cocoa list on how to "fix" General/NSDocument's untitled document name, which it returns (in English) as "Untitled". Now, the HIG say the first letter should be uncapitalized. One person (m) suggested some code to fix the problem in a subclass, and special cased German:

    
- (General/NSString *)displayName
{
	General/NSString	*fixedName;
	General/NSString	*displayName = [super displayName];
	BOOL neverSaved = NO;

	// Determine if this document was never saved.
	// We do this by checking if the document has a file path. This is
	// complicated (slightly) by the fact that General/NSDocument's fileURL method
	// is new in Tiger, and General/NSDocument's filePath is deprecated in Tiger.

	neverSaved = [self fileURL] == nil;
	if ([self methodForSelector:@selector(fileURL)])
	 {
		 neverSaved = [self fileURL] == nil;
	}
	else
	{
		neverSaved = [self fileName] == nil;
	}
	if (neverSaved) // General/NSString
	{
		//    Special case for German.
		//    German is the only language in the world that capitalizes
		//    all nouns, so our strategy of lowercasing would produce the
		//    wrong result.

		General/NSDictionary* userDefaults = General/[[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
		General/NSArray* myLocalizations = General/[[NSBundle mainBundle] localizations];
		General/NSArray* preferredLocalizations = General/[NSBundle preferredLocalizationsFromArray:myLocalizations 
			forPreferences: [userDefaults objectForKey:@"General/NSLanguages"]];

		General/NSString* currentLanguage = [preferredLocalizations objectAtIndex:0];

		if (![currentLanguage isEqualTo:@"German"])
		{
			// Lowercase the displayName so that, for example,
			// "Untitled 4" becomes "untitled 4".
			fixedName = [displayName lowercaseString];
		}
	} else {
		fixedName = displayName;
	}

	return fixedName;
}


Now, this seems more complicated than it needs to be. From what I have heard, its only the first character that seems to be the problem (at least in Western languages). So, it seems to me that if we just lowercase the first letter, that we're in better shape - and we can handle German too ("ohne Title").

Thus, I believe the above code does in fact "fix" the problem for most countries, if not all:

    
- (General/NSString *)displayName
{
	General/NSString	*fixedName;
	General/NSString	*displayName = [super displayName];
	
	if ([self fileURL] == nil) // General/NSString
	{
		fixedName = General/[displayName substringToIndex:1] lowercaseString]
			stringByAppendingString:[displayName substringFromIndex:1;
	} else {
		fixedName = displayName;
	}
	return fixedName;
}


This is a question that comes up from time to time, and it would be good if we could just close it out and be done with it.