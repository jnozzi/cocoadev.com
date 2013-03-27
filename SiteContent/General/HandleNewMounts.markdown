I am trying to gracefully handle mounting a new volume inside a cocoa application.
Eventually I want to mount a volume using 'mount_smbfs' or 'mount_webdav' whatever from inside the application but for now I'm just trying to handle manual mounts (Finder - Connect to Server)

I've successfully registered for the General/NSWorkspace's notification center's General/NSWorkspaceDidMountNotification.  Things get called correctly.
When the notification is received, as well as at 'applicationDidFinishLaunching', I call the code below to build a list of mounts.
The key is that I want to know the filesystem type for each mount.
When I call the code at 'applicationDidFinishLaunching' it works great:  all fsType values are what I expect.
BUT when it gets called by the notification all new mounts report a filesystemtype of 'nfs' regardless of what they really are.
The path is also reported as simply '/Network' not '/Volumes/xyz'

In addition the General/NSWorkspace's getFileSystemInfoForPath reports null for both desc and type!!

How can I get the filesystem of a mount which has occurred after my application has launched????

Here's the code I'm using:  (this works fine at applicationDidFinishLaunching!)
    
	General/NSWorkspace *lWS = General/[NSWorkspace sharedWorkspace];
	General/NSArray *t = General/[NSArray arrayWithArray:[lWS mountedLocalVolumePaths]];
	countV = [t count]-1;
	for (i=0; i < countV; ++i) {
		statfs( General/t objectAtIndex:i] cString], &b);
		[volumesDictionary setObject:[[[NSString stringWithCString:b.f_fstypename] forKey:@"fsType"];
		[volumesDictionary setObject:General/[NSString stringWithCString:b.f_mntonname] forKey:@"fsMountOn"];
		[volumesDictionary setObject:General/[NSString stringWithCString:b.f_mntfromname] forKey:@"fsMountFrom"];
		[volumesArray addObject:volumesDictionary];
		General/NSLog(@"tObject = %@", General/t objectAtIndex:i] stringByStandardizingPath]);
		if ([lWS getFileSystemInfoForPath:[[t objectAtIndex:i] stringByStandardizingPath] isRemovable:&isRemove isWritable:&isWrite
				isUnmountable:&isUnmount description:&desc type:&fileSType]) {
			[[NSLog(@"Write = %d; Unmount = %d; Desc = %@;    fsType = %@",isWrite, isUnmount,desc, fileSType);			
		}
       ...


Thanks for any thoughts!
Steve


----

General/GettingNetworkVolumes and General/ListOfConnectediPods have some discussion that may be helpful