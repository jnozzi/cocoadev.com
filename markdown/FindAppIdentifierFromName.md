is there a way i could find the identifier for an application by it's name.  i.e. "iCal" would return com.apple.ical or whatever.

thanks!
----
General/NSWorkspace has a lot of system-user methods. In this case, you probably want to do something like this. --General/JediKnil
    
General/NSString *identifier = General/[[NSBundle bundleWithPath:General/[NSWorkspace fullPathForApplication:@"iCal"]] bundleIdentifier];
