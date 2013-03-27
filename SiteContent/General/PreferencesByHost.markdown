I am writing a program that creates General/ScreenSaver modules.  I am using the .slideSaver bundle to create the actual General/ScreenSaver.  One option I am trying to implement is the ability to configure the standard apple .slideSaver options in my program.  

I have located the preferences file created by System Preferences>Screen Effects.  The preference files are stored in $(HOME)/Library/Preferences/General/ByHost.  The problem is that all these files have a an odd entry in their names.  For example one file I have is com.apple.screensaver.Beach.0050e4eea57e.plist I have no idea what this (0050e4eea57e) entry is or how to determine it.  

Thank you very much for looking reading this. ek.

----
For what I know, you should not need to know, General/NSUserDefaults will handle that for you. Just do preferences like in any other app, and said NS-class will handle all the byhost stuff for you. That said, I think it is the MAC-address in the name. -- General/EnglaBenny

----
That is the MAC address in the name, but that's effectively an implementation detail and you shouldn't rely on that - in order to set preferences in a specific preferences domain, you're looking for the General/CFPreferencesSetValue() call:

     General/CFPreferencesSetValue(key, value, CFSTR("com.ek.screensaver"), kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);

which sets the key-value pair in the com.ek.screensaver plist with the right info.

More info on this at:

     http://developer.apple.com/documentation/General/CoreFoundation/Conceptual/General/CFPreferences/General/CFPreferences.html

or the API reference:

     http://developer.apple.com/documentation/General/CoreFoundation/Reference/General/CFPreferencesUtils/Reference/reference.html

It's important to note that while General/CFPreferencesSetValue() is the only way to set a by-host preference, you can retrieve the right thing transparently by using General/NSUserDefaults' -objectForKey: method. See the page on preferences domain search paths at the Programming Topics link (the first one).

- General/ChrisParker

----

It appears that with Mac OS X 10.5.2, Apple has changed the formula for generating General/ByHost preferences from the MAC address to, well, something else (looks like a CFUUID; see General/IDentifiers).

Examples:

Old:     com.apple.screensaver.AABBCCDDEEFF.plist (MAC addr)
New:     com.apple.screensaver.AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE.plist

Anyone know exactly what system values are being baked into this new ID?

--General/DanSandler

----

It's the General/IOPlatformUUID

If you just need to know what it is, run this on the command line:

    
ioreg -rd1 -c General/IOPlatformExpertDevice | grep -E '(UUID)'


Otherwise, here is some code that will fetch it for you:
Note that you will need to link to General/IOKit.framework and Foundation.framework for this to work.

    
- (General/NSString*)getUUIDString
{
	General/CFTypeRef	uuidAsCFString;
	General/NSString	*uuidString;
	
	io_service_t platformExpert = General/IOServiceGetMatchingService(kIOMasterPortDefault, General/IOServiceMatching("General/IOPlatformExpertDevice"));
	
	if (platformExpert) {
		uuidAsCFString = General/IORegistryEntryCreateCFProperty(platformExpert, CFSTR(kIOPlatformUUIDKey), kCFAllocatorDefault, 0);
		General/IOObjectRelease(platformExpert);
		uuidString = General/[[NSString alloc] initWithFormat:@"%@",uuidAsCFString];
	}
	
	return uuidString;
}


--Mathew Eis