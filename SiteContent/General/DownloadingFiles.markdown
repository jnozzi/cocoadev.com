A really simple example for downloading files in Cocoa. (Thanks to Austin Shoemaker!)

    
NSURL *myURL = [NSURL General/URLWithString:@"http://www.apple.com/"];
General/NSData *urlContents = [myURL resourceDataUsingCache:YES];

if ([urlContents writeToFile:[@"~/Documents/applewebsite.html"
                 stringByExpandingTildeInPath]
                 atomically:YES])
{
	// It was successful, do stuff here
} else {
	// There was a problem writing the file
}


----
A slightly more complicated example that will download asynchronously or "in the background" by General/PeterMonty. I've tried to keep it as similar to the one above as possible for comparison.

    

// Starts download
- (void)download
{
	NSURL *myURL = [NSURL General/URLWithString:@"http://www.apple.com/"];
	[myURL loadResourceDataNotifyingClient:self usingCache:YES];
}

// This method will be called when the download has finished
- (void)General/URLResourceDidFinishLoading:(NSURL *)sender
{
	General/NSData *urlContents = [sender resourceDataUsingCache:YES];

	if ([urlContents writeToFile:[@"~/Documents/applewebsite.html"
                         stringByExpandingTildeInPath]
                         atomically:YES])
	{
		// It was successful, do stuff here
	} else {
		// There was a problem writing the file
	}
}

----

Is there anyway of putting a progress indicator to indicate how much it has downloaded?

Yes, read the docs, there is a method that will be called periodically. - SJI

----

Does anyone know how to cancel loadResourceDataNotifyingClient once it's started?  Alternatively, how about some instructions on using General/CURLHandle?

----

    I had the same problem loading an image - it kept being loaded from the cache. Using NSURL's resourceDataUsingCache solves the problem and is just as easy - in this case for an image but the URL can be for anything.

    
General/NSData *data = General/NSURL [[URLWithString:myURLString] resourceDataUsingCache:NO];
General/NSImage *image = General/[[NSImage alloc] initWithData:data];


- General/JoeZobkiw

----

