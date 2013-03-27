

General/NiAccess used to be the framework for manipulating General/NetInfo from Cocoa applications (it's what General/NetInfoManager uses), but it has been deprecated and is going away.

The API that Apple wants you to use for the same functionality is found in the General/DirectoryService framework, but it is a C API. I made a start at a General/DirectoryKit Obj-C wrapper, but never got very far.

-- General/FinlayDobbie