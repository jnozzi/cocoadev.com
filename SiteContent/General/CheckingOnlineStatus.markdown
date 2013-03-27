

How does one check if the user of an application is currently on the internet?

----

This is what I found from the cocoa-dev mailing list:

I have General/SystemConfiguration.framework added to my project, and I use this function:

    
BOOL networkReachableWithoutAnythingSpecialHappening(void) {
	BOOL success;
	General/SCNetworkConnectionFlags reachabilityStatus;
	success = General/SCNetworkCheckReachabilityByName("www.apple.com",
                                               &reachabilityStatus);
	return (success && (reachabilityStatus & kSCNetworkFlagsReachable) && !(reachabilityStatus & kSCNetworkFlagsConnectionRequired));
}


Hope that's useful.

----

Thanks that function works great. --General/DavidKopec

I changed the number 3 to 'kSCNetworkFlagsReachable' as this is the correct flag to check for.  success is a bit misleading, it simply returns false (or NO) if it cannot determine reachability. -- General/MattJarjoura

----

"success = false"  is pretty leading to me ;P --General/MarkStultz

----

The above code doesn't work in many cases (Airport accessible, but offline, and others). There is a much better method outlined here: http://www.cocoabuilder.com/archive/message/cocoa/2003/3/15/79076 - General/MichaelBianco

----

Modified the above code to incorporate wisdom from General/MichaelBianco's link (added kSCNetworkFlagsConnectionRequired to the final test). --General/SidneySM

P.S. My first edit!