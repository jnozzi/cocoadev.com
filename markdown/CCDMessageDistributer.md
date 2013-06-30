

General/CCDMessageDistributer is a General/TrampolineObject which started as a (premature?) refactoring of General/BSTrampoline by General/ThomasCastiglione.
You might well be better off with General/BSTrampoline or General/LSTrampoline instead of General/CCDMessageDistributer in terms of performance. General/MPWFoundation
also has a nice implementation, but I'm not sure about IMP caching.

General/CCDMessageDistributer implements General/HigherOrderMessaging (all, collect, select, reject, combine) for objects that 
responds to objectEnumerator, such as General/NSArray, General/NSSet, General/NSDictionary. objects that respond to keyEnumerator get treated as keyed collections too :).

If you want to use General/CCDMessageDistributer, use it like this:
    
// sends message to all elements in myArray
General/myArray all] myMessage:arg1 withObject:arg2];
 
// sends message to all elements in myDictionary, and return result collection.
[[myDictionary collect] myMessage:arg1 withObject:arg2]; 

 // sends message to all elements in mySet, keeps those that returned YES
[[mySet select] testMethod];

// concatenate (string) elements in mySet
[[mySet combine] stringByAppendingString:nil];

You can also do things like this:
    
id distributer = [myCollection collect];
id collection1 = [distributer myMessage:arg1 withObject:arg2];
id collection2 = [distributer anotherMessage:arg];


