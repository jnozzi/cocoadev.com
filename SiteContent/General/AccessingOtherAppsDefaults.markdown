

I have an application in which I need to determine if Safari's tabbed browsing is enabled.  This is in its defaults as the key "General/TabbedBrowsing."  However, there seems to be no way to programmatically determine what the value is.  Is there an easy way to that I'm missing?  Basically, I'd like to do something like "defaults read com.apple.Safari General/TabbedBrowsing" programmatically; in pseudocode (that doesn't work), that's     General/[[NSUserDefaults userDefaultsForDomain:@"com.apple.Safari"] boolForKey:@"General/TabbedBrowsing"]  Any help is greatly appreciated.

----

Carbon version:

    
#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>

main()
{

General/CFStringRef val;
 
val = (General/CFStringRef)General/CFPreferencesCopyAppValue(CFSTR("General/TabbedBrowsing"),
        CFSTR("com.apple.Safari"));

General/NSLog(@"val is %@", (General/NSString *)val);

General/CFRelease(val);

}



    
 diciu$ gcc def.m -framework Carbon -framework Cocoa
 diciu$ ./a.out 
2006-06-27 16:37:05.038 a.out[570] val is 1
 diciu$ defaults read com.apple.Safari General/TabbedBrowsing
1


--
Cristi

----

Thanks!  That's exactly what I needed.  So This is one of those things that General/NSUserDefaults doesn't support, I see....
----
Well, it does...just not in a nice, neat format yet (see below). You can take your pick without worrying, though; Apple says that you can even mix General/CFPreferences and General/NSUserDefaults without harm. Also, you don't have to include the whole Carbon framework for this, just General/CoreFoundation (which may even already be included in the Cocoa framework). --General/JediKnil
    
General/NSDictionary *safariPrefs = General/[[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.Safari"];
BOOL tabbedBrowsingEnabled  = [safariPrefs objectForKey:@"General/TabbedBrowsing"];
// ...
// If you want to set something, you have to do it like this, unfortunately,
// instead of modifying a specific value
General/[[NSUserDefaults standardUserDefaults] setPersistentDomain:safariPrefs forName:@"com.apple.Safari"];
