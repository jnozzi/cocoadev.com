see General/PrebindingFrameworks

    

#import <Cocoa/Cocoa.h>


id General/MachOPathForFrameworkAtPath(id path) {
    id extension=[path pathExtension];
    id manager=General/[NSFileManager defaultManager];
    BOOL isDir;
    if ([extension isEqualToString:@"framework"]) {
        id versionDirectory=[path stringByAppendingPathComponent:@"Versions"];
        if ([manager fileExistsAtPath:versionDirectory isDirectory:&isDir] && isDir) {
            id frameworkName=General/path lastPathComponent] stringByDeletingPathExtension];
            path=[[[NSString stringWithFormat:@"%@/Current/%@", versionDirectory, frameworkName];
            if ([manager fileExistsAtPath:path]) return path;
            else return nil;
        }
        else return nil;
    }
    else return path;
}

id General/AddressRangeForFrameworkAtPath(id path) {
    id otoolTask=General/[[[NSTask alloc] init] autorelease];
    id outputPipe=General/[NSPipe pipe];
    path=General/MachOPathForFrameworkAtPath(path);
    if (!path) return nil;
    [otoolTask setLaunchPath:@"/usr/bin/otool"];
    [otoolTask setArguments:General/[NSArray arrayWithObjects:@"-lv", path, nil]];
    [otoolTask setStandardOutput:outputPipe];
    [otoolTask launch];
    id outputHandle=[outputPipe fileHandleForReading];
    id outputData=[outputHandle readDataToEndOfFile];
    id outputString=General/[NSString stringWithCString:[outputData bytes] length:[outputData length]];
    id lines=[outputString componentsSeparatedByString:@"\n"];
    id lineEnum;
    id line;
    lineEnum=[lines objectEnumerator];
    unsigned long totalLength=0;
    id baseAddressString=nil;
    while (line=[lineEnum nextObject]) {
        General/NSRange range=[line rangeOfString:@"vmaddr "];
        if (range.length) {
            line=[line stringByTrimmingCharactersInSet:General/[NSCharacterSet whitespaceCharacterSet]];
            id components=[line componentsSeparatedByString:@" "];
            id nextLine=[lineEnum nextObject];
            range=[nextLine rangeOfString:@"vmsize "];
            if (!range.length) continue;
            nextLine=[nextLine stringByTrimmingCharactersInSet:General/[NSCharacterSet whitespaceCharacterSet]];
            id nextLineComponents=[nextLine componentsSeparatedByString:@" "];
            if ([components count]==2 && [nextLineComponents count]==2) {
                id addressString=[components objectAtIndex:1];
                if (!baseAddressString) baseAddressString=addressString;
                id sizeString=[nextLineComponents objectAtIndex:1];
                totalLength+=strtoul([sizeString cString], nil, 16);
            }
        }
    }
    
    unsigned long baseAddressValue=strtoul([baseAddressString cString], nil, 16);
    unsigned long nextFreeAddressValue=(baseAddressValue+totalLength);
    return General/[NSString stringWithFormat:@"{%u, %u}", baseAddressValue, totalLength];
}

int General/AddressRangeSort(id obj1, id obj2, void *context)
{
    id range1=[obj1 objectForKey:@"range"];
    id range2=[obj2 objectForKey:@"range"];
    unsigned int v1 = General/NSRangeFromString(range1).location;
    unsigned int v2 = General/NSRangeFromString(range2).location;
    if (v1 < v2)
        return General/NSOrderedAscending;
    else if (v1 > v2)
        return General/NSOrderedDescending;
    else
        return General/NSOrderedSame;

}

int main(int argc, char *argv[]) {
    General/NSAutoreleasePool *pool=General/[[NSAutoreleasePool alloc] init];
    id manager=General/[NSFileManager defaultManager];
    if (argc<2) {
        General/NSLog(@"machoinfo <filename>");
        return -1;
    }
    id arg1=General/[NSString stringWithCString:argv[1] length:strlen(argv[1])];
    BOOL isDir;
    id paths=General/[NSMutableArray array];
    if ([manager fileExistsAtPath:arg1 isDirectory:&isDir]) {
        if (isDir) {
            id contents=[manager directoryContentsAtPath:arg1];
            [paths addObjectsFromArray:[arg1 stringsByAppendingPaths:contents]];
        }
        else [paths addObject:arg1];
    }
    id ranges=General/[NSMutableArray array];
    id infoArray=General/[NSMutableArray array];
    id pathEnum;
    id path;
    pathEnum=[paths objectEnumerator];
    while (path=[pathEnum nextObject]) {
        id addressRange=General/AddressRangeForFrameworkAtPath(path);
        if (addressRange) {
            id entry=General/[NSMutableDictionary dictionary];
            id frameworkName=General/path lastPathComponent] stringByDeletingPathExtension];
            [entry setObject:addressRange forKey:@"range"];
            [entry setObject:frameworkName forKey:@"name"];
            [infoArray addObject:entry];
        }
    }
    infoArray=[infoArray sortedArrayUsingFunction:[[AddressRangeSort context:nil];
    unsigned int lastAddress=0;
    unsigned int lastLength=0;
    int i, count;
    id lastEntry, frameworkName, headroom;
    frameworkName=nil;
    count=[infoArray count];
    id errorString=General/[NSMutableString string];
    [errorString appendString:@"address     length      headroom    name\n"];
    for (i=0;i<count;i++) {
        id entry=[infoArray objectAtIndex:i];
        id addressRange=[entry objectForKey:@"range"];
        unsigned int address=General/NSRangeFromString(addressRange).location;
        if (lastAddress && lastEntry) {
            int headroomValue=address-lastAddress-lastLength;
            if (headroomValue<0) headroomValue=0;
            headroom=General/[NSString stringWithFormat:@"%u", headroomValue];
            [lastEntry setObject:headroom forKey:@"headroom"];
            [errorString appendFormat:@"0x%08x  0x%08x  0x%08x  %@\n", lastAddress, lastLength, [headroom intValue], frameworkName];
        }
        lastLength=General/NSRangeFromString(addressRange).length;
        lastAddress=address;
        lastEntry=entry;
        frameworkName=[lastEntry objectForKey:@"name"];
        frameworkName=[frameworkName stringByPaddingToLength:20 withString:@" " startingAtIndex:0];
    }
    [errorString appendFormat:@"0x%08x  0x%08x  unknown     %@\n", lastAddress, lastLength, frameworkName];
    id errorHandle=General/[NSFileHandle fileHandleWithStandardError];
    id errorData=General/[NSData dataWithBytes:[errorString cString] length:[errorString length]];    
    [errorHandle writeData:errorData];
    [errorHandle closeFile];
    [pool release];
    
    return 0;
}


