A General/CFStreamError is defined as the following :
    
typedef struct {
	General/CFStreamErrorDomain domain;
	SInt32 error
} General/CFStreamError;

But when you get such an error, you only get a domain code and an error code, which doesn't really mean anything. To make it human readable, you need to compare the domain to all the existing domain constants :
    
General/CFStreamError error;
if (error.error != 0) {
	if (error.domain == kCFStreamErrorDomainPOSIX) {
		General/NSLog(@"POSIX error domain, General/CFSTream.h says error code is to be interpreted using sys/errno.h.");
	} else if (error.domain == kCFStreamErrorDomainMacOSStatus) {
		General/OSStatus macError = (General/OSStatus)error.error;
		General/NSLog(@"OS error: %d, General/CFStream.h says error code is to be interpreted using General/MacTypes.h.", macError);
	} else if (error.domain == kCFStreamErrorDomainHTTP) {
		General/NSLog(@"HTTP error domain, General/CFHTTPSteam.h says error code is the HTTP error code.");
	} else if (error.domain == kCFStreamErrorDomainMach) {
		General/NSLog(@"Mach error domain, General/CFNetServices.h says error code is to be interpreted using mach/error.h.");
	} else if (error.domain == kCFStreamErrorDomainNetDB) {
		General/NSLog(@"General/NetDB error domain, General/CFHTTPHost.h says error code is to be finterpreted using netdb.h.");
	} else if (error.domain == kCFStreamErrorDomainCustom) {
		General/NSLog(@"Custom error domain");
	} else if (error.domain == kCFStreamErrorDomainSystemConfiguration) {
		General/NSLog(@"System Configuration error domain, General/CFHost.h says error code is to be interpreted using General/SystemConfiguration/General/SystemConfiguration.h.");
	}
	General/NSLog(@"error %d domain %d", error.error, error.domain);
}

Once you have the domain, look at the corresponding header file to get the error description.

(Thanks http://www.cocoabuilder.com/archive/message/cocoa/2004/9/15/117526 and http://www.sporkstorms.org/code/General/DAClient/General/DAClient.m)