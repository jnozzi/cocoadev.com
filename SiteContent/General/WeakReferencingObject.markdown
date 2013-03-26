<insert>Can anyone tell me why this example is allowed to ignore the "must be the same size" rule of poseAsClass: by adding an extra int to the definition? Incidentally, I reformatted the code to stop it adding a horizontal scrollbar on my screen. --[[KritTer]] </insert>

Have written it, I can't tell you that. It compiles... or did... maybe bit rot has set in, I'm not certain. As it is, I don't really have any use for it, so it's fallen by the proverbial wayside; thank you for the formatting, however (the horizontal scrollbar is bloody ''evil''). -- [[RobRix]]

----

[[FDWeakReferencingObject]] is a nice little class which poses as [[NSObject]] to give all objects some lovely little [[WeakReferencing]] methods.

Class reference:

* +(void)setupWeakReferencing

This does absolutely nothing except insure that the runtime has sent the +initialize method to the class. Use this to allow you to use weak referencing everywhere. This is the only method you'll need to call directly. 
* -(id)weakRetain

Increments the weakRetainCount and retainCount.
* -(void)weakRelease

Decrements the weakRetainCount and retainCount.
* -(void)release

This is an extension of [[NSObject]]'s -release method (that is, it calls [[NSObject]]'s -release method within the implementation). All it adds is a short block of code to check whether or not the weakRetainCount and retainCount are the same, and if they are, it -releases and -weakReleases self till both counts are zero.
* -(unsigned int)weakRetainCount

Returns weakRetainCount, which is the number of weak retains that have been made.
* -(id)description

Returns a description of the instance. This varies from [[NSObject]]'s version by putting the weakRetainCount in along with the class name.


----

I have provided the code for your fancy (this is newer than the code on my site):

'''From [[FDWeakReferencingObject]].h'''

<code>
//
//  [[FDWeakReferencingObject]].h
//  [[FDFoundation]]
//
//  Created by Rob Rix on Sun Jun 24 2001.
//  Copyright (c) 2001 Rob Rix. All rights reserved.
//

//	v1.2

#import <Foundation/Foundation.h>

void setupWeakReferencing();
// sets up weak referencing by making _certain_ that the
// [[FDWeakReferencing]] Class has had a chance to pose as [[NSObject]].
// It does this by allocating and releasing a temporary
// object, so we know that the runtime has sent the +initialize
// message to the class.

@interface [[FDWeakReferencingObject]] : [[NSObject]]
{
	unsigned int weakRetainCount;
}
+(void)initialize;
+(void)setupWeakReferencing;

-(id)weakRetain;
-(void)release;
-(void)weakRelease;

-(unsigned int)weakRetainCount;

-(id)description;
@end
</code>

----

'''From [[FDWeakReferencingObject]].m'''

<code>
//
//  [[FDWeakReferencingObject]].m
//  [[FDFoundation]]
//
//  Created by Rob Rix on Sun Jun 24 2001.
//  Copyright (c) 2001 Rob Rix. All rights reserved.
//

//	v1.2

#import "[[FDWeakReferencingObject]].h"

@implementation [[FDWeakReferencingObject]]

+ (void)initialize
{
	static BOOL tooLate = NO;
	if (tooLate == NO)
	{
		[[[FDWeakReferencingObject]] poseAsClass:[[[NSObject]] class]];
		tooLate = YES;
	}
}

+(void)setupWeakReferencing
{
	// that's all we need to get it to work. empty. not a thing further.
    //life is sweet.
}

-(void)__incrementCount
{
	weakRetainCount++;
}

-(void)__decrementCount
{
	weakRetainCount--;
}

-(id)weakRetain
{
	[self __incrementCount];
	return [self retain];
}

-(void)release
{
	if([self retainCount] == [self weakRetainCount])
	{
		unsigned int counter = 0;
		for(counter = 0; counter < [self retainCount]; counter++)
		{
			[self weakRelease];
			[super release];
		}
	}
	else
	{
		[super release];
	}
}

-(void)weakRelease
{
	[self __decrementCount];
	[self release];
}

-(unsigned int)weakRetainCount
{
	return weakRetainCount;
}

-(id)description
{
	[[NSMutableString]] ''descriptionString = [[[[NSMutableString]] alloc] init];
	
	[descriptionString appendFormat:
        @"Instance of %@ with a weakRetainCount of %i",
        [self class], [self weakRetainCount]];

	return [descriptionString autorelease];
}

@end

void setupWeakReferencing()
{
	static BOOL hasBeenSetUp = NO;
	
	if(hasBeenSetUp == NO)
	{
		[[[FDWeakReferencingObject]] setupWeakReferencing];
	}
}
</code>

-- [[RobRix]]