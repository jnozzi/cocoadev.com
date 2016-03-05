

Here's a couple of methods for creating a report on the performance of random disk access on a single file. I ran this test on a dual 1.8 G5, but I wouldn't mind getting some help on building a database of performance results for other setups. I posted a summary of my results in the form of tab delimited table data here RandomDiskAccessSingleFileTestResults. This table data was generated by the method     tabDelimitedTableDataFromReport and saved to file in the method     randomDiskAccessTest. The summary table shows that for my system you can read 65k blocks before you start to see average seek times increase as a function of the block size. I'm wondering how much this threshold varies from system to sytem. The test was run on a file larger than 500MB, so the only requirement for the test will be for a file size greater than 500MB.

If you would like to help out, please add your test results to RandomDiskAccessSingleFileTestResults. --zootbobbalu

*I noticed that OS X will cache large amounts of disk access in RAM, so if you have touched the test file (e.g. the file has just been copied or moved across volumes) before performing this test you will get inaccurate results. The only way to be sure that the test file is not in RAM is to reboot or to copy a file larger than the amount of installed RAM (the first choice is probably better).*

**Conclusion**

After plotting the data for two different setups, I noticed how well the curves match the reported specs for two different drives. Both drives have average seek times of 8.5 ms and both drives have an average sustained transfer rate of around 60MB/s. These two values show up nicely in the test results. Since an average sustained transfer rate of 60MB/s is about 60k/ms this would explain why 65k block reads was showing up as a threshold in both test results. I guess a general rule of thumb for figuring out the maximum block size to read for a random disk access is to just multiply the sustained transfer rate by ten percent of the average seek time. I'm using ten percent because I figure this is where the average seek time becomes a second order influence and the sustained transfer rate becomes a first order influence.  

    
- (NSString *)tableDataFromReport:(NSArray *)report usingKeys:(NSArray *)keys {
	int i, count = [report count];
	NSMutableString *table = [NSMutableString stringWithCapacity:4096];
	for (i = -1; i < count; i++) {
		NSDictionary *entry = (i == -1) ? nil : [report objectAtIndex:i];
		unsigned int ii, count_count = [keys count];
		for (ii = 0; ii < count_count; ii++) {
			NSString *key = [keys objectAtIndex:ii];
			[table appendFormat:@"%@\t", (i == -1) ? key : [entry objectForKey:key]];
		}
		[table appendString:@"\n"];
	}
	return table;
}

- (void)flushDiskCache {
	NSFileManager *manager = [NSFileManager defaultManager];
	NSAutoreleasePool *innerPool = [[NSAutoreleasePool alloc] init];
	NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:@"/Applications"];
	NSString *subpath;
	int bytesRead = 0; 
	while (subpath = [dirEnum nextObject]) {
		BOOL isDir;
		NSString *file = [@"/Applications" stringByAppendingPathComponent:subpath];
		if ([manager fileExistsAtPath:file isDirectory:&isDir] && isDir) continue;
		NSData *data = [NSData dataWithContentsOfFile:file];
		bytesRead += [data length];
		[data writeToFile:@"/tmp/temp" atomically:YES];
		if (bytesRead > 33554432) {
			NSLog(@"<%p>%s: bytes flushed: %i", self, __PRETTY_FUNCTION__, bytesRead);
			break;
		}
	}
	[innerPool release];	
}

- (void)randomDiskAccessTest {
	int bufferSize = 1 << 20;
	NSMutableData *buffer = [NSMutableData dataWithLength:bufferSize];
	char *buf = [buffer mutableBytes]; 
	int blockSize = 512, blockCount = 0;
	NSTimeInterval startTime, time;
	unsigned long long fileSize = 0;
	NSMutableArray *report = [NSMutableArray array];
	sranddev();	
	for (blockSize = 1 << 1; blockSize <= bufferSize; blockSize <<= 1) {	
		[self flushDiskCache];
		int fd = open([path UTF8String], O_RDONLY, nil);
		if (fd == -1) continue;
		fileSize = lseek(fd, 0, SEEK_END);
		int i, bytesRead = 0;
		blockCount = fileSize / blockSize;
		unsigned long long offsets[RandomDiskAccessReadCount];
		unsigned long long min = fileSize, max = 0;
		startTime = [NSDate timeIntervalSinceReferenceDate];
		for (i = 0; i < RandomDiskAccessReadCount; i++) {
			unsigned long long block = rand() % blockCount;
			offsets[i] = lseek(fd, block * blockSize, SEEK_SET);
			if (offsets[i] > max) max = offsets[i];
			if (offsets[i] < min) min = offsets[i];
			bytesRead += read(fd, buf, blockSize);
		}
		time = [NSDate timeIntervalSinceReferenceDate] - startTime;
		NSMutableString *offsetInfo = [NSMutableString stringWithCapacity:RandomDiskAccessReadCount * 16];
		NSMutableString *histogram = [NSMutableString stringWithCapacity:16 * 16];
		int dist[10];
		for (i = 0; i < 10; i++) dist[i] = 0;
		for (i = 0; i < RandomDiskAccessReadCount; i++) {
			[offsetInfo appendFormat:@"%qi ", offsets[i]];
			float normOffset = (float)offsets[i] / (float)fileSize;
			if (normOffset > 0.99f) normOffset = 0.99f;
			dist[(int)(normOffset * 10.0f)]++;
		}
		[histogram appendString:@"bucket[0, 1, 2, 3, 4, 5, 6, 7, 8, 9] = ["];
		for (i = 0; i < 10; i++) [histogram appendFormat:@"%i, ", dist[i]];
		[histogram deleteCharactersInRange:NSMakeRange([histogram length] - 2, 2)];
		[histogram appendString:@"]"];
		NSMutableDictionary *entry = [NSMutableDictionary dictionary];
		[entry setObject:offsetInfo forKey:@"offsets"];
		[entry setObject:histogram forKey:@"histogram"];
		[entry setObject:[NSNumber numberWithDouble:time] forKey:@"time"];
		[entry setObject:[NSNumber numberWithDouble:time / (float)RandomDiskAccessReadCount] 
				forKey:@"average seek time"];
		[entry setObject:[NSNumber numberWithInt:bytesRead] forKey:@"bytesRead"];
		[entry setObject:[NSNumber numberWithInt:blockSize] forKey:@"blockSize"];
		[entry setObject:[NSNumber numberWithInt:blockCount] forKey:@"blockCount"];
		[entry setObject:[NSNumber numberWithInt:min] forKey:@"minSeek"];
		[entry setObject:[NSNumber numberWithInt:max] forKey:@"maxSeek"];
		[entry setObject:[NSNumber numberWithInt:RandomDiskAccessReadCount] forKey:@"readCount"];
		[report addObject:entry];
		close(fd);
		NSLog(@"<%p>%s: %@", self, __PRETTY_FUNCTION__, [entry description]);
	}
	[report writeToFile:@"/tmp/RandomDiskAccessReport.plist" atomically:YES];
	NSArray *keys = [NSArray arrayWithObjects:@"blockSize", @"average seek time", @"bytesRead", nil];
	NSString *table = [self tableDataFromReport:report usingKeys:keys];
	NSLog(@"<%p>%s: table: %@", self, __PRETTY_FUNCTION__, table);
	[table writeToFile:@"/tmp/RandomDiskAccessSummary.txt" atomically:YES];

}
