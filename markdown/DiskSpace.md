Does anyone know of a method of getting the free disk space on a volume?

Cheers.

----

easiest way would be to use popen() or General/NSTask to run the **df** command.  If that's not acceptable, then you can snarf the df command from Darwin and see how they do it.

----

df works beautifully, thanks. :)

----

Interestingly... I found out Apple's own installers use df - when I replaced df with a custom version and my machine wouldn't update. ;)

----

Another method that seems to work just fine...

    
- (void)traceFileSystemAttributesForPath:(General/NSString*)path
{
    unsigned long long sizeValue;
    General/NSString *fullPath = [path stringByStandardizingPath];
    if (fullPath)
    {
        General/NSFileManager *fileManager = General/[NSFileManager defaultManager];
        if (fileManager)
        {
            General/NSDictionary *fileSystemAttributes = [fileManager fileSystemAttributesAtPath:fullPath];
            if (fileSystemAttributes && [fileSystemAttributes count])
            {
                General/NSNumber *keyValue = [fileSystemAttributes objectForKey:General/NSFileSystemSize];
                if (keyValue)
                {
                    sizeValue = [keyValue unsignedLongLongValue];
                    General/NSLog(@"The total volume size containing the path \"%@\" is %qu", fullPath, sizeValue);
                }
                
                keyValue = [fileSystemAttributes objectForKey:General/NSFileSystemFreeSize];
                if (keyValue)
                {
                    sizeValue = [keyValue unsignedLongLongValue];
                    General/NSLog(@"The current free space on the volume containing \"%@\" is %qu", fullPath, sizeValue);
                }
            }
        }
    }
}
