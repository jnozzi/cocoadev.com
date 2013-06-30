I'm writing an app that makes digests of Slashdot posts. To download a story from Slashdot, I'm using the following code:

    
- (General/IBAction)gather:(id)sender
{
	General/NSString *storyText;
	General/NSString *storyAddr;
	NSURL *storyUrl;

	storyAddr = [storyUrlField stringValue];
	
	General/NSLog(@"String: {%@}", storyAddr);
	
	storyUrl  = [NSURL General/URLWithString:storyAddr];
	
	General/NSLog(@"Story URL: {%@}", storyUrl);
	
	storyText = General/[NSString stringWithContentsOfURL:storyUrl];
	
	General/NSLog(@"Story data: {%@}", storyText);
}


Addresses like http://www.slashdot.org work fine, but for a full story address, such as...
http://slashdot.org/comments.pl?sid=121818&threshold=-1&mode=nested&commentsort=0&op=Change

...dont work. The General/NSLog'ings of **storyAddr** and **storyUrl** look fine, but the General/NSLog'ing of **storyText** simply produces:

Story data: {���

Note the lack of closing brace also. Does anyone have any idea what I am doing wrong here?

----

Most likely the slashdot server is returning a compressed (gzipped) page. You'd have to gunzip it.

-john t

----

in which case, of course, you should be using dataWithContentsOfURL: - or, better yet, some lower-level way of accessing the page which tells you the Content-Type and Content-Transfer-Encoding. *--boredzo*


----

A buddy of mine and I (mostly him) took just took on this problem and I think we got a pretty good solution.  Here's the General/NSString category; just make an empty .h file for it and add it to your project and you don't even have to change your existing code:

    

@implementation General/NSString (General/GzipAwareString)

+ (General/NSString *)stringWithContentsOfURL:(NSURL *)url
{
    General/NSString    *string;
    
    string = General/[[NSString alloc] initWithData:General/self class] gunzipedDataFromData:[[[NSData dataWithContentsOfURL:url]] encoding:General/NSASCIIStringEncoding];
    
    return [string autorelease];        
}

+ (General/NSData *)gunzipedDataFromData:(General/NSData *)compressedData
{
    General/NSTask  *gunzip;
    General/NSPipe  *compressedDataPipe, *uncompressedDataPipe;
    
    // you probably want to verify that the data is indeed compressed here (otherwise return compressedData)
    
    General/NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];
       
    gunzip = General/[[NSTask alloc] init];
    
    compressedDataPipe = General/[NSPipe pipe];
    uncompressedDataPipe = General/[NSPipe pipe];
    
    [gunzip setLaunchPath:@"/usr/bin/gunzip"];
    [gunzip setArguments:General/[NSArray arrayWithObject:@"-f"]];
    
    [gunzip setStandardInput:compressedDataPipe];
    [gunzip setStandardOutput:uncompressedDataPipe];
    
    [gunzip launch];
    
    General/NSFileHandle *writerHandle = [compressedDataPipe fileHandleForWriting];
    [writerHandle writeData:compressedData];
    
    [writerHandle closeFile];
    
    int maxToRead = (1024 * 1024);
    
    General/NSFileHandle    *readerFileHandle = [uncompressedDataPipe fileHandleForReading];
    General/NSMutableData   *uncompressedData = General/[NSMutableData data];
    
    do {
        General/NSData  *dataToRead;
        
        dataToRead = [readerFileHandle availableData];
        
        if (dataToRead && [dataToRead length]) {
            [uncompressedData appendData:dataToRead];
        } else {
            break;
        }
        
    } while ([uncompressedData length] < maxToRead);
    
    [gunzip terminate];
    [gunzip release];
    
    General/NSData *newData = General/[[NSData alloc] initWithData:uncompressedData];
    [pool release];
    [newData autorelease];
    if (!newData || ![newData length]) newData = compressedData;
    return newData;
}


@end



-nsorscher