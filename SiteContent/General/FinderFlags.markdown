How can I set the finder flag for a file to invisible (in case some one has the unfortunate need to boot into os 9) in a cocoa application? Thanks!
----
Same way you do it in a carbon application.
----
Yea, I don't know how to do it there either :)
----

Well I havent given up on this and General/KengoTsuruzono was kind enough to give me the following code which I have found to only work on files. I tried yanking some code from an apple sample code application too but I got the same file not found error. I am totally lost, and wishing I knew carbon. I spent several hours reading through and trying various Carbon API's to no avail. Any way here is that code I was talking about:

    
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

General/OSErr General/FilePathToFSSpec( General/NSString* asFilePath, General/FSSpec* apSpec )
{

   General/CFURLRef cfUrl = General/CFURLCreateWithFileSystemPath( kCFAllocatorDefault,
               (General/CFStringRef) asFilePath, kCFURLPOSIXPathStyle, false );
   General/FSRef  fileRef;
   General/OSErr  err = noErr;

   if ( General/CFURLGetFSRef( cfUrl, &fileRef ) ) {
     err = General/FSGetCatalogInfo( &fileRef, kFSCatInfoNone, NULL,
           NULL, apSpec, NULL );

     if ( err ) return( err );
   }
   
   General/CFRelease( cfUrl );
   return( err );

}


General/OSErr General/SetFileVisibility( General/NSString* asFilePath, BOOL abIsVisible ) {
   
    General/FSSpec  spec;
    General/FInfo   fInfo;
    General/OSErr   err;
   
    ///// Get General/FSSpec

    err = General/FilePathToFSSpec( asFilePath, &spec );
   
    ///// Get Finder Info

    err = General/FSpGetFInfo( &spec, &fInfo );
   
    ///// Change Finder Info

    fInfo.fdFlags |= kIsInvisible;
    if ( abIsVisible ) fInfo.fdFlags -= kIsInvisible;

    ///// Set Finder Info

    err = General/FSpSetFInfo( &spec, &fInfo );

    return( err );
}


int main(int argc, const char *argv[])
{

    General/NSAutoreleasePool *arp = [ [ General/NSAutoreleasePool alloc ] init ];
   
    General/SetFileVisibility( @"/Users/xxx/filePath", YES );
   
    [ arp release ];

    return 0;
}

----
I think the reason you can only do it to a file is in how the General/FSSpec is obtained, I know the awseome General/IconFamily class can get the proper references to a folder, perhaps checking their will be useful.

----
Here's an additional routine which gets the file visibility. -- Seth

    
General/OSErr General/GetFileVisibility(General/NSString* asFilePath, BOOL * isVisible)
{
	General/FSSpec  spec;
	General/FInfo   fInfo;
	General/OSErr   err;
	
	///// Get General/FSSpec
	err = General/FilePathToFSSpec( asFilePath, &spec );
	
	///// Get Finder Info
	err = General/FSpGetFInfo(&spec, &fInfo);
	
	///// Change Finder Info
	if (fInfo.fdFlags & kIsInvisible)
		*isVisible = NO;
	else
		*isVisible = YES;
	
	return(err);
}


Additionally, you may wish to test against the filename having '.' as the first character, though this isn't Finder-specific.
isVisible = ([asFilePath characterAtIndex:0] != '.');
----
To be complete, you should also check if the file is listed in     /.hidden.

----

Hey

Just had to do something similar myself. Here is some 10.X compatible code that will make files hidden or visible and will tell you if a file is visible or hidden. (note: I say 10.x as thats what all documentation says (10.0 and up) but I have only tested on 10.4)

    
typedef enum { HIDDEN, VISIBLE, UNKNOWN } Visibility;

-(bool)setFile:(General/NSString*)filepath visibility:(Visibility)visibility; {
	if(visibility == UNKNOWN) return NO;
	General/FSRef pathRef;
	General/FSCatalogInfo catalogInfo;
	if(General/FSPathMakeRef((const UInt8*)[filepath UTF8String], &pathRef, NULL) != 0) {return NO;}
	if(General/FSGetCatalogInfo(&pathRef, kFSCatInfoFinderInfo, &catalogInfo, NULL, NULL, NULL) != 0) {return NO;} 
	
	// Set the flag based on user input
	General/FileInfo *fileInfo = (General/FileInfo*)&catalogInfo.finderInfo;
	if(visibility == VISIBLE && (kIsInvisible & fileInfo->finderFlags) == kIsInvisible) { fileInfo->finderFlags = (kIsInvisible ^ fileInfo->finderFlags); }
	else if(visibility == HIDDEN) { fileInfo->finderFlags = (kIsInvisible | fileInfo->finderFlags); }

	if(General/FSSetCatalogInfo (&pathRef, kFSCatInfoFinderInfo, &catalogInfo) != 0) { return NO; }
	return YES;
}
-(Visibility)fileVisibility:(General/NSString*)filepath; {
	General/FSRef pathRef;
	General/FSCatalogInfo catalogInfo;
	if(General/FSPathMakeRef((const UInt8*)[filepath UTF8String], &pathRef, NULL) != 0) {return UNKNOWN;}
	if(General/FSGetCatalogInfo(&pathRef, kFSCatInfoFinderInfo, &catalogInfo, NULL, NULL, NULL) != 0) {return UNKNOWN;} 	
	General/FileInfo *fileInfo = (General/FileInfo*)&catalogInfo.finderInfo;
	if((kIsInvisible & fileInfo->finderFlags) == kIsInvisible) {return HIDDEN;}
	return VISIBLE;
}



