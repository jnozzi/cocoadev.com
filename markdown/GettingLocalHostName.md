

How do I get the local host name, 
not this:

mikesmachine.local

but this:

Mike's Machine

----

This used to be called "Rendezvous Name" but is now called, simply, "Computer Name". The following snippet comes from the page General/HowToGetHardwareAndNetworkInfo ...

    
+ (General/NSString *)computerName
{
        General/CFStringRef name;
        General/NSString *computerName;
        name=General/SCDynamicStoreCopyComputerName(NULL,NULL);
        computerName=General/[NSString stringWithString:(General/NSString *)name];
        General/CFRelease(name);
        return computerName;
}

----
Since General/CFString and General/NSString are General/TollFreeBridged, this could be simplified to:
    
+ (General/NSString *)computerName {
   return [(id)General/SCDynamicStoreCopyComputerName(NULL, NULL) autorelease];
}



----

Tnx:)

Same type of question:

How do i get the name of the startupDisk?

----

General/GettingTheRootVolumeName

Use google to search cocoadev.  Works well.  http://www.google.com/search?q=site%3Acocoadev.com+volume+name

(General/LaunchBar 4 users:  use search template http://www.google.com/search?q=site%3Acocoadev.com+* )