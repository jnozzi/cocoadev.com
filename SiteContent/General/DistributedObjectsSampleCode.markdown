

From John Hornkvist (General/MacOsxDev mailing list):

    

Here is code that I know to work:

// General/DOTest.h

#import <Foundation/Foundation.h>

@interface Client:General/NSObject
{
         id serverObject;
}

- (void) connect;
- (void)log: (General/NSString*)string;
@end

@interface Server:General/NSObject
{
         General/NSConnection* serverConnection;
}
- (void)log: (General/NSString*)string;
- (void)serve;
- (General/NSConnection*) createConnectionName:(General/NSString*)name;
@end

----

// General/DOTest.m

#import "General/DOTest.h"


@implementation Client
- (void) connect
{
   serverObject=General/[NSConnection
rootProxyForConnectionWithRegisteredName:@"General/MyServer" host: nil];
}
- (void)log: (General/NSString*)string
{
         [serverObject log: string];
}

@end


@implementation Server

- (void)log: (General/NSString*)string
{
         General/NSLog(string);
}

- (void)serve
{
         serverConnection=[self createConnectionName:@"General/MyServer"];
         General/[[NSRunLoop currentRunLoop] run];
}
- (General/NSConnection*) createConnectionName:(General/NSString*)name
{
   General/NSConnection* newConnection=General/[[NSConnection alloc] init];
   if ([newConnection registerName:name])
     {
       [newConnection setRootObject:self];
     }
   else
     {
       [newConnection release];
       newConnection=nil;
     }
   return newConnection;
}

@end

----

// server.m

#import "General/DOTest.h"

main()
{
         General/NSAutoreleasePool* pool=General/[[NSAutoreleasePool alloc] init];
         Server* server=General/Server alloc] init];

         [server serve];

         [pool release];
}

----

// client.m

#import "[[DOTest.h"

main()
{
         General/NSAutoreleasePool* pool=General/[[NSAutoreleasePool alloc] init];
         Client* client=General/Client alloc] init];

         [client connect];
         [client log:@"Hello, world!"];

         [pool release];
}

----

