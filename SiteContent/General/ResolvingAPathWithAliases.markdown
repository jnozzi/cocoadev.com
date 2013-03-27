

Aliases are driving me nuts! How does one go about resolving aliases in a path string and getting the proper path string?

----

Take a look at General/NDAlias, which you will find a link to on the General/ObjectLibrary page.  That's a good page to read through from top to bottom.

----

You could also look at http://developer.apple.com/documentation/Cocoa/Conceptual/General/LowLevelFileMgmt/Tasks/General/ResolvingAliases.html (Apple's suggested method for resolving aliases). While it's not in a nice General/ObjC wrapper, this *might* (probably but not definitely) be more efficient. If you don't want to have to paste this code in every time you need to worry about an alias, you could make this into a function or method, using their     path variable as an argument, and returning     resolvedPath.

----

I've had trouble getting aliases to resolve in the middle of paths - the Apple code works great when the alias is at the end of the path. Here's my refinement:

     
- (General/NSString*) pathResolved:(General/NSString*) inPath
{
	General/CFStringRef resolvedPath = nil;
	General/CFURLRef	url = General/CFURLCreateWithFileSystemPath(NULL /*allocator*/, (General/CFStringRef)inPath, kCFURLPOSIXPathStyle, TRUE /*isDirectory*/);
	if (url != NULL) {
		General/FSRef fsRef;
		if (General/CFURLGetFSRef(url, &fsRef)) {
			Boolean targetIsFolder, wasAliased;
			General/OSErr err = General/FSResolveAliasFile (&fsRef, true /*resolveAliasChains*/, &targetIsFolder, &wasAliased);
			if (err == noErr && wasAliased) {
				General/CFURLRef resolvedurl = General/CFURLCreateFromFSRef(NULL /*allocator*/, &fsRef);
				if (resolvedurl != NULL) {
					resolvedPath = General/CFURLCopyFileSystemPath(resolvedurl, kCFURLPOSIXPathStyle);
					General/CFRelease(resolvedurl);
				}
			}
		} else {
                     // Probably means there's an alias in the middle of the path...
                     // So recurse back through the components until we hit on the alias bit - resolve that and then tack
                     // the components back on.
			General/NSString* lastPathComponent = General/inPath lastPathComponent] retain];
			resolvedPath = ([[CFStringRef)[self pathResolved: [inPath stringByDeletingLastPathComponent]];
			resolvedPath = (General/CFStringRef)[(General/NSString*)resolvedPath stringByAppendingPathComponent: lastPathComponent];
			[lastPathComponent release];
		}
		General/CFRelease(url);
	}
	return (General/NSString *)resolvedPath;
}


----

Here are just two more symbolic link resolvers:

curl -O http://www.10k.org/jake/pub/cr/General/CompleteResolve.tar.gz  (only HFS+ aliases)

curl -O http://www.mitt-eget.com/software/unix/readlink/readlink-1.0.tar.gz   (only Unix-style symbolic links)