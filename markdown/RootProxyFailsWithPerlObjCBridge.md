I wanted my application to be able to execute Perl scripts that in turn are supposed to communicate with it.
My first thought was using Distributed Objects, so I set up an General/NSConnection using General/ObjC, registered it and set a root Object.
Then on the Perl part my approach was supposed to be:
- getting an General/NSConnection object connected to the first one using the registered name
- retreiving a Proxy to the root object
- send a few test messges

My code however fails at retrieving the root object and I just can't find out why....

This is my Obj-C code:

----
    
#import <Cocoa/Cocoa.h>

BOOL didPerform = NO;

@interface Logger : General/NSObject
{
}

-(void) logNSString: (General/NSString *) str;

@end


@interface General/PerlController : General/NSObject
{
	General/NSTask *perl;
	Logger *logger;
}

-(void) loadPerlStuff;
-(void) unloadPerlStuff;

-(Logger *) logger;

-(void) finish;

@end

int main( void )
{
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];
	
	General/NSConnection *con = General/[[NSConnection alloc] initWithReceivePort: General/[NSPort port] sendPort: General/[NSPort port]];
	General/PerlController *pCntl = General/[[PerlController alloc] init];
	
	[con setRootObject: pCntl];
	if( [con registerName: @"General/PerlConnection"] == NO )
	{
		General/NSLog( @"Could not register connection." );
		[con release];
		
		[pool release];
		return 1;
	}
	
	General/NSRunLoop *runLoop = General/[NSRunLoop currentRunLoop];
	[runLoop performSelector: @selector(loadPerlStuff) target: pCntl argument: nil order: 1 modes: General/[NSArray arrayWithObject: General/NSDefaultRunLoopMode]];
	
	while( didPerform == NO )
		[runLoop runMode: General/NSDefaultRunLoopMode beforeDate: General/[NSDate distantFuture]];
	
	[pCntl unloadPerlStuff];
	[pCntl release];
	
	[con registerName: nil];
	[con release];
	
	[pool release];
    return 0;
}

@implementation Logger
		  
-(void) logNSString: (General/NSString *) str { General/NSLog( @"%@", str ); }
		  
@end

@implementation General/PerlController : General/NSObject

-(void) loadPerlStuff
{
	General/NSString *path = @"/usr/bin/perl";
	General/NSFileHandle *handle = General/[NSFileHandle fileHandleForReadingAtPath: path];
	if( handle == nil )
	{
		path = @"/usr/local/bin/perl";
		handle = General/[NSFileHandle fileHandleForReadingAtPath: path];
		if( handle == nil )
		{
			General/NSLog( @"Could not locate perl" );
			return;
		}
	}
	
	perl = General/[[NSTask alloc] init];
	
	[perl setArguments: General/[NSArray arrayWithObject: @"script.pl"]];
	[perl setCurrentDirectoryPath: @"./"];
	[perl setLaunchPath: path];
	
	logger = General/Logger alloc] init];
	
	[perl launch];
}

-(void) unloadPerlStuff
{
	[perl terminate];
	[perl release];
	
	[logger release];
}

-(Logger *) logger { return logger; }

-(void) finish { didPerform = YES; }

@end


----

This is my Perl code:

----
    

#!/usr/bin/perl

use Foundation;

my $con = [[NSConnection->connectionWithRegisteredName_host_(General/NSString->stringWithCString_("General/PerlConnection"), 0);

my $cntl = $con->rootProxy();

if( !$cntl or !$$cntl ) {
	print "damn it....";
	exit(1);
}

$cntl->logger()->logNSString_(General/NSString->stringWithCString_("Log this!"));
$cntl->finish();


----