

Hello my dear comrades.

I'm trying to create a [[NSPipe]] subclass that automatically reads everything written to it into a supplied [[NSMutableString]].
    The problem is that as soon as i call <code>[self fileHandleForReading]</code> my whole call stack disappears (I'm not 100% sure of the terminology here), and i end upp in some obscure function called by [[NSNotificationCenter]] (<code>_nsnote_callback()</code>).
The code is written like this:

<code>

@interface [[ReadOutputPipe]] : [[NSPipe]] {
    [[NSMutableString]] ''output;
    [[NSArray]] ''modes;
    
    [[NSFileHandle]] ''fileHandle;
}

#pragma mark Initializers

+ (id)pipeWithReadOutput:([[NSMutableString]] '')outputString forModes:([[NSArray]] '')runLoopModes;
- (id)initWithReadOutput:([[NSMutableString]] '')outputString forModes:([[NSArray]] '')runLoopModes;


#pragma mark [[NSFileHandle]] Notifications

- (void)fileHandleDidCompleteReading:([[NSNotification]] '')aNotification;

@end

@implementation [[ReadOutputPipe]]

#pragma mark Initializers

+ (id)pipeWithReadOutput:([[NSMutableString]] '')outputString forModes:([[NSArray]] '')runLoopModes {
    return [[[self alloc] initWithReadOutput:outputString forModes:runLoopModes] autorelease];
}
- (id)initWithReadOutput:([[NSMutableString]] '')outputString forModes:([[NSArray]] '')runLoopModes {
    if (self = [super init]) {
        output = [outputString retain];
        modes = [runLoopModes copy];
        
        fileHandle = [self fileHandleForReading];
        
        [notificationCenter addObserver:self
                               selector:@selector(fileHandleDidCompleteReading:)
                                   name:[[NSFileHandleReadCompletionNotification]]
                                 object:fileHandle];
        
        [fileHandle readInBackgroundAndNotifyForModes:modes];
    }
    
    return self;
}
- (void)dealloc {
    [notificationCenter removeObserver:self];
    
    [output release];
    [modes release];
    
    [super dealloc];
}


#pragma mark [[NSFileHandle]] Notifications

- (void)fileHandleDidCompleteReading:([[NSNotification]] '')aNotification {
    [[NSData]] ''readData = [[aNotification userInfo] valueForKey:[[NSFileHandleNotificationDataItem]]];
    
    // an empty data object means EOF, so until we get that we just keep requesting more
    //
    if ([readData length]) {
        [[NSString]] ''latestOutput = [[[[[NSString]] alloc] initWithData:readData encoding:NSUTF8StringEncoding] autorelease];
        
        [output appendString:latestOutput];
        
        [fileHandle readInBackgroundAndNotifyForModes:modes];
    }
}

@end

</code>

All help is welcomed.

/Mr Fisk

----

Actually, looking it through in the debugger yet again, I see that the call stack is just reverted back to just before my <code>[[[[NSApp]] delegate] applicationWillFinishLaunching:]</code> method is called, but there's no clues whatsoever in the debugger console.

/Mr Fisk

----

It seems like a very odd choice to make this an [[NSPipe]] subclass. This seems like the right time to write something with a has-a relationship, where you write a custom class which has an [[NSPipe]] instance variable, rather than an is-a relationship where you subclass.

In any case, can you post the stack trace and tell us which line the crash occurs on, if it is indeed crashing? If it's not crashing, what exactly is the problem?

----

The reason for making it a subclass of [[NSPipe]] is that then you can pass it to, for example, <code>-[[[NSTask]] setStandardOutput:]</code> and then just parse the string. I don't really see how this is bad design, since the original function of [[NSPipe]] is still maintained, but you get a [[NSMutableString]] instead of the [[NSFileHandle]].
Like I explained before, it doesn't crash the application, but it jumps back in the call stack to where <code>[[[[NSApp]] delegate] applicationWillFinishLaunching:]</code> gets called, with no error logs at all. I tried stepping into <code>-[self fileHandleForReading]</code>, but it still does the same thing.

----

Are you sure that this is an actual program flow problem and not just a debugger problem? Have you tried inserting [[NSLog]] statements to see exactly what the program flow is like? What does your applicationWillFinishLaunching: method look like?

----

Ah, got it now, [[NSPipe]] is an abstract class etc etc..
seems like xCode 2.1 doesn't print log output to the debugger console like the older versions used to. Because they did use to do that, right? I haven't done any coding for a couple of months, so it might just be me being stupid.

''Used to and still does. You're either doing something wrong, or your Xcode is broken. Which window the output appears in depends on whether you're running or debugging; are you sure you're looking at the right one?''

Anyway, the docs don't say anything about [[NSPipe]] being an abstract class, they should right? And, if they are in fact lacking, you're supposed to file a bug report?

''Yes they should, and yes you should. The easiest way is probably to just use the feedback section at the bottom of the docs page, which is what I'm going to do.''

----

Just for public interest, here's the final code for the class. It doesn't work in quite the same way, since i realized that you can't convert the read data to a utf8-encoded string due to variable length characters (what if you just got the first byte of two?)

<code>

@interface [[WritableBufferPipe]] : [[NSPipe]] {
    int readDescriptor;
    [[NSFileHandle]] ''writeHandle;
    
    [[NSMutableData]] ''buffer;
    [[NSLock]] ''bufferLock;
}

#pragma mark Actions

- (void)readDataToEndOfFile;


#pragma mark Accessors

- ([[NSData]] '')buffer;

@end

@implementation [[WritableBufferPipe]]

#pragma mark Initializers

+ (id)pipe {
    return [[[self alloc] init] autorelease];
}
- (id)init {
    if (self = [super init]) {
        int fileDescriptors[2];
        
        if (0 != pipe(fileDescriptors)) {
            [self release];
            return nil;
        }
        
        readDescriptor = fileDescriptors[0];
        
        writeHandle = [[[[NSFileHandle]] alloc] initWithFileDescriptor:fileDescriptors[1]
                                                    closeOnDealloc:YES];
        
        buffer = [[[[NSMutableData]] alloc] init];
        bufferLock = [[[[NSLock]] alloc] init];
        
        [[[NSThread]] detachNewThreadSelector:@selector(readDataToEndOfFile)
                                 toTarget:self
                               withObject:nil];
    }
    
    return self;
}
- (void)dealloc {
    close(readDescriptor);
    [writeHandle release];
    
    [buffer release];
    [bufferLock release];
    
    [super dealloc];
}


#pragma mark Actions

- (void)readDataToEndOfFile {
    [[NSAutoreleasePool]] ''autoreleasePool = [[[[NSAutoreleasePool]] alloc] init];
    
    char readBuffer[1024];
    int bytesRead = 0;
    
    while (bytesRead = read(readDescriptor, readBuffer, sizeof(readBuffer))) {
        [bufferLock lock];
        
        [buffer appendBytes:readBuffer length:bytesRead];
        
        [bufferLock unlock];
    }

    [autoreleasePool release];
}


#pragma mark Accessors

- ([[NSData]] '')buffer {
    [bufferLock lock];
    
    [[NSData]] ''bufferSnapshot =  [[buffer copy] autorelease];
    
    [bufferLock unlock];

    return bufferSnapshot;
}

- (id)fileHandleForReading {
    [[[NSException]] raise:[[NSInvalidArgumentException]]
                format:@"-fileHandleForReading cannot be sent to an instance of %@.", [self className]];

    return nil;
}

- (id) fileHandleForWriting {
    return writeHandle;
}

@end

</code>

/Mr Fisk

----

Thanks for posting the code, it looks nice. If you really needed the data to stream, rather than waiting for it all to accumulate, it wouldn't be that difficult to write a very basic UTF-8 parser that's just smart enough to know where the character breaks lie. Of course, if you don't need streaming, then there's no reason to go through that work.