I'm using a General/NSMutableArray to hold a bunch of Integers for a program Cocoa-Java, so I can save and reload them easily enough using General/NSUserDefaults.

I'm putting Integers into the Array, the .plist describes an array of <integer>s, but when I try to cast any object which I pull out of the Array with General/NSArray.objectAtIndex(int index) back to an Integer I get a General/ClassCastException thrown.

Now here's the really strange part: the exception message tells me that the object is a Long, not an Integer. As an experiment, I tried casting the Object to a Long, to the same effect, except the exception message reckons I should be casting to an Integer!

----

Cast it to a     Number and run     intValue() on it. --General/TheoHultberg/Iconara