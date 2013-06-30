I'm working on a framework with 25-30 classes, and right now I'm in a testing phase, writing nice test cases for most of the classes. While doing this I discover lots of memory leaks, and fix them. However, I only discover the leaks as a result of testing the other code, so I'm probably missing some. In one of the cases, I wrote a simple addition to one of my classes, so that it incremented a counter whenever it was alloc'ed and decremented the same counter when it was dealloc'ed, effectively giving me a counter telling me how many instances of this class that were around at any given time. Then I calculated the difference between the number of instances before the tested code, and compared that to the number after (making sure that I had allocated a new autorelease pool for that code, and released it before the comparation). This was very handy for detecting where the memory leaks actually occured.

Now, I want to do this with any class. I know that there are two utilities called General/OmniObjectMeter and General/ObjectAlloc, that can do something like this. But what I want to do is to include this check in my testcases, which means that running General/ObjectAlloc or whatever is not an option. What I want to do is call a function that gives me the current instance count of a named class (any class, not just my own), then execute some code and compare the new result from that function with the old in an assertion or something. Then I can select the test target in my project, type command-r and just wait for the message "All tests passed".

So, how do I do this? Apple and Omni knows how, so it must be possible.

--General/TheoHultberg/Iconara

----

You could try using General/MethodSwizzling to add to General/NSObject's allocWithZone:/retain/release methods. -- General/KritTer

----

Nice idea, I will try this out and report back.
-- General/TheoHultberg/Iconara

----

OK, here's my implementation: (link removed, see below instead)

Example
    
// wrap the counting in an autorelease pool, so that we can
// release any autoreleased objects before counting
General/NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];

int count;

General/IXStartInstanceCounting();

count = General/IXInstaceCountForClass( [Foo class] );

doSomethingThatMightLeakMemory();

// important! if the pool is not released, the instance count
// will be higher because of any autoreleased objects in the pool
[pool release];

// check so that the number of instances of Foo is the same as
// before the function call that might leak (in this case zero)
General/NSCAssert( diff == General/IXInstaceCountForClass( [Foo class] ), @"Leaking memory" );

General/IXEndInstanceCounting();


You can also use the function General/IXAllInstanceCounts() to get a dictionary with all the classes that have been allocated since the count started, and the number of instances of them. 

I have decided on having a start and end function since the code that does the counting shouldn't be on always (it's a lot of uneccesary instructions if you're not interested in the counting).

-- General/TheoHultberg/Iconara

----

*Can you rewrite your code to automatically report *all* memory leaks? Having to do it per class could well miss mistakes, e.g. where you used a temporary General/NSString and forgot to release it properly. -- General/KritTer*

----

Yeah, sure, I'll do that. There are problems with it though, General/NSString isn't just General/NSString, it's reported as General/NSCFString and other kinds as well (because of General/NSString being a General/ClassCluster), but what the hell, it's no big deal. --General/TheoHultberg/Iconara

----

OK, now, if you call the function General/IXEndInstanceCountingAndCheckLeaks() (hey, that was a long name) it'll trow an exception (General/IXMemoryLeakException) warning you that there are alloc'ed objects that have not been dealloc'ed. The message will tell you which classes and how many instances there are left. The userInfo dictionary contains all classes and their counts.
-- General/TheoHultberg/Iconara (who loves when he can solve his own problems with just a nudge in the right direction from someone, cheers General/KritTer)

*No problemo. In the interest of global harmony...or...something...anyway, I'm posting the code you made up here. We can then scour it and refactor it, and it's up even if your server perishes :) Take it down of course if you object. -- General/KritTer*

Good idea --General/TheoHultberg

----

