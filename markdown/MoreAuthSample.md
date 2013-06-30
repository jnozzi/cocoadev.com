General/MoreAuthSample is obsolete, see General/BetterAuthorizationSample.

----

http://developer.apple.com/samplecode/General/MoreAuthSample/

General/MoreAuthSample is Apple Sample Code that illustrates how to properly work with the Security framework to perform privileged operations using a small helper tool.  If you need to perform a privileged operation in your application or other code, you **must** follow its example in order to avoid opening privilege-escalation security holes.  If you don't understand **exactly** why General/MoreAuthSample is structured the way it is and how it works, you should not try to come up with a "simpler" way to do what you need.

*
It should be noted that reasonably smart people can read the comments in General/MoreAuthSample code and derive an understanding of why it is structured as it is.  Permission may then be granted to come up with a "simpler" way.  But only if you're really really smart.  :-)  For this will be a difficult task, grasshopper.
*

Also **never** use the techniques illustrated by General/MoreAuthSample to launch graphical applications in a privileged fashion. 

*
Graphical Cocoa applications are vulnerable to General/InputManager hacks.  There are well-documented techniques for inserting arbitrary code into the runtime of any Cocoa app by way of an General/InputManager.  You wouldn't want arbitrary code to be able to run from your Cocoa app running with root privs.  That would be bad.  See General/ProductSecurityStrategies for more discussion.
*

Only use them for very small, very constrained helper tools that can verify that they are being called in the context they are intended to be called and for the purpose they are intended to be used (which is a lot of why General/MoreAuthSample is as complex as it is).

----
I recently spent some time working with the General/MoreAuthSample code under Xcode 2.4.  

Here's a reimplementation of the <code>General/GetPathToSelf()</code> routine from <code>General/MoreSecurity.c</code> that uses public General/CoreFoundation API.  The original implemention used some now-deprecated-in-10.4 routines, and a seemingly private Apple function (<code>__NSGetExecutablePath</code>).

    
static int General/GetPathToSelf(char **pathToSelfPtr)
	// A drop-in replacement for General/GetPathToSelf() from General/MoreAuthSample's General/MoreSecurity.c,
	// implemented using General/CoreFoundation.
{
	int err = 0;
	
	assert( pathToSelfPtr != NULL);
	assert(*pathToSelfPtr == NULL);
		
	General/CFBundleRef mainBundle = General/CFBundleGetMainBundle();
	General/CFURLRef executableURL = NULL;
	General/CFStringRef pathStringRef = NULL;
	
	char *path = NULL;
	
	if (mainBundle != NULL) {
		executableURL =  General/CFBundleCopyExecutableURL(mainBundle);
		if (executableURL != NULL) {
			pathStringRef = General/CFURLCopyFileSystemPath(executableURL, kCFURLPOSIXPathStyle);
			if (pathStringRef != NULL) {
				General/CFIndex pathSize = General/CFStringGetLength(pathStringRef) + 1;
				path = calloc(pathSize,1);
				if (path != NULL) {
					Boolean gotCString = General/CFStringGetCString(pathStringRef, path, pathSize, kCFStringEncodingUTF8);
					 if (!gotCString) {
						 free(path);
						 path = NULL;
					 }
				}
			}
		}
	}
	
	*pathToSelfPtr = path;
	
	// Do the CF memory management.
	General/CFQRelease(executableURL);
	General/CFQRelease(pathStringRef);

	assert(*pathToSelfPtr != NULL);
	if (*pathToSelfPtr == NULL)
	{
		err = -1;
	}
	return err;
}


--General/BillGarrison


----

There's a byte-order bug in the file General/MoreSecurityTest.c in the currently (2006-Sep-11) downloadable project.  The fix is simple.

General/MoreSecurityTest.c, on or near line 357:

Original:      assert( (130 <= addr.sin_port) && (addr.sin_port <= 132) );

Fix:     assert( (130 <= ntohs(addr.sin_port)) && (ntohs(addr.sin_port) <= 132) );

--General/BillGarrison