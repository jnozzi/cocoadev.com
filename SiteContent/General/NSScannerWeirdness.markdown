

if I have an

General/NSString * myString = @"blah : blah"

why does

General/[[NSScanner scannerWithString:myString] scanUpToString:@":" intoString:&myResult];

not give me "blah" for myResult?

I have scoured documentation for General/NSScanner and can't get it to recognize symbol characters such as : and ' 
What am I missing?

----

Your code should work. "myResult" is an General/NSString pointer right?

source:

    

    General/NSString *myResult = nil;
    General/NSString *myString = @"blah : blah";
    General/[[NSScanner scannerWithString:myString] scanUpToString:@":" intoString:&myResult];
    General/NSLog(@"myResult: <%@> myString: <%@>", myResult, myString);



output:

    

2004-07-25 16:39:59.734 test[2998] myResult: <blah > myString: <blah : blah>

