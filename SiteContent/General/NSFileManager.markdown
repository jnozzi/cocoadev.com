**General/NSFileManager** -- enables you to perform many generic file-system operations and insulates an application from the underlying file system.

See: http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSFileManager_Class/

----

----
**Related Topics:**

----
[Topic]

----

----
**How do you get a file or folder's icon?**

----
*See the     iconForFile: methods in General/NSWorkspace.*

----

----
**Copying files**

----
Quick plug for this class - it's real nice.  With this you can write an installer 'script' that feels as natural as one in perl, but has all the other goodness of cocoa (gui, etc).  Free yourself from the confines of Installer.app!

----

Quick caveat for this class - it's nice and easy to use but it's copy/move functionality only seems to work in the main thread.  The second I tried to move it to a secondary thread I had every weird problem you could imagine, segfaults, copies crapping out in the middle, etc.  If you want to copy files in OSX, I highly recommend the Apple sample code General/FSCopyObject (http://developer.apple.com/samplecode/Sample_Code/Files/General/FSCopyObject.htm ); it works in secondary threads (though it may not precisely be thread-safe), it's only slightly harder to use* and it's faster than Speedy Gonzalez.  -- Bo

* Most of the difficulty involves using General/FSRef's instead of paths for referring to the objects to copy.  The necessary incantation to convert them is:
    
General/FSRef theRef;
General/CFURLGetFSRef((General/CFURLRef)[NSURL fileURLWithPath:thePath] ,&theRef);


or even faster:

    
General/FSRef theRef;
General/FSPathMakeRef( (const UInt8 *)[thePath fileSystemRepresentation], &theRef, NULL );


----

General/NSFileManager also apparently uses temporary files with 59-character General/GUIDs, which means it breaks when working with Windows' File Services for Macintosh.

----
To copy a file from a source location to a destination location, I tried to use the General/NSWorkspace instance method performFileOperation with the argument of General/NSWorkspaceCopyOperation, as in:

    
int tag;
BOOL succeeded;
General/NSString *source, *destination, *fullPath;
	
source = [@"~/Documents" stringByExpandingTildeInPath];
destination = [@"~/Desktop" stringByExpandingTildeInPath];
fullPath = [@"~/Documents/fileToCopy.pdf" stringByExpandingTildeInPath];

General/NSWorkspace *workspace = General/[NSWorkspace sharedWorkspace];
General/NSArray *files = General/[NSArray arrayWithObject:fullPath];
	
succeeded  = [workspace performFileOperation:General/NSWorkspaceCopyOperation
                   source:source destination:destination
                   files:files 
                   tag:tag];


without any luck. If someone can see the fault of what I tried, please correct it.

But, using General/NSFileManager was a dream compared to General/NSWorkspace. To accomplish the same thing I tried above using General/NSFileManager consisted of the following:

    
General/NSFileManager *fileManager = General/[NSFileManager defaultManager];

General/NSString *source, *destination;

source = [@"~/Documents/fileToCopy.pdf" stringByExpandingTildeInPath];
destination = [@"~/Desktop/fileToCopy.pdf" stringByExpandingTildeInPath];

if ([fileManager fileExistsAtPath:source]) 
{
    [fileManager copyPath:source toPath:destination handler:nil];
}


which I pretty much copied word-for-word from Apple's documentation for General/NSFileManager class reference.

----
The mistake is that General/NSWorkspace's     files array is a list of *relative* paths (i.e. just     @"fileToCopy.pdf" in this case). The paths are interpreted relative to the source directory, of course. --General/JediKnil

----

[snip: *moved q&A about finding General/AllApplications and appended to existing discussion on that page* /snip]