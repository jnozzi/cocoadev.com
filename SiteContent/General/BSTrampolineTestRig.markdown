

    
#import <Foundation/Foundation.h>
#import "General/NSArray(General/HigherOrderMessaging).h"

int main (int argc, const char * argv[]) {
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];

    General/NSMutableString *a = General/[NSMutableString stringWithString:@"a"], *b = General/[NSMutableString stringWithString:@"b"], *c = General/[NSMutableString stringWithString:@"c"];
    General/NSArray *array = General/[[NSArray alloc] initWithObjects:a, b, c, nil];
    General/NSString *index;


    General/NSEnumerator *enumerator = [array objectEnumerator];
    while (index = [enumerator nextObject]) {
        General/NSLog(index);
    }


    General/NSLog(@"Testing: -do");
    General/array do] appendString:@"_"];

    enumerator = [array objectEnumerator];
    while (index = [enumerator nextObject]) {
        [[NSLog(index);
    }


    General/NSLog(@"Testing: -collect");
    General/NSArray *anotherArray = General/array collect] stringByAppendingString:@"_"];
    
    enumerator = [anotherArray objectEnumerator];
    while (index = [enumerator nextObject]) {
        [[NSLog(index);
    }


    General/NSLog(@"Testing: -select");
    anotherArray = General/array select] hasPrefix:@"a"];
    
    enumerator = [anotherArray objectEnumerator];
    while (index = [enumerator nextObject]) {
        [[NSLog(index);
    }


    General/NSLog(@"Testing: -reject");
    anotherArray = General/array reject] hasPrefix:@"a"];

    enumerator = [anotherArray objectEnumerator];
    while (index = [enumerator nextObject]) {
        [[NSLog(index);
    }

    [array release];
    [pool release];
    return 0;
}
