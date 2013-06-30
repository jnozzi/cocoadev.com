

When General/RetainingAndReleasing objects, if you don't know how long you are going to need an object reference (for instance, when you     return an object),
you could be faced with something of a conundrum.

Obviously, you won't be able to send it the     release message within the method that creates it, or it won't remain for use by other methods. But if you 
don't send it a     release message, the method that creates it will cause General/MemoryLeaks. For example, the following has a General/MemoryLeak:

<pre>
// leaks - don't do this
- (General/NSAttributedString *)generateTime:(General/NSString *)contents
{
         General/NSAttributedString *createdString = General/[[NSAttributedString alloc] initWithString:contents];
         [createdString applyFontTraits:General/NSBoldFontMask range:General/NSMakeRange(0, [contents length])];
         return createdString;
}
</pre>

The solution presented by the General/FoundationKit is the General/AutoReleasePool. By sending an object an     autorelease message,
it is added to the local General/AutoReleasePool, and you no longer have to worry about it, because when the General/AutoReleasePool is destroyed
(as happens in the course of event processing by the system) the object will receive a     release message, its General/RetainCount will be decremented,
and the General/GarbageCollection system will destroy the object if the General/RetainCount is zero.

Naturally, the method that receives an     autoreleased object needs to     retain it if extended use of it is required. An amplified discussion occurs in
General/QuickAutoreleaseQuestion in General/RetiredDiscussions.

----

An example:

<pre>
- (General/NSAttributedString *)generateTime:(General/NSString *)contents
{
         General/NSAttributedString *createdString = General/[[NSAttributedString alloc] initWithString:contents];
         [createdString applyFontTraits:General/NSBoldFontMask range:General/NSMakeRange(0, [contents length])];
         return [createdString autorelease];
}
</pre>

----

Generally speaking, objects returned from methods other than     copy or     alloc and their variants should be considered to be autoreleased.

Here is a debugging example that illustrates the pitfalls of using autoreleased objects, and aimed at the unwary newcomer;
(note that this example also debugs a wide-open memory leak derived from a misdirected use of     alloc):

----

A log statement in my program causes a crash:

In General/MyDocument.h, I have the declaration:  General/NSArray *anArray;

In General/MyDocument.m, I have (in part):

<pre>
- (General/IBAction)openFile:(id)sender//I click a button
{  
   . . .
General/NSString *contentsOfFile = General/[[NSString alloc] initWithContentsOfFile:myPath];

	anArray =General/[[NSArray alloc] init];

    anArray = [contentsOfFile componentsSeparatedByString:@"\xD"];//CR

		General/NSLog(@"anArray = %@",anArray);//correctly list the 139 strings in anArray
}

- (General/IBAction)extractData:(id)sender//I click another button
{
	General/NSLog(@"anArray = %@",anArray);        //crashes with the message: program "has exited due to signal 5 (SIGTRAP)."
}
</pre>
	Why does this crash occur?  There should be no scope problem since anArray has been declared outside either Action.  Just to test, if I make the declaration "General/NSArray *testArray; in General/MyDocument.h, then in the first Action above I write:
<pre>
testArray = General/[[NSArray alloc] initWithObjects:@"hello",@"goodbye",nil];
General/NSLog(@"testArray = %@", testArray ); //works fine
</pre>
	and in the second Action, I write
<pre>
General/NSLog(@"testArray = %@", testArray ); /also works fine--no crash
</pre>

----

**The     componentsSeparatedByString: method returns an autoreleased array.** If you need to use this array later, you have to retain it. Remove the     anArray =General/[[NSArray alloc] init] (it's a General/MemoryLeak) and change the next line to         anArray = General/contentsOfFile componentsSeparatedByString:@"\xD"] retain];//CR. You could also replace the @"\xD" with @"\r".

The reason your test worked was you created the test array with alloc/init which returns an object with a [[RetainCount of 1. To avoid another leak, you'd have to     release it in your     dealloc method, or some other suitable place.