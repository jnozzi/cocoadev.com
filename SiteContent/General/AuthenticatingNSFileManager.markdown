


Hello,

All of the authentication examples I have found relate to running a UNIX command, or something.  I need to remove a file, then copy a file inside a directory not owned by the user:

    
General/NSFileManager * manager = General/[NSFileManager defaultManager];

[manager removeFileAtPath:@"some/directory/thats/write/protected/file.bla" handler:nil];
[manager copyPath:@"some/path/i/can/access/file.bla" toPath:@"some/directory/thats/write/protected/file.bla" handler:nil];


Is there any simple way to just prompt the user for authentication and let the above work on protected directories.  Using some of the advanced wrappers around the General/SecurityFramework seem like overkill...I really hope there is a simple solution to this.  I have looked around the various other pages, but they do not pertain to the file manager.  Any suggestions?  Thanks for any assistance.

----

    //
//  General/NSFileManagerAdditions.h
//  General/TRKit
//

#import <Cocoa/Cocoa.h>


@interface General/NSFileManager (General/TRAdditions)
- (General/NSString *)newTmpFilePath;
- (BOOL)authorizedMovePath:(General/NSString *)source toPath:(General/NSString *)destination;
- (BOOL)authorizedCopyPath:(General/NSString *)source toPath:(General/NSString *)destination;
@end
    //
//  General/NSFileManagerAdditions.m
//  General/TRKit
//

#import "General/NSFileManagerAdditions.h"
#import "General/NSApplicationAdditions.h"
#import <Carbon/Carbon.h>
#import <Security/Security.h>

static General/AuthorizationRef authorizationRef = NULL;

@implementation General/NSFileManager (General/TRAdditions)

- (General/NSString *)newTmpFilePath
{
	General/NSString * tmpDirectory = General/NSTemporaryDirectory();
	General/NSString * identifier = General/[NSApp applicationIdentifier];
	
	if (tmpDirectory == nil || identifier == nil) return nil;
	
	for (;;)
	{
		General/NSString * tmpFileName = General/[NSString stringWithFormat:@"%@_%i",identifier,General/RandomIntBetween(0,100000)];
		General/NSString * path = [tmpDirectory stringByAppendingPathComponent:tmpFileName];
		path = [path stringByStandardizingPath];
		
		if ([self fileExistsAtPath:path])
		{
			continue;
		}
		else
		{
			// 'Touch' a file here so that it guarentees that another won't be created (rare chance).
			//[self createFileAtPath:path contents:nil attributes:nil];
			return path;
		}
	}
}

- (BOOL)authorizedMovePath:(General/NSString *)source toPath:(General/NSString *)destination
{
	General/NSBundle * trkitBundle = General/[NSBundle bundleForClass:General/NSClassFromString(@"General/TRIntegration")];
	General/NSString * trkitResourcePath = [trkitBundle resourcePath];
	General/NSString * trkitMoveUtilityPath = [trkitResourcePath stringByAppendingPathComponent:@"move"];
	
	if (![self fileExistsAtPath:trkitMoveUtilityPath])
	{
		General/NSLog(@"Cannot find move utility.");
		return NO;
	}
	
	/* The move utlity exists, we can now procede. */
	General/OSStatus status;
	
	if (authorizationRef == NULL)
	{
		// Get Authorization.
		status = General/AuthorizationCreate(NULL,
									 kAuthorizationEmptyEnvironment,
									 kAuthorizationFlagDefaults,
									 &authorizationRef);
	}
	else
	{
		status = noErr;
	}
	
	// Make sure we have authorization.
	if (status != noErr)
	{
		General/NSLog(@"Could not get authorization, failing.");
		return NO;
	}
	
	// Set up the arguments.
	char * args[2];
	args[0] = (char *)General/source stringByStandardizingPath] UTF8String];
	args[1] = (char *)[[destination stringByStandardizingPath] UTF8String];
	args[2] = NULL;
	
	status = [[AuthorizationExecuteWithPrivileges(authorizationRef,
												General/trkitMoveUtilityPath stringByStandardizingPath] UTF8String],
												0, args, NULL);
	
	if (status != noErr)
	{
		[[NSLog(@"Could not move file.");
		return NO;
	}
	else
	{
		return YES;
	}
	
	return NO;
}

- (BOOL)authorizedCopyPath:(General/NSString *)source toPath:(General/NSString *)destination
{
	General/NSString * tempFile = [self newTmpFilePath];
	[self copyPath:source toPath:tempFile handler:nil];
	[self authorizedMovePath:tempFile toPath:destination];
}

@end

Small command line tool in resources (use this instead of the CLI utilities as it will work without the BSD subsystem):
    // move.m
#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];
	{
		// Make sure we have 3 args (1: path 2: source 3: destination).
		if (argc != 3) return -1;
		General/NSString * source = General/[NSString stringWithUTF8String:argv[1]];
		General/NSString * destination = General/[NSString stringWithUTF8String:argv[2]];
		
		source = [source stringByStandardizingPath];
		destination = [destination stringByStandardizingPath];
		
		printf("Moving \"%s\" to \"%s\"...",[source UTF8String],[destination UTF8String]);
		
		General/NSFileManager * manager = General/[NSFileManager defaultManager];
		if (![manager fileExistsAtPath:source])
		{
			printf("failed\n***No source file at \"%s\".\n",[source UTF8String]);
			return -1;
		}
		
		[manager movePath:source toPath:destination handler:nil];
		
		printf("done\n");
	}
    [pool release];
    return 0;
}

