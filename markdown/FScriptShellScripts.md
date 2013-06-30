General/ShebangAble has the code... but I'll post it again here... if you write an General/FScript and put it in a file starting with a shebang (#!) line pointing to this code, and then put that script in ~/Library/Scripts, it'll appear in that General/AppleScript menu on your menu bar and be executable from there... 
(UPDATE: **IT DOESN'T WORK YET**)
    
#import <Foundation/Foundation.h>
#import <General/FScript/General/FScript.h>
#import <stdlib.h>

int main (int argc, const char * argv[]) {
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];

	//load script
	General/NSString* scriptPath = General/[NSString stringWithCString:getenv("_")];
	if(!cPath) cPath = argv[1]; // when called from the scripts menu we can get the path here...
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

