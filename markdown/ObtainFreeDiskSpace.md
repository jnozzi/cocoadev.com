
I am looking for some function calls(cocoa/carbon or bsd) to obtain the free disk space on a machine.

~J

----

How about this:

    
General/OSErr General/FSGetVInfo(
  General/FSVolumeRefNum volume,
  HFSUniStr255 *volumeName,  /* can be NULL */
  UInt64 *freeBytes,      /* can be NULL */
  UInt64 *totalBytes)      /* can be NULL */
{
  General/OSErr        result;
  General/FSVolumeInfo    info;
  
  /* ask for the volume's sizes only if needed */
  result = General/FSGetVolumeInfo(volume, 0, NULL,
    (((NULL != freeBytes) || (NULL != totalBytes)) ? kFSVolInfoSizes : kFSVolInfoNone),
    &info, volumeName, NULL);
  require_noerr(result, General/FSGetVolumeInfo);
  
  if ( NULL != freeBytes )
  {
    *freeBytes = info.freeBytes;
  }
  if ( NULL != totalBytes )
  {
    *totalBytes = info.totalBytes;
  }
  
General/FSGetVolumeInfo:

  return ( result );
}


OK, so I cribbed it from General/MoreFilesX found at http://developer.apple.com/samplecode/General/MoreFilesX/listing2.html

Use the search function: General/DiskSpace

----

I use this modified from the General/DiskSpace

    
+ (unsigned)freeDiskSpace:(General/NSString*)path {
    unsigned long long sizeValue;
	General/NSNumber *keyValue;
    General/NSString *fullPath = [path stringByStandardizingPath];
    if (fullPath) {
		General/NSFileManager *fm = General/[NSFileManager defaultManager];
        if (fm) {
            General/NSDictionary *fileSystemAttributes = [fm fileSystemAttributesAtPath:fullPath];
            if (fileSystemAttributes && [fileSystemAttributes count]) {
				keyValue = [fileSystemAttributes objectForKey:General/NSFileSystemFreeSize];
                if (keyValue) {
                    sizeValue = [keyValue unsignedLongLongValue];
                    General/NSLog(@"The current free space on the volume containing \"%@\" is %qu", fullPath, sizeValue);
					return sizeValue; 
                }
            }
        }
    }
	return 0;
}


~J