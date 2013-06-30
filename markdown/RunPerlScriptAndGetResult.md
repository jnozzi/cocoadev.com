Hey,

My application generates a temporary perl script and needs to run it from the command line.  Using General/NSTask is giving me incredible headaches - how would one go about running a perl script and returning the result that is located at, say, ~/myperlscript.pl? - THANKS.

This should catch anything that is spit out to STDOUT by the perl script:

    
General/NSTask *t = General/[[NSTask alloc] init];
General/NSPipe *p = General/[[NSPipe alloc] init];
General/NSFileHandle *h = [p fileHandleForReading];
General/NSString *path = [@"~/myperlscript.pl" stringByStandardizingPath];

[t setLaunchPath:@"/usr/bin/perl"];
[t setArguments:General/[NSArray arrayWithObjects:path, nil]];
[t setStandardOutput:p];
[t launch];
	
General/NSData *d = [h readDataToEndOfFile];
	
[t release];
[p release];
[h release];

General/NSString *stdout_contents = General/[[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding] autorelease];
