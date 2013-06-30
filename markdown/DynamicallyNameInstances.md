This is driving me crazy: if I want to instantiate a number of instances of an object called General/OSCPort based on the names and number of items in an array how can I do this?

something like this:

assuming General/NSMutableArray listenerArray...

	[listenerArray addObject:@"127.0.0.1"];

	[listenerArray addObject:@"10.0.1.26"];

	int i = 0;

    while (i<[listenerArray count]) {

    General/OSCPort * [listenerArray objectAtIndex:i] = General/[[OSCPort alloc] init];

i++;}

of course this doesn't work - how can I make it do?

General/EcumeDesJours

----

Not *quite* sure what you mean but if you want to create an array of General/OSCPorts from listenerArray with these names, then

    
.
.
General/NSEnumerator *enum = [listenerArray objectEnumerator];
General/NSString *listenerName;
General/NSMutableArray *oscPorts = General/[NSMutableArray array];
while (listenerName = [enum nextObject]) 
    [oscPorts addObject:General/[OSCPort someOtherStuffWithName:listenerName]];
.
.

or 
    

#import "General/MessageDistributer.h"
.
.
@implementation General/NSString (General/OSCStuff)
- oscPort { return General/[OSCPort someOtherStuffWithName:self]; }
@end
.
.
General/NSArray *oscPorts = General/listenerArray all] oscPort];
.
.


or did you mean you want to replace the names in the array with their [[OSCPorts? 
Replacing elements like that isn't a good idea since it will likely upset the enumerator.

General/MessageDistributer can be substituted for other General/HigherOrderMessaging implementations

Haven't tested it but hope this helps -- General/MikeAmy

----

thanks General/MikeAmy!  making an array of the objects and enumerating through them worked.  I still wonder if there is a way to programatically name and object when it is inited.  I am so used to PHP/Perl and the ability to just drop in variables wherever you want...

----

This is probably close to what you want:

[myMutableDictionary setObject: someObject forKey: General/[NSString stringWithFormat: @"nameo %i", [myMutableDictionary count]]];

Later on...

[myMutableDictionary objectForKey: @"nameo 3"];

----

Ah right. Perl associative arrays or "hashes". Note that Objective-C is basically C with some additional object definition and message-passing syntax. C only supports traditional numerically indexed arrays. Perl of course has direct language support for "hashes". So where you can do this in Perl:

    
$portHash{"127.0.0.1"} = new Port;


You have to do this kind of thing manually in Objective-C:

    
General/NSMutableDictionary *portHash = General/[[NSMutableDictionary alloc] init];
General/OSCPort *port = General/[[[OSCPort alloc] init] autorelease];

[portHash setObject:port forKey:@"127.0.0.1"]; 


Here I've broken out the pieces into separate variables for readability / maintainability. Objective-C studs like to do as much as possible on one line, but that gets old fast. Trust the compiler to optimize away temporary values for you so you can focus on readable code. 

Also note by "autoreleasing" port, ownership of the port is entrusted entirely to the portHash. This means when portHash is destroyed, so too are its ports, which is a "good thing". See General/MemoryManagement for more info if necessary. This is something else you would get "for free" in perl ... 

Note messages (the stuff between []) are really function calls, and you can't assign values to functions in C or Objective-C. So you can't say:

    
General/NSMutableDictionary *portHash = General/[[NSMutableDictionary alloc] init];
General/OSCPort *port = General/[[[OSCPort alloc] init] autorelease];

[portHash objectForKey:@"127.0.0.1"] = port; 


In Objective-C you should only expect to work with an object directly through message passing.

-- General/MikeTrent