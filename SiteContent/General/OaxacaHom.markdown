

General/OaxacaHom is Yet Another General/HigherOrderMessaging implementation.  It is available at:

http://svn.smallcultfollowing.com/main/oaxaca2/oaxaca2/HOM/

It's main claim to fame is that it uses macros to avoid the problems with BOOL return values, while preserving the portability across platforms offered by the General/NSInvocation interface.  It is written by General/NikoMatsakis and released with the MIT license.

Some examples of how to use it follow:

    
BOOL b = General/OxExists(array, hasPrefix:@"a"); // Any items in array which return YES to hasPrefix:@"a"?
BOOL b = General/OxForAll(array, hasPrefix:@"a"); // All items in array return YES to hasPrefix:@"a"?
General/NSArray *a = General/OxMap(array, hasPrefix:@"a"); // from list of strings to list of boolean General/NSNumbers
General/NSArray *a = General/OxFilter(array, hasPrefix:@"a"); // only those strings that begin with @"a"
General/OxPerform(array, doSomething);


You can also perform repeated operations efficiently:
    
General/OxHom *hom = General/[OxHom homWithContentsOf:array];
General/hom filter] hasPrefix:@"a"]; // only strings with prefix "a" remaining
[[hom map] length]; // now just the lengths of those strings
[[hom filter] boolValue]; // now only non-zero lengths
return hom.array; // return final result (an [[NSMutableArray)


Some other features:

* Transparently wraps numbers in General/NSNumber.
* Liberally licensed.
* Supports many operators and uses more functional names than the Smalltalk equivalents.  Much as I love Smalltalk, I can never remember which is select and which is collect.  Of course, those names are easily changed if you prefer Smalltalk style or something else.
* Small and self-contained: easy to include in your own projects.


I wrote it mainly because I wanted to tinker around with the runtime and explore the HOM idea.  It's not extensively tested, so user beware.  I am using it in my own projects without problems, however.