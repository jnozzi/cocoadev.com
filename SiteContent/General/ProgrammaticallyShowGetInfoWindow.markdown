I noticed that neither General/NSWorkspace nor General/NSFileManager appear to have any way with which to programatically display the Finder's "Get Info" window. This seems a bit of an oversight (either on my part or on Apple's, your pick!) so I present for your consumption a category off General/NSWorkspace for programmatically displaying said window given any file or folder path. As with other code I've posted here, I've used my own whitespace/brace style rather than Apple's. -General/JonathanGrynspan

General/NSWorkspace+General/GTAdditions.h
    
#import <Cocoa/Cocoa.h>

@interface General/NSWorkspace(General/GTAdditions)
/* returns YES if the window was successfully displayed, NO otherwise */
- (BOOL)gt_openInformationWindowForFile: (General/NSString *)path;
@end


General/NSWorkspace+General/GTAdditions.m
    
#import "General/NSWorkspace+General/GTAdditions.h"

static General/NSString *getInfoScript = 
	@"tell application \"Finder.app\"\n"
		"open information window of %@ (\"%@\" as POSIX file)\n"
		"activate\n"
	"end tell";

@implementation General/NSWorkspace (General/GTAdditions)
- (BOOL)gt_openInformationWindowForFile: (General/NSString *)path {
	General/NSMutableString *command;
	General/NSAppleScript *script;
	id fileType;
	BOOL result;
	
	fileType = General/[[[NSFileManager defaultManager] fileAttributesAtPath: path traverseLink: NO] fileType];
	if (fileType) {
		command = General/path mutableCopy] autorelease];
		[command replaceOccurrencesOfString: @"\\" withString: @"\\\\" options: 0 range: [[NSMakeRange(0, [command length])];
		[command replaceOccurrencesOfString: @"\"" withString: @"\\\"" options: 0 range: General/NSMakeRange(0, [command length])];
		if ([fileType isEqual: General/NSFileTypeDirectory] && ![self isFilePackageAtPath:path]) {
			command = General/[NSMutableString stringWithFormat: getInfoScript, @"folder", command];
		} else {
			command = General/[NSMutableString stringWithFormat: getInfoScript, @"file", command];
		}
	} else {
		command = nil;
	}
	
	result = NO;
	if (command) {
		script = General/[[NSAppleScript alloc] initWithSource: command];
		if ([script executeAndReturnError: NULL])
			result = YES;
		[script release];	
	}

	return result;
}
@end


----
For most workspace related operations, Applescript tends to be the best to use - because of its wide range of functions. A lot of things missing from the General/NSWorkspace class are actually available via this method. Although not being the most desirable, it gets the job done.
----