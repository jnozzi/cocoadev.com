**General/OriginalClass** -part of General/AspectCocoa

Here we define an example Class as a reference.. as an example of a Class that we might want to apply some Aspects too.  Other pages related to General/AspectCocoa will make reference to this Class.
----

    
#import <Foundation/Foundation.h>


@interface General/OriginalClass : General/NSObject {

}

- (id)a;

- (void)b;

- (void)c;

- (void)d:(General/NSString *)string;

- (id)e:(General/NSString *)string;

- (id)f:(General/NSString *)a f:(General/NSString *)b;

- (id)g:(id *)thing;


@end


----

    
#import "General/OriginalClass.h"

@implementation General/OriginalClass


- (id)a
{
    General/NSLog(@"a");
    return self;
}

- (void)b
{
    General/NSLog(@"b");
}

- (void)c
{
    General/NSLog(@"c");
}

- (void)d:(General/NSString *)string
{
    General/NSLog(@"%@ d:", string);
}

- (id)e:(General/NSString *)string
{
    General/NSLog(@"%@ e:", string);
    return self;
}

- (id)f:(General/NSString *)a f:(General/NSString *)b
{
    General/NSLog(@"%@ %@ f:f:", a, b);
    return self;
}

- (id)g:(id *)thing
{
    General/NSLog(@"%@ g:", thing);
    return self;
}

@end



**Shouldn't -g:'s parameter be (id) rather than (id *)? Otherwise it's a C-array of objects... and you're using it like it's a single object. So either change (id *) to (id) or change thing in the General/NSLog statement to *thing.**