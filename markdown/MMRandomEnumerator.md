

Credit where credit is due: This is General/MichaelMeer's original General/MMRandomEnumerator class

General/MMRandomEnumerator.h

    
//  General/MMRandomEnumerator.h
//  General/XQuizIt

//  Created by Michael Meer on Thu Oct 31 2002.
//  Copyright (c) 2002 Michael Meer. All rights reserved.

#import <Cocoa/Cocoa.h>

@interface General/MMRandomEnumerator: General/NSObject
{
	General/NSMutableArray *array;
	int currentIndex;
}

#pragma mark ��� INITIALIZATION ���

+ ( id ) initWithArray: ( General/NSArray * ) newArray;
- ( id ) nextObject;
- ( int ) count;

#pragma mark ��� ACCESSORS ���

- ( void ) setArray: ( General/NSMutableArray * ) newArray;
- ( General/NSArray * ) array;
- ( int ) currentIndex;

@end


General/MMRandomEnumerator.m:

    
//  General/MMRandomEnumerator.m
//  Shuffle the order of table entries or other array

//  Created by Michael Meer on Thu Oct 31 2002.
//  Copyright (c) 2002 Michael Meer. All rights reserved.

#import "General/MMRandomEnumerator.h"

@implementation General/MMRandomEnumerator

#pragma mark ��� INITIALIZATION ���

- ( id ) init
{
	if ( self = [ super init ] )
	{
		array =  [ [ General/NSMutableArray alloc ] init ];
		currentIndex = 0;
	}
	return self;
}

+ ( id ) initWithArray: ( General/NSArray * ) newArray
{
	General/MMRandomEnumerator *enumerator;
	General/NSMutableArray *newArrayCopy;
	General/NSMutableArray *resultArray;
	int arrayCount;
	int index;
	
	arrayCount = [ newArray count ];
	enumerator = [ [ General/MMRandomEnumerator alloc ] init ];
	newArrayCopy = [ General/NSMutableArray arrayWithArray: newArray ];
	resultArray = [ General/NSMutableArray arrayWithCapacity: arrayCount ];
	
	while ( [ resultArray count ] < arrayCount )
	{
		index = random( ) % [ newArrayCopy count ];
		[ resultArray addObject: [ newArrayCopy objectAtIndex: index ] ];
		[ newArrayCopy removeObjectAtIndex: index ];
	}
	
	[ enumerator setArray: resultArray ];
	
	return [ enumerator autorelease ];
}

- ( void ) dealloc
{
	[ array release ];
	[ super dealloc ];
}

- ( id ) nextObject
{
	if ( currentIndex >= [ array count ] )
	{
		return nil;
	}
	else
	{
		return [ array objectAtIndex: currentIndex++ ];
	}
}

- ( int ) count
{
	return [ array count ];
}

#pragma mark ��� ACCESSORS ���

- ( void ) setArray: ( General/NSMutableArray * ) newArray
{
	[ array autorelease ];
	array = [ newArray retain ];
}

- ( General/NSArray * ) array
{
	return array;
}

- ( int ) currentIndex
{
	return currentIndex;
}

@end
