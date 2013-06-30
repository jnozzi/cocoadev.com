General/CFHost allows you to asynchronously resolve a name or address without the main thread blocking. General/CFNetwork will spawn the thread for you in the background and fire a notification back to the main thread once it acquires the information.


    

-(void)connectTo: (General/NSString *)address {
    BOOL success = NO;
    
    General/CFHostClientContext hostContext;
    
    hostContext.version = 0;
    hostContext.info = self;
    hostContext.retain = nil;
    hostContext.release = nil;
    hostContext.copyDescription = nil;
    
    General/CFStreamError error;
    
    General/CFHostRef host = General/CFHostCreateWithName(kCFAllocatorDefault, (General/CFStringRef)address);
    success = General/CFHostSetClient(host, _network_host_callback, hostContext);
    General/CFHostScheduleWithRunLoop(host, General/CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    
    success = General/CFHostStartInfoResolution(host, kCFHostAddresses, &error);
}

