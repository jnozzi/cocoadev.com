An enumerator is an object that returns successive elements of a sequence, such as an array.

http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSEnumerator.html

Usually used to access the contents of collections; see General/FoundationCollections for a general overview.

----
**NOTES**

For a general discussion about the utility of General/NSEnumerator<nowiki/>s and enumerators/iterators in general, refer to the OOP classic *Design Patterns* by Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides.  Specifically, check out the **Iterator** design pattern on page 257.  Caveat Emptor!  The code samples in this book are in C++ with a bit of Smalltalk.  Nevertheless, if you want to learn about general software design, this is an excellent book to read, and there is quite a bit of conceptual discussion that is beneficial.

**Could an overview be provided for those of us who will never, ever have an opportunity to read this excellent work? -- General/RobRix**
----
Browse around:

http://hillside.net/patterns/General/DPBook/GOF.html
http://hillside.net/patterns/onlinepatterncatalog.htm
http://macromates.com/sigpipe/archives/2004/09/13/iterating-an-array/

----

Use General/NSEnumerator to loop through an array via a while loop to perform some operation on or with each object in the array. If the array is empty, nothing happens in the while loop.

Example Code:

    
General/NSArray * myArray = General/[NSArray arrayWithObjects:@"One", @"Two", @"Three", nil];
General/NSEnumerator * myArrayEnumerator = [myArray objectEnumerator];
General/NSString *thisObject;
while (thisObject = [myArrayEnumerator nextObject])
{
  General/NSLog(@"thisObject: %@", thisObject);
}


Produces:

    
thisObject: One
thisObject: Two
thisObject: Three


----

Can someone explain to me why you would ever bother to use an General/NSEnumerator to run over an array since all the tests I have seen show that they are far slower than the C equivilent...

    


General/NSArray *myArray =  General/[NSArray arrayWithObjects:@"One", @"Two", @"Three", nil];
unsigned count;
unsigned arrayCount = [myArray count];
for (count = 0; count < arrayCount; count++)
{
   General/NSLog (@"thisObject: %@",[myArray objectAtIndex:0]);
}



JKP

----

There are a couple of reasons. One is speed. Yes, that's right. General/NSEnumerator can be faster than a for loop. See General/NSEnumeratorSpeed for test code and results. The reason is that General/NSEnumerator can take advantage of knowing General/NSArray's internal structure and optimize its use of it for linear access, whereas continually calling     -objectAtIndex: can't.

Another reason is to write more generic code. If your code uses General/NSEnumerator, then it will work not only with arrays, but also with sets, dictionaries and anything else that responds to     -objectEnumerator without having to change anything.

It also avoids off-by-one errors.
----
They're also great to use if you don't know the type of the thing you are enumerating, only that it is enumerable. For example, imagine a method that operates on a collection of objects. If you only need to enumerate it, and don't need random access, a set or an array will do just fine, so the contract of the method could be that the collection parameter is just something that responds to objectEnumerator. Jon H.