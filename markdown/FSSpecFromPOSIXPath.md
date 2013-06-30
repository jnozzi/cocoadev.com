Before you go any farther, see the General/FSSpec page and do everything you can to eliminate all use of General/FSSpec from your application.

If you really need to get an General/FSSpec from a path, here's how (warning: untested code, error checking eliminated for breity):

    
General/FSRef fsref;
General/FSSpec fsspec;
General/OSStatus result;

result = General/FSPathMakeRef((UInt8*)[directory UTF8String], &fsref, nil);
result = General/FSGetCatalogInfo(&newRef, kFSCatInfoNone, NULL, NULL, &fsspec, NULL);


Because this code goes through an General/FSRef, it will only work for files which already exist. If you get an error -43 from     General/FSPathMakRef that means the file doesn't exist, and this code won't work.