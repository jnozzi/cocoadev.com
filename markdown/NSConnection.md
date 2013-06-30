Describe General/NSConnection here.
For communication between threads, and in particular to General/AppKit, see: http://lachand.free.fr/cocoa/Threads.html 

----

Here's a simple example that shows how to use an General/NSConnection to communicate between processes.

**Server Object Methods**

    

-(void)awakeFromNib {
    General/NSConnection *serverConnection=General/[NSConnection defaultConnection];
    [serverConnection setRootObject:self];
    [serverConnection registerName:@"General/SimpleServerConnection"];

}

-(General/NSString *)request:(General/NSString *)request {
    id reply=General/[NSString stringWithFormat:@"server has received request: %@", request];
    General/NSLog(reply);
    return reply;
}



**Client Object Method**

    

- (General/IBAction)go:(id)sender
{
    General/NSProxy *proxy=General/[NSConnection rootProxyForConnectionWithRegisteredName:@"General/SimpleServerConnection" host:nil];
    id reply=[proxy request:@"echo this"];
    General/NSLog(reply);
}



--zootbobbalu

----
Using the defaultConnection is a good quick way to make temporary connections, however it is more reliable to initialize your own, as the defaultConnection's rootProxy can be overwritten by anything, namely Input Managers. In the case of Growl, the Logitech Input Manager overwrote the rootProxy of the defaultConnection preventing Growl from receiving notifications. This was bad practise on Logitech's part, but it shows that it's a good idea to protect your connections by owning them yourself.
----

----

How to deregister an General/NSConnection from the General/NSPortNameServer.  Trying to find a way to use the same name twice (in serial, not overlappingly), I tried every method and class in the threading book.  Let's say you've got this class method, which presumably gets called everytime a user clicks a button.

    

#import "General/MyObject.h"

@implementation General/MyObject

- (General/IBAction)newThread:(id)sender
{
	General/[NSThread detachNewThreadSelector:@selector(detachSubthread) toTarget:self withObject:nil];
}

- (void)detachSubthread
{
    General/NSAutoreleasePool*  pool = General/[[NSAutoreleasePool alloc] init];
    
    General/NSConnection *serverConnection = General/[NSConnection defaultConnection];
		[serverConnection setRootObject:self];
    if ( [serverConnection registerName:@"General/SimpleServerConnection"] ) {
        General/NSLog( @"Thread: successfully registered connection with port %@", 
			   [serverConnection receivePort] );
    } else {
        General/NSLog( @"Thread: name occupied by %@", 
			   General/[[NSPortNameServer systemDefaultPortNameServer] portForName:@"General/SimpleServerConnection"] );
    }

    //[self deregister];	

    [pool release];
}



Click the button once, and you'll see the first log.  All subsequest clicks show the second log.  Even though the thread is long since dead and gone, its default connection remains registered with that name (as evidenced by the description of the registered port in the log).  
Remove the comment tag from the deregister method.  The correct way to invalidate the connection seems to be to go inside of the connection and individually invalidate its ports.  You can't just send the connection an -invalidate message, or tell the General/NSPortNameServer to remove the name; it refuses.  Nor will removing this from the runtime loop, having it remove itself from the runtime, or registering it under a different name or nil.

    

- (void)deregister
{
	General/[[[NSConnection defaultConnection] receivePort] invalidate];
}

@end



--Stephen