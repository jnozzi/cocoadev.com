

I am trying to create a very simple logging application. I want to learn about unix sockets and network programming.
The app is a server that opens a port (7371) and then echos everything that comes in that port to an General/NSTextView (the only outlet).

I actually have everything working, and the logger does indeed log stuff sent to it, but the problem is that after a client has connected  and sent a string to the server  I can not mouse over the General/NSTextView without it crashing or popping up the debugger. No error is given but if I try to continue with the debugger I get an  ECX_BAD_ACCESS signal.

I can only feel that it has to do with the way I am dealing with notifications. Here is how to recreate

1) Run the app

2) In a teminal window "telnet 127.0.0.1 7371". Connection works even after a crash due to the 'setsockopt' command (thank you Aaron Hillegrass).

3) Move mouse away from General/NSTextView. No problem, can even cick onthe app and back to the terminal without any issue

4) Type 'hello' in the terminal. 'hello' displayed in the General/NSTextView of the app.

5) Move mouse away from being over the terminal window and mouse over the General/NSTextView.

6) Instantly the app crashes as described - If running in release mode it just 'unexpectedly quits', if in Xcode the debugger pops up. The gdb where command tells me:

#0  0x90a594c7 in objc_msgSend ()

#1  0xbffff6d8 in ?? ()

#2  0x93288e28 in -General/[NSApplication run] ()

#3  0x9327cd2f in General/NSApplicationMain ()

#4  0x0000dffc in main (argc=1, argv=0xbffff8f0) at /Users/conrad/Documents/General/FairWeatherPunk/Subversion/General/FlashLogger/main.m:13

Which is not helpful atall (line 13 is simply the only line of code in a normal main.m).

So I presume it has to either do with the fact that I have received a 'General/NSFileHandleReadCompletionNotification' from the remoteSocket - initiated by typing in at the terminal - and not finished with it properly, OR the text I have added to the General/NSTextView from the socket is breaking it up somehow.

Unfortunately the real thing I want to connect to it (a flash movie) also experiences the same problems.

Can anybody help?

Thank you for listening



The code follows

    
/* General/FlashLoggerController */

#import <Cocoa/Cocoa.h>

@interface General/FlashLoggerController : General/NSObject
{
    General/IBOutlet General/NSTextView *logView;
	General/NSFileHandle *listenSocket;
	General/NSFileHandle *remoteSocket;
}

- (void) receiveMessage:(General/NSNotification *) notification;
- (void) addMessage: (General/NSString *) message;
- (void) startServer;

@end

    
#import "General/FlashLoggerController.h"

#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

@implementation General/FlashLoggerController

- (void) awakeFromNib
{
	[self addMessage: @"Logger: Starting up.\n"];
	[self startServer];
}

- (void) startServer
{ 
	
	struct sockaddr_in addr;
    int sockfd;
	
    // Create a socket
    sockfd = socket( AF_INET, SOCK_STREAM, 0 );
	
    // Setup its address structure
    bzero( &addr, sizeof(struct sockaddr_in));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl( INADDR_ANY );
    addr.sin_port = htons( 7371 );
	
	// make address reusable
	int yes=1;
	setsockopt(sockfd,SOL_SOCKET,SO_REUSEADDR,&yes,sizeof(int));
	
    // Bind it to an address and port
    bind( sockfd, (struct sockaddr *)&addr, sizeof(struct sockaddr));
	
    // Set it listening for connections
    listen( sockfd, 5 );

    // Create an General/NSFileHandle to communicate with the socket
    listenSocket = General/[[NSFileHandle alloc] initWithFileDescriptor: sockfd];
	
    // Register for General/NSFileHandle socket-related notification
    General/NSNotificationCenter *nc = General/[NSNotificationCenter defaultCenter];
    [nc addObserver:self
		   selector:@selector(clientConnected:)
			   name:General/NSFileHandleConnectionAcceptedNotification
			 object:listenSocket];
	
    // Begin waiting for and accepting connections
    [listenSocket acceptConnectionInBackgroundAndNotify];
}

- (void) clientConnected:(General/NSNotification *)notification
{
	[self addMessage: @"Logger: Client connected.\n"];
    remoteSocket = General/notification userInfo] objectForKey:[[NSFileHandleNotificationFileHandleItem];
	
    General/NSNotificationCenter *nc = General/[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(receiveMessage:)
               name:General/NSFileHandleReadCompletionNotification
             object:remoteSocket];
//    [listenSocket acceptConnectionInBackgroundAndNotify];
    [remoteSocket readInBackgroundAndNotify];
}

- (void) receiveMessage:(General/NSNotification *) notification
{
//	General/NSLog(@"[Logger] Received message.");
    General/NSData *messageData = General/notification userInfo] objectForKey:[[NSFileHandleNotificationDataItem];
//	General/NSLog(@"[Logger] Received message. %@",messageData);
    if ( messageData != nil && [messageData length] > 0 ) 
	{
		General/NSString *message = General/[NSString stringWithUTF8String:[messageData bytes]];
		[self addMessage: message];
		[message release];
    }
    [remoteSocket readInBackgroundAndNotify];    
}

- (void) addMessage: (General/NSString *) message
{
    General/NSAttributedString *aStr = General/[[NSAttributedString alloc] initWithString: message];
    General/logView textStorage] appendAttributedString: aStr];
    [aStr release];
}

- (void) dealloc
{
    [[[[NSNotificationCenter defaultCenter] removeObserver:self];
	[remoteSocket closeFile];
	[remoteSocket release];
    [listenSocket closeFile];
    [listenSocket release];	
    [super dealloc];
}

@end


----

The first thing that jumps out at me is this:

    
		General/NSString *message = General/[NSString stringWithUTF8String:[messageData bytes]];
		[self addMessage: message];
		[message release];


All of the General/NSString string... messages return an autoreleased instance so you are releasing it again.  This is likely to cause bad things to happen when the event loop returns and frees the atorelease pool that it created for you.

Does changing that fix anything?

--General/JeffDisher

----

Thanks Jeff, that fixed it. Amazing, all of that code brought down by a misunderstanding of General/NSString.

----
Is     messageData NUL-terminated? Because that's what     stringWithUTF8String: is expecting, and if it's not then you'll end up reading garbage in some circumstances. You probably want to use     initWithData:encoding:.