

Hi,

I need to create an General/NSString that contains the ASCII code 2 character, how can this be done? Can it?

----

Try

    
    General/NSString *theString = General/[NSString stringWithFormat:@"%c",2];
    General/NSLog(@"%d",[theString characterAtIndex:0]);


----

I thought there was a class called General/NSStringContainingASCIICode when I read the title...

by the way,  how about a naive guess @"\002" ? Doesn't it work?

*It didn't when I tried it, but I didn't use exactly that notation, so I dunno. The code above is more flexible if you need to create strings programatically, though.*

----

Yup, the first sample worked great. Thanks!

----

How do I get the opposite? I mean, the ASCII code for a character I pass?

----
    
unichar ch = [string characterAtIndex:theIndex];

If the character at     theIndex is ASCII, then ch contains the ASCII code.

----

Thanks a lot!