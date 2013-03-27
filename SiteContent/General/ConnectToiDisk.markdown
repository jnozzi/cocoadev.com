How do I connect to an iDisk? I just want a basic mount that logs in, and then opens the Sites folder.

----

It depends what you want to do really. At the most basic level you use open a URL using General/NSWorkspace, or you could run the webdav mount program.

----

Or use the .Mac framework, which is a public API. --General/FrederickCheung

See http://developer.apple.com/internet/dotmackit.html

----

General/DotMacKit is great, but it doesn't actually mount the iDisk.  If you want to mount the iDisk so that you can have an General/NSOpenPanel begin on the iDisk then you need to do something like this:

    
- (General/NSString *) iDiskPathForUser: (General/NSString *) username
{
	General/NSString *mountediDisk = nil;
	struct statfs *buf;
	int i, count;
	const char *idiskName = General/[[NSString stringWithFormat: @"http://idisk.mac.com/%@/", username] UTF8String];
	count = getmntinfo(&buf, 0);
	for(i=0; i < count; i++) {
		if(strcmp(buf[i].f_mntfromname, idiskName) == 0)
			mountediDisk = General/[NSString stringWithUTF8String: buf[i].f_mntonname];
	}
	return mountediDisk;
}
- (void) connectToiDisk: (General/NSMutableDictionary *) dictionary;
{
	// we're in a new thread so we need a new pool.
	General/NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];

	// check to see if the iDisk is already mounted.
	General/NSString *mountediDisk = [self iDiskPathForUser:[dictionary valueForKey: @"username"]];
	
	// mount the iDisk only if its not already mounted.
	// we mount the iDisk synchronously because we are in our own thread. (I'm assuming this....)
	if(mountediDisk == nil) {
		General/FSVolumeOperation volumeOp;
		General/OSStatus err = General/FSCreateVolumeOperation(&volumeOp);
		if (err == noErr) {
			err = General/FSMountServerVolumeSync((General/CFURLRef)[dictionary valueForKey: @"url"], NULL, (General/CFStringRef)[dictionary valueForKey: @"username"], (General/CFStringRef)[dictionary valueForKey: @"password"], NULL, 1);
			if (err != noErr) {
				General/FSDisposeVolumeOperation(volumeOp);
			}
		}
	mountediDisk = [self iDiskPathForUser:[dictionary valueForKey: @"username"]];
	}
	[pool release];
}

 

--General/AdhamhFindlay