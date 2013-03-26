How would I go about examining an [[NSString]], and if it contains any spaces ' ', then insert a '+' sign, where the space was?

Example:

<code>
[[NSString]] ''orignalString = @"I program in Cocoa.";

and end up like:

[[NSString]] ''orignalString = @"I+program+in+Cocoa.";
</code>

Any help would be appreciated.


A quick peek at the [[NSMutableString]] documentation shows the method -replaceCharactersInRange:withString: and is just what you want. See how simple that was? Just read the docs bud... :-) --[[KevinPerry]]

----

For some reason I cant get it to work

----

The following code prints out "I+program+in+Cocoa." for me. --Bo
<code>
[[NSMutableString]]'' myString = [@"I program in Cocoa." mutableCopy];

[myString replaceOccurrencesOfString:@" " withString:@"+" options:0 range:[[NSMakeRange]](0, [myString length])];
[[NSLog]](@"%@", myString);
</code>

----

Thanks man, works perfect.