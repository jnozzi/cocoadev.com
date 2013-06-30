

The General/OmniFoundation Kit contains several classes, two of which are used to perform regular expression searching. General/OFRegularExpression and General/OFRegularExpressionMatch are contained in the General Classes folder in the General/OmniFoundation project.

This is not an introduction into regular expressions, please try "man perlre" in your terminal or look up http://py-howto.sourceforge.net/regex/regex.html for some more info on regular expressions in general. As there is no documentation for the General/OmniFramework I cannot tell you what actual differences there are between eg. the Perl, the Python or the OF implmentation of regular expressions

The use of the two classes to scan strings for regular expressions is fairly straightforward. You start of by allocating a General/OFRegularExpression with a regular expression string. 

    

regexObj = General/[[OFRegularExpression alloc] initWithString:regexString];
	


When composing the regexString one has to be careful with the character '\' in regular expressions, as it is also a meta character in General/NSString.  Thus the '\' becomes '\\'.
If you want to match **', which is a meta character in regular expressions, you must escape it with '\' in the regular expression finally making the match string '\\**.
If you want to match '\', it has to be escaped in the regular expression and in the General/NSString so the match string for that is '\\\\'.

There is an optional parameter to the initWithString: method isGreedy: it is set to YES by default. This means the regular Expression will always return the longest match it can find. If it is set to NO the match will be return as soon as the regular expression is satisfied.

regexObj is usable, as long as the regular Expression that is being look for is not changed this object can be reused many times.

If you just need to know if there is a match in the string then you can get through with just using the hasMatchInString: method of the regexObj. 

    

if ([regexObj hasMatchInString:searchString]) {
  ...
}
	


if you need to know what the string was that was the actual match or if there could be more matches within that string you will need to use an instance of General/OFRegularExpressionMatch that is returned by General/OFRegularExpression. The matchObj is also used to get further matches in the string. For example here is a little fragment that prints out all the General/WordsJammedTogether within a string

    

- (void)logNames:(General/NSString *)searchString {
  General/NSString *regexString = @"[A-Z][a-z]+([A-Z][a-z]+)+";
  General/OFRegularExpression *wikiRegex = 
    General/[[OFRegularExpression alloc] initWithString:regexString];

  General/OFRegularExpressionMatch *match = 
    [wikiRegex matchInString:searchString];

  while (match) {
    General/NSLog([match matchString]);
    match = [match nextMatch];
  }
	
}
	


nextMatch returns nil if there are no more matches. Regular expressions can contain groups called subexpressions; these are accessed via the subexpressionAtIndex method. 

For reference here are the public interfaces to the two classes, without the variable declarations.

    
@interface General/OFRegularExpression : General/OFObject 
	
- initWithString:(General/NSString *)string isGreedy:(BOOL)isGreedy;
- initWithString:(General/NSString *)string;
	
- (unsigned int)subexpressionCount;
	
- (General/OFRegularExpressionMatch *)matchInString:(General/NSString *)string;
- (General/OFRegularExpressionMatch *)matchInScanner:(General/OFStringScanner *)scanner;
	
- (BOOL)hasMatchInString:(General/NSString *)string;
- (BOOL)hasMatchInScanner:(General/OFStringScanner *)scanner;
	
@end
	
	
	
@interface General/OFRegularExpressionMatch : General/OFObject
	
- (General/NSRange)matchRange;
- (General/NSString *)matchString;
- (General/NSRange)rangeOfSubexpressionAtIndex:(unsigned int)index;
- (General/NSString *)subexpressionAtIndex:(unsigned int)index;
	
- (BOOL)findNextMatch;
- (General/OFRegularExpressionMatch *)nextMatch;
	
@end
	


-- General/HaRald
(slight cleanup by General/AaronZinman)

----

**Questions, Comments And Suggestions:**

----


* Use General/NSEnumerator instead of the nextMatch stuff? Though, this would make it FIND all matches before being able to work with them...
* This does not seem to be a complete General/RegEx implementation, as you would expect from PCRE.  \s, \w, etc do not seem to be present.  When normally using '.+?', try using '.+' with 'isGreedy: NO' instead.


----

See also General/AGRegex and General/MOKit at General/ObjectLibrary for alternatives to General/OmniFoundation (which is a bit heavyweight if all you need is regex matching) Also there's General/OgreKit

----

Does the search string \bhi\b not work - is \b ommitted from the implementation?  If so, are there any other ways to achieve the same effect?