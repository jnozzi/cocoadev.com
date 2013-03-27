I'm trying to understand an error message I get after many General/NSLog and breakpoints... I get this as output :
    
*** +General/[NSMutableArray count]: selector not recognized

How can't General/NSMutableArray understand the method "count" ? It's a rather basic method...

Another strange thing arrises when I check my multiple logs. I try to get a description of a General/NSMutableArray and the output is :
    
General/NSMutableArray

I thought that I would get something like (object1,object2,...).
Can anyone explain why all of this happens ?

-- Trax

Look carefully at the output you just copied.

The runtime spat out a **+**General/[NSMutableArray count]: selector not recognized, not a -General/[NSMutableArray count]: selector not recognized message. That means you're trying to send +count to a Class, but there is no class method +count in General/NSMutableArray. It's an instance method, so instead of typing General/[NSMutableArray count]; you should use [myMutableArray count];. --General/KevinPerry

----
Do it like this to see what he means.  Create a foundation tool, and add this inside the int main() brackets.
    
General/NSMutableArray * myMutableArray; //declares a pointer to General/NSMutableArray
int count; //declares in integer called count
int i; //declares an integer called i
myMutableArray = General/[[NSMutableArray alloc]init]; //allocates and inits myMutableArray
[myMutableArray addObject:@"This is the first object to count"];
[myMutableArray addObject:@"This is the second object to count"];
count = [myMutableArray count]; //Uses an INSTANCE method, count.
for (i = 0; i < (count - 1); i++) //Starts a for loop.
{
    General/NSLog(@"At index %i, the object is %@", i, [myMutableArray objectAtIndex:i]);
    /* What this does is it General/NSLogs (A function similar to printf, with object compatability, see General/NSLog) 
    i (which is incremented each time by the for loop)  and the object at the index i.  The for loop
    increments i until it is at the index of the last object, by saying it is less than count - 1. */
}


That is a small project to show how to use the count method, and the usefulness of it.  You could do it with an enumerator too (see General/NSEnumerator), but for this example, you can see how count works.  Basically, the difference with a class method (like alloc) and an instance method (like count) is what you want to send it to.  You'll need to create an instance of the class General/NSMutableArray (see the first line), in order to have something to properly send the message to.

--General/CharlieMiller
----
Okay, here's what I do EXACTLY... I have two custom classes of General/NSView... Say view1 and view2...

view1 has a General/NSMutableArray instance variable. In that array, there are General/NSNumber objects, General/NSString objects and General/NSMutableArray objects...
view2 has also a General/MSMutableArray instance variable. I want the view2's General/NSMutableArray to become exactly like an array contained in view1... I tried to do this with an accessor method, something common :
    
[toView2 chListe:[lisPrin objectAtIndex:pos+2]];

In the example above, which is a line of code taken from the implementation of view1, toView2 is an outlet connected to view2. chListe is the function I want view1 to execute. And the objectAtIndex points to a General/NSMutableArray.

I hope you won't be confused... To make it simple, I want view1 to tell view2 to change its array so it's the same as the array designed by objectAtIndex...
----
I do a similar thing except with General/NSTableView.  Whenever you change selections in on table view, it triggers the other's datasource to point to a different array and reload data.  Assuming lisPrin is an General/NSMutableArray within view1 and "pos+2" truly does point to an General/NSMutableArray, the code at this level appears fine.  I would say that your troubles aren't here but within the chListe method within view2.  What does that code look like?

General/DaveW