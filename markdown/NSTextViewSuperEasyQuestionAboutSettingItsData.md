I have an General/NSTextView for which I want to:

1)  store its data in an General/NSData variable

2) set the content of this General/NSTextView based on the content of some General/NSData variable

(The idea here is that I want to store the General/NSTextView's data in a variable for encoding with all my General/NSDocument's other data before saving and then after loading, replace the General/NSTextView's data with that which has been decoded after loading.)

I've read General/NSTextView's help and it's very confusing for me.  Using an object controller it's fairly easy to point to an General/NSTextView's General/NSData data object, but I want to do this with straightforward accessor methods for this simple application.

So, what is the accessor method to grab the General/NSTextView's General/NSData object?  And what is the method to change its data to the newly loaded General/NSData object?

Thanks,
Kent!

----

General/NSTextView is a subclass of General/NSText. General/NSText has many of the methods you need to flatten and unflatten rich text format (RTF). Take a look at     replaceCharactersInRange:withRTF: and     General/RTFFromRange. One method takes an General/NSData object as an argument and the other method returns an General/NSData object for a given range. 

----

Thanks!  Worked like a charm!

Kent!