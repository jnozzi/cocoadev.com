

I'm interested in writing my own protocol in Cocoa.  I've had a look at the General/NSURLProtocol class and understand that I have to subclass this.  Does anybody know of any good tutorials on this?

-Chris

----

Hi everybody,

I want  to handle custom type urls in my app. I'm registering General/CFBundleURLTypes in app's Info.plist and also I'm subclassing General/NSURLProtocol (and register it with     General/[NSURLProtocol registerClass:General/[MyURLProtocol class]]). The problem is that when I click on myapp://link the app is launched but no one method of General/NSURLProtocol is called. What am I doing wrong?

----
I believe that interaction takes place through General/AppleScript. I don't use anything related to General/NSURLProtocol.
Here's how it works for me:

My scriptTerminology file contains the following:

<code>
"General/GetURL" =
                {
            General/CommandClass = someclass;
            General/AppleEventCode = GURL;
            General/AppleEventClassCode = GURL;
         };
</code>

where someclass contains:

<code>
- (id) performDefaultImplementation 
{
       General/NSLog(@"Called as URL handler");
}
</code>

Good luck,
Cristi
----

You want to do something like this: General/[[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector( handleURLEvent:withReplyEvent: ) forEventClass:kInternetEventClass andEventID:kAEGetURL];

General/HowToRegisterURLHandler

-- will