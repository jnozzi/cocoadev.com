To get a generic folder icon you have to use the [[NSWorkSpace]] API as follows:
<code>
            [[NSString]] ''folderFileType = [[NSFileTypeForHFSTypeCode]](kGenericFolderIcon);
            icon = [[[[NSWorkspace]] sharedWorkspace] iconForFileType:folderFileType];
</code>

You can generate other system wide icons by using the following HFS type codes:

* kGenericFolderIcon
*  kDropFolderIcon
*   kMountedFolderIcon
*   kOpenFolderIcon
*   kOwnedFolderIcon
*   kPrivateFolderIcon
*   kSharedFolderIcon