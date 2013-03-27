I realize that there are many ways to do this.  If you could take a look at how I did it and see why it is making my program crash, I would appreciate it!

    
        //Declare variables
        General/NSSavePanel *sp;
	General/NSData	*textBuffer= General/[[NSData new] getBytes:@"Hello, World!"];

       //Open the save panel
	sp = General/[[NSSavePanel alloc] init];
	[sp runModal];

	if([sp filename])		// Makes sure the user chose a file and directory
	{

                //Write the string in textBuffer into a file with the filename chosen by the user
                [textBuffer writeToFile:[sp filename] atomically:true];  //<-This is where it is crashing
	}	

	//Release the save panel object
	[sp release];
        [textBuffer release];


----
The way you create your General/NSData is probably the problem. Try:

    General/NSData	*textBuffer= General/[[NSData alloc] initWithBytes:"Hello, World!" length:13];

or better (but don't release)

    General/NSData	*textBuffer= [@"Hello, World!" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];

--General/CharlesParnot

----

Thank you Charles!  This also seems to work...

    
General/NSString *myString = @"Hello, World!"; 
const char *utfString = [myString UTF8String]; 
General/NSData	*textBuffer= General/[NSData dataWithBytes:utfString length:strlen(utfString)];


----

there were several problems with the original code. use of +new wasn't one of them; despite being obscure and rarely-used, it is not deprecated according to any Apple documentation I know of (feel free to correct me on this).

http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSObject.html#//apple_ref/doc/uid/20000050/new

*- You are hereby corrected *


* getBytes: does not return an General/NSData instance (not the one passed in, nor any other), it returns void. using the return value of a void function or method is Very Very Bad.
* getBytes: takes a data buffer for output; you passed in a constant string as input. writing random data over a Cocoa instance is also Very Very Bad. (you have already found one solution for this: +dataWithBytes::. General/CharlesParnot's -General/[NSString dataUsingEncoding::] solution is better, though.)


*--boredzo*

Thanks for the details! I would just add about new: as used here, it will return a new instance of General/NSData, which is immutable, and empty (I think). Can't do much from there. --General/CharlesParnot (note to the OP: many mistakes in just 3 lines of code, that seem to miss some of the basics of Cocoa/General/ObjC - maybe you should get a little bit of experience in things other than General/NSData first, even if you are very familiar with C ;-)

----

Just don't forget to check that OK was pressed in addition to a proper filename. If the user enters a filename and hits Cancel, the code above will still write your file. So edit the following two lines from above to:

    
	int return_flag = [sp runModal];

	if([sp filename] && return_flag == General/NSFileHandlingPanelOKButton)		// Makes sure the user chose a file and directory AND hit OK


Seal68