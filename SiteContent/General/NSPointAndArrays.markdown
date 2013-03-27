How do you make an array of General/NSPoints? I'm trying to generate a path using some points stored in a General/NSMutableArray. Any help?

-- General/JohnDevor


----

My first try at this was sacrificed to the wiki gods so let's try this again.  General/NSValue is designed to handle precisely this problem. -- Bo

To insert:
    
[myArray addObject:General/[NSValue valueWithPoint:myPoint]];

And to retrieve:
    
myPoint = General/myArray objectAtIndex:i] pointValue];



----

Hey learn something new every day!!! --zootbobbalu

----

Sweet... 

-- [[JohnDevor

----

If you want to go the C route, I believe General/NSPointArray is defined as General/NSPoint *. All standard warnings apply. -- General/RobRix

----

You might try an General/NSSet.  I believe it is a useful container for other objects with faster sorting/comparison than an General/NSArray.

-- General/SashaGelbart

General/NSSet is a great class, but if you need to preserve ordering, then it's of less utility. -- General/RobRix

Or you could do something completely amusing (and a waste of time) and simply make each General/NSPoint a data item and place it in the array. Why? I dunno...was too early in the morning to make up something else.