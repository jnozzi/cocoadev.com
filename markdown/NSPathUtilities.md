General/NSString path-oriented methods such as     stringByStandardizingPath and     lastPathComponent are declared at /System/Library/Frameworks/Foundation.framework/Headers/General/NSPathUtilities.h. 

    
public static General/NSDictionary fileAttributes( String filePath, boolean resolveSymlink)


Description found!

this is what it returned for us:
General/NSDictionary:
*General/NSFileGroupOwnerAccountName = theGroup; 
*General/NSFileModificationDate = 2001-07-13 15:04:33 -0700; 
*General/NSFileOwnerAccountName = theUser; 
*General/NSFilePosixPermissions = 420; 
*General/NSFileReferenceCount = 1; 
*General/NSFileSize = 39273; 
*General/NSFileSystemFileNumber = 197077; 
*General/NSFileSystemNumber = 234881033; 
*General/NSFileType = { General/NSFileTypeRegular, General/NSFileTypeSymbolicLink, ...} ; 

General/FrancoisFrisch

----

WARNING when using
    
public static General/NSDictionary stringByResolvingSymlinksInPath( String filePath)


This method resolves any symlinks in the path HOWEVER it also strips the trailing "/"!

General/FrancoisFrisch

----

enums in General/NSPathUtilites.h:

    
FOUNDATION_EXPORT General/NSString *General/NSUserName(void);
FOUNDATION_EXPORT General/NSString *General/NSFullUserName(void);

FOUNDATION_EXPORT General/NSString *General/NSHomeDirectory(void);
FOUNDATION_EXPORT General/NSString *General/NSHomeDirectoryForUser(General/NSString *userName);

FOUNDATION_EXPORT General/NSString *General/NSTemporaryDirectory(void);

FOUNDATION_EXPORT General/NSString *General/NSOpenStepRootDirectory(void);

typedef enum {
    General/NSApplicationDirectory = 1,		// supported applications (Applications)
    General/NSDemoApplicationDirectory,		// unsupported applications, demonstration versions (Demos)
    General/NSDeveloperApplicationDirectory,	// developer applications (Developer/Applications)
    General/NSAdminApplicationDirectory,	// system and network administration applications (Administration)
    General/NSLibraryDirectory, 		// various user-visible documentation, support, and configuration files, resources (Library)
    General/NSDeveloperDirectory,		// developer resources (Developer)
    General/NSUserDirectory,			// user home directories (Users)
    General/NSDocumentationDirectory,		// documentation (Documentation)
#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED
    General/NSDocumentDirectory,		// documents (Documents)
#endif
    General/NSAllApplicationsDirectory = 100,	// all directories where applications can occur
    General/NSAllLibrariesDirectory = 101	// all directories where resources can occur
} General/NSSearchPathDirectory;

typedef enum {
    General/NSUserDomainMask = 1,	// user's home directory --- place to install user's personal items (~)
    General/NSLocalDomainMask = 2,	// local to the current machine --- place to install items available to everyone on this machine (/Library)
    General/NSNetworkDomainMask = 4, 	// publically available location in the local area network --- place to install items available on the network (/Network)
    General/NSSystemDomainMask = 8,	// provided by Apple, unmodifiable (/System)
    General/NSAllDomainsMask = 0x0ffff	// all domains: all of the above and future items
} General/NSSearchPathDomainMask;

FOUNDATION_EXPORT General/NSArray *General/NSSearchPathForDirectoriesInDomains(General/NSSearchPathDirectory directory, General/NSSearchPathDomainMask domainMask, BOOL expandTilde);
