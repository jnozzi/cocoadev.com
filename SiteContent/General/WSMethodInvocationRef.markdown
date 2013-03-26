[[WSMethodInvocationRef]] is the data structure used when making XMLRPC or SOAP calls from C. The structures and related functions are C-language functions, but of course you can use them within Objective-C code.

Here is an example of how to build a SOAP request and call it. Of course there are problems that we'll discuss afterward...
<code>NSURL                 ''soapURL;
[[WSMethodInvocationRef]]  soapCall;
[[NSString]]              ''methodName;
[[NSMutableDictionary]]   ''params;
[[NSDictionary]]          ''result;

soapURL    = [NSURL [[URLWithString]]:
    @"http://ws.cdyne.com/psaddress/addresslookup.asmx"];
methodName = @"[[AdvancedCheckAddress]]";
params     = [[[[[NSMutableDictionary]] alloc] init] retain];

[params setObject:@"123 Main St" forKey:@"AddressLine1"];
[params setObject:@""            forKey:@"AddressLine2"];
[params setObject:@"Springfield" forKey:@"City"];
[params setObject:@"OH"          forKey:@"State"];
[params setObject:@"12345"       forKey:@"[[ZipCode]]"];
[params setObject:@"0"           forKey:@"[[LicenseKey]]"];

soapCall = [[WSMethodInvocationCreate]](
    ([[CFURLRef]])soapURL,
    ([[CFStringRef]])methodName,
    kWSSOAP2001Protocol );

[[WSMethodInvocationSetParameters]](
    soapCall,
    ([[CFDictionaryRef]])params,
    NULL );

[[WSMethodInvocationSetProperty]](
    soapCall,
    kWSSOAPMethodNamespaceURI,
    ([[CFTypeRef]])@"http://ws.cdyne.com/" );


result = ([[NSDictionary]] '')[[WSMethodInvocationInvoke]]( soapCall );

[[NSLog]]( @"Result: %@", result );

[params release];
params = nil;</code>

Aside from the fact that there's a fake address in there, this will fail because this particular SOAP server really, really insists on having a [[SOAPAction]] HTTP header, and I've not yet figured out how to make that happen (see [[WSMethodInvocationRefAndSOAPActionHTTPHeader]] discussion).

Still, you can use this on other SOAP servers possibly, or even with an XMLRPC call, which is a little different.

For an XML-RPC call, instead of using the kWSSOAP2001Protocol constant above you use kWSXMLRPCProtocol. Also the order of the parameters matter in an XMLRPC call. You pass those as a [[CFArrayRef]] as the last argument of [[WSMethodInvocationSetParameters]]. You also '''do not''' set a method namespace (just miss out the call to [[WSMethodInvocationSetProperty]]).

Apple's documentation begins here:
http://developer.apple.com/documentation/Networking/Conceptual/[[WebServices]]/

----

Useful XML-RPC example here:

http://ranchero.com/cocoa/xmlrpcdemo/

The only differences from a SOAP call are those noted above.


----

I added a tutorial on Cocoa XML-RPC client tutorial at [ http://www.scottydelicious.com/blog/cocoa_xmlrpc.html ] . It goes over passing multiple parameters in a call to a server as well as handleing a response that contains values of different types (string, int, NULL, etc..). You can download the Xcode (2.4) project and all associated source files.

-sD-
Dr. Scotty Delicious, Scientist.