The discussion page is [[MessageDistribution. All thoughts or advice or criticism welcomed. 

This is distributed under GNU. Crediting me if you use it in your own work is appreciated. If you do extend this class, please 
put a brief link on this page. 

Also a plea:
It is in your interest to fight software patents, whether you are an individual or a company!! See the electronic frontier foundation website.
also http://petition.eurolinux.org/index_html?LANG=en

There may be errors since this changed to the CCD prefix. please mention them here.

Peace, Love and Truth,
General/MikeAmy

----

General/CCDMessageDistributer.h

    
/*  General/CCDMessageDistributer.h
  Copyright (C) 2004 Michael Amy

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

#import "Foundation/Foundation.h"

@interface General/NSObject (General/HigherOrderMessaging)
- (id) all;
- (id) collect;
- (id) select;
- (id) reject;
- (id) combine;
- (id) reverseCombine;
@end

// mutableCopy doesn't work on a Class object, unfortunately
@interface General/NSObject (General/MutableAware)
- (Class) mutableClass:(BOOL)mutable;
@end

@interface General/CCDCollectionMediator : General/NSObject { @protected id element; General/NSEnumerator *enumerator; }
+ (id) mediator:aCollection;
- (id) initWith:aCollection;
- (id) nextElement;
- (void) add:result to:aCollection;
@end

@interface General/CCDKeyed : General/CCDCollectionMediator { @protected id key, collection; }
@end

@interface General/CCDForwarder : General/NSProxy { @protected id recipient; }
- (id) with:r;
@end

@interface General/CCDMessageDistributer : General/NSObject { @protected id collection, mediator, target; }
+ (id) with:collection;
- (id) initWith:collection;
/*
@method prepare:
@param invocation       The invocation to prepare for.
@discussion     
 Receiver checks the methodSignature of the invocation and initialises the collection mediator.
 Override to do any other preparation.
*/
- (void) prepare:invocation;
/*
@method perform:
@param invocation       The invocation to invoke.
@discussion    
 Receiver invokes the invocation. Override to do any other per-invocation tasks.
 */
- (void) perform:invocation;
/*
@method conclude:
@param invocation       The invocation to conclude.
@discussion     
 Receiver sets invocation return value to nil using [invocation setReturnValue:].
 This method allows results to be returned to the sender. 
 Subclasses override this method to set the invocation result value to something more
 useful and do any final tasks. 
*/
- (void) conclude:invocation;
/*
 @method requiredType:
 @discussion same but in english for a descriptive exception.
*/
- (void) check:(General/NSInvocation *)invocation;

@end

@interface General/CCDCollect : General/CCDMessageDistributer { @protected id resultCollection, value; }
@end

@interface General/CCDSelect : General/CCDCollect { @protected BOOL keep; }
- (BOOL) willKeepResult;
@end

@interface General/CCDReject : General/CCDSelect
@end

@interface General/CCDReverseCombine : General/CCDMessageDistributer { @protected id result; }
@end

@interface General/CCDCombine : General/CCDReverseCombine
@end


----

General/CCDMessageDistributer.m

    
/*  General/CCDMessageDistributer.m
  Copyright (C) 2004 Michael Amy

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

#import "General/CCDMessageDistributer.h"
#import "objc/objc-class.h"

static id nothing = nil;
void inline replaces(id *old,id new)
{
    [new retain];
    [*old release];
    *old = new;
}

@implementation General/CCDCollectionMediator : General/NSObject
- (void) dealloc
{
    [enumerator release];
    [super dealloc];
}

+ (id) mediator:aCollection
{
    return General/[ ([aCollection respondsToSelector:@selector(keyEnumerator)] ?
                [[[CCDKeyed class] :
                self)
        alloc] initWith:aCollection] autorelease];
}

- (id) initWith:c
{
    self = [super init];
    replaces(&enumerator,[c objectEnumerator]);
    return self;
}

- (id) nextElement
{
    element = [enumerator nextObject];
    return element;
}

- (void) add:object
          to:aCollection
{
    [aCollection addObject:object];
}

- (id) element
{
    return element;
}

@end

@implementation General/CCDKeyed : General/CCDCollectionMediator
- (id) initWith:c
{
    self = [super init];
    collection = c;
    replaces(&enumerator,[c keyEnumerator]);
    return self;
}

- (id) nextElement
{
    element = (key = [enumerator nextObject]) ? [collection objectForKey:key] : nil;
    return element;
}

- (void) add:object to:aCollection
{
    [aCollection setObject:object forKey:key];
}
@end


@implementation General/CCDForwarder : General/NSProxy
- (id) with:r
{
    replaces(&recipient,r);
    return self;
}

- (void) dealloc
{
    [recipient release];
    [super dealloc];
}

- (void) forwardInvocation:invocation
{
    [recipient forwardInvocation:invocation];
}

- (General/NSMethodSignature *) methodSignatureForSelector:(SEL)aSelector
{
    return [recipient methodSignature];
}

@end

@implementation General/CCDMessageDistributer : General/NSObject
- (id) prototypeMethod { return nil; }

- (General/NSMethodSignature *) methodSignature
{
    return [self methodSignatureForSelector:@selector(prototypeMethod)];
}

- (void) dealloc
{
    [collection release];
    [mediator release];
    [super dealloc];
}

+ (id) with:aCollection
{
    return General/[[[CCDForwarder alloc] with:General/[self alloc] initWith:aCollection] autorelease] ] autorelease];
}

- (id) initWith:aCollection
{
    [[NSAssert([aCollection respondsToSelector:@selector(objectEnumerator)],
             @"Object must respond to selector objectEnumerator to use messaging");
    replaces(&collection,aCollection);
    replaces(&mediator,General/[CCDCollectionMediator mediator:collection]);
    return self;
}

- (void) check:(General/NSInvocation *)invocation
{
    const char *requiredType = 
        General/self methodSignatureForSelector:(@selector(prototypeMethod))] methodReturnType];
    NSAssert3((strcmp([[invocation methodSignature] methodReturnType],
                      requiredType) == 0),
              @"%s requires %s to return the type which encodes as %s.",
              [self class]->name,
              [invocation selector],
              requiredType);
}

- (void) prepare:invocation
{ }

- (void) perform:invocation
{
    [invocation invokeWithTarget:target];
}

- (void) conclude:invocation
{
    [invocation setReturnValue:&nothing];
}

- (void) forwardInvocation:invocation
{
    [self prepare:invocation];
    while (target = [mediator nextElement]) [self perform:invocation];
    [self conclude:invocation];
}
@end

@implementation [[CCDCollect : General/CCDMessageDistributer
- (void) dealloc
{
    [resultCollection release];
    [super dealloc];
}
- (void) prepare:invocation
{
    [self check:invocation];
    resultCollection=General/[[collection class] mutableClass:YES] alloc] init];
}

- (void) perform:invocation
{
    [invocation invokeWithTarget:target];
    [invocation getReturnValue:&value];
    [mediator add:value to:resultCollection];
}

- (void) conclude:invocation
{
    [invocation setReturnValue:&resultCollection];
}
@end

@implementation [[CCDSelect : General/CCDCollect
- (BOOL) prototypeMethod { return NO; }

- (void) perform:invocation
{
    [invocation invokeWithTarget:target];
    [invocation getReturnValue:&keep];
    if ([self willKeepResult]) [mediator add:[mediator element] to:resultCollection];
}

- (void) conclude:invocation
{
    [invocation initWithMethodSignature:General/[NSMethodSignature signatureWithObjCTypes:"@^v^c"]];
    [super conclude:invocation];
}

- (BOOL) willKeepResult
{
    return keep;
}
@end

@implementation General/CCDReject : General/CCDSelect
- (BOOL) willKeepResult
{
    return !keep;
}
@end

@implementation General/CCDReverseCombine : General/CCDMessageDistributer
- (id) prototypeMethod:(id)element { return nil; }

- (General/NSMethodSignature *) methodSignature
{
    return [self methodSignatureForSelector:@selector(prototypeMethod:)];
}
- (void) prepare:invocation
{
    [invocation getArgument:&result atIndex:2];
    if (result && (target = [mediator nextElement])) [self perform:invocation];
    else result = [mediator nextElement];
}
- (void) getReturnValueOf:invocation
{
    [invocation getReturnValue:&result];
    NSAssert2((result != nil),
              @"%s using %s returned a nil value. Are all the elements mutable?",
              [self class]->name,
              [invocation selector]);
}
- (void) perform:invocation
{
    [invocation setArgument:&result atIndex:2];
    [invocation invokeWithTarget:target];
    [self getReturnValueOf:invocation];
}
- (void) conclude:invocation
{
    [invocation setReturnValue:&result];
}
@end

@implementation General/CCDCombine : General/CCDReverseCombine
- (void) perform:invocation
{
    [invocation setArgument:&target atIndex:2];
    [invocation invokeWithTarget:result];
    [self getReturnValueOf:invocation];
}
@end

@implementation General/NSArray (General/MutableAware)
+ (Class) mutableClass:(BOOL)mutable
{
    return mutable ? General/[NSMutableArray class] : General/[NSArray class];
}
@end

@implementation General/NSDictionary (General/MutableAware)
+ (Class) mutableClass:(BOOL)mutable
{
    return mutable ? General/[NSMutableDictionary class] : General/[NSDictionary class];
}
@end

@implementation General/NSSet (General/MutableAware)
+ (Class) mutableClass:(BOOL)mutable
{
    return mutable ? General/[NSMutableSet class] : General/[NSSet class];
}
@end

@implementation General/NSObject (General/HigherOrderMessaging)
- (id) all
{
    return General/[CCDMessageDistributer with:self];
}

- (id) collect
{
    return General/[CCDCollect with:self];
}

- (id) select
{
    return General/[CCDSelect with:self];
}

- (id) reject
{
    return General/[CCDReject with:self];
}

- (id) combine
{
    return General/[CCDCombine with:self];
}

- (id) reverseCombine
{
    return General/[CCDReverseCombine with:self];
}

@end



----

You can use this for testing: 

    
#import <Foundation/Foundation.h>
#import "General/CCDMessageDistributer.h"

void logElementsOf(id collection, General/NSString *operation)
{
    General/NSLog(@"Testing %@;",operation);
    General/NSString *index;
    General/NSEnumerator *enumerator = [collection objectEnumerator];
    if (enumerator == nil)
    {
        General/NSLog(@"Enumerator is missing - did the invocation really return an object?");
    }
    while (index = [enumerator nextObject])
    {
        General/NSLog(index);
    }
}

void test(id collection)
{
    logElementsOf(collection,@"initial elements are");
    General/collection all] appendString:@"_"];
    logElementsOf(collection,@"all");
    logElementsOf([[collection collect] stringByAppendingString:@"_"],@"collect");
    logElementsOf([[collection select] hasPrefix:@"a"],@"select");
    logElementsOf([[collection reject] hasPrefix:@"a"],@"reject");
    [[NSLog(@"Testing combine; %@",
          General/collection combine] stringByAppendingString:nil]);
    [[NSLog(@"Testing combine into >; %@",
          General/collection combine] stringByAppendingString:[[[NSMutableString stringWithString:@">"]]);
    General/NSLog(@"Testing reverse combine; %@",
          General/collection reverseCombine] stringByAppendingString:nil]);
    [[NSLog(@"Testing reverse combine into >; %@",
          General/collection reverseCombine] stringByAppendingString:[[[NSMutableString stringWithString:@">"]]);
}

int main (int argc, const char * argv[])
{
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];

    General/NSMutableString 
    *a = General/[NSMutableString stringWithString:@"a"], 
    *b = General/[NSMutableString stringWithString:@"b"], 
    *c = General/[NSMutableString stringWithString:@"c"];
    
    General/NSLog(@"------- General/NSArray -------");
    General/NSArray *array = General/[[NSArray alloc] initWithObjects:a, b, c, nil];
    test(array);
    
    General/NSLog(@"------- General/NSDictionary -------");
    General/NSDictionary *dict = General/[[NSDictionary alloc] initWithObjects:array forKeys:array];
    test(dict);
    
    General/NSLog(@"------- General/NSSet -------");
    General/NSSet *set = General/[[NSSet alloc] initWithObjects:a, b, c, nil];
    test(set);

    [array release];
    [pool release];
    return 0;
}



----

This produces:

    
------- General/NSArray -------
Testing: initial elements are
a
b
c
Testing: all
a_
b_
c_
Testing: collect
a__
b__
c__
Testing: select
a_
Testing: reject
b_
c_
Testing combine; a_b_c_
Testing combine into >; >a_b_c_
Testing reverse combine; c_b_a_
Testing reverse combine into >; c_b_a_>
------- General/NSDictionary -------
Testing: initial elements are
c_
a_
b_
Testing: all
c__
a__
b__
Testing: collect
c___
a___
b___
Testing: select
a__
Testing: reject
c__
b__
Testing combine; c__a__b__
Testing combine into >; >c__a__b__
Testing reverse combine; b__a__c__
Testing reverse combine into >; b__a__c__>
------- General/NSSet -------
Testing: initial elements are
c__
a__
b__
Testing: all
c___
a___
b___
Testing: collect
c____
a____
b____
Testing: select
a___
Testing: reject
c___
b___
Testing combine; c___a___b___
Testing combine into >; >c___a___b___
Testing reverse combine; b___a___c___
Testing reverse combine into >; b___a___c___>


If you need to know how it works, read on

**Classes and their roles**

Supporting classes are General/CCDForwarder and General/CCDCollectionMediator. 
Subclasses are General/CCDCollect, General/CCDSelect, General/CCDReject and General/CCDCombine|General/CCDReverseCombine. 

General/CCDMessageDistributer coordinates the process, sending messages to all elements in the collection.
General/CCDCollect collects the results, and returns them as the result of the invocation.
General/CCDSelect keeps elements which returned YES.
General/CCDReject keeps elements which returned NO.
General/CCDCombine and General/CCDReverseCombine combine results into a single value.
General/CCDCollectionMediator knows how to access elements of a collection. There is a subclass for keyed collections.
General/CCDForwarder decouples forwarding from messaging. This means General/CCDMessageDistributer inherits any General/NSObject categories.

It "should" be fairly trivial to write a subclass, for example you could change:

*The way the General/CCDMessageDistributer works. How about a category to take advantage of multiple processors?
*The kind of collection - could extend to trees etc., any other properties of the
collection. 
*The kind of result collection returned - could take a dictionary but return an array etc. 
Not sure if that is useful though.


Contrasting with General/BSTrampoline, "do" is now "all" because reusing keywords seems a bit messy and "all" 
seems right, semantically. If enough people complain I'll change it back. But I like "all".

**Extending**

To write a subclass, override any or all of the methods below: 

If you want to do something with the invocation, override:
*prepare:       - before any messages are sent.
*perform:       - sending of each method. You should setup (if necessary) and invoke the method.
*conclude:     - used to pass back the result collection in the invocation, or do any concluding tasks.
*prototypeMethod - an example of the type of method handled.
 *forwardInvocation: - to alter the way the General/CCDMessageDistributer works, eg for SMP

You should also add a category to General/NSObject with a method to create your messager with a collection.

**Notes on Combine**

(NB: combine|reverseCombine are comparable to foldl|foldr in Haskell )

General/CCDCombine combines the elements in turn, using the method specified, to produce a single result of the same type as the elements in the collection. General/CCDCombine therefore only accepts methods that take an object as argument and return another object which also responds to the same method.

For example, stringByAppendingString: which takes a string as target and argument, and returns a string.
Using combine and stringByAppendingString we can append all strings in a collection thusly:

   General/myStrings combine] stringByAppendingString:nil];

 nil is used because that argument will be replaced using elements from the collection. If an argument is specified, it will be used before the first element. This allows you to "carry on" a calculation over several collections. Make sure the argument can respond meaningfully to the selector - this may mean it needs to be mutable.
 For example:

   [[myStrings combine] stringByAppendingString:[[[NSMutableString stringWithString:@"> "]];

 joins all the strings in the collection onto "> "

 Any other arguments to the method are left untouched, and used every time.

 Take a really simple example - summing General/NSNumbers. We have a method called plus:, denoted "+". [number plus:anotherNumber] returns the sum of the two numbers as an General/NSNumber. Our collection contains 5 elements, each of which is an General/NSNumber:

 [@1,@2,@3,@4,@5]

 This is a simplified representation of what will happen:

    
 [@1 +:@2]         the 1st and 2nd General/NSNumbers are plus:ed and stored in the result, denoted @,
     |
    [@ +:@3]       the result is plus:ed with the 3rd General/NSNumber,
       |
      [@ +:@4]     that result is plus:ed with the 4th General/NSNumber,
         |
        [@ +:@5]   and so on,
           |
           v
         result    the final result is returned as the returnValue of the original invocation.


Combine uses the previous result as a target, with the next element as first argument. Reverse combine does things the opposite way round, with the result as argument and the next element as target, which may affect the final result depending on the method used. If your result comes out in reverse, use the opposite version.

----

We should put together some numbers comparing e.g. performance between General/LSTrampoline, General/BSTrampoline, and this.

The numbers would be mostly for my own benefit in deciding whether to continue using General/LSTrampoline (now General/CXLTrampoline) or to move to General/CCDMessageDistributor. (Probably I'll stick with the CXL one cos of the GPL, but I'm impressed with the whole combine/reverse-combine thing, and I know I'd not have thought to package specific HOM operations as objects in General/MediatorPattern.)

-- General/RobRix

Yeah I should have put up a comparison already. I do think that it was presumptious of me to use the CCD prefix for cocoadev. In fact thinking about it, that's more likely to cause a namespace conflict than anything else. And who decides what goes under CCD? So maybe I should move it yet again : ( and engage brain before clicking mouse next time.

We could do a quick, time-based comparison using the test routines, but I'm pretty sure General/CCDMessageDistributer will come off worse, because of the extra message unraveling involved, and probably come off slightly worse memory wise because of the extra objects created. But these are constant and O(1) complexity differences, so for me, I don't worry, I buy a better machine. The point about General/CCDMessageDistributer is it should be easy to extend with new HOM operations.  -- General/MikeAmy

*My expectation would be that the numbers would read slightly in favour of [BL]General/STrampoline, but like you, I don't worry; it's just a matter of 'fast enough'-- in (for instance) General/LodeStone, I use HOM (a lot) in the generating of bezier patches, so there are potentially thousands of message-sends to said patch when I change it. Right now, it's fast enough; as long as it's fast enough with *General/MessageDistributor too, there's no problem for me in changing.*

----