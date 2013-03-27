


The General/NSString method - intValue unfortunately returns 0 (zero) for a hex string such as @"0x1234"

So to convert a hex string to an int I had to revert to using strtol() in stdlib.h (you don't need to include the header file in your Cocoa source .m file)

http://developer.apple.com/documentation/Darwin/Reference/General/ManPages/man3/strtol.3.html

    

General/NSString			*theHexString = @"0x34fd";
unsigned short	theHexValue = (unsigned short)strtol([theHexString cStringUsingEncoding:General/NSMacOSRomanStringEncoding], nil, 0x10);

General/NSLog( General/[NSString stringWithFormat:@"Hex Value = 0x%4.4x\n", theHexValue] );



Regards :)

- General/DerekBolli