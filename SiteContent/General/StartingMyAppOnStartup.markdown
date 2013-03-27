First, some terminology:



*startup item: these run before a user logs in
*login item: these run after a user logs in. Each user has a different set of login items.



The difference is very important.  This article is about login items.

Over the years, many developers have wanted their apps to run at login.  For a long time, there was no supported API to do this and various hacks were used.  As of this writing, the best-practice depends on which OS version your app is running under:



*For 10.5 or later use the General/APIs in General/LaunchServices/General/LSSharedFileList.h.  

*For 10.2 or later use Apple's General/LoginItemsAE sample code (<http://developer.apple.com/samplecode/General/LoginItemsAE/index.html>) or General/UliKusterer's Cocoa wrapper General/UKLoginItemRegistry (<http://www.zathras.de/angelweb/sourcecode.htm#General/UKLoginItemRegistry>)



Apple's documentation also details a great number of different ways to execute code at login and logout. Note that although this page doesn't say so, launchd user agents are completely broken on 10.4 and should be avoided:
<http://developer.apple.com/documentation/General/MacOSX/Conceptual/General/BPSystemStartup/Articles/General/CustomLogin.html>

If you want to programatically determine at runtime if your app was launched because it is a login item, see General/KnowingIfAppWasLaunchedFromLoginItems.