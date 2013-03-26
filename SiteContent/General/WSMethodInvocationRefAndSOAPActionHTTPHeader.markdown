I've discovered how to make SOAP calls with the [[WSMethodInvocationRef]] and related functions, but I cannot make a [[SOAPAction]] appear in the outgoing HTTP header. Does anyone know how to do this?

It seems like it ought to be <code>[[WSMethodInvocationSetProperty]]( 
    soapCall, 
    kWSSOAPMethodSOAPAction , 
    ([[CFTypeRef]] @"http://ws.cdyne.com/[[AdvancedCheckAddress]]" );</code>

but there is no such constant as kWSSOAPMethodSOAPAction.

-Rob

----

You can create a kWSHTTPExtraHeaders property for the invocation which is a [[CFDictionary]] of { key ([[CFString]]), val ([[CFString]]) } pairs. See:
http://developer.apple.com/documentation/Networking/Conceptual/[[WebServices]]/3_ref_folder/chapter_3_section_33.html
for details. The snippet below should be enough to get you going.
<code>
[[NSDictionary]] ''headers = [[[NSDictionary]] dictionaryWithObject:@"urn:[[GoogleSearchAction]]" forKey:@"[[SOAPAction]]"];
/'' your code to create the invocation and set its parameters - see [[WSMethodInvocationRef]] ''/
[[WSMethodInvocationSetProperty]] (rpcCall, ([[CFStringRef]]) kWSHTTPExtraHeaders, ([[CFTypeRef]]) headers);
</code>

The headers dictionary could also contain @"[[MyFunkyApp]] 1.0 (Macintosh; Mac OS X)" with key @"User-Agent" if you want fame in server logs :)

-- Merman

----

I still have troubles getting soap to work, keep getting exception from my call.
It seem's that something is missing but i had several sleepless nights because of this anyone please help, i would be very gratefull.

--JJ

<code>

#import <[[CoreServices]]/[[CoreServices]].h>
#import "soap.h"


@implementation soap


- ([[IBAction]]) getQuote: (id) sender {	
																																											
	
	[[WSMethodInvocationRef]] soapCall;
	[[NSMutableDictionary]] ''params;
	params     = [[[[[NSMutableDictionary]] alloc] init] retain];



	[params setObject:@"AAPL" forKey:@"symbol"];
	
		
	[[NSMutableDictionary]] ''headers = [[[NSMutableDictionary]] dictionaryWithObject:@"http://www.webserviceX.NET/[[GetQuote]]" forKey:@"[[SOAPAction]]"];	
	NSURL ''rpcURL = [NSURL [[URLWithString]]: @"http://www.webservicex.net/stockquote.asmx"];	
	[[NSString]] ''methodName = @"[[GetQuote]]";	
	
	[[NSDictionary]] ''result;
	

	soapCall = [[WSMethodInvocationCreate]] (([[CFURLRef]]) rpcURL, ([[CFStringRef]]) methodName, kWSSOAP2001Protocol);
	
	[[WSMethodInvocationSetParameters]] (soapCall, ([[CFDictionaryRef]]) params,([[CFArrayRef]]) NULL);
	
	[[WSMethodInvocationSetProperty]] (soapCall, ([[CFStringRef]]) kWSHTTPExtraHeaders, ([[CFTypeRef]]) headers);
	result = ([[NSDictionary]] '') ([[WSMethodInvocationInvoke]] (soapCall));
		

if ([[WSMethodResultIsFault]] (([[CFDictionaryRef]]) result)) 
	
	[[NSLog]] (@"%@", result);//[resultField setStringValue: [result objectForKey: ([[NSString]] '') kWSFaultString]];	


else 
	[[NSLog]] (@"%@", result);	
	[resultField setStringValue: [result objectForKey: ([[NSDictionary]] '') kWSMethodInvocationResult]];	
	
	[params release];
	params = nil;
	} 



@end


</code>
----
These examples are great and I've been able to use these as a model to call my .NET web services, so thanks to everyone for contributing. I need to take things a little further, now.

So far all the examples are sending parameters objects as strings. Can someone post a sample that sends an array of strings (or even better a structure of some sort that includes an array of strings) as one of the parameters? I've tried a few things but I'm failing miserably.

Thanks, 
PH