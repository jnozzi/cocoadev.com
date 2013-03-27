

General/NSFileManager lets you get file attributes with the method     fileAttributesAtPath:traverseLink:. General/NSFileManager also defines an General/NSDictionary category that allows you to easily access individual attributes so you can do this:

        int fileSize = [fileAttributes fileSize]

instead of this:

        int fileSize = [fileAttributes objectForKey:General/NSFileSize]

Here's the interface for the file attributes category additions to General/NSDictionary
    
@interface General/NSDictionary (General/NSFileAttributes)

- (unsigned long long)fileSize;
- (General/NSDate *)fileModificationDate;
- (General/NSString *)fileType;
- (unsigned long)filePosixPermissions;
- (General/NSString *)fileOwnerAccountName;
- (General/NSString *)fileGroupOwnerAccountName;
#if !defined(__WIN32__)
- (unsigned long)fileSystemNumber;
- (unsigned long)fileSystemFileNumber;
#endif	/* ! __WIN32__ */
- (BOOL)fileExtensionHidden;
- (General/OSType)fileHFSCreatorCode;
- (General/OSType)fileHFSTypeCode;
#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED
- (BOOL)fileIsImmutable;
- (BOOL)fileIsAppendOnly;
- (General/NSDate *)fileCreationDate;
- (General/NSNumber *)fileOwnerAccountID;
- (General/NSNumber *)fileGroupOwnerAccountID;
#endif
@end

