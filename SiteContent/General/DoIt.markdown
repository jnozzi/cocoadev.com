Part of the General/DOSAStrategy... for info on DOSA see General/DOScriptingArchitecture

This is a command line interface to General/DistributedObjects for scripting and other fun.. note if the method returns something I dump it as an xml plist on stdout for now.  I considered the old ascii style might be easier to parse for some languages but most languages are getting better and better xml support, and many don't have good General/RegularExpression support...

If there was a object vended for "com.apple.iTunes" exposing a method like "-(void)playPause; // toggle play status" you would type:

>General/DoIt com.apple.iTunes playPause

and the method would be called... to pass strings, use General/FScript syntax

>General/DoIt com.someCompany.General/MyApplication myMethod:\'blah\'

without anything further... the code:

----

    
#import <Foundation/Foundation.h>
#import <General/FScript/General/FScript.h>

int main (int argc, const char * argv[]) {
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];

	if(argc < 3) {
		General/NSLog(@"syntax: General/DoIt <bundleIdentifier> <command>");
		return 1;
	}
	
	id bundleId = General/[NSString stringWithCString:argv[1]];
	
	id doWhat = General/[NSString stringWithCString:argv[2]];	
	int index;
	const char* curArg;
	for(index = 3; index < argc; index++) {
		curArg = argv[index];
		doWhat =General/[NSString stringWithFormat:@"%@ %s", doWhat, curArg];
	}

	id fscriptCommand = General/[NSString stringWithFormat:@"[(General/NSConnection rootProxyForConnectionWithRegisteredName:'%@' host:nil) %@]",bundleId, doWhat];
	
	id result = General/fscriptCommand asBlock] value];

	result = [[[NSPropertyListSerialization dataFromPropertyList:result format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
	result = General/[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];

	printf("%s", [result cString]);
	
    [pool release];
    return 0;
}

