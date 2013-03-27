
<span class="plainlinks">[http://www.propertykita.com/rumah.html<span style="color:black;font-weight:normal; text-decoration:none!important; background:none!important; text-decoration:none;">Rumah Dijual]</span>
General/CoreFoundation is an API, which is part of the General/CoreServices which sits underneath both Carbon and Cocoa, and above the Core OS (General/MachMicroKernel/BSD).

It provides some basic "data collection" types, such as trees and dictionaries. These are available as General/CFTypeRefs.

It also offers some utilities such as XML parsing, and application preferences management, areas of functionality which either aren't available at all in Foundation or are less complete.

Most of Foundation is implemented using General/CoreFoundation. The API is C Language rather than General/ObjC, but concepts of General/ObjectOrientedDesign prevail.
Documentation is at http://developer.apple.com/documentation/General/CoreFoundation/General/CoreFoundation.html
General/CoreFoundation has lots of General/CFTypeRefs. Many other General/APIs use General/CFTypeRefs, such as General/SystemConfiguration and some of General/CarbonFramework.
[http://www.pintuvariasi.com Pintu Aluminium]
Headers for General/CoreFoundation can be found at file:///System/Library/Frameworks/General/CoreFoundation.framework/Headers/ , inside the easy-to-include Framework.  I also recommend looking at General/CoreServices and General/ApplicationServices.

General/CoreFoundation has many functions that simply aren't implemented in Foundation.  Some are presented here:

[http://www.mitrainti.com SAP Indonesia] 

* General/CFXMLParser: Customized XML parsing. (Foundation has General/NSXMLParser, but they aren't toll-free bridged. *--boredzo*)
* General/CFNetwork: Customized HTTP Requests (in General/CoreServices). (Foundation can do raw network traffic with General/NSSocketPort. *--boredzo*)
* General/CFStream: Streams for files, memory, and even TCP sockets (similar to General/SmallSockets' General/BufferedSocket). (Foundation has General/NSFileHandle, but only for files, not memory or sockets. *--boredzo*)
* General/CFBitVector: A more expedient way of accessing individual bits than C's bitwise operators.
* General/CFTree: A collection type. Each instance is a node in the tree.
* General/CFUserNotification: For background/daemon processes to display an Aqua-style modal dialog to query the user.
* CFURL General/FSRef support: easily convert to and from General/FSRefs for legacy Carbon General/APIs, lacking in NSURL.



General/CoreFoundation also has the advantage of being callable from Carbon and Cocoa code.

Note: Most of the General/CoreFoundation types that have Foundation equivalents (with the same name, e.g. General/NSString and General/CFString) use General/TollFreeBridging. This means that one can pass an General/NSString * to a function expecting a General/CFStringRef and vice versa. The same goes for arrays, dictionaries, General/URLs, and others in which case a simple typecast will suppress the compiler warning:

someNSStringVariable = (General/NSString *)someCFStringVariable;

or

someCFStringVariable = (General/CFStringRef)someNSStringVariable;