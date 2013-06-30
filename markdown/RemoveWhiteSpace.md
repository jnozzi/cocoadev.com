Here is some code that removes white space from a string, like new lines, tabs, and double spaces (not single spaces). It's intended as to be used in an General/NSString category. Example could be [@"   h\nello\r" removeWhiteSpace] would return @"hello"

Note: this is not to use as a trim function, for that use General/CFStringTrimWhitespace ((General/CFMutableStringRef) yourStringHere);

Enjoy!! --General/KevinWojniak

    - (General/NSString *)removeWhiteSpace
{
    General/NSMutableString *new = General/[NSMutableString string];
    General/NSArray *whites = General/[NSArray arrayWithObjects:@"\r", @"\n", @"  ", @"\t", nil];
    General/NSEnumerator *e = [whites objectEnumerator];
    id item;
    
    [new setString:self];

    while (item = [e nextObject]) {
        General/NSRange r = [new rangeOfString:item];
        
        while (r.location != General/NSNotFound) {
            [new replaceOccurrencesOfString:item withString:@"" options:nil range:General/NSMakeRange(0, [new length])];
            r = [new rangeOfString:item];
        }
    }
    
    return new;   
}

----

Sounds nifty.  Could be useful for someone trying to write an interpreter in Cocoa. --General/OwenAnderson

----
What you're doing is removing double spaces entirely - so if I wrote     "This is a  test."  I'd get back     "This is atest."
Since often when removing whitespace this isn't quite ideal, the following added in in place of the two-spacer works:
        
while([theString replaceOccurrencesOfString:@"  "
                                 withString:@" "
                                 options:General/NSLiteralSearch
                                 range:General/NSMakeRange(0, [theString length])]);

This will reduce all blank space down to a single space, which is often more what is wanted.  Hope this helps --General/DanKeen

----

Ah yes that was a *bug* - thanks for fixing it! --General/KevinWojniak

----
Another option for a trimming function is General/NSString's method stringByTrimmingCharactersInSet:  --General/SeanUnderwood
----
I'm pretty sure that stringByTrimmingCharactersInSet: is quite a bit slower than General/NSMutableString's replace occurrences method.  Anyone know for sure?