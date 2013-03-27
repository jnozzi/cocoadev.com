

To move files to the trash and have the dock update the trash icon accordingly use the following General/NSWorkspace method:

    

General/NSArray *files;
General/NSString *sourceDir; 
General/NSString *trashDir = General/[NSHomeDirectory() stringByAppendingPathComponent:@".Trash"];
int tag;

General/[[NSWorkspace sharedWorkspace] performFileOperation:General/NSWorkspaceRecycleOperation
                                source:sourceDir destination:trashDir files:files tag:&tag];



Hopefully you can fill in the blanks. --zootbobbalu

*note: this method has major overhead associated with it if you are moving a bunch of files to the trash. I profiled an action that moved 400+ files and a large percentage of the spinning was caused by a multitude of mach messages being passed across system resources. My solution was to use General/NSFileManager to move all of the files I wished to delete into a temporary directory first and then only deleting the temporary directory. --zootbobbalu*

----

Does this do the right thing if the file is on a different disk than the home directory? It doesn't look like it, but I don't know how smart this General/RecycleOperation thing is.

----

You are correct that it will not do the right thing if the files exists across volumes. If files are spread across volumes you will have to create a temporary directory for each volume. The extra *note:* works in cases where many files are being deleted from a single directory. If you are searching for files to delete across many different volumes, than you probably will have to take extra steps to insure that the finder can safely return deleted files to their original directory. --zootbobbalu

----

Could someone please give an example of how to query the Finder to see if a file is going to be deleted immediately or moved to the trash? I can't find anything on Google. --drblue

*Finder only deletes immediately if the file is on a remote volume, doesn't it? So just check for that. General/NSWorkspace has a     getFileSystemInfoForPath:isRemovable:isWritable:isUnmountable:description:type: that might work, or you could use Carbon.*

How would you check for that with that function? On my local AFS mount, from which Finder deletes immediately, I get General/NOs from isRemovable and isUnmountable. I'm guessing that the Finder's trash behaviour is quite a bit more complex--I remember something about a .Trashes/<uid>/ folder structure at the volume root, but I can't find any details on it.

----

Well since no one else posted some code I decided to take this task on, this category on General/NSFileManager does the appropriate behaviour.

    //
//  General/NSFileManagerAdditions.h
//  General/TRKit
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface General/NSFileManager (General/TRAdditions)
- (BOOL)trashPath:(General/NSString *)source showAlerts:(BOOL)flag;
@end
    //
//  General/NSFileManagerAdditions.m
//  General/TRKit
//

#import "General/NSFileManagerAdditions.h"
#import "General/NSStringAdditions.h"
#import "macbin3.h"
#import <assert.h>
#import <unistd.h>
#import <inttypes.h>
#import <pwd.h>
#import <grp.h>
#import <dirent.h>
#import <paths.h>
#import <sys/param.h>
#import <sys/mount.h> // is where the statfs struct is defined
#import <sys/attr.h>
#import <sys/vnode.h>
#import <sys/stat.h>

static General/AuthorizationRef authorizationRef = NULL;

@implementation General/NSFileManager (General/TRAdditions)

