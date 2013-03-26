

The [[SystemConfiguration]] framework has several uses:

Checking if the user is currently connected to the internet (see [[CheckingOnlineStatus]]).
Managing persistent and current network (and other) settings.
Get proxy settings/the name of the computer/the name of the current console user (this will probably change in 10.3 with [[FastUserSwitching]]).

Apple has some sample code called [[MoreSCF]] for common operations such as creating and manipulating locations, services ("ports"), etc. It is available at http://developer.apple.com/samplecode/Sample_Code/Networking/[[MoreSCF]].htm

Documentation is at http://developer.apple.com/documentation/Networking/Conceptual/[[SystemConfigFrameworks]]/index.html

----

Accessing the current proxy settings:

<code>
#include <[[SystemConfiguration]]/[[SystemConfiguration]].h>

[[NSDictionary]] ''proxies = ([[NSDictionary]] '')[[SCDynamicStoreCopyProxies]](NULL);

BOOL [[HTTPEnabled]] = [[proxies objectForKey:([[NSString]] '')kSCPropNetProxiesHTTPEnable] boolValue];
[[NSString]] ''[[HTTPHost]] = [proxies objectForKey:([[NSString]] '')kSCPropNetProxiesHTTPProxy];
[[NSString]] ''[[HTTPPort]] = [proxies objectForKey:([[NSString]] '')kSCPropNetProxiesHTTPPort];
</code>


replace kSCPropNetProxiesHTTPProxy with kSCPropNetProxiesHTTPSProxy, kSCPropNetProxiesFTPProxy or whatever to get the other settings.

----

See [[NotificationOnNewNetwork]] for more info & notification handling in [[SystemConfiguration]].

----

On Mac OS X 10.4.3, when I use:

<code>
#include <[[SystemConfiguration]]/[[SystemConfiguration]].h>
[[NSDictionary]] ''proxies = ([[NSDictionary]] '')[[SCDynamicStoreCopyProxies]](NULL);
</code>

proxies contains the expected proxy information. However, running the same code on 10.3.9 or 10.2.8, proxies = NULL. Apple's [[TechNote]] on this ( http://developer.apple.com/qa/qa2001/qa1234.html ) says it's compatible back to 10.2. Am I missing something?