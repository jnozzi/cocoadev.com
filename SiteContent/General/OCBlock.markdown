

An implementation of Smalltalk-style General/CodeBlocks in Objective-C.  At its guts is, for all intents and purposes, an Objective-C interpreter. This object enables General/HigherOrderMessaging, and creation of blocks is pretty easy, using General/OCBlock.h's ocblock() and ocblockc() macros.
    
[collection do:ocblock(:each | [each doSomething]; [self doSomethingWith:each];)];


If you're only using class objects, self, numerical or boolean constants, arguments (inclusive-)or block-local variables in your block, it's also ok to just use ocblock().  ocblockc() is a variadic macro that allows you to specify context keys(see General/OCBlock's test cases).

It's also possible to pass in your own General/OCBlockContext object using +General/[OCBlock blockWithString:inContext:].

Blocks can take arguments, which is really neat.  They can have local variables, too.  

Currying is also available with General/OCBlock, via the '- assumeValue:aValue forArgumentNamed:aName' and '- assumeValue:aValue atIndex:(int)anIndex' methods.  An example of currying is to prevent the overhead of multiple parsings of a block by parsing once and then assuming the arguments where necessary, as per:

    
- (id)checkElementsAgainst:(id)anObject
{
     static General/OCBlock * block = nil;
     if(block == nil) block = ocblock(:each :arg | [each isEqual:arg];);
     return [elements detect:[block assumeValue:anObject forArgumentNamed:@"arg"]];
}


This will return the first object in elements that is equal to anObject, or nil if none is equal.

General/OCBlocks can only deal with object values and General/BOOLs(which are automatically converted to General/OCBooleans).  At block parsing time, numerical constants will be turned into General/NSNumbers, and BOOL constants into General/OCBooleans.

----

The most recent revision of General/OSFoundation is tarred and gzipped and available at http://homepage.mac.com/being.  This includes General/OCBlock.

--General/JoeOsborn, of General/OpenSwordGroup.

**Er... I see it empty :'( ** -- l0ne aka General/EmanueleVulcano

Linkrot is a terrible thing.  I'll try and hunt down an archived copy somewhere -- sorry it's been lost!
A lot of uses of it, though, are being subsumed by KVC; -collect, for instance, is now implied by General/NSArray's -valueForKey:.  General/RobRix has a neat forall macro as well, inspired by General/AllanOdgaard:

    
#ifndef forall
#define forall(collection, element) for(id _ ## element ## _enumerator = [collection objectEnumerator], element; element = [_ ## element ## _enumerator nextObject]; )
#endif


*I should note that the only real difference between Allan's version from his blog and my version here is the ## element ## stuff which lets you nest them. Allan did the interesting bit, I just slapped some putty on the side. Yeaaaah, putty. - General/RobRix*

So, I'll repost General/OSFoundation.zip in the next few days, but there are alternatives to blocks now.  The burning need isn't there so much these days. -- General/JoeOsborn