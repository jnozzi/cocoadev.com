I've just started using General/NetSocket in the place of General/SocketPort and have run into a weird problem.  I would like to use rendezvous to discover client apps and establish General/NetSocket connections to them.

General/NetSocket needs an IP number (or host) to create the socket.  Rendezvous (at least in all the examples and tutorials I could find) resolves services and gives you the socket Struct as a bunch of bytes, which works fine with General/SocketPort but not with General/NetSocket (which wants a plain old IP number).  How to get human readable (ie not a socket struct) IP number from rendezvous'  "did resolve address'" delegate?

Right now I am cheating and passing General/[[NSHost currentHost] name] through the the rendezvous service name but this is a mega hack and not the point of rendezvous.

Thanks, as always.

General/EcumeDesJours

----

The Picture Sharing Browser example [file:///Developer/Examples/Foundation/General/PictureSharingBrowser/] retrieves the IP address from a socket struct, but it doesn't appear to handle IPv6 and feels a little hackish to me. I am also curious for a better solution to this problem considering almost all high level networking frameworks do not accept a socket struct. Anyone have a suggestion? -- General/RyanBates

----

    inet_ntop() is your friend.  Here's my code:
    
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

General/NSString* addressStringWithSocketData(General/NSData* inSocketData)
{
	if (inSocketData == nil) {
		return nil;
	}
	struct sockaddr* sock = (struct sockaddr*)[inSocketData bytes];
	if (sock->sa_family == AF_INET) {
		struct sockaddr_in* sock_in = (struct sockaddr_in*)sock;
		char buf[INET_ADDRSTRLEN];
		const char* address = inet_ntop(AF_INET, &(sock_in->sin_addr), buf, INET_ADDRSTRLEN);
		if (address) {
			return General/[NSString stringWithCString:buf];
		}
	} else if (sock->sa_family == AF_INET6) {
		struct sockaddr_in6* sock_in6 = (struct sockaddr_in6*)sock;
		char buf[INET6_ADDRSTRLEN];
		const char* address = inet_ntop(AF_INET6, &(sock_in6->sin6_addr), buf, INET6_ADDRSTRLEN);
		if (address) {
			return General/[NSString stringWithCString:buf];
		}
	}
	return nil;	
}

The irony of this is that those high-level frameworks generally turn around and create a sockaddr structure behind the scenes so a better solution might be to modify them to take an General/NSData-wrapped sockaddr.  That is, however, left as an exercise for the reader.  -- Bo

Independently I did this excercise: [http://www.dasgenie.com/scrap/archives/000103.html General/NSStringNetworkingAdditions]-- General/DominikWagner

----

Bo, you ROCK!!!!  I don't know what many of us would do without cocoadev!!!