**General/IXInstanceCounting.h**

    
/*
 * @header         General/IXInstanceCounting
 * @abstract       This is a collection of functions to enable instance counting
 * @discussion     Instance counting is a way to count how many instances of a
 *                 class that exist in the scope of a program at a given time.
 *                 It can be used to discover and track memory leaks, or just to
 *                 discover how memory management in a piece of code works.
 *
 *                 Instance counting is not reference counting, the difference is
 *                 that the instance count tells you how many instances of a class
 *                 (that is, how many objects) exist, whereas reference counting
 *                 tells you how many references to a single instance (object)
 *                 there are.
 *
 *                 Basic usage:
 *                 Cocoa does not support instance counting by itself, so we have
 *                 to strap it on somehow. This is done by calling the function
 *                 General/IXStartInstanceCounting before the code you wish to check.
 *                 Call the funtion General/IXEndInstanceCounting to end the instance
 *                 counting. In between the two calls you can check the current
 *                 number of instances of a class by calling the function
 *                 General/IXInstanceCountForClass with the class that you're interested
 *                 in as an argument.
 *
 *                 The instance count will be relative to when counting started.
 *                 If you create twenty instances of General/NSString, and then start
 *                 instance counting, General/IXInstanceCountForClass will still report
 *                 that the instance count of General/NSString was zero.
 *
 *                 It's a good idea to create an autorelease pool around the code
 *                 you're checking, since any autoreleased objects otherwise would
 *                 report as leaking when the instance counting ended.
 *
 *                 Example:
 *                     General/NSAutoreleasePool *pool;
 *                     General/DOMDocument *document;
 *                     int documents, elements, attributes, texts, pis;
 *                 	
 *                     General/IXStartInstanceCounting();
 *                 	
 *                     pool = General/[[NSAutoreleasePool alloc] init];
 *                 	
 *                     document = General/[[DOMBuilder defaultBuilder] buildFromFile:@"XML/build.xml"];
 *
 *                     documents  = General/IXInstanceCountForClass( General/[DOMDocument class] );
 *                     elements   = General/IXInstanceCountForClass( General/[DOMElement class] );
 *                     attributes = General/IXInstanceCountForClass( General/[DOMAttribute class] );
 *                     texts      = General/IXInstanceCountForClass( General/[DOMText class] );
 *                     pis        = General/IXInstanceCountForClass( General/[DOMProcessingInstruction class] ); 
 *
 *                     General/NSLog( 
 *                         @"There are %d documents, %d elements, %d attributes, %d texts and %d processing instructions",
 *                         documents, elements, attributes, texts, pis
 *                     );
 *                 
 *                     [pool release];
 *                 	
 *                     General/IXEndInstanceCounting();
 *
 *                 Advanced usage:
 *                 The function General/IXEndInstanceCountingAndCheckLeaks can be used to end
 *                 the instance counting and throw an exception if any class has
 *                 an instance count of more than one. I use this feature in my unit 
 *                 testing to test complex features that I suspect contain memory leaks.
 *                 I end the instance counting with General/IXEndInstanceCountingAndCheckLeaks, 
 *                 which throws an exception if any class has a positive instance count.
 *                 I catch this exception and trigger an assertion failure, which is
 *                 picked up by my unit testing framework, and reported as a test failure.
 *
 *                 Example:
 *                     General/NSAutoreleasePool *pool;
 *                     
 *                     General/IXStartInstanceCounting();
 *                     
 *                     pool = General/[[NSAutoreleasePool alloc] init];
 *                     
 *                     // test code goes here
 *
 *                     [pool release];
 *                     
 *                     NS_DURING
 *                         General/IXEndInstanceCountingAndCheckLeaks();
 *                     NS_HANDLER
 *                         General/NSAssert ( NO, @"Memory leak!" );
 *                     NS_ENDHANDLER
 *
 *                 Notes:
 *                 General/IXStartInstanceCounting will raise an exception if called again without
 *                 first having called General/IXEndInstanceCounting or General/IXEndInstanceCountingAndCheckLeaks.
 *                 
 *                 General/IXInstanceCountForClass and General/IXAllInstanceCounts will raise an
 *                 exception if no counting is in progress.
 *
 *                 The instance counts of some classes can sometimes be negative,
 *                 this is only natural, since instances created before the start
 *                 of the instance counting can be deallocated within the scope of
 *                 the instance counting.
 *
 *                 The dictionary returned by General/IXAllInstanceCounts has class objects
 *                 as keys, and instances of the class General/IXCount as values. Call
 *                 the method -value on the General/IXCount instance to get the instance count.
 *                 The reason why the values are not General/NSNumbers is that General/NSNumbers are
 *                 immutable, and the counts are updated very frequently, you don't
 *                 want to create an throw away massive amounts of objects like that,
 *                 especially when doing memory leak checking...
 *
 *                 There is more documentation on the functions below.
 *                 
 */

#import <Foundation/Foundation.h>

/*!
 * @extern         General/IXMemoryLeakException
 * @abstract       Raised when a memory leak is discovered, 
 *                 see General/IXEndInstanceCountingAndCheckLeaks
 */
extern General/NSString *General/IXMemoryLeakException;

/*!
 * @extern         General/IXInvalidStateException
 * @abstract       Raised if the instance counting is forced in to an
 *                 ivalid state, i.e when start is called twice without
 *                 an end in between.
 */
extern General/NSString *General/IXInvalidStateException;

/*!
 * @function       General/IXStartInstanceCounting
 * @abstract       Call to start instance counting
 * @discussion     Did I mention that you have to call this method 
 *                 before you want instance counting to begin?
 *
 *                 It is recommended that you create a local autorelease
 *                 pool just after calling this function, and release
 *                 that pool just before ending the counting. By doing this
 *                 you ensure that any autoreleased objects are released
 *                 properly and don't look like unreleased objects in the counts.
 *
 *                 If this method is called again, before the counting has ended
 *                 an exception of type General/IXInvalidStateException will be raised.
 */
