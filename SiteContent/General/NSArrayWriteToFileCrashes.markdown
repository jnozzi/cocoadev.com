

Hello,

When executing "writeToFile" below, my code consistently crashes (SIGSEGV), and I cannot figure out why.
All I want to do is to pick some directory (e.g., "/tmp" in the code below) and gather information about all the files within that directory.
Once that is completed, I want to save this information to file.  I don't understand, though, why this code would
crash on me.  What am I missing?


    
	General/NSDirectoryEnumerator *enumerator = General/[[NSFileManager defaultManager] enumeratorAtPath:@"/tmp"];
	General/NSMutableArray *array = General/[NSMutableArray arrayWithCapacity:50];
	while ([enumerator nextObject]) {
		[array addObject:[enumerator fileAttributes]];
	}

	[array writeToFile:@"/tmp/experiment" atomically:YES]; // crashes right here



P.S.: I am using OS X Panther

----
What is the backtrace of the crash? What are the exact contents of array?

----
Thanks for the reply.  The stack trace is as follows:

    
... [ repeat #12260 - #12258 until crash ]
#12258	0x90a9041c in -General/[NSCFArray isEqual:]
#12259	0x90ae7a68 in -General/[NSFileAttributes isEqual:]
#12260	0x901c1eb0 in General/CFEqual
#12261	0x90a9041c in -General/[NSCFArray isEqual:]
#12262	0x90ae7a68 in -General/[NSFileAttributes isEqual:]
#12263	0x901c1eb0 in General/CFEqual
#12264	0x90a9041c in -General/[NSCFArray isEqual:]
#12265	0x90ae7a68 in -General/[NSFileAttributes isEqual:]
#12266	0x901c1eb0 in General/CFEqual
#12267	0x901c7170 in __CFSetFindBuckets1
#12268	0x901d3904 in General/CFSetGetValueIfPresent
#12269	0x90a2d210 in -General/[NSCFSet member:]
#12270	0x90a321c4 in -General/[NSSet containsObject:]
#12271	0x90a31b4c in _NSIsPList
#12272	0x90a31be4 in _NSIsPList
#12273	0x90aaa73c in -General/[NSArray writeToFile:atomically:]
#12274	0x000d8e3c in main at main.m:12


The contents of the array is:

    
(
    {
        General/NSFileCreationDate = 2006-10-12 11:00:08 -0700; 
        General/NSFileExtensionHidden = 0; 
        General/NSFileGroupOwnerAccountID = 0; 
        General/NSFileGroupOwnerAccountName = wheel; 
        General/NSFileModificationDate = 2006-10-12 11:02:33 -0700; 
        General/NSFileOwnerAccountID = 502; 
        General/NSFileOwnerAccountName = xyz; 
        General/NSFilePosixPermissions = 488; 
        General/NSFileReferenceCount = 3; 
        General/NSFileSize = 102; 
        General/NSFileSystemFileNumber = 2481598; 
        General/NSFileSystemNumber = 234881026; 
        General/NSFileType = General/NSFileTypeDirectory; 
    }, 
    {
        General/NSFileCreationDate = 2006-10-12 11:02:33 -0700; 
        General/NSFileExtensionHidden = 0; 
        General/NSFileGroupOwnerAccountID = 0; 
        General/NSFileGroupOwnerAccountName = wheel; 
        General/NSFileModificationDate = 2006-10-12 11:06:32 -0700; 
        General/NSFileOwnerAccountID = 502; 
        General/NSFileOwnerAccountName = xyz; 
        General/NSFilePosixPermissions = 488; 
        General/NSFileReferenceCount = 3; 
        General/NSFileSize = 102; 
        General/NSFileSystemFileNumber = 2481628; 
        General/NSFileSystemNumber = 234881026; 
        General/NSFileType = General/NSFileTypeDirectory; 
    }, 
    {
        General/NSFileCreationDate = 2006-10-12 11:02:33 -0700; 
        General/NSFileExtensionHidden = 0; 
        General/NSFileGroupOwnerAccountID = 0; 
        General/NSFileGroupOwnerAccountName = wheel; 
        General/NSFileModificationDate = 2006-10-12 11:02:33 -0700; 
        General/NSFileOwnerAccountID = 502; 
        General/NSFileOwnerAccountName = xyz; 
        General/NSFilePosixPermissions = 488; 
        General/NSFileReferenceCount = 3; 
        General/NSFileSize = 102; 
        General/NSFileSystemFileNumber = 2481629; 
        General/NSFileSystemNumber = 234881026; 
        General/NSFileType = General/NSFileTypeDirectory; 
    }, 
    {
        General/NSFileCreationDate = 2006-10-12 11:02:33 -0700; 
        General/NSFileExtensionHidden = 0; 
        General/NSFileGroupOwnerAccountID = 0; 
        General/NSFileGroupOwnerAccountName = wheel; 
        General/NSFileModificationDate = 2006-10-12 11:02:33 -0700; 
        General/NSFileOwnerAccountID = 502; 
        General/NSFileOwnerAccountName = xyz; 
        General/NSFilePosixPermissions = 488; 
        General/NSFileReferenceCount = 2; 
        General/NSFileSize = 68; 
        General/NSFileSystemFileNumber = 2481630; 
        General/NSFileSystemNumber = 234881026; 
        General/NSFileType = General/NSFileTypeDirectory; 
    }, 
    {
        General/NSFileCreationDate = 2006-10-12 10:59:50 -0700; 
        General/NSFileExtensionHidden = 0; 
        General/NSFileGroupOwnerAccountID = 0; 
        General/NSFileGroupOwnerAccountName = wheel; 
        General/NSFileHFSCreatorCode = 0; 
        General/NSFileHFSTypeCode = 0; 
        General/NSFileModificationDate = 2006-10-12 10:59:50 -0700; 
        General/NSFileOwnerAccountID = 0; 
        General/NSFileOwnerAccountName = root; 
        General/NSFilePosixPermissions = 420; 
        General/NSFileReferenceCount = 1; 
        General/NSFileSize = 745; 
        General/NSFileSystemFileNumber = 2481588; 
        General/NSFileSystemNumber = 234881026; 
        General/NSFileType = General/NSFileTypeRegular; 
    }
)


----
It seems that the dictionary you get back is being uncooperative, and is a special subclass of General/NSDictionary. Try making normal General/NSDictionary objects from the array, something like this:

    
[array addObject:General/[NSDictionary dictionaryWithDictionary:[enumerator fileAttributes]]];


I'm not sure this is the problem but it's worth a try.
----
Are you sure you have the right write rights on that path?

otherwise try this
    
General/NSString *storePath = General/[NSHomeDirectory() stringByAppendingPathComponent:@"/tmp/experiment"];
		[arrayData writeToFile:storePath atomically:YES];


I did convert your given content into a plist, read that into a array and then wrote it to disk. No problems here, even in /tmp/.. ( if I have write rights ).

----

Thank you very much for the two suggestions!  Creating normal General/NSDictionary objects did the trick.

----
I recommend filing a bug about this on http://bugreport.apple.com . The interface declares the return type as General/NSDictionary and so they ought to be directly serializable! Whip up a small test case to post with the report, they like that.
----
Can you tell us what version of osx and xcode you did use? I did use this code in an older app to and want to be sure if I need to change it. Thanks

----
Re: 1) Good point.  Just filed a bugreport.
Re: 2) OS X 10.3.9 Build 7W98, General/XCode 1.2

----

So you haven't tried 10.4?

----
No,  all my machines are still running 10.3.