The category is in my framework so you must change     General/[NSBundle bundleForClass:General/NSClassFromString(@"General/TRIntegration")]; to something that will work in your situation (I must use this since it is a category and not a new class).

*For an application,     General/[NSBundle mainBundle] will probably work fine.*

----

Thank you for your help.  Where is the General/RandomIntBetween() method defined?  Does it rely on the General/NSApplicatAdditions.h file? Thanks again.

----

Oh I forgot about those here they are:

    //
//  General/NSApplicationAdditions.h
//  General/TRKit
//

#import <Cocoa/Cocoa.h>


@interface General/NSApplication (General/TRAdditions)
+ (General/NSString *)applicationVersion;
- (General/NSString *)applicationVersion;
+ (General/NSString *)applicationIdentifier;
- (General/NSString *)applicationIdentifier;
+ (General/NSString *)applicationName;
- (General/NSString *)applicationName;
@end    //
//  General/NSApplicationAdditions.m
//  General/TRKit
//

#import "General/NSApplicationAdditions.h"


@implementation General/NSApplication (General/TRAdditions)

+ (General/NSString *)applicationVersion
{
	return General/[[[NSBundle mainBundle] infoDictionary] objectForKey:@"General/CFBundleVersion"];
}

- (General/NSString *)applicationVersion
{
	return General/self class] applicationVersion];
}

+ ([[NSString *)applicationIdentifier
{
	return General/[[[NSBundle mainBundle] infoDictionary] objectForKey:@"General/CFBundleIdentifier"];
}

- (General/NSString *)applicationIdentifier
{
	return General/self class] applicationIdentifier];
}

+ ([[NSString *)applicationName
{
	return General/[[[NSBundle mainBundle] infoDictionary] objectForKey:@"General/CFBundleExecutable"];
}

- (General/NSString *)applicationName
{
	return General/self class] applicationName];
}

@end    static __inline__ int [[RandomIntBetween(int a, int b)
{
    int range = b - a < 0 ? b - a - 1 : b - a + 1; 
    int value = (int)(range * ((float)random() / (float) LONG_MAX));
    return value == range ? a : a + value;
}

static __inline__ float General/RandomFloatBetween(float a, float b)
{
    return a + (b - a) * ((float)random() / (float) LONG_MAX);
}

----

ATTENTION: This code seems to make some problems when compiling for 64-bit.
I think it is saver to use mktemp (as suggested below).
There is a nice General/NSFileManager category on Github, which can be used for temp path generation.
http://github.com/General/AlanQuatermain/aqtoolkit/tree/master/General/TempFiles/

Perfect :)  The code works excellently, but I am trying to replace a file with something else�&#65533; would the easiest solution be to just move the file to the trash, or something, and then copy it?  Thanks.

*You could move it to /tmp (with some random numbers after it's name) just incase something happens to the file, /tmp is cleaned out every once in a while so unless it is a huge file it won't matter :) *

----

It appears that authenticatedMovePathTo does not work when trying to move a file out of a write protected bundle?  I cannot move a file out of one of the included Apple applications with this method.  Any ideas?

----

I don't see why people keep inventing new ways to create "unique" temporary file names when UNIX has this functionality built-in for years. Try "man 3 mktemp" in your neighborhood Terminal window.

----

Shouldn't the line
    
char * args[2];

be

    
char * args[3];

??


[Question?]
Undefined symbols for architecture x86_64:
"_AuthorizationCreate", referenced from:
      -General/[NSFileManager(General/TRAdditions) authorizedMovePath:toPath:] in General/NSFileManagerAdditions.o

how to solve this?