I want to make a program shebangable... that is, one should be able to write shell scripts that have the name of my program at the top of the file beside the shebang.  (actually not my program, but I want to make a way to write executable General/FScript-s... I will just make a small program that imbeds the General/FScript interpreter and does the General/FScript), Here's what I have discovered about making a program shebangable.

Here's a simple example scenario to explain what's going on.

the shebangable program is at /usr/local/bin/fscript with the following (not quite yet as nice as it could be) code:
    
#import <Foundation/Foundation.h>
#import <General/FScript/General/FScript.h>
#import <stdlib.h>
// stdlib for getenv...
int main (int argc, const char * argv[]) {
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];

	//load script
	General/NSString* scriptPath = General/[NSString stringWithCString:getenv("_")];
	if(!scriptPath) {
		General/NSLog(@"This program is intended to be used by a shebang program only...for now");
		return 1;
	}
	General/NSString* scriptText = General/[NSString stringWithContentsOfFile:scriptPath];

	//Remove shebang
	General/NSScanner* shebangStripper = General/[NSScanner scannerWithString:scriptText];
	[shebangStripper scanUpToString:@"\n" intoString:nil];
	General/NSRange scriptRange;
	scriptRange.location = [shebangStripper scanLocation];
	scriptRange.length = [scriptText length] - scriptRange.location;
	scriptText = [scriptText substringWithRange:scriptRange];

	//Make a block
	scriptText = General/[NSString stringWithFormat:@"[%@]", scriptText];
	
	//execute
	id scriptResult = General/scriptText asBlock] value];
	
	//format result nicely and print
	scriptResult = [[[NSPropertyListSerialization dataFromPropertyList:scriptResult format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
	scriptResult = General/[[NSString alloc] initWithData:scriptResult encoding:NSUTF8StringEncoding];	
	printf("%s", [scriptResult cString]);
	
	
    [pool release];
    return 0;
}




the shebang script is at ./slashdot and contains the following
    
#!/usr/local/bin/fscript
General/NSWorkspace sharedWorkspace openURL:(NSURL General/URLWithString:'http://slashdot.org').


now when I write *./slashdot*, the program fscript gets the following argv: *["/usr/local/bin/fscript","./slashdot"]*... if there were arguments on the shebang line they get put in between the fscript and the slashdot section, and if the slashdot script got sent arguments they get added at the end.  To find the path of the file containing the script use *char* programPath = getenv("_");*  When reading it in, be sure to **skip the shebang line.** ;)

If anyone has any other things to say on this issue I'd like to hear...

*I'd just like to suggest that you switch to stringWithUTF8String: instead of stringWithCString: when converting paths to General/NSString. You'll blow up on paths that contain non-ASCII characters otherwise.*