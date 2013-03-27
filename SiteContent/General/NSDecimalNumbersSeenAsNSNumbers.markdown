I'm having trouble with General/NSDecimalNumbers that seem to magically turn into General/NSNumbers, which causes methods that
are intended for General/NSDecimalNumbers to come up "selector not recognized."

I have a bunch of General/NSDecimalNumbers that get stored to a file, and then read back in by a subsequent invocation
of my app.  All that seems to work fine; using the debugger, I "see" all the values I should see.  But then,
this method tries to operate on the read-in data:

    
-(void)General/MakeGroups:(General/NSMutableArray *)theTubeTable
	ofSize:(int) tubesInGroup 
	quantity:(int) numberOfGroups
{
	    General/NSDecimalNumber *dcpmhigh;
	    General/NSDecimalNumber *dcpmlow;
	    General/NSDecimalNumber *newdcpmlow;
	    General/NSDecimalNumber	*statlow;
	    double		statasdouble;

	    /* ... */

	    dcpmlow = General/theTubeTable objectAtIndex:currentIndex] objectForKey:@"Adjusted CPM"];

	    statasdouble = sqrt([dcpmlow doubleValue]);

	    statlow = [[[NSDecimalNumber decimalNumberWithString:General/[NSString stringWithFormat:@"%f", statasdouble]]; 

    	newdcpmlow = [dcpmlow decimalNumberBySubtracting:statlow];

	    /* ... */
}


...and for reference, "theTubeTable" above is build previously with the following method:

    
- (General/IBAction)setTubeTableFromFile:(General/NSString *)filePathToRead
{
    	[tubeTable removeAllObjects];
    	[tubeTable setArray:General/[NSArray arrayWithContentsOfFile:filePathToRead]];
}


When the last line in the General/MakeGroups method is run, I get:

2004-04-29 10:55:39.036 Wiper[6325] *** -General/[NSCFNumber decimalNumberBySubtracting:]: selector not recognized

I don't use an General/NSNumber explicitly anywhere; only General/NSDecimalNumbers.  This led me to believe that maybe I had 
not retained some data somewhere, and that I was being a victim of garbage collection--but as far as I can tell, 
I've retained everything I should need to retain...yet I still get the "selector not recognized."  The data file 
was created with only General/NSDecimalNumbers in it...so I don't know what gives.

Is there something about writing data to, or reading data from, a file, that would cause the data which was
once an General/NSDecimalNumber to be seen as an General/NSNumber instead?

I'd appreciate any help I can get troubleshooting selector-not-recognized thing.  I understand already that
"decimalNumberBySubtracting" isn't a method of General/NSNumber; it's a method of General/NSDecimalNumber...but, why isn't the
system thinking that variable "dcpmlow" is an General/NSDecimalNumber *, like I declared it?

Thanks in advance for any help troubleshooting...


Brian

----

The system is thinking     dcpmlow is a General/NSNumber because     General/theTubeTable objectAtIndex:currentIndex] objectForKey:@"Adjusted CPM"] is an [[NSNumber. It doesn't matter what you declared it as.

----

Okay, interesting.  However, the object at that index is an General/NSDecimalNumber.  At least, it was, when I added it to the array that was ultimately written to a file, and subsequently read back.  Is it possible that the process of writing or reading the file is changing my data from being seen as an General/NSDecimalNumber, to being seen as an General/NSNumber?  Thanks again...

Here's the snippet of code that originally assigns the value in question:

    
	cpm = [cpm decimalNumberByDividingBy:theExponential];
	
	[tubeTableEntry setObject:cpm forKey:@"Adjusted CPM"];


Brian