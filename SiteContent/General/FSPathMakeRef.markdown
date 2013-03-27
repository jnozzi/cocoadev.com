General/FSPathMakeRef is a function which creates an General/FSRef from a POSIX path. This is probably the simplest way to get an General/FSRef from an General/NSString containing a path. Example:

    
General/FSRef outRef;
General/OSStatus err = General/FSPathMakeRef((const UInt8 *)[path fileSystemRepresentation], &outRef, NULL);
if(err != noErr)
   ...signal the error...


Note that since General/FSRef<nowiki/>s can only point to existing files, this function will not work if the file indicated by the path does not exist.

----

In most cases it is better to call General/FSPathMakeRefWithOptions and pass kFSPathMakeRefDefaultOptions, since it will succeed for paths such as "/Volumes" unlike General/FSPathMakeRef.