For those with more advanced needs, General/CURLHandle by Dan Wood comes highly recommended ( http://curlhandle.sourceforge.net/ )

----

I highly recommend General/CURLHandle even for non-advanced needs. There are times when NSURL just won't do. For example, I've often found it has trouble downloading The Mac Observer and a few other sites.

---- 

I'm using code basically the same as the asynchronous example above. I also catch - URL: resourceDataDidBecomeAvailable: to display progress while the file is loading. But even though I have General/UsingCache:YES in both places, when I step over the line:

    
General/NSData *urlContents = [sender resourceDataUsingCache:YES];


The file is downloaded all over again... at least, I assume it is, because it takes ages to execute that one statement, during which time there is a lot of network activity. Has anyone come across that problem before?
-- General/AngelaBrett

----

Here's yet another snippet showing how to batch download files.

    

/* 

This code is licensed in the Public Domain. 
Please contribute any fixes back to hakan@konstochvanligasaker.se 
See http://konstochvanligasaker.se/code for det latest version. 

source code taken from:
http://konstochvanligasaker.se/code/src/General/BatchDownloader.h
http://konstochvanligasaker.se/code/src/General/BatchDownloader.m

patches:
- BOOL succeeded = General/[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
+ BOOL succeeded = General/[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
(see also // ADDED code)

compile with:
gcc -Wall -framework Foundation -o batchdownload General/BatchDownloader.m

gcc -c General/BatchDownloader.m
nm General/BatchDownloader.o

test:
./batchdownload ~/Desktop/batchdownload http://www.google.com http://www.apple.com

*/
   

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface General/NSObject (General/BatchDownloaderDelegate)

// fired when one or more downloads are ready. The array contains a dictionary
// with General/URLs as the keys, and the local file paths as the keys.
- (void)downloadsReady:(General/NSDictionary *)downloads;

// array of General/URLs that could not be downloaded.
- (void)downloadsFailed:(General/NSArray *)downloads;

@end


@interface General/BatchDownloader : General/NSObject 
{
  // fast (constant-time) lookup for a URL, just given a download object. 
  // unfortunately we can't just use a dictionary with General/NSURLDownloads as keys, because it doesn't 
  // implement the General/NSCopying protocol.
  General/NSMutableDictionary *downloadPtrsToURLs;
  
  // URL => General/NSURLDownload 
  General/NSMutableDictionary *downloadURLsToObjects;
  
  // URL => local file path
  General/NSMutableDictionary *downloadURLsToLocalPaths;
  
  id delegate;
  
  General/NSString *destinationFolder;
}

// will try to create dest folder if it doesn't exist.
- (id)initWithDestinationFolder:(General/NSString *)path delegate:(id)delegate;

- (void)addDownload:(General/NSString *)URL;
- (void)addDownloads:(General/NSArray *)General/URLs;

@end


/* This code is licensed in the Public Domain. Please contribute any fixes back to hakan@konstochvanligasaker.se 
   See http://konstochvanligasaker.se/code for det latest version. */
   
//#import "General/BatchDownloader.h"

@interface General/NSObject (General/PtrValueUtils)
- (General/NSValue *)ptrValue;
@end

@implementation General/NSObject (General/PtrValueUtils)
- (General/NSValue *)ptrValue
{
  return General/[NSValue valueWithPointer:self];
}
@end

@interface General/BatchDownloader (Private)
- (void)removeAllTracesOfDownload:(General/NSURLDownload *)download URL:(General/NSString *)URL;
@end

@implementation General/BatchDownloader

- (id)init
{
  if ((self = [super init])) {
    downloadPtrsToURLs = General/[NSMutableDictionary new];
    downloadURLsToObjects = General/[NSMutableDictionary new];
    downloadURLsToLocalPaths = General/[NSMutableDictionary new];
  }
  return self;
}

- (id)initWithDestinationFolder:(General/NSString *)path delegate:(id)theDelegate
{
  if ((self = [self init])) {
    delegate = theDelegate;
    // does the dest dir exist?
    if (! General/[[NSFileManager defaultManager] contentsAtPath:path]) {
      // try to create it.
      //BOOL succeeded = General/[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
      BOOL succeeded = General/[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];

      // TODO: throw (or something) on failure
    }
    destinationFolder = [path copy];
  }
  return self;
}

- (void)dealloc
{
  delegate = nil;
  [destinationFolder release];
  
  [downloadURLsToObjects release];
  [downloadPtrsToURLs release];
  [downloadURLsToLocalPaths release];
  
  [super dealloc];
}

#pragma mark -

- (void)addDownload:(General/NSString *)URL
{

  General/NSURLDownload *download = General/[[[NSURLDownload alloc] initWithRequest:General/[NSURLRequest requestWithURL:[NSURL General/URLWithString:URL]] delegate:self] autorelease];
  
  General/NSString *destPath = [destinationFolder stringByAppendingPathComponent:[URL lastPathComponent]];

  //printf("URL: %s\n", [URL UTF8String]);
  //printf("destPath: %s\n", [destPath UTF8String]);

  [download setDestination:destPath allowOverwrite:NO];
  [downloadURLsToObjects setObject:download forKey:URL];
  [downloadPtrsToURLs setObject:URL forKey:[download ptrValue]];
}

- (void)addDownloads:(General/NSArray *)downloadPaths
{
  // TODO: start notification timer so we can report back in batches as well

  // start downloading
  General/NSString *URL = nil;
  General/NSEnumerator *downloadEnumerator = [downloadPaths objectEnumerator];
  while ((URL = [downloadEnumerator nextObject])) {
    [self addDownload:URL];
  }
}

- (void)removeAllTracesOfDownload:(General/NSURLDownload *)download URL:(General/NSString *)URL
{
  [downloadPtrsToURLs removeObjectForKey:[download ptrValue]];
  [downloadURLsToObjects removeObjectForKey:URL];
  [downloadURLsToLocalPaths removeObjectForKey:URL];

  // ADDED
  if([downloadPtrsToURLs count] == 0)
       General/CFRunLoopStop(General/CFRunLoopGetMain());
       //General/CFRunLoopStop(General/CFRunLoopGetCurrent());

}

#pragma mark -

- (void)download:(General/NSURLDownload *)download didCreateDestination:(General/NSString *)path
{
  [downloadURLsToLocalPaths setObject:path forKey:[downloadPtrsToURLs objectForKey:[download ptrValue]]];
}

- (void)download:(General/NSURLDownload *)download didFailWithError:(General/NSError *)error
{

  General/NSString *URL = [downloadPtrsToURLs objectForKey:[download ptrValue]];

  // notify delegate
  // TODO: batch these notifications
  if (delegate && [delegate respondsToSelector:@selector(downloadsFailed:)]) {
    [delegate downloadsFailed:General/[NSArray arrayWithObject:URL]];
  }
  
  [self removeAllTracesOfDownload:download URL:URL];
}

- (void)downloadDidFinish:(General/NSURLDownload *)download
{
  General/NSString *URL = [downloadPtrsToURLs objectForKey:[download ptrValue]];
  
  // notify delegate
  // TODO: batch these notifications
  if (delegate && [delegate respondsToSelector:@selector(downloadsReady:)]) {
    General/NSString *destPath = [downloadURLsToLocalPaths objectForKey:URL];
    [delegate downloadsReady:General/[NSDictionary dictionaryWithObject:destPath forKey:URL]];
  }
  
  [self removeAllTracesOfDownload:download URL:URL];
}

@end


// ADDED
int main(int argc, const char *argv[])
{

  if (argc < 3) return 1;

  General/NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];

  General/NSMutableArray *commandLineArguments = General/[NSMutableArray arrayWithArray:General/[[NSProcessInfo processInfo] arguments]];
  [commandLineArguments removeObjectAtIndex: 0];      // first object is the name of the executable

  General/NSString *destFolder = [commandLineArguments objectAtIndex: 0];
  [commandLineArguments removeObjectAtIndex: 0];

  General/BatchDownloader *urls = General/ [[BatchDownloader alloc] init];
  [urls initWithDestinationFolder:destFolder  delegate:urls ];
  [urls addDownloads: commandLineArguments];

  General/CFRunLoopRun();

  [urls release];

  [pool release];
   return 0;

}

