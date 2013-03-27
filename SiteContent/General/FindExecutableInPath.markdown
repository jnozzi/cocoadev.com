**Overview**

General/FindExecutableInPath allows you to search directories in $PATH for a specific executable name. 

**$PATH Notes**

The default $PATH returned by General/NSProcessInfo only includes /usr/bin, /bin, /usr/sbin and the user's home directory. 

In the code below, I've also added /sw/bin (Fink), and /usr/local/bin, which are common locations for third-party command-line applications.

**Credits**

This is based on the example provided on the General/AllApplications page.

**Code**

<code>
    
- (void)applicationsInDirectory:(General/NSString*)searchPath
                  searchResults:(General/NSMutableArray*)resultPaths
                 	  file:(General/NSString*)filename
{
    General/NSFileManager *manager = General/[NSFileManager defaultManager];
    General/NSArray *files = [manager directoryContentsAtPath:searchPath];
    General/NSEnumerator *fileEnum = [files objectEnumerator]; 
	General/NSString *file;
    
	while (file = [fileEnum nextObject]) {
        [manager changeCurrentDirectoryPath:searchPath];
        if ([manager isExecutableFileAtPath:file]) 
		{
            General/NSString *fullpath = [searchPath stringByAppendingPathComponent:file];
            if ([file isEqualToString:filename]) 
			{
				[resultPaths addObject:fullpath];
			} 
		} 
    }
}


- (General/NSArray*)allApplications:(General/NSArray*)searchPaths file:(General/NSString*)filename 
{
    General/NSMutableArray *resultPaths = General/[NSMutableArray array];
    General/NSEnumerator *searchPathEnum = [searchPaths objectEnumerator]; 
	General/NSString *path;
    
	while (path = [searchPathEnum nextObject]) 
	{
		[self applicationsInDirectory:path searchResults:resultPaths file:filename];
    }
	
	return ([resultPaths count]) ? resultPaths : nil;
}

- (void)findExecutableInPath:(General/NSString *)filename 
{
	General/NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];
	
	/* ======================================================================= */
	/* 1. Setup Search Path array based on default $PATH environment variable. */
	/* 2. Add path to fink bin directory and /usr/local/bin 				   */
	/* ======================================================================= */
	
	General/NSString *searchPath = General/[NSString stringWithUTF8String:getenv("PATH")];
	searchPath = [searchPath stringByAppendingString:@":/sw/bin:/usr/local/bin"];
	General/NSArray *searchPaths = [searchPath componentsSeparatedByString:@":"];
	
	//General/NSLog(@"%s: Searching Paths %@", _cmd, searchPaths);
	General/NSArray *executablePaths = [self allApplications:searchPaths file:filename];
		
	if ([executablePaths count] > 0) {
		// Do something with the path here
		//General/NSLog(@"%s: executable Paths %@", _cmd, executablePaths);	
	}
	
	[pool release];
}


</code>

-- ncb

----
This code is *ridiculously* convoluted and won't even work. It is good to test your examples before posting them. (The initializer for     searchPath is totally broken, will produce a warning, and will crash when run. There may be other problems.)

I would suggest code like the following (uses a General/ForallMacro):

    
General/NSArray *General/ExecutablesInPath(General/NSString *name)
{
    General/NSMutableArray *retVal = General/[NSMutableArray array];
    General/NSString *pathEnv = General/[[[NSProcessInfo processInfo] environment] objectForKey:@"PATH"];
    General/NSArray *paths = [pathEnv componentsSeparatedByString:@":"];
    forall(path, paths)
    {
        General/NSString *executablePath = [path stringByAppendingPathComponent:name];
        if(General/IsExecutable(executablePath))
            [retVal addObject:executablePath];
    }
    return retVal;
}


Note that this code is *also* not tested, as it is meant to illustrate the technique, handle with caution.

The implementation of     General/IsExecutable is left as an exercise to the reader. Depending on what you want to do, you may want to check for     +x, or for a     .app wrapper, or something else.


----

Woops. 

I've fixed the code to to use getenv("PATH") for the searchPath initialisation.


-- ncb

----
I've fixed the code not to leak and to work properly with non-ASCII paths. (See General/StringWithCString for why this is.)