void General/IXStartInstanceCounting( void );

/*!
 * @function       General/IXEndInstanceCounting
 * @abstract       Call when instance counting is no longer needed, 
 * @discussion     After this function has been called, all counts are lost,
 *                 but since the counting is not free, neither in space
 *                 nor time, it can be a good idea to end the counting.
 *
 *                 This function has no effect if instance counting has not
 *                 started (i.e General/IXStartInstanceCounting has not been called).
 */
void General/IXEndInstanceCounting( void );

/*!
 * @function       General/IXEndInstanceCountingAndCheckLeaks
 * @abstract       Does what General/IXEndInstanceCounting does and raises
 *                 an exception of type General/IXMemoryLeakException
 *                 if there was any class that had a positive 
 *                 instance count.
 * @discussion     The message of the exception will contain the names
 *                 of the classes that were leaked. The user info
 *                 dictionary contains all classes and their instance counts.
 */
void General/IXEndInstanceCountingAndCheckLeaks( void );

/*!
 * @function       General/IXInstanceCountForClass
 * @abstract       Get the number of unique instances there has
 *                 been created since instance counting started.
 * @discussion     If the number is negative, it means that
 *                 some objects have been alloc'ed before the instance 
 *                 counting started.
 *
 *                 If instance counting has not been started this function
 *                 raised an exception of type General/IXInvalidStateException 
 *                 is raised.
 *
 */
int General/IXInstanceCountForClass( Class class );


/*!
 * @function       General/IXAllInstanceCounts
 * @abstract       Returns a dictionary containing all the counts for all classes
 * @discussion     The keys of the dictionary are the classes, the value
 *                 is an object of type General/IXCount.
 *
 *                 If instance counting has not been started this function
 *                 raised an exception of type General/IXInvalidStateException 
 *                 is raised. 
 */
General/NSDictionary *General/IXAllInstanceCounts( void );

/*!
 * @class          General/IXCount
 * @abstract       A simple counter class.
 * @discussion     Dictionaries take only objects as values, and the instance
 *                 counting scheme needs a counter, so instead of creating
 *                 and destroying lots of General/NSNumbers just to increment
 *                 and decrement the instance count of a class, General/IXCount is used.
 *                 You can increment, decrement and get the value. Everything you need.
 */
@interface General/IXCount : General/NSObject {
	int i;
}

/*!
 * @method         increment:
 * @abstract       Increments the value by one, equivalent to ++.
 */
- (void)increment;

/*!
 * @method         decrement:
 * @abstract       Decrements the value by one, equivalent to --.
 */
- (void)decrement;

/*!
 * @method         value:
 * @abstract       Returns the current value as an int.
 */
- (int)value;

@end


----

**General/IXInstanceCounting.m**

    
#import "/usr/include/objc/objc-class.h"

#import "General/IXInstanceCounting.h"


void _IXICSwizzle(void);
void _IXMethodSwizzle(Class aClass, SEL orig_sel, SEL alt_sel);

General/NSString *General/IXMemoryLeakException   = @"General/IXMemoryLeakException";
General/NSString *General/IXInvalidStateException = @"General/IXInvalidStateException";

static General/NSMutableDictionary *General/IXInstanceCounts = nil;


@interface General/NSObject ( General/InstanceCounting ) 

- (id)ixic_init;

- (void)ixic_dealloc;

@end


void General/IXStartInstanceCounting( ) {
	if ( General/IXInstanceCounts == nil ) {
		General/[IXInstanceCounts release];
		General/IXInstanceCounts = General/[[NSMutableDictionary alloc] init];
	
		_IXICSwizzle();
	} else {
		General/[NSException raise:General/IXInvalidStateException
		            format:@"Instance counting already in progress"];
	}
}

void General/IXEndInstanceCounting( ) {
	if ( General/IXInstanceCounts != nil ) {
		_IXICSwizzle();
	
		General/[IXInstanceCounts release];
	
		General/IXInstanceCounts = nil;
	}
}

int General/IXInstanceCountForClass( Class class ) {
	if ( General/IXInstanceCounts != nil ) {
		General/IXCount *i = General/[IXInstanceCounts objectForKey:class];
	
		return [i value];
	} else {
		General/[NSException raise:General/IXInvalidStateException
		            format:@"Instance counting not in progress"];
		return nil;
	}
}

General/NSDictionary *General/IXAllInstanceCounts( ) {
	if ( General/IXInstanceCounts != nil ) {
		return General/IXInstanceCounts;
	} else {
		General/[NSException raise:General/IXInvalidStateException
		            format:@"Instance counting not in progress"];
		return nil;
	} 
}

