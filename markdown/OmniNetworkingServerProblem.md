

I've been trying to set up a simple server app to better my knowledge of networking.  After trying to work directly with BSD sockets I opted for a more Cocoa-like approach.  General/OMniNetworking seemed to be just the thing for me so I installed all of the necessary frameworks and tried a simple little program.  That worked like a charm so I decided to try something a bit more complex.  My idea was to have a server that would accept connections, write them a little welcome message, add them to an array, then loop through the array to read from each connection.  Anything that was recieved from the connection would be echoed back to the same connection.  If the connection sent the string "quit" it would shut down the server.

This is the code I used:

    
#import <Foundation/Foundation.h>
#import <General/OmniNetworking/General/OmniNetworking.h>

#define PORT 4000

int main (int argc, const char * argv[]) {
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];
	
	General/ONTCPSocket *listenSocket = General/[ONTCPSocket tcpSocket];
	BOOL running = TRUE;
	
	General/NSMutableArray *connectArray = General/[[NSMutableArray alloc] init];
	
	[listenSocket startListeningOnLocalPort:PORT allowingAddressReuse:YES];
	
	while(running) {
		General/NSAutoreleasePool *arp = General/[[NSAutoreleasePool alloc] init];

		General/ONTCPSocket *connectSocket = [listenSocket acceptConnectionOnNewSocket];
		[connectSocket setNonBlocking:YES];
		
		if ([connectSocket isConnected]) {
			// Someone has connected to the server
			General/NSLog(@"connectSocket is connected\n");
			General/ONSocketStream *socketStream = General/[ONSocketStream streamWithSocket:connectSocket];
			[socketStream writeString:@"Welcome!\n"];
			[connectArray addObject:connectSocket];
		}
		
		General/NSEnumerator *connectEnum = [connectArray objectEnumerator];
		General/ONTCPSocket *enumSocket;
		
		while (enumSocket = [connectEnum nextObject]) {
			/* code to act on each element as it is returned */
			if([enumSocket isConnected]) {
				General/NSLog(@"Connected\n");
				General/ONSocketStream *enumStream = General/[ONSocketStream streamWithSocket:enumSocket];
				General/NSString *sockReadString = [enumStream readString];
				if ([sockReadString caseInsensitiveCompare:@"quit"] == General/NSOrderedSame) {
					running = FALSE;
				} else {
					[enumStream writeString:sockReadString];
				}
			} else {
				General/NSLog(@"Not connected\n");
				[enumSocket abortSocket];
			}
		}
		
		[arp release];
	}
	
	General/NSEnumerator *abortArrayEnum = [connectArray objectEnumerator];
	General/ONTCPSocket *abortSocket;
	
	while (abortSocket = [abortArrayEnum nextObject]) {
		/* code to act on each element as it is returned */
		if([abortSocket isConnected]) {
			[abortSocket abortSocket];
		}
	}
	

    [pool release];
    return 0;
}


When a client connects, it gets the "Welcome!" message, but then the server crashes at the line General/NSString *sockReadString = [enumStream readString]; with an "Uncaught exception: <General/ONTCPSocketWouldBlockExceptionName> Read aborted" error.

This has been driving me nuts for a couple of days now.  Any suggestions?

----
You set the socket as non-blocking, then you attempt to perform a blocking read. This is not a great strategy.