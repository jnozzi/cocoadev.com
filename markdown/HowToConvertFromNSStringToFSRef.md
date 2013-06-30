

I am using a save panel to get the user's desired directory and filename. I would like to pass these two General/NSString values to a function that requires an General/FSRef for the directory name and a General/CFStringRef for the filename. What can I do to get these two strings in a format that is compatible with General/FSRef and General/CFStringRef? 

Thank you in advance for any help.
----
General/CFStringRef is easy, it is toll free bridged with General/NSString, which means that they can be used interchangeably
For the General/FSRef you could create an NSURL with the path. NSURL is toll free bridged with General/CFURLRef, so you can call General/CFURLGetFSRef on it. Alternatively get a UTF8 representation to the string and stick it into General/FSPathMakeRef

General/FrederickCheung