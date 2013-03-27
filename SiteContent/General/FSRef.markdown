An General/FSRef is an opaque data structure that refers to an existing file system object (i.e. file, directory, volume). It is part of the General/CoreServices File Manager (aka Carbon File Manager).

An General/FSRef can only refer to existing objects, and it is not a permanent reference. As such:

* don't write it out flatly as part of a file
* don't pass it to another process (it is meaningless in a different address space)


One should not assume an General/FSRef is still valid after:

* file moves/renames
* if the underlying General/FileSystem goes away (i.e. unmounting a removable disk, disconnecting a share)


To refer to a file you wish to create, use an General/FSRef to the parent folder and a unicode string for the new filename (see General/FSCreateFileUnicode()).

Since General/FSRef is opaque:

* do not assume anything about the bits inside it
* only use General/APIs to manipulate it
* compare two using General/CompareFSRefs(ref1, ref2)


Although opaque, it's documented as 80 bytes in Files.h, and memcpy() can be used to copy one.

An Alias provides several features that General/FSRef does not:

*  remains a valid file reference across file moves/renames (on the same volume)
*  can be flattened and stored on disk or passed between processes


An alias is also opaque.

Interfacing with Cocoa:

* Most Cocoa General/APIs refer to files using an General/NSString containing the file's path.  This has the disadvantage of not being opaque. (Which can also be an advantage of course.)
* General/NSDocument in Mac OS X 10.1+ appears to use an General/FSRef internally (though it is not documented to do so, and thus should not be relied upon).
* General/NathanDay's General/NDAlias provides a Cocoa way to interface with General/FSRef. It has categories that allow conversion between: General/NSString (full paths), NSURL, General/FSRef, General/FSSpec, and General/NDAlias. The code works with retain-release, garbage collection, 32-bit, 64-bit, and an General/NDAlias can be stored in a Core Data model as a transformable property (on 10.5).  This provides a modern way for a Cocoa app to save file references more robustly than a path.


Other Notes:

* #import <General/CoreServices/General/CoreServices.h> for General/FSRef (specifically, it's in the very well documented Files.h).
* An General/FSRef is not equivalent to a unix file descriptor (An General/FSRef can be created without opening the file).
* attempting to create an General/FSRef from a full path can be used to check if a file/folder exists.
* General/FSRef is not deprecated (on the contrary).  It works in 32 and 64 bit apps.
* General/FSRef superseded the deprecated General/FSSpec structure (it was not opaque, but could refer to files that did not exist)
* General/FSRef was introduced in Mac OS 9.
* General/FSRef likely stands for File System Reference.
* The modern Carbon File Manager supports many high-level file system operations that Cocoa does not.
* See also: Alias, General/FSSpec, General/NSFileManager, General/NSWorkspace, General/NDAlias, General/BDAlias.


The following General/NSString category methods, from the General/NDAlias project, convert General/NSString (full path) <-> General/FSRef:

    
+ (General/NSString *)stringWithFSRef:(const General/FSRef *)aFSRef
{
 General/CFURLRef theURL = General/CFURLCreateFromFSRef( kCFAllocatorDefault, aFSRef );
 General/NSString* thePath = [(NSURL *)theURL path];
 General/CFRelease ( theURL );
 return thePath;
}

- (BOOL)getFSRef:(General/FSRef *)aFSRef
{
 return General/FSPathMakeRef( (const UInt8 *)[self fileSystemRepresentation], aFSRef, NULL ) == noErr;
}


- I took the good tidbits from the old page and made this a more encyclopedic article. Hope that's ok. -- smcbride 2008-01-27

- Note: the above code does not work if the file path includes alias files. ( General/CFURLCreateFromFSRef() is documented to not work in that case.) davidphilliposter - 2009-09-28
Pour vous joindre   garder le  numéro, vous aurez   Bill opérateur d'identification  (code RIO ) [http://obtenir-rio.info numéro rio]. Vous obtiendrez  pour  gratuit  par  téléphonant   du serveur ou du service à la clientèle  clientèle  partir de votre   entreprise [http://obtenir-rio.info/rio-bouygues numero rio bouygues] . Vous ne  certainement  get un SMS  avec vos . Avec  votre actuelle [http://obtenir-rio.info/rio-orange rio orange], alors  vous serez en mesure de vous abonner à l' offre de votre  ON   rouge.