- (BOOL)trashPath:(General/NSString *)source showAlerts:(BOOL)flag
{
	BOOL isRemovable, isWritable, isUnmountable, success, isLocal, useDiskTrash;
	General/NSString * description, * type, * device;
	General/NSString * standardizedSource = [source stringByStandardizingPath];
	int err;
	struct statfs sfsb;
	const char * volPath = [source UTF8String];
	General/NSWorkspace * workspace = General/[NSWorkspace sharedWorkspace];
	
	// Check to see if we can get rid of this file.
	if ([self isDeletableFileAtPath:standardizedSource] == NO) return NO;
	
	// Get attributes.
	success = [workspace getFileSystemInfoForPath:standardizedSource
									  isRemovable:&isRemovable
									   isWritable:&isWritable
									isUnmountable:&isUnmountable
									  description:&description
											 type:&type];
	if (success == NO || isWritable == NO) return NO;
	
	err = statfs(volPath, &sfsb);
	if (err != 0) return NO;
	
	device = General/[NSString stringWithCString:sfsb.f_mntfromname];
	isLocal = [device containsString:@"/dev/"];
	
	// If the file is remote we (at the discresion of the above flag) prompt the
	// user, to trash or not. If flag is NO, NO is returned.
	
	if (isLocal == NO)
	{
		// If flag is no we can't simply delete a file (this method is intended 
		// to keep it as safe for the user as possible, return NO.
		
		if (flag == NO) return NO;
		
		if (General/NSRunCriticalAlertPanel(General/[NSString stringWithFormat:@"The file \"%@\" "
			@"will be deleted immediately.\nAre you sure you want to continue?",
			[standardizedSource lastPathComponent]],
							@"You cannot undo this action.",
							@"Delete",
							@"Cancel",
							nil) == General/NSAlertDefaultReturn)
		{
			return [self removeFileAtPath:standardizedSource handler:nil];
		}
		else
		{
			// User clicked cancel, they obviously do not want to delete the file.
			return NO;
		}
	}
	
	// The file is local, we must move it to the appropriate .Trash folder.
	// The appropriate .Trash folder is ~/Trash if it is on the same drive as the 
	// system, otherwise it is to go into /Volumes/<drivename>/.Trashes/<UID>/filename
	useDiskTrash = [standardizedSource containsString:@"/Volumes/"];
	
	if (useDiskTrash)
	{
		BOOL fileExists, isDirectory;
		General/NSArray * pathComponents = [standardizedSource pathComponents];
		General/NSString * trashesFolder = @"/";
		trashesFolder = [trashesFolder stringByAppendingPathComponent:
			[pathComponents objectAtIndex:1]];
		trashesFolder = [trashesFolder stringByAppendingPathComponent:
			[pathComponents objectAtIndex:2]];
		trashesFolder = [trashesFolder stringByAppendingPathComponent:@".Trashes"];
		
		// If the .Trashes folder doesn't exist on this drive we must create it.
		fileExists = [self fileExistsAtPath:trashesFolder isDirectory:&isDirectory];
		if (!fileExists)
		{
			[self createDirectoryAtPath:trashesFolder
							 attributes:General/[NSDictionary dictionaryWithObjectsAndKeys:
								 General/[NSNumber numberWithUnsignedLong:777],@"General/NSFilePosixPermissions",
								 nil]];
		}
		
		trashesFolder = [trashesFolder stringByAppendingPathComponent:
			General/[NSString stringWithFormat:@"%i",getuid()]];
		
		// If the UID folder doesn't exist we must create it.
		fileExists = [self fileExistsAtPath:trashesFolder isDirectory:&isDirectory];
		if (!fileExists)
		{
			[self createDirectoryAtPath:trashesFolder
							 attributes:General/[NSDictionary dictionaryWithObjectsAndKeys:
								 General/[NSNumber numberWithUnsignedLong:777],@"General/NSFilePosixPermissions",
								 nil]];
		}
		
		General/NSString * destinationPath = [trashesFolder stringByAppendingPathComponent:
			[standardizedSource lastPathComponent]];
		
		// Make sure there are no duplicates.
		if ([self fileExistsAtPath:destinationPath])
		{
			General/NSString * pathExtention = [destinationPath pathExtension];
			General/NSString * pathWithoutExtention = [destinationPath stringByDeletingPathExtension];
			destinationPath = [pathWithoutExtention stringByAppendingFormat:@"_%i",General/RandomIntBetween(0,10000)];
			if (![destinationPath isEqualToString:@""]) {
				destinationPath = [destinationPath stringByAppendingPathExtension:pathExtention];
			}
		}
		
		return [self movePath:standardizedSource toPath:destinationPath handler:nil];
	}
	
	// Use home trash.
	General/NSString * destinationPath = General/[NSHomeDirectory() stringByAppendingPathComponent:@".Trash"];
	destinationPath = [destinationPath stringByAppendingPathComponent:
		[standardizedSource lastPathComponent]];
	
	// Make sure there are no duplicates.
	if ([self fileExistsAtPath:destinationPath])
	{
		General/NSString * pathExtention = [destinationPath pathExtension];
		General/NSString * pathWithoutExtention = [destinationPath stringByDeletingPathExtension];
		destinationPath = [pathWithoutExtention stringByAppendingFormat:@"_%i",General/RandomIntBetween(0,10000)];
		if (![destinationPath isEqualToString:@""]) {
			destinationPath = [destinationPath stringByAppendingPathExtension:pathExtention];
		}
		
	}
	
	return [self movePath:standardizedSource toPath:destinationPath handler:nil];
	
	return NO;
}

