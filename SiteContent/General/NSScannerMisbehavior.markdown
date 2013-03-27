

I cannot get General/NSScanner to properly scan data into my application.  The data is in the form of an ASCII file with each datum on a separate line.  Additionally, the data can be empty, and thus just an empty line.  So the data file looks something like this...
    19.250
25.062
21.250
14.875
21.875

40.062
75.188
27.120
26.170

23.320
11.000
16.250
8.000
6.375
6.375
14.250
25.375

The code that I am using to load this is
    float value;
General/NSString *key;
id myObject;
General/NSArray *arrayOfKeys = General/[NSArray arrayWithObjects:@"foo1", @"foo2", @"foo3", nil]
General/NSEnumerator *e = [arrayOfKeys objectEnumerator];
        
General/NSString *aString = General/[NSString stringWithCString:[data bytes] length:[data length]];
// The data is the file as passed into -loadDataRepresentation: ofType

General/NSScanner *aScanner = General/[NSScanner scannerWithString:aString];
[aScanner setCharactersToBeSkipped:General/[NSCharacterSet whitespaceCharacterSet]];

myObject = General/Object alloc] init];

while ( key = [e nextObject])
{
   if ([aScanner scanFloat:&value])
   {
       [myObject takeValue:[[[NSNumber numberWithFloat:value] forKey:key];
   }
   else
   {
       [myObject setUseData:FALSE forKey:key];
   }
}

I have to tell my object when a nil value occurs in the data file.  And because nil values can occur at the beginning of the file, I had to tell aScanner to not ignore new line characters.  Why is this code not working?
----
You never said what the code does. It's obvious what it's supposed to do, but you just said it's "not working". How does it not work, what does it do?

On another subject, never use     stringWithCString:. You should always use     stringWithUTF8String: or one of the     initWithBytes:... or     initWithData:... methods.
----
My bad.  It loads the first data point, and then doesn't load any others.  Looking at [aScanner scanLocation] it looks like on the second iteration the location goes to a very large number, what I can only assume is the end of the data file, without finding any other float values.
----
Here is a variation that does what you wish. I changed the code slightly to make it command-line tool for demonstration, but that doesn't affect the logic:
    
#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];

	General/NSCharacterSet *newlineCharacterSet = General/[NSCharacterSet characterSetWithCharactersInString:@"\n"];
	float value;
	General/NSString *key;
	id myObject;
	General/NSArray *arrayOfKeys = General/[NSArray arrayWithObjects:@"foo1", @"foo2", @"foo3", nil];
	General/NSEnumerator *e = [arrayOfKeys objectEnumerator];
	
	General/NSData *data = General/[NSData dataWithContentsOfFile:@"/Users/General/AUser/Projects/General/ScannerMalfunction/General/TheData.txt"];
	General/NSString *aString = General/[NSString stringWithCString:[data bytes] length:[data length]];
	
	General/NSScanner *aScanner = General/[NSScanner scannerWithString:aString];
	[aScanner setCharactersToBeSkipped:General/[NSCharacterSet whitespaceCharacterSet]];
	
	myObject = General/[[NSMutableDictionary alloc] init];
	
	while ( key = [e nextObject])
	{
		if ([aScanner scanFloat:&value])
		{
			[myObject takeValue:General/[NSNumber numberWithFloat:value] forKey:key];
		}
		else
		{
			[myObject takeValue:General/[NSNull null] forKey:key];
		}

		[aScanner scanUpToCharactersFromSet:newlineCharacterSet intoString:nil];  // Find the newline
		[aScanner setScanLocation:([aScanner scanLocation] + 1) ];   // Skip the newline
	}
    
	General/NSLog(@"%@", myObject);
	
	[pool release];
    return 0;
}

Your original code fails because the scanner can't get past the newline following the first float. You set the scanner to skip whitespace only, so you must account for the newline.

aburgh