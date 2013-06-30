    
 Boolean CFURLGetFSRef (
    CFURLRef url,
    FSRef *fsRef
 );


Retrieves the General/FSRef associated with a given General/CFURLRef; returns false on failure, true on success.

I presume the General/CFURL must be a file:// URL, or this function won't do any good. *The documentation does seem to imply that*.

General/NSURL object pointers are General/TollFreeBridged with the General/CFURLRef type -- you can cast them freely between both types and use them happily and nicely with either Cocoa or General/CoreFoundation api calls. See General/NSURL for more information on the General/NSURL type.

Apple Documentation:
http://developer.apple.com/documentation/CoreFoundation/Reference/CFURLRef/Reference/reference.html