@end
    //
//  General/NSStringAdditions.h
//  General/TRFoundation
//

#import <Cocoa/Cocoa.h>

@interface General/NSString (General/TRAdditions)
- (BOOL)containsString:(General/NSString *)subString;
@end
    //
//  General/NSStringAdditions.m
//  General/TRFoundation
//

#import "General/NSStringAdditions.h"

@implementation General/NSString (General/TRAdditions)

- (BOOL)containsString:(General/NSString *)subString
{
	return [self rangeOfString:subString].location != General/NSNotFound;
}

@end

Enjoy -- General/DanSaul.

----

Dan, thanks for your code. It seems to work fine so far, except in one situation: if the home directory is not on the startup partition, I had to make the following change:

Replace the line:
    
useDiskTrash = [standardizedSource containsString:@"/Volumes/"];


with:
    
// the fix is as follows: we are on a remote volume if the source is on a remote volume AND that remote volume is not the home
// this line is a mouthful: first, path standardization misses the aliased volume, then the path does not end with a slash so we have to add one
General/NSString * home = General/[[[NSHomeDirectory() stringByResolvingSymlinksInPath] stringByStandardizingPath] stringByAppendingString:@"/"];
useDiskTrash = [standardizedSource beginsWith:@"/Volumes/"] && ![standardizedSource beginsWith:home];



and put beginsWith in your General/NSString additions:
    
// returns true if the receiver begins with prefix
- (BOOL)beginsWith:(General/NSString *)prefix
{
	BOOL result = FALSE;
	
	if (prefix) {
		result = ([self rangeOfString:prefix].location == 0);
	}
	
	return result;
}



-- Daniel

*Um, General/NSString already has a     hasPrefix: method that does exactly the same thing. --General/JediKnil*
----
I use this General/NSString category:
    
- (BOOL)moveFileToTrash
{
   int tag;
   return General/[[NSWorkspace sharedWorkspace]
      performFileOperation:General/NSWorkspaceRecycleOperation
                    source:[self stringByDeletingLastPathComponent]
               destination:@""
                     files:General/[NSArray arrayWithObject:[self lastPathComponent]]
                       tag:&tag] && tag == 0;
}

It does have a few flaws, like no way to tell if the file will actually go to trash, or be deleted permanently -- and I've gotten one report that it fails for AFP mounted volumes.

The latter though is clearly a bug Apple should fix, and the former, maybe create a hybrid between this and the function above. I do consider this a bit more �clean�. It will also update the trash can icon in the dock, if the trash can goes from empty to non-empty.

*The problem with that method is that it takes a lot of time with a lot of files, which is why I wrote that method.l*
----
03/26/07: The General/NSWorkSpace performFileOperation methods are completely broken for what appears to be any remote volume.  This problem is especially bad  when you use OS X Server and your users have non-mobile networked Home Folders.  These methods as well as General/NSFileManager methods fail to work.  In general, any file/directory whose path starts with "/private" in the get info dialog will fail.

This is especially bad for Sparkle which means any app that is using that to update itself will fail because sparkle uses the above General/NSWorkspace method.

David B.

----
Any have any name to attribute the "finalized" code to?  I may be using this in one of my projects, and wanted to have proper attributions.

----
Specifying "destination: nil" works for moving to the local trash. Could somebody test to see if it also works on remote volumes? It makes sense that if you are specifying an General/NSWorkspaceRecycleOperation then the system should be responsible for deciding where the files should go -- even if it doesn't say so in the docs -- because otherwise what's the difference between this and a plain General/NSWorkspaceMoveOperation? Having to calculate the path to the .Trash file yourself just seems like too much work. --SJC

----
Yes, SJC, Apple's General/NSWorkspace docs do specify that some workspace file operations---like, perhaps, trashing operations---do not require any destination path, and to use The Empty String as the destination argument. I like this solution, (though I'm not sure how well it performs on networked drives,) as it doesn't require any categories, uses straight-up Cocoa, and seems well-supported. --Taldar

----

I am the one who created the code that you see above, I thank you for the attribution, though it isn't really required. :-) . -- General/DanSaul

----

