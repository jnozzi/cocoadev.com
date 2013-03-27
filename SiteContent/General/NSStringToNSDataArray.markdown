 
 
What would be an easy way to take each character out of an General/NSString, and place it into an array of General/NSData's?  Or hell, to further that, what would be an easy way to go back from single General/NSData's into an General/NSString?  (for the latter, I would assume use a Mutable String, yes?)
 
Could someone provide some sample code for both, please?  Thanks :)

----
I'm sick and just got out of bed, so caveat emptor.

    

-(General/NSArray *)dataArrayFromString:(General/NSString *)theString
{
    General/NSMutableArray *myArray = General/[NSMutableArray arrayWithCapacity:0];

    int i;

    for (i=0; i < [theString length]; i++)
      {
	[myArray addObject: General/[NSArchiver archivedDataWithRootObject:[theString substringWithRange: General/NSMakeRange(i,1)]]];
      }
    return General/myArray copy] autorelease];
}


-([[NSString *)stringByAppendingDataInArray:(General/NSArray *)theDataArray;
{
    General/NSMutableString *myString = General/[NSMutableString stringWithCapacity:0];
    General/NSData *eachObject;
    General/NSEnumerator *arrayEnumerator = [theDataArray objectEnumerator];

    while (eachObject = [arrayEnumerator nextObject])
      {
	General/NSString *aCharacter = General/[NSUnarchiver unarchiveObjectWithData: eachObject];

	[myString appendString: aCharacter];
      }
    return General/myString copy] autorelease];
}



----

Using a for loop to go through the array will be faster than using [[NSEnumerator

*Can you quantify that? General/NSEnumerator is fast.*

----

It seems to be 'accepted knowledge' that there's a slight overhead with General/NSEnumerator. I doubt you'd see any noticable difference until you get up to an array with many thousands of elements though.

----

Is it just me, or do the above two code samples leak the initially allocated General/NSMutableArray and General/NSMutableString instances? Each of them is copy'ed and the copy is autoreleased, but the initial instance that operates as the scratch space is ignored. I'm still getting my head around retain and release, i come from java ;-)

*It appears fine to me. Any of the arrayWith... or stringWith... methods are autoreleased so you don't have to do anything with them unless you want to keep them around longer.*

----

The above code can be sped up by saying

    
    General/NSMutableArray *myArray = General/[NSMutableArray arrayWithCapacity:[theString length]];


and

    
    General/NSMutableString *myString = General/[NSMutableString stringWithCapacity:[theDataArray count]];


to roughly preallocate the amount of space that will be needed, instead of just passing zero for the capacity. Adding to mutable objects is much faster if the object already has enough room to do it in.