void General/IXEndInstanceCountingAndCheckLeaks( ) {
	if ( General/IXInstanceCounts != nil ) {
		General/NSException *exception;
		General/NSMutableDictionary *leaks = General/[NSMutableDictionary dictionary];
		General/NSMutableString *leakedClasses = General/[NSMutableString string];
		General/NSEnumerator *e;
		Class c;
		
		_IXICSwizzle();

		e = General/[IXInstanceCounts keyEnumerator];
		
		if ( c = [e nextObject] ) {
			General/IXCount *count = General/[IXInstanceCounts objectForKey:c];
			
			if ( [count value] > 0 ) {
				[leakedClasses appendFormat:@"%@ (%d)", General/NSStringFromClass(c), [count value]];
			}
		}
		
		while ( c = [e nextObject] ) {
			General/IXCount *count = General/[IXInstanceCounts objectForKey:c];
		
			if ( [count value] > 0 ) {
				[leakedClasses appendFormat:@", %@ (%d)", General/NSStringFromClass(c), [count value]];
				[leaks setObject:count forKey:c];
			}
		}
		
		if ( [leaks count] > 0 ) {
			General/NSString *reason = General/[NSString stringWithFormat:@"Memory leak detected: %@", leakedClasses];
		
			exception = General/[NSException exceptionWithName:General/IXMemoryLeakException 
			                                    reason:reason
			                                  userInfo:General/IXInstanceCounts];
		} else {
			exception = nil;
		}

		General/[IXInstanceCounts release];
	
		General/IXInstanceCounts = nil;
		
		[exception raise];
	} else {
		General/[NSException raise:General/IXInvalidStateException
		            format:@"Instance counting not in progress"];
	} 
}

void _IXICSwizzle( ) {
	_IXMethodSwizzle(General/[NSObject class], @selector(init),   @selector(ixic_init));
	_IXMethodSwizzle(General/[NSObject class], @selector(dealloc), @selector(ixic_dealloc));
}

void _IXMethodSwizzle(Class aClass, SEL orig_sel, SEL alt_sel) {
	/*
	 * General/IXMethodSwizzle
	 * This function exchanges one implementation of
	 * a method with another, it is used by General/IXStartInstanceCounting
	 * and General/IXEndInstanceCounting to enable or disable the instance
	 * counting scheme.
	 * Kudos to Jack Nutting & Kritter for this code. See
	 * http://www.cocoadev.com/index.pl?General/MethodSwizzling	
	 * for more information.
	 */
	 
	Method orig_method = nil, alt_method = nil;

	// First, look for the methods
	orig_method = class_getInstanceMethod(aClass, orig_sel);
	alt_method = class_getInstanceMethod(aClass, alt_sel);

    // If both are found, swizzle them
    if ((orig_method != nil) && (alt_method != nil)) {
		char *temp1;
		IMP temp2;

		temp1 = orig_method->method_types;
		orig_method->method_types = alt_method->method_types;
		alt_method->method_types = temp1;

		temp2 = orig_method->method_imp;
		orig_method->method_imp = alt_method->method_imp;
		alt_method->method_imp = temp2;
	}
}

@implementation General/IXCount

- (id)init { self = [super init]; i = 0; return self; }

- (void)increment { i++; }

- (void)decrement { i--; }

- (int)value { return i; }

- (General/NSString *)description { return General/[NSString stringWithFormat:@"General/IXCount[value=%d]", i]; }

@end


@implementation General/NSObject ( General/InstanceCounting )

- (id)ixic_init {
	if ( [self class] != General/[IXCount class] ) {
		General/IXCount *i = General/[IXInstanceCounts objectForKey:[self class]];
	
		if ( i == nil ) {
			i = General/[[IXCount alloc] init];
			General/[IXInstanceCounts setObject:i forKey:[self class]];
		}
		
		[i increment];
	}
	
	return [self ixic_init];
}

- (void)ixic_dealloc {
	if ( [self class] != General/[IXCount class] ) {
		General/IXCount *i = General/[IXInstanceCounts objectForKey:[self class]];
	
		if ( i == nil ) {
			i = General/[[IXCount alloc] init];
			General/[IXInstanceCounts setObject:i forKey:[self class]];
		}
	
		[i decrement];
	}
	
	[self ixic_dealloc];
}

@end



----

*Changes:*


* Moved an import to the .m --Theo
* Fixed a bug in General/IXEndInstanceCountingAndCheckLeaks, the exception would be raised before the instance counts dictionary was emptied. --Theo
* Added state checks, will raise an exception if instance counting is already in progress (currently only supports one counting at a time, could perhaps be extended to allow for several counts at the same time). --Theo
* Added loads of documentation to the header. --Theo