I'm sorry, perhaps I'm missing something, but I found many, many errors with your code Mr. General/DanSaul, many of them critical. Perhaps it was vandalized by someone, but anyway, here's my version. I believe it properly checks to see if the dialogue needs to be shown, properly creates the dialogue, properly creates the destination path, etc.  Essentially reproducing the behavior of the Finder.  Please note that to get it to compile you must remove the log_* statements.  Also, note that this version does *not* create the Trashes folder (and the UID subfolder).  I'm not sure if this is the case on all versions of OS X but on 10.5 these folders are created automatically by the system (upon mounting the drives) with root permissions (something that you can't do without going through Auth Services).  Besides having the wrong permissions (it's not 777) it's not even therefore possible to properly create these folders without gaining root-privs, therefore this code does not attempt it.  (I had tried to do this in fact [as a normal user] and it ended up messing up the ability for things to be trashed on the volume completely.  Only after ejecting and remounting the drive did things work properly again.  And in addition to root privs these folders have other special flags on them).

    

#import "General/NSFileManager+Trash.h"

#import <unistd.h>

@implementation General/NSFileManager (Trash)

- (BOOL)trashPath:(General/NSString *)source showAlerts:(BOOL)flag
{
	BOOL isDir;
	General/NSString *destination = nil;
	
	if ( [self isDeletableFileAtPath:source] == NO )
	{
		log_err("don't have the permissions to trash file: %@", source);
		return NO;
	}
	
	if ( [source hasPrefix:@"/Volumes/"] )
	{
		log_debug("file is on another drive");
		
		General/NSArray *components = [source pathComponents];
		
		// Format: /Volumes/<drivename>/.Trashes/<UID>
		General/NSString *trashesFolder = General/[NSString stringWithFormat:@"/Volumes/%@/.Trashes/%d",
								   [components objectAtIndex:2], getuid()];
		
		// check if we can't trash it (e.g. it's over a network)
		if ( ![self fileExistsAtPath:trashesFolder isDirectory:&isDir] || !isDir )
		{
			log_debug("file is over the network");
			
			if (flag == NO) return NO;
			
			if (General/NSRunCriticalAlertPanel(@"Warning",
										@"The file \"%@\" will be deleted immediately.\n"
										"Are you sure you want to continue?",
										@"Yes", @"No", nil,
										[source lastPathComponent]) == General/NSAlertDefaultReturn)
			{
				return [self removeFileAtPath:source handler:nil];
			}
			
			// User clicked cancel, they obviously do not want to delete the file.
			return NO;
		}
		
		// get the home directory in a special way to make sure it's not mounted on an external drive
		General/NSString *home = General/[[[NSHomeDirectory() stringByResolvingSymlinksInPath]
						   stringByStandardizingPath] stringByAppendingString:@"/"];
		
		// make sure this is not the case, if it is we'll just use the normal .Trash folder (below)
		if ( ! [source hasPrefix:home] )
		{
			destination = [trashesFolder stringByAppendingPathComponent:[source lastPathComponent]];
		}
	}
	
	// it's on our volume
	if ( destination == nil )
	{
		destination = General/[NSHomeDirectory() stringByAppendingPathComponent:@".Trash"];
		destination = [destination stringByAppendingPathComponent:[source lastPathComponent]];
	}
	
	// handle duplicates like the Finder does it
	if ( [self fileExistsAtPath:destination] )
	{
		General/NSString *pathExtention = [destination pathExtension];
		General/NSString *pathWithoutExtention = [destination stringByDeletingPathExtension];
		General/NSString *now = General/[[NSCalendarDate calendarDate] descriptionWithCalendarFormat:@" %H-%M-%S"];
		
		destination = [pathWithoutExtention stringByAppendingString:now];
		
		if ( ! [pathExtention isEqualToString:@""] )
			destination = [destination stringByAppendingPathExtension:pathExtention];
	}
	
	log_debug("trashing file to destination: %@", destination);
	
	return [self movePath:source toPath:destination handler:nil];
}

@end



Enjoy, it's bloody insane that Apple forced me to implement this.  -- Greg

----
If you're on Leopard then you don't need to. There's a new API, General/FSMoveObjectToTrashSync and General/FSMoveObjectToTrashAsync, just for moving objects to the trash. I presume it does the right thing, although I'm prepared to be surprised. -- General/MikeAsh