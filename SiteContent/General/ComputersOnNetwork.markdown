I'm writing a program which uses General/AppleScript to issue commands to a remote computer. I want to be able to find all of the computers on a network which support this. How would I do that? If you don't know how to do that, then can you tell me how to find all of the computers or devices connected to a network. Any help will be greatly appreciated.

----

check this out-> http://developer.apple.com/documentation/Cocoa/Conceptual/General/NetServices/

----

I was able to get this to work by finding all of the computers on the network using eppc (Apple Remote Events) by using the General/NSNetServiceBrowser class. Thanks for your help.

----

It would be nice if you could post your solution once you get it working. I'm sure it will be useful info!!

----

This code finds all of the computers on the network with Apple Remote Events (eppc) enabled and puts it into an General/NSTableView called remoteHostTableView.

    
@interface Controller : General/NSObject

{
    General/NSMutableArray *remoteHosts;
    General/NSNetServiceBrowser *serviceBrowser;
    General/IBOutlet General/NSTableView *remoteHostTableView;
}

@end


#import "Controller.h"

@implementation Controller

- (void)awakeFromNib
{
    remoteHosts = General/[[NSMutableArray alloc] init];
    serviceBrowser = General/[[NSNetServiceBrowser alloc] init];
    [serviceBrowser setDelegate:self];
    [serviceBrowser searchForServicesOfType:@"_eppc._tcp." inDomain:@""];
}

// General/NSNetServiceBrowser delegate methods
- (void)netServiceBrowser:(General/NSNetServiceBrowser *)aNetServiceBrowser
    didFindService:(General/NSNetService *)aNetService
    moreComing:(BOOL)moreComing
{   
    [remoteHosts addObject:aNetService];
    
    [aNetService setDelegate:self];
    [aNetService resolve];
    
    if (!moreComing)
    {
        [remoteHostTableView reloadData];
    }
}

- (void)netServiceBrowser:(General/NSNetServiceBrowser *)aNetServiceBrowser
    didRemoveService:(General/NSNetService *)aNetService
    moreComing:(BOOL)moreComing
{   
    [remoteHosts removeObject:aNetService];
    
    if (!moreComing)
    {
        [remoteHostTableView reloadData];
    }
}

// General/NSNetService delegate methods
- (void)netService:(General/NSNetService *)sender didNotResolve:(General/NSDictionary *)errorDict
{
    General/NSLog( @"Couldn't resolve %@", [sender name] );
}

- (void)netServiceDidResolveAddress:(General/NSNetService *)sender
{
    General/NSLog( @"Successfully resolved %@.", [sender name] );
}

- (void)netServiceWillResolve:(General/NSNetService *)sender
{
    General/NSLog( @"Attempting to resolve %@...", [sender name] );
}

// data source methods
- (int)numberOfRowsInTableView:(General/NSTableView *)aTableView
{
    return [remoteHosts count];
}

- (id)tableView:(General/NSTableView *)aTableView
    objectValueForTableColumn:(General/NSTableColumn *)aTableColumn
    row:(int)rowIndex
{
    return General/remoteHosts objectAtIndex:rowIndex] name];
}

@end


I have a new problem now. I'm trying to find the IP Address of the [[NSNetService after it is resolved so I can use it to tell the remote computer to do things in General/AppleScript using of machine. If you do [aNetService addresses], it returns an array of addresses, each is an General/NSData object. I'm just going to use the first address to attempt to make a connection. The problem is I can't convert the General/NSData object into the format that I need it in which is something like 192.168.1.1.

----

The sockaddr_in structure that the General/NSData object encapsulates is defined in the netinet/in.h header and there are some convenience methods for handling it in the arpa/inet.h header (both of these are found in /usr/include/).  Anyway, without further ado, a quick (as in entirely untested) category on General/NSData to extract the relevant bits would look something like this:
General/NSData+Extras.h
    
#import <Foundation/Foundation.h>

@interface General/NSData (Extras)
- (struct sockaddr_in)sockAddrStruct;
- (General/NSString*)ipAddress;
- (unsigned short)port;
@end

General/NSData+Extras.m
    
#import "General/NSData+Extras.h"
#import "sys/socket.h"
#import "netinet/in.h"
#import "arpa/inet.h"

@implementation General/NSData (Extras)
- (struct sockaddr_in)sockAddrStruct
{
	return *(struct sockaddr_in*)[self bytes];
}
- (General/NSString*)ipAddress
{
	return General/[NSString stringWithCString:inet_ntoa([self sockAddrStruct].sin_addr)];
}
- (unsigned short)port
{
	return ntohs([self sockAddrStruct].sin_port);
}
@end

*Edited the above code to add ntohs() around the return value of the port method.  This recently bit me on a new Intel machine.*

----

Since addresses could be either IPv4 or IPv6 I'd rather do something like

    
General/NSString *addressString = nil;
struct sockaddr *address;
unsigned int port = 0;

address = (struct sockaddr *) [data bytes];

switch( address->sa_family )
{
  case AF_INET:
  {
    struct sockaddr_in *ip4;
    char dest[INET_ADDRSTRLEN];

    ip4 = (struct sockaddr_in *) address;

    addressString = General/[NSString stringWithFormat: @"%s", inet_ntop(AF_INET, &ip4->sin_addr, dest, sizeof dest)];
    port = ntohs(ip4->sin_port);
  }
  break;

  case AF_INET6:
  {
    struct sockaddr_in6 *ip6;
    char dest[INET6_ADDRSTRLEN];

    ip6 = (struct sockaddr_in6 *) address;

    addressString = General/[NSString stringWithFormat: @"%s",  inet_ntop(AF_INET6, &ip6->sin6_addr, dest, sizeof dest)];
    port = ntohs(ip6->sin6_port);
  }
  break;

  default:
    General/NSLog(@"Unknown family");
    break;
}
