To get a generic folder icon you have to use the General/NSWorkSpace API as follows:
    
            General/NSString *folderFileType = General/NSFileTypeForHFSTypeCode(kGenericFolderIcon);
            icon = General/[[NSWorkspace sharedWorkspace] iconForFileType:folderFileType];


You can generate other system wide icons by using the following HFS type codes:

* kGenericFolderIcon
*  kDropFolderIcon
*   kMountedFolderIcon
*   kOpenFolderIcon
*   kOwnedFolderIcon
*   kPrivateFolderIcon
*   kSharedFolderIcon