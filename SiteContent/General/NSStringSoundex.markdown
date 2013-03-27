This is a simple category on General/NSString to allow comparisons using the Soundex algorithm. This compares a string by the way it sounds, i.e. phonetically. It can be quite handy for suggesting alternative words for example, or doing fuzzy matches, book indexing, etc. General/GrahamCox.

    

#import <Cocoa/Cocoa.h>


@interface General/NSString (Soundex)

- (General/NSString*)	soundexString;
- (BOOL)	soundsLikeString:(General/NSString*) aString;


@end

#import "General/NSString+Soundex.h"

@implementation General/NSString (Soundex)


static General/NSArray* soundexCharSets = nil;

- (void)		initSoundex
{
	if( soundexCharSets == nil )
	{
		General/NSMutableArray* cs = General/[NSMutableArray array];
		General/NSCharacterSet* charSet;
		
		charSet = General/[NSCharacterSet characterSetWithCharactersInString:@"aeiouhw"];
		[cs addObject:charSet];
		charSet = General/[NSCharacterSet characterSetWithCharactersInString:@"bfpv"];
		[cs addObject:charSet];
		charSet = General/[NSCharacterSet characterSetWithCharactersInString:@"cgjkqsxz"];
		[cs addObject:charSet];
		charSet = General/[NSCharacterSet characterSetWithCharactersInString:@"dt"];
		[cs addObject:charSet];
		charSet = General/[NSCharacterSet characterSetWithCharactersInString:@"l"];
		[cs addObject:charSet];
		charSet = General/[NSCharacterSet characterSetWithCharactersInString:@"mn"];
		[cs addObject:charSet];
		charSet = General/[NSCharacterSet characterSetWithCharactersInString:@"r"];
		[cs addObject:charSet];
		
		soundexCharSets = [cs retain];
	}
}


- (General/NSString *)	stringByRemovingCharactersInSet:(General/NSCharacterSet*) charSet options:(unsigned) mask
{
	General/NSRange				range;
	General/NSMutableString*	newString = General/[NSMutableString string];
	unsigned			len = [self length];
	
	mask &= ~General/NSBackwardsSearch;
	range = General/NSMakeRange (0, len);
	while (range.length)
	{
		General/NSRange substringRange;
		unsigned pos = range.location;
		
		range = [self rangeOfCharacterFromSet:charSet options:mask range:range];
		if (range.location == General/NSNotFound)
			range = General/NSMakeRange (len, 0);
		
		substringRange = General/NSMakeRange (pos, range.location - pos);
		[newString appendString:[self substringWithRange:substringRange]];
		
		range.location += range.length;
		range.length = len - range.location;
	}
	
	return newString;
}


- (General/NSString *)	stringByRemovingCharactersInSet:(General/NSCharacterSet*) charSet
{
	return [self stringByRemovingCharactersInSet:charSet options:0];
}


- (unsigned)	soundexValueForCharacter:(unichar) aCharacter
{
	// returns the soundex mapping for the first character in the string. If the value returned is 0, the character should be discarded.
	
	unsigned		indx;
	General/NSCharacterSet* cs;
	
	for( indx = 0; indx < [soundexCharSets count]; ++indx )
	{
		cs = [soundexCharSets objectAtIndex:indx];
		
		if([cs characterIsMember:aCharacter])
			return indx;
	}
	
	return 0;
}


- (General/NSString*)	soundexString
{
	// returns the Soundex representation of the string. 
	/*
	 
	 Replace consonants with digits as follows (but do not change the first letter):
	 b, f, p, v => 1
	 c, g, j, k, q, s, x, z => 2
	 d, t => 3
	 l => 4
	 m, n => 5
	 r => 6
	 Collapse adjacent identical digits into a single digit of that value.
	 Remove all non-digits after the first letter.
	 Return the starting letter and the first three remaining digits. If needed, append zeroes to make it a letter and three digits.
	 
	 */
	
	[self initSoundex];
	
	if([self length] > 0)
	{
		General/NSMutableString* soundexStr = General/[NSMutableString string];
		
		// strip whitespace and convert to lower case
		
		General/NSString*	workingString = General/self lowercaseString] stringByRemovingCharactersInSet:[[[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		unsigned	indx, soundValue, previousSoundValue = 0;
		
		// include first character
		
		[soundexStr appendString:[workingString substringToIndex:1]];
		
		// convert up to 3 more significant characters
		
		for( indx = 1; indx < [workingString length]; ++indx )
		{
			soundValue = [self soundexValueForCharacter:[workingString characterAtIndex:indx]];
			
			if( soundValue > 0 && soundValue != previousSoundValue )
				[soundexStr appendString:General/[NSString stringWithFormat:@"%d", soundValue]];
				
			previousSoundValue = soundValue;	
			
			// if we've got four characters, don't need to scan any more
			
			if([soundexStr length] >= 4)
				break;
		}
		
		// if < 4 characters, need to pad the string with zeroes
		
		while([soundexStr length] < 4)
			[soundexStr appendString:@"0"];
		
		//General/NSLog(@"soundex for '%@' = %@", self, soundexStr );
		
		return soundexStr;
	}
	else
		return @"";
}


- (BOOL)		soundsLikeString:(General/NSString*) aString
{
	return General/self soundexString] isEqualToString:[aString soundexString;
}

@end

