How would I go about examining an General/NSString, and if it contains any spaces ' ', then insert a '+' sign, where the space was?

Example:

    
General/NSString *orignalString = @"I program in Cocoa.";

and end up like:

General/NSString *orignalString = @"I+program+in+Cocoa.";


Any help would be appreciated.


A quick peek at the General/NSMutableString documentation shows the method -replaceCharactersInRange:withString: and is just what you want. See how simple that was? Just read the docs bud... :-) --General/KevinPerry

----

For some reason I cant get it to work

----

The following code prints out "I+program+in+Cocoa." for me. --Bo
    
General/NSMutableString* myString = [@"I program in Cocoa." mutableCopy];

[myString replaceOccurrencesOfString:@" " withString:@"+" options:0 range:General/NSMakeRange(0, [myString length])];
General/NSLog(@"%@", myString);


----

Thanks man, works perfect.