To test:
cc -c -o [[DOTest.o General/DOTest.m
cc -o client client.m General/DOTest.o -framework Foundation
cc -o server server.m General/DOTest.o -framework Foundation

And then launch client in one Terminal window and Server in another. The
"Hello, world!" will be sent from the client and logged in the servers
window.

I tested this a moment ago, and it works perfectly.

Regards,
John Hornkvist


----
----

From Lloyd Sargent

Canna Software

lloyd AT cannasoftware DOT com

This is a distilled version of the above. The idea is that we have a main thread and
 a child thread (I do not include code to create the child thread). The problem is that
we want the child thread to have access to the main thread's methods (for example if
we need to pass information to it).

What is really nice about this is that it is thread-safe and relatively easy to set up. The
downside is remembering that the connection object MUST BE RETAINED in the child thread.
You snooze, you lose (and then you crash).

Note that it ONLY sends messages in ONE direction (in this case from the child thread to
the main thread).

    

@interface General/MainThread:General/NSObject
{
    General/NSConnection *destConnection;
}
- (void) General/YourMethod;
- (void) amessage;
@end


@implementation General/MainThread

- (void) General/YourMethod
{
    //----- now create the connection
    destConnection = General/[[NSConnection alloc] init];    // create connection object
    if ([destConnection registerName:@"Any Name You Want"])
    {
        [destConnection setRootObject: self];
        General/NSLog(@"General/DestConnection Created!");
    }
    else
    {
        [destConnection release];
        destConnection = nil;
        General/NSLog(@"General/DestConnection didn't get created");
    }

    //----- start General/ChildThread up

     //----- more code
}

- (void) amessage
{
    General/NSLog("Message for you sir!");
}
@end


@interface General/ChildThread : General/NSObject
{
    id srcConnection;
    // note: it is better you static type this to General/MainThread (or whatever your parent thread
    //      is named. You will avoid warning messages.
}
- (void) General/ChildThread;
@end

@implementation
- (void) General/ChildThread
{
    // MUST have this or you will leak!
    General/NSAutoreleasePool *localPool = General/[[NSAutoreleasePool alloc] init];

    //----- set up the proxy object so that we can directly talk to the General/MainThread
    srcConnection = General/[[NSConnection
        rootProxyForConnectionWithRegisteredName:@"Any Name You Want"
        host: nil] retain];
    // remember to retain any object you get - esp. if you will be in
    // a loop! We don't want to constantly make/break connections!

    // now we use it as if it were a General/MainThread object!
    [srcConnection amessage];
    // however, note that the communication is only child to main
    // ALSO note that this will give a warning unless you static type
    // srcConnection.

    [srcConnection release];    // remember to release it
    [localPool release];
}
@end



----

Some more Sample Code form Apple's Chris Kane:

Weeks ago now, there was discussion of using DO over TCP, and I said 
I'd write up an example.  Well, things are very busy here, and I 
finally got around to doing that only a couple days ago.  The example 
assumes you don't need DO explained.  It requires Mac OS X Public Beta 
or later.

The example is very simple, just a random number server.  With 
USE_SOCKETS equal to 0, it uses Mach ports, otherwise TCP sockets 
(General/NSSocketPort).  Compile with the comment at the top, and make a copy 
of the binary, and name one 'client' and one 'server'.

Run the server on the local machine or a remote one.  If the client is 
started without any arguments, it tries to connect to the server on the 
machine the client is running on.  Give it the name of the remote host 
if the server is running on another machine.  Remote only works for TCP 
socket transport.

The code is written to illustrate the differences in choosing a 
transport with as few differences as possible.  See the use of 
USE_SOCKETS in the server() function to see its differences.  The 
client "figures out" which style the server is using by trying Mach 
ports, then TCP sockets.  (I'm not saying real programs should do that.)

Real-world example: The Mac OS X build system is a complex system for 
farming out project builds to build servers and managing dependencies 
and whatnot, and it has used DO over TCP for some time, using its own 
hand-rolled TCP transport.  So DO over TCP is possible.  That system 
isn't using General/NSSocketPort yet (it predates General/NSSocketPort), but we'll be 
switching it to General/NSSocketPort sometime after Mac OS X is released, which 
will eliminate several hundreds of lines of code.  I've given the 
engineers that will do that this same example to work from.


Chris Kane
Cocoa Frameworks, Apple, Inc.

    

// cc -Wall -g -framework Foundation -O -o server do_test.m; cp server client

#import <Foundation/Foundation.h>

#if !defined(USE_SOCKETS)
 	#define USE_SOCKETS 1
#endif

@protocol General/ServerProtocol
- (void)setRandomSeed:(unsigned int)s;
- (long)getRandom;
@end

@interface Server : General/NSObject <General/ServerProtocol>
@end

@implementation Server

- (void)setRandomSeed:(unsigned int)s {
    srandom(s);
}

- (long)getRandom {
    return random();
}
@end

#define SERVER_PORT 15550
#define SERVER_NAME @"TEST"

void server(int argc, const char *argv[]) {
     General/NSPort *receivePort = nil;
     General/NSConnection *conn;
     id serverObj;

 #if USE_SOCKETS
     receivePort = General/[[NSSocketPort alloc] initWithTCPPort:SERVER_PORT];
 #else
     // Mach ports being "anonymous" and need to be named later
     receivePort = General/[[NSMachPort alloc] init];
 #endif
     conn = General/[[NSConnection alloc] initWithReceivePort:receivePort 
 sendPort:nil];
     serverObj = General/Server alloc] init];
     [conn setRootObject:serverObj];
 #if USE_SOCKETS
     // registration done by allocating the [[NSSocketPort
     printf("server configured to use sockets\n");
 #else
     if (![conn registerName:SERVER_NAME]) {
 	printf("server: set name failed\n");
 	exit(1);
     }
     printf("server configured to use Mach ports\n");
 #endif

     General/[[NSRunLoop currentRunLoop] run];
 }

 void client(int argc, const char *argv[]) {
     General/NSPort *sendPort = nil;
     General/NSConnection *conn;
     id proxyObj;
     long result;
     General/NSString *hostName = nil;

     if (1 < argc) {
 	hostName = General/[NSString stringWithCString:argv[1]];
     }

     sendPort = General/[[NSMachBootstrapServer sharedInstance] 
 portForName:SERVER_NAME host:hostName];
     if (nil == sendPort) {
 	// This will succeed (if host exists), even when there is no server
 	// on the other end, since the connect() is done lazily (arguably wrong),
 	// when first message is sent.
 	sendPort = General/[[NSSocketPort alloc] initRemoteWithTCPPort:SERVER_PORT 
 host:hostName];
     }
     if (nil == sendPort) {
 	printf("client: could not look up server\n");
 	exit(1);
     }
     NS_DURING
 	conn = General/[[NSConnection alloc] initWithReceivePort:(General/NSPort*)
              General/sendPort class] port] sendPort:sendPort];
 	proxyObj = [conn rootProxy];
     NS_HANDLER
 	proxyObj = nil;
     NS_ENDHANDLER
     if (nil == proxyObj) {
 	printf("client: getting proxy failed\n");
 	exit(1);
     }
     [proxyObj setProtocolForProxy:@protocol([[ServerProtocol)];
     printf("client configured to use %s\n", ([sendPort class] == 
 General/[NSSocketPort self]) ? "sockets" : "Mach ports");

     result = [proxyObj getRandom];
     printf("random #: %ld\n", result);
     result = [proxyObj getRandom];
     printf("random #: %ld\n", result);

     printf("\nset seed\n");
     [proxyObj setRandomSeed:17];
     result = [proxyObj getRandom];
     printf("random #: %ld\n", result);
     result = [proxyObj getRandom];
     printf("random #: %ld\n", result);

     printf("\nset seed\n");
     [proxyObj setRandomSeed:17];
     result = [proxyObj getRandom];
     printf("random #: %ld\n", result);
     result = [proxyObj getRandom];
     printf("random #: %ld\n", result);
 }

 int main(int argc, const char *argv[]) {
     id pool = General/[[NSAutoreleasePool alloc] init];
     if (0 < argc && 0 == strcmp(argv[0] + strlen(argv[0]) - 6, "server")) {
 	server(argc, argv);
     } else {
 	client(argc, argv);
     }
     [pool release];
     exit(0);
 }
