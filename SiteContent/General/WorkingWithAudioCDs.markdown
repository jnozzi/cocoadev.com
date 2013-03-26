

Hello -


I am developing a media player application, and wish to implement Audio CD handling and playback. I have a method that will theoretically work, however I would like to ensure that this method is the most efficient, since I can't find particularly clear information on the subject.


Possible method:
1. Detect volume mount with [[NSWorkspace]]
2. Check for presence of invisible .TOC.plist file created by Mac OS X's CDDA filesystem handler
3. List the contents of the CD alphabetically, then play back each track by opening the illusionary .aiff files using Quicktime


Are there any better ways (for example, a system notification of Audio CD insertion)? Also, any other suggestions related to working with Audio [[CDs]] is welcomed (even to the extent of CDDB/[[FreeDB]] functionality).

Thanks!

----
CDDB access costs money unless you're releasing a freeware app; [[FreeDB]] unfortunately has shut down.

----

If your app is for 10.4 and up, you can use the [[DiskArbitration]] framework.  To do this, you need to create a [[DASession]] that you will use as your context for all calls to the framework.

To do this, and to register for mount and unmount notifications:

<code>
// Only request mount/unmount information for audio [[CDs]]
[[NSDictionary]] ''match = [[[NSDictionary]] dictionaryWithObjects:[[[NSArray]] arrayWithObjects:@"[[IOCDMedia]]", [[[NSNumber]] numberWithBool:YES], nil] forKeys:[[[NSArray]] arrayWithObjects:([[NSString]] '')kDADiskDescriptionMediaKindKey, kDADiskDescriptionMediaWholeKey, nil]];
		
_session = [[DASessionCreate]](kCFAllocatorDefault);
[[DASessionScheduleWithRunLoop]](_session, [[CFRunLoopGetCurrent]](), kCFRunLoopDefaultMode);
[[DARegisterDiskAppearedCallback]](_session, ([[CFDictionaryRef]])match, diskAppearedCallback, NULL);
[[DARegisterDiskDisappearedCallback]](_session, ([[CFDictionaryRef]])match, diskDisappearedCallback, NULL);
</code>

Then, when a disc is mounted (or your app is first launched), diskApperaredCallback will be called.

In my code I have a singleton object that handles the mount/unmount notifications, so I don't use the context above.  It would be normal practice to pass self.  When your callback is invoked, you can use [[DADiskGetBSDName]]() to get the device name, and then use the DKIOCD'' ioctls for accessing the disc's TOC and audio data (and subchannel data if desired).  For example, the following code is the kind of thing you could do to open a CD and read the TOC.  I omitted any error checking for brevity.

<code>
const char ''bsdName = [[DADiskGetBSDName]](disk); // disk comes from the diskAppearedCallback
int fd = opendev(bsdName, O_RDONLY | O_NONBLOCK, 0, NULL);

dk_cd_read_toc_t cd_read_toc;
uint8_t buffer [2048];
	
bzero(&cd_read_toc, sizeof(cd_read_toc));
bzero(buffer, sizeof(buffer));
	
cd_read_toc.format = kCDTOCFormatTOC;
cd_read_toc.buffer = buffer;
cd_read_toc.bufferLength = sizeof(buffer);
	
int result = ioctl(fd, DKIOCCDREADTOC, &cd_read_toc);

// Read the descriptors
close(fd);
</code>

Finally, when you're finished, clean up:

<code>
[[DAUnregisterCallback]](_session, diskAppearedCallback, NULL);
[[DAUnregisterCallback]](_session, diskDisappearedCallback, NULL);
[[DASessionUnscheduleFromRunLoop]](_session, [[CFRunLoopGetCurrent]](), kCFRunLoopDefaultMode);
[[CFRelease]](_session);
</code>

-sbooth