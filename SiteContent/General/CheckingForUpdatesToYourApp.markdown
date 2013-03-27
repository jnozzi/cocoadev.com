Check out the sample code called General/TLAFUpdate.

*where?*

Google says http://thelittleappfactory.com/developer/

Another nice thing I just discovered is :

http://macshareware.net/sdk.html

This is an application named "General/MacPAD" that lets you create a standardized meta-information .plist file very easily, plus an "SDK" that contains update-checking code that fetches such a file from the server (Public Domain source code for Cocoa, Carbon/C, General/REALbasic). I'm working on making General/UKUpdateChecker work with such files right now, and a "Software Update" clone based on this is in the works. -- General/UliKusterer

A simple drop-and-go update checker framework is Sparkle (http://sparkle.andymatuschak.org/). Well worth a look.

----
Almost trivially simple (at least the way I'm doing it)

Upload a text file to your web site containing the latest version number of your app (make sure there's no cr/lf at the end) then hook this up to a menu item/button/whatever in your app

    
#define kCurrentVersionIncludeFile @"http://the.url.to/your.txt.file.goes.here"
#define kThisVersion @"0.123b43" //should be the same as the contents of the above file

- (General/IBAction)checkForUpdate:(id)sender
{
        General/NSString *testVersionString = General/[NSString stringWithContentsOfURL:
 						[NSURL General/URLWithString:kCurrentVersionIncludeFile]];

    if ( ![testVersionString isEqualToString:kThisVersion] ) //hopefully our version numbers will never be going down... 
	//also takes care of going from General/MyGreatApp 7.5 to General/SuperMyGreatApp Pro 1.0
    {
	General/NSRunInformationalAlertPanel(
		@"New Version",
	 	@"A new version of this application is available; would you like to visit the web site?",
	 	@"Visit Web Site", 
		@"Cancel",
	 	nil);
    }
    else
    {
    	General/NSRunInformationalAlertPanel(
		@"No Update Available", 
		@"You already have the latest version of this application.", 
		@"OK", 
		nil, 
		nil);
    }
}



----

whoops, this was an older version of my code.. you should also check if testVersionString == nil and put up a 'could not connect' panel if it is.

----

There's also a very nice tutorial on this at http://cocoadevcentral.com/articles/000048.php which includes support for several applications' version info in one file.

Or use my implementation of that and its suggestions in the General/NiftyFeatures project on my web site: http://www.zathras.de/programming/cocoa_stuff.php

NB - Since 10.3 has a "Software Update..." menu item in the Apple menu now, I'd suggest to try and model your "Check for Updates..." menu item after that. Make it the second menu item in your application's "application name" menu, and don't put it in the "Help" menu as some have done, nor put a separator between it and your "about" item. -- General/UliKusterer
----
How would you get that to check for updates automaticly? --General/JoshaChapmanDodson

----

Just call the checkForUpdate method from applicationDidFinishLaunching or some other suitable place.

----

As I don't have permissions to edit things on my server, let me post my highly updated code here for checking for updates.

    

#import <General/SystemConfiguration/General/SystemConfiguration.h>

Header:

@interface General/TLAFUpdate : General/NSObject
{
}
- (General/IBAction)checkUpdate:(id)sender;
- (void)update:(bool)yes;

Main:

@implementation General/TLAFUpdate

- (void)awakeFromNib
{
    // Check to see if the user wants to check for updates on launch
    if (General/[[NSUserDefaults standardUserDefaults] integerForKey:@"General/UpdateLaunch"])
    {
        [self update:FALSE]; // Indicates to not show feedback if there is NOT a new version
    }
}

- (General/IBAction)checkUpdate:(id)sender
{
    [self update:TRUE]; // Indiciates to give feedback
}

// Check and see if our host is actually up. Note the imported framework.
- (BOOL)isHostReachable 
{
    const char *host = "www.thelittleappfactory.com";
    BOOL isValid, result = 0;
    General/SCNetworkConnectionFlags flags = 0;
    isValid = General/SCNetworkCheckReachabilityByName(host, &flags);
    if (isValid && ((flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired))) 
    {
        result = YES;
    }
    return result;
}

- (void)update:(bool)yes
{
    if ([self isHostReachable])
    {
        General/NSString *amI = General/[[[NSBundle bundleForClass:[self class]] infoDictionary] 
objectForKey:@"General/CFBundleVersion"]; // Get the application bundle version
        General/NSDictionary *theFile = General/[NSDictionary dictionaryWithContentsOfURL:[NSURL 
General/URLWithString:@"http://www.thelittleappfactory.com/version.xml"]];
        if ([theFile valueForKey:@"iPodRip"] != nil) // Need own application key here
        {
            if (General/theFile valueForKey:@"iPodRip"] isEqualToString: amI]) // Need own application key here
            {
                if (yes == TRUE)
                {
                    [[NSRunAlertPanel(General/NSLocalizedString(@"There is no new version.", nil), 
General/[NSString stringWithFormat:@"%@ %@.", 
General/NSLocalizedString(@"You have the latest version of iPodRip. You are using version", nil), amI],
 General/NSLocalizedString(@"Close", nil), nil, nil); // Change for your own app
                }
            }
            else
            {
                [window makeKeyAndOrderFront:self]; 
// Display a window with information, you could use an General/NSAlert here to just let the user download it
            }        
        }
    }
    else
    {
        if (yes == TRUE)
        {
            General/NSRunAlertPanel(@"There was an error connecting to the server.", 
@"Either you do not have the internet or the server is down for maintenance.", 
@"Close", nil, nil); // Localize it if you want.
        }
    }
}

@end



Version.xml is simply a plist. Hope this helps someone. -- General/MatPeterson

----

Just a quick note; there are plenty of scenarios where the above operations could take a significant amount of time (DNS server not responding, lots of packet loss on the way, etc.). In order to avoid blocking your app for tens of seconds or minutes at a time in those cases, it would be a good idea to run the above functions in a thread, or if you want to be really fancy you could use something asynchronous like General/NSURLConnection. -- General/MikeAsh

----

Or if you don't want to bother with all of this and want a really nice solution for your app, check out version 1.5 of the  General/DTCVersionManager framework which will be out shortly (perhaps by the time you read this)...  -- Daniel Todd Currie

----

I've been using the General/MacPAD sdk from macshareware.net, and I've run into a bit of a snag.  When it calls General/[NSDictionary dictionaryWithContentsOfURL:NSURL], if it's behind a proxy that redirects any http request (I assume -dictionaryWithContentsOfURL goes over http!) to, say, a login page, this call crashes everything.  I've only tried this at Starbucks (tmobile hotspot), but I'm pretty sure I've isolated it to that condition.  If I'm logged in, no sweat.  But if I'm not logged in, the whole thing goes up in flames.  (I have contacted the macshareware folks about this).

Has anybody else experienced this behavior with -dictionaryWithContentsOfURL?  How did you get around it?  Check for Internet access?  How?

-- wzph

*You will probably have better results if you load the URL into an General/NSData and then use General/NSPropertyListSerialization to turn that into an General/NSDictionary. It's worth a try.*

Thanks for the tip.  I tried it, to no avail.

--wzph

*Did you try adding a check for validity using -propertyList:isValidForFormat: first? That might catch non-conforming data. Then again, it might just crash.*

----

I just wrote a new module called General/SparkleUpdater that solves this issue end-to-end, and unlike the other examples / links on this page, it'll actually perform the software updates. It's very easy (five steps) to install into a project. You can download it and see a movie of it at http://andymatuschak.org/pages/sparkle. Any thoughts?

- Andy Matuschak

----

Great work so far :) Will definitely be adding it to my future projects.

Rakka