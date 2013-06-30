

Is there a way to determine the current version of a Framework? For example I'd like to check if General/WebKit is of a minimum version in my code.

I've looked at the General/NSApplication version info, but that only seems to indicate up to 10.2.3, and seems specific to General/NSApp class only.

----

Get an General/NSBundle pointing to the framework (using     +bundleWithIdentifier: is probably the best route) and then look at the General/CFBundleVersion in its info dictionary.

*Ah, yes! Works perfectly:*
    General/NSLog(@"General/WebKit v.%@",General/[[[NSBundle bundleWithIdentifier:@"com.apple.General/WebKit"] infoDictionary] valueForKey:@"General/CFBundleVersion"]);
