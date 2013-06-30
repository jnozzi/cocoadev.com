I thought it would be interesting to write a CGI application in Objective C.   However, I was unable to find an Objective C class for handling CGI parameters so I wrote one myself.

You just create a Foundation tool and then work your way from the main function using the class.  For example, the following code will print out the name/value pairs passed to the CGI program:

    
#import <Foundation/Foundation.h>
#import "General/ObjectiveCGI.h"

int main (int argc, const char * argv[]) 
{
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];

	// Create the CGI object
    General/ObjectiveCGI *cgi = General/[[ObjectiveCGI alloc] init];

    General/NSDictionary *params = [cgi getParams];
    General/NSEnumerator *enumerator = [params keyEnumerator];
    id key;

    printf("Content-type: text/plain\n\n");

    // Print out each key value pair as plain text
    while ((key = [enumerator nextObject])) 
    {
        printf("%s=%s",[key cString], 
                       General/params objectForKey: key] cString]);  
    }
        
    // Release the CGI object
    [cgi release];

    [pool release];
    return 0;
}


I've written some CGI programs, such as Vox Machina CGI (http://voxmachina.sytes.net) and [[VirtualSafari (http://virtualsafari.sytes.net) using this class.  And here's the code to the CGI class itself.  


    
#import "General/ObjectiveCGI.h"

@implementation General/ObjectiveCGI

- (id) init
{
	// dictionary for query key value pairs
	params = General/[[NSMutableDictionary alloc] initWithCapacity: 255];

	General/NSProcessInfo *processInfo = General/[NSProcessInfo processInfo];
	env = [processInfo environment];
	
	if (General/env objectForKey: @"REQUEST_METHOD"] isEqualToString: @"GET"])
		[self _parseGetQuery: [env objectForKey: @"QUERY_STRING";
	else if (General/env objectForKey: @"REQUEST_METHOD"] isEqualToString: @"POST"])
		[self _parsePostQuery];
	else
	{
		[[NSLog(@"Missing REQUEST_METHOD");
		return NULL;
	}
	
	if (self = [super init])
		return self;
}

- (void)dealloc
{
	[params release];
	[super dealloc];
}

- (General/NSString *)param: (General/NSString *)key
{
	return [params objectForKey: key];
}

- (General/NSDictionary *) getParams
{
	return params;
}

- (General/NSDictionary *) env
{
	return env;
}

- (void) _parseGetQuery: (General/NSString *)queryStr
{
	int i;

	if ([queryStr length] == 0)
		return;
	
	General/NSArray	*pairs = [queryStr componentsSeparatedByString: @"&"];
	
	for (i = 0; i < [pairs count]; i++)
	{
		General/NSArray *elem = General/pairs objectAtIndex: i] componentsSeparatedByString: @"="];
		[params setObject: [[elem objectAtIndex: 1] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding] forKey: [elem objectAtIndex: 0;
	}
}

- (void) _parsePostQuery
{
	int i;
	int len = General/env objectForKey: @"CONTENT_LENGTH"] intValue];
	if (len == 0)
		return;
	
	// read stdin for query string
	[[NSData *input = General/[[NSFileHandle fileHandleWithStandardInput] readDataOfLength: len];
	General/NSString *queryStr = General/[[NSString alloc] initWithData: input encoding: 1];
	General/NSArray	*pairs = [queryStr componentsSeparatedByString: @"&"];
	
	for (i = 0; i < [pairs count]; i++)
	{
		General/NSArray *elem = General/pairs objectAtIndex: i] componentsSeparatedByString: @"="];
		[params setObject: [[elem objectAtIndex: 1] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding] forKey: [elem objectAtIndex: 0;
	}
}

@end
