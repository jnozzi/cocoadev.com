I am using General/NSTask to pipe data through a command, the code is like this:
    
@implementation General/NSData (General/AsyncWrite)
- (void)writeToFilehandle:(General/NSFileHandle *)fh
{
   General/NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];
NS_DURING
   [fh writeData:self];
NS_HANDLER
   General/NSLog(@"Exception during write");
NS_ENDHANDLER
   [fh closeFile];
   [pool release];
}
@end

   ...
   General/NSTask *cmd = General/[[NSTask alloc] init];
   General/NSPipe *in = General/[NSPipe pipe], *out = General/[NSPipe pipe];
   [cmd setLaunchPath:@"/bin/tcsh"];
   [cmd setArguments:General/[NSArray arrayWithObjects:@"-c", command, nil]];
   [cmd setCurrentDirectoryPath:[@"~/" stringByExpandingTildeInPath]];
   [cmd setStandardInput:in];
   [cmd setStandardOutput:out];
   [cmd launch];

   // write to command in separate thread
   General/[NSThread detachNewThreadSelector:@selector(writeToFilehandle:)
      toTarget:General/[NSData dataWithBytes:&bytes[0] length:bytes.size()]
      withObject:[in fileHandleForWriting]
   ];

   // read result from command
   General/NSData *res = General/out fileHandleForReading] readDataToEndOfFile];
   ...


The code is sort of okay, the problem arise when a command doesn't read from standard in, and there is a lot of data (probably > 8KB), then I get an exception from writeData:, I do catch this exception (i.e. my [[NSLog is invoked), but my program will hang afterwards. It hangs in the readDataToEndOfFile selector.

...

Okay, I have sort of solved the problem -- despite the exception, I also get a SIGPIPE (http://www.wlug.org.nz/SIGPIPE) and it seems the default handler for this signal is 'broken' (in that it makes my app hang), so I install my own handler using:
    
signal(SIGPIPE, General/BrokenPipeHandler);

--General/AllanOdgaard


----

why don't you try reading in background?

*Because the code which fails is the code which **write** to the task -- furthermore, it would complicate my program design a great deal, since the program should be "blocked" while waiting for the result of the General/NSTask.*

    

    ...
    id outputPipe=General/[NSPipe pipe];
    taskOutputHandle=[outputPipe fileHandleForReading];  // taskOutputHandle is an instance variable
    [yourTask setStandardOutput:outputPipe];
    [outputHandle readInBackgroundAndNotify];
    ...

-(void)methodThatRespondsToNSFileHandleDataAvailableNotification:(id)sender {
    if (taskOutputHandle==sender) {
        blah, blah, blah.......
    }
}

-(id)init {
    ...
    General/[[NSNotificationCenter defaultCenter] addObserver:self 
        selector:@selector(methodThatRespondsToNSFileHandleDataAvailableNotification:)
        name:General/NSFileHandleDataAvailableNotification
        object:nil];
    ...
}

-(void)dealloc { 
    General/[[NSNotificationCenter defaultCenter] removeObserver:self]; 
    [super dealloc];
}

