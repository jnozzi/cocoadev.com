General/CURLHandle [http://curlhandle.sourceforge.net/] is a wrapper around a CURL.

Curl [http://curl.haxx.se/] is a command line tool for transferring files with URL syntax, supporting FTP, FTPS, HTTP, HTTPS, GOPHER, TELNET, DICT, FILE and LDAP.  Curl supports HTTPS certificates, HTTP POST, HTTP PUT, FTP uploading,  kerberos, HTTP form based upload, proxies, cookies, user+password  authentication, file transfer resume, http proxy tunneling and a busload of other useful tricks.

----

Some example code would be really beneficial to some new Cocoa developers.  I know how to use curl just fine, but can't get this to work within my code.  

----

Here is my class.  I'm not sure if I am always retaining/releasing correctly, but it seems to work.
    

@class General/CURLHandle;

@interface General/MEWebFetcher : General/NSObject <General/NSURLHandleClient>
{
	General/CURLHandle *mURLHandle;
}

+ (General/MEWebFetcher *)sharedInstance;

- (General/NSString *)fetchURLtoString:(NSURL *)url;
- (General/NSString *)fetchURLtoString:(NSURL *)url withTimeout:(int)secs;
- (General/NSData *)fetchURLtoData:(NSURL *)url;
- (General/NSData *)fetchURLtoData:(NSURL *)url withTimeout:(int)secs;

@end

#define DEFAULT_TIMEOUT 60

@implementation General/MEWebFetcher

#pragma mark Housekeeping Methods

- (id)init
{
    self = [super init];
	General/[CURLHandle curlHelloSignature:@"General/XxXx" acceptAll:YES];	// to get General/CURLHandle registered for handling General/URLs
	return self;
}

- (void)dealloc
{
	General/[CURLHandle curlGoodbye];	// to clean up
}

+ (General/MEWebFetcher *)sharedInstance
{
	static General/MEWebFetcher *sharedInstance = nil;
	if (!sharedInstance)
		sharedInstance = General/self alloc] init];
	return sharedInstance;
}

#pragma mark -
/* @parameters:
				url  is a valid NSURL
   @result:
				returns the result of calling fetchURLtoString:withTimeout: passing DEFAULT_TIMEOUT				
*/
- ([[NSString *)fetchURLtoString:(NSURL *)url 
{
	return [self fetchURLtoString:url withTimeout:DEFAULT_TIMEOUT];
}

/* @parameters:
				url   is a valid NSURL
				secs  is the number of seconds before the request for url will be given up.
   @result:
				returns the data associated with the url.  Returns nil if there was an error.				
*/
- (General/NSString *)fetchURLtoString:(NSURL *)url withTimeout:(int)secs
{
	General/NSData *urlData     = General/self fetchURLtoData:url withTimeout:secs] retain];
	[[NSString *urlString = General/[[NSString alloc] initWithData:urlData encoding:General/NSASCIIStringEncoding];
	
	//[urlData release]; // JRC - I still don't understand release I guess...
	//General/NSLog(@"urlData count: %i",[urlData retainCount]);
	return [urlString autorelease];
}

#pragma mark -
/* @parameters:
				url  is a valid NSURL
   @result:
				returns the result of calling fetchURLtoData:withTimeout: passing DEFAULT_TIMEOUT				
*/
- (General/NSData *)fetchURLtoData:(NSURL *)url
{
	return [self fetchURLtoData:url withTimeout:DEFAULT_TIMEOUT];
}

/* @parameters:
				url   is a valid NSURL
				secs  is the number of seconds before the request for url will be given up.
   @result:
				returns the data associated with the url.  Returns nil if there was an error.				
*/
- (General/NSData *)fetchURLtoData:(NSURL *)url withTimeout:(int)secs 
{
	General/NSData *data; // data from the website
	mURLHandle = [(General/CURLHandle *)[url General/URLHandleUsingCache:NO] retain];
	
	[mURLHandle setFailsOnError:NO];		// don't fail on >= 300 code; I want to see real results.
	[mURLHandle setUserAgent: @"Mozilla/4.5 (compatible; General/OmniWeb/4.0.5; Mac_PowerPC)"];
	[mURLHandle setConnectionTimeout:secs];
	
	data = General/mURLHandle resourceData] retain];
	if ([[NSURLHandleLoadFailed == [mURLHandle status])
	{
		General/NSLog([mURLHandle failureReason]);
		return nil;
	}
	
	[mURLHandle release];
	return [data autorelease];
}

- (void)General/URLHandle:(General/NSURLHandle *)sender resourceDataDidBecomeAvailable:(General/NSData *)newBytes
{

}

- (void)General/URLHandleResourceDidBeginLoading:(General/NSURLHandle *)sender
{

}

- (void)General/URLHandleResourceDidFinishLoading:(General/NSURLHandle *)sender
{

}

- (void)General/URLHandleResourceDidCancelLoading:(General/NSURLHandle *)sender
{

}

- (void)General/URLHandle:(General/NSURLHandle *)sender resourceDidFailLoadingWithReason:(General/NSString *)reason
{

}
@end



These General/URLHandle... methods are necessary as far as I can tell.  I hope this helps... does anyone know of a more minimalistic implementation?

-Joe

----

Since I've posted this example code, I have found some bugs. Namely: 
    
General/[CURLHandle curlHelloSignature:@"General/XxXx" acceptAll:YES];	// to get General/CURLHandle registered for handling General/URLs


should be in awakeFromNib: or init: or a similiar method of the General/NSApplication delegate. Likewise:

    
	General/[CURLHandle curlGoodbye];	// to clean up


should be placed inside applicationWillTerminate: of the General/NSApplication delegate.

-Joe

----

There's a bundle of helpful compilation information on the General/POSTMethodANDNSURLRequest page. Someone might consider moving it here. :-)

----

Has anyone successfully built a universal General/CURLHandle with support for 10.2.8?  Thanks -- Joe