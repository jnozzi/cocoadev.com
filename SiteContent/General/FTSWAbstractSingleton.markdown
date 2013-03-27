

Hope folks find this code useful. Please point out any defects or improvements. -General/ShawnErickson

The following code is an implementation of a base class that allows sub-classes to inherit singleton behavior including preventing deallocation of the singleton instance and related enforcement of the contract. This implementation is also thread safe. 

(Are you sure? See: http://www.aristeia.com/Papers/DDJ_Jul_Aug_2004_revised.pdf) - Yes, this implementation uses synchronize (grab a lock) and not any broken double check, etc. scheme as outline in the PDF you referenced.

General/FTSWAbstractSingleton.h
    
#import <Foundation/Foundation.h>

@interface General/FTSWAbstractSingleton : General/NSObject {
}
+ (id)singleton;
+ (id)singletonWithZone:(General/NSZone*)zone;

//designated initializer, subclasses must implement and call supers implementation
- (id)initSingleton; 
@end


General/FTSWAbstractSingleton.m
    
#import "General/FTSWAbstractSingleton.h"

@implementation General/FTSWAbstractSingleton

static General/NSMutableDictionary  *s_FTSWAbstractSingleton_singletons = nil;

+ (void)initialize
{
    @synchronized(General/[FTSWAbstractSingleton class]) {
        if (s_FTSWAbstractSingleton_singletons == nil) {
            s_FTSWAbstractSingleton_singletons = General/[[NSMutableDictionary alloc] init];
        }
    }
}

// Should be considered private to the abstract singleton class, 
// wrap with a "sharedXxx" class method
+ (id)singleton
{
    return [self singletonWithZone:[self zone]];
}

// Should be considered private to the abstract singleton class
+ (id)singletonWithZone:(General/NSZone*)zone
{
    id singleton = nil;
    Class class = [self class];
    
    if (class == General/[FTSWAbstractSingleton class]) {
        General/[NSException raise:General/NSInternalInconsistencyException
                    format:@"Not valid to request the abstract singleton."];
    }
    
    @synchronized(General/[FTSWAbstractSingleton class]) {
        singleton = [s_FTSWAbstractSingleton_singletons objectForKey:class];
        if (singleton == nil) {
            singleton = General/NSAllocateObject(class, 0U, zone);
            if ((singleton = [singleton initSingleton]) != nil) {
                [s_FTSWAbstractSingleton_singletons setObject:singleton forKey:class];
            }
        }
    }
    
    return singleton;
}

// Designated initializer for instances. If subclasses override they
// must call this implementation.
- (id)initSingleton
{
    return [super init];
}

// Disallow the normal default initializer for instances.
- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
}

// ------------------------------------------------------------------------------
// The following overrides attempt to enforce singleton behavior.

+ (id)new
{
    return [self singleton];
}

+ (id)allocWithZone:(General/NSZone *)zone
{
    return [self singletonWithZone:zone];
}

+ (id)alloc
{
    return [self singleton];
}

- (id)copy
{
    //[self doesNotRecognizeSelector:_cmd]; //optional, do if you want to force certain usage pattern
    return self;
}

- (id)copyWithZone:(General/NSZone *)zone
{
    //[self doesNotRecognizeSelector:_cmd]; //optional, do if you want to force certain usage pattern
    return self;
}

- (id)mutableCopy
{
    //[self doesNotRecognizeSelector:_cmd]; //optional, do if you want to force certain usage pattern
    return self;
}

- (id)mutableCopyWithZone:(General/NSZone *)zone
{
    //[self doesNotRecognizeSelector:_cmd]; //optional, do if you want to force certain usage pattern
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
}

- (id)retain
{
    return self;
}

- (id)autorelease
{
    return self;
}

- (void)dealloc
{
    [self doesNotRecognizeSelector:_cmd];  //optional, do if you want to force certain usage pattern
}
// ------------------------------------------------------------------------------

@end



----

The following is an example sub-class...
    
#import "General/FTSWAbstractSingleton.h"

@interface General/MySingleton : General/FTSWAbstractSingleton {
    ...blah...
}
+ (General/MySingleton*)sharedMySingleton;
...blah...
@end

@implementation General/MySingleton

+ (General/MySingleton*) sharedMySingleton
{
    static General/MySingleton *s_MySingleton = nil;
    
    @synchronized(General/[MySingleton class]) {
        if (s_MySingleton == nil) {
            s_MySingleton = [self singleton];
        }
    }
    
    return s_MySingleton;
    
    // or you could not use the static var above and just do "return [self singleton];"
}

- (id)initSingleton
{
    if (self = [super initSingleton]) {
        ...blah...
    }
    
    return self;
}

...blah...
@end


----