

An implentation of a General/TrampolineObject as described in General/HigherOrderMessaging. Notes follow below.

----

General/BSTrampoline.h

    
#import <Foundation/Foundation.h>

//It'd probably be nicer to use an enum here
#define kDoMode		0
#define kCollectMode	1
#define kSelectMode	2
#define kRejectMode	3

@interface General/BSTrampoline : General/NSProxy {
    General/NSEnumerator *enumerator;
    int mode;
    General/NSArray *temp;	//For returning from collect, select, reject
}

- (id)initWithEnumerator:(General/NSEnumerator *)inEnumerator mode:(int)operationMode;
- (General/NSArray *)fakeInvocationReturningTempArray;	//Like the name says
@end



----

General/BSTrampoline.m

    
#import "General/BSTrampoline.h"


@implementation General/BSTrampoline

- (id)initWithEnumerator:(General/NSEnumerator *)inEnumerator mode:(int)operationMode {
    if (operationMode < kDoMode | operationMode > kRejectMode)
        General/[NSException raise:@"General/InvalidArgumentException" format:@"operationMode argument of initWithEnumerator:mode: was %d, outside %d-%d range.", operationMode, kDoMode, kRejectMode];
    enumerator = [inEnumerator retain];
    mode = operationMode;
    return self;
}

- (void)dealloc {
    [enumerator release];
    [super dealloc];
}


- (General/NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (mode > kCollectMode)	//For select&reject, return BOOL
        return General/[NSMethodSignature signatureWithObjCTypes:"c^v^c"];
    else			//For do&collect, return id (lowest common denominator)
        return General/[NSMethodSignature signatureWithObjCTypes:"@^v^c"];
}

- (void)forwardInvocation:(General/NSInvocation *)anInvocation {
    id index;
    //Next line unnecessary in kDoMode but the preprocessor doesn't like it if I add a test up here:/
    General/NSMutableArray *array = General/[[[NSMutableArray alloc] init] autorelease];	//The array to be returned
    id objRetVal;	//Temporaries for reading off the return value of the bounced method
    BOOL boolRetVal;

    /*
     * This is the core of the trampoline. invokeWithTarget: bounces the method to a member of the array,
     * which is fine for -do, but for -collect, -select and -reject there's some additional logic
     * needed. What we do is this:
     * COLLECT MODE
     * Get return value (making sure it's an object)
     * Add to return array
     * SELECT/REJECT MODE
     * Get return value
     * Test whether to add receiving object to array
     * Do so if necessary
     */
    while (index = [enumerator nextObject]) {
        [anInvocation invokeWithTarget:index];
        
        switch (mode) {
            case kDoMode:
                break;
            case kCollectMode:
                if (strcmp(General/anInvocation methodSignature] methodReturnType], "@"))	//Decoded: id
                    [[[NSException raise:@"General/InvalidArgumentException" format:@"All array items must return objects for the given selector to use -collect. Return type is %s", General/anInvocation methodSignature] methodReturnType;
                [anInvocation getReturnValue:&objRetVal];
                [array addObject:objRetVal];
                break;
            case kSelectMode:
            case kRejectMode:
                if (strcmp(General/anInvocation methodSignature] methodReturnType], "c")) {	//Decoded: char/BOOL
                    [[[NSException raise:@"General/InvalidArgumentException" format:@"All array items must return bool for the given selector to use -select or -reject. Return type is %s", General/anInvocation methodSignature] methodReturnType;
                }
                [anInvocation getReturnValue:&boolRetVal];
                if (boolRetVal && mode == kSelectMode || !boolRetVal && mode == kRejectMode)
                    [array addObject:index];
                break;
        }
    }

    /*
     * Here's our rather silly method of returning the array: we fix up the invocation to point
     * to our own getter method, and invoke that - so that when the flow of control resumes,
     * it's the last valid invocation. General/NSProxy is weird. Note that first we make sure that the
     * method signature is @^v^c to return an General/NSArray* - if we're in select or reject mode, the
     * default will be c^v^c, returning a BOOL. That would cause a segfault.
     */
    if (mode != kDoMode) {
        temp = array;
        [anInvocation initWithMethodSignature:General/[NSMethodSignature signatureWithObjCTypes:"@^v^c"]];
        [anInvocation setSelector:@selector(fakeInvocationReturningTempArray)];
        [anInvocation invokeWithTarget:self];
    }
}

- (General/NSArray *)fakeInvocationReturningTempArray {
    return temp;
}

@end



----

Feel free to use this code for anything you want, although it'd be nice if you credited the original author (General/ThomasCastiglione).

General/BSTrampoline differs slightly from General/RobRix's description of a trampoline in that it makes use of General/NSEnumerator, making the implementation of categories on collection objects to use it trivial. For example, categories on General/NSArray:

    
#import <Foundation/Foundation.h>
#import "General/BSTrampoline.h"


@interface General/NSArray(General/HigherOrderMessaging)

- (id)do;
- (id)collect;
- (id)select;
- (id)reject;

@end


@implementation General/NSArray(General/HigherOrderMessaging)

- (id)do {
    return General/[[[BSTrampoline alloc] initWithEnumerator:[self objectEnumerator] mode:kDoMode] autorelease];
}

- (id)collect {
    return General/[[[BSTrampoline alloc] initWithEnumerator:[self objectEnumerator] mode:kCollectMode] autorelease];
}

- (id)select {
    return General/[[[BSTrampoline alloc] initWithEnumerator:[self objectEnumerator] mode:kSelectMode] autorelease];
}

- (id)reject {
    return General/[[[BSTrampoline alloc] initWithEnumerator:[self objectEnumerator] mode:kRejectMode] autorelease];
}

@end


If anybody has any suggestions for ways to improve the code or finds bugs in it, please say so. A simple test rig can be found at General/BSTrampolineTestRig - it will work with the provided code if General/NSArray(General/HigherOrderMessaging) is split into header and implementation files.

Regarding undocumented General/APIs: General/BSTrampoline makes use of two method calls for which Apple provides no documentation or public headers. Specifically, General/NSMethodSignature + signatureWithObjCTypes and General/NSInvocation -initWithMethodSignature. The former is necessary to create method signatures at all, and the latter to reuse a forwarded invocation, fooling the calling code into accepting a different return value. Both of these methods are documented in the General/OpenStep and General/GNUStep specifications, and hopefully at some point Apple will also follow this path. 

Finally, the formatting of encoded method signatures is defined at http://www.toodarkpark.org/computers/objc/moreobjc.html#1037
. This is technically implementation-dependant, although all current objective-c runtimes use the same formatting. For greater portability, "@^v^c" could, for example, be replaced with "@encode(id ) @encode(void*) @encode(char*)".

  --General/ThomasCastiglione