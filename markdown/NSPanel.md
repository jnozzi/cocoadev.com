A sub-class of General/NSWindow, documented at http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSPanel_Class/Reference/Reference.html.

----

General/NSPanel**'s should be used for floating palettes or toolbars, and that's it. They don't show up in the Window menu, they disappear when the app becomes inactive, and they show up in the responder chain before the main window does. -- General/DustinVoss

----

They're also acceptable (actually intended) for application-modal alerts. Generally speaking application-modal alerts are strongly discouraged under OS X, but sometimes they're appropriate. For example, in a beta release of a program I'm working on, there is a general-purpose "holy crap" handler that attempts to catch wild exceptions and "can't happen" conditions. When it fires, it posts an application-modal fatal error alert telling the user what happened and where to find the crash dump. I use an General/NSPanel for this.

(General/JeffHarrell)

----

In my application I also find General/NSPanel's very useful as the main window.  My application provides a small window for doing text translation and semantically General/NSPanel is superior because it is supposed to be used with other applications as a panel.  That is kind of like stickies.app which are look closer to a utility window then General/NSWindow.

However, to use General/NSPanel as the main window isn't very easy.  I needed to subclass it and:


* override      canBecomeMainWindow  to return      YES 
*      setHidesOnDeactivate:NO 
* override      isExcludedFromWindowsMenu  to return      NO 
* call in      awakeFromNib: 

    General/[[NSApplication sharedApplication] addWindowsItem:self
					    title:[self title]
				         filename:NO];



All this just to get the look of a utility panel.  I wish there was an easier way. -- General/DevinBayer

*the look of a utility panel should signal the behavior of a utility panel. if your window is going to behave exactly like a General/NSWindow, it should be one and look like one.*

----
Should "Preferences" be implemented as a panel or a window?  I say panel.  Any reason to choose otherwise?

----

How do I create an General/NSPanel from code? IB has a "Utilty window" checkbox for a window, but I don't see anywhere how to set that in code. Any ideas?

----
To create an General/NSPanel from code, do the same as you would for an General/NSWindow but change the class name. For "Utility window", General/NSUtilityWindowMask.

----

Thanks, I had it all there except for the General/NSUtilityWindowMask :) -- in case others get stuck, here's the code:

    
_panel = General/[[NSPanel alloc] initWithContentRect:panelRect
    styleMask:General/NSTitledWindowMask | General/NSClosableWindowMask | General/NSUtilityWindowMask
    backing:General/NSBackingStoreBuffered defer:YES];
