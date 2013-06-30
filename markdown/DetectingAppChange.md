Is there a way in General/ObjC / Cocoa to detect that the current app has changed (and find out which app the user has changed to)?  Note that I don't just mean *my* app... I mean that I want to know whenever a user makes a new app active, and I want to know which app it is she activated.  The best I can come up with is an General/NSTimer/Applescript solution, but I don't really like that one because without making the timer frequency super-high, it will be wrong if the user switches too fast.  Thanks!

----

If you don't mind undocumented tricks, you can use the following code:
    
General/[[NSDistributedNotificationCenter defaultCenter] 
   addObserver:self
   selector:@selector(registerFrontAppChanged:)
   name:@"com.apple.General/HIToolbox.menuBarShownNotification"
   object:nil]

From there, you can use General/NSWorkspace to get information about the front application.

If you prefer documented tricks, you'll have to go to Carbon for it. But this works in 10.2 and 10.3, at least, and probably earlier General/OSes as well, and I would not be at all shocked if it continued to work in later General/OSes. -- General/MikeAsh

23 September 2004 - *Actually, it will stop working in Tiger, according to someone from Apple:* http://www.cocoabuilder.com/archive/message/2004/8/11/114301

----
I'm curious now as to how one figures out when the relevant notification names are if they are undocumented.  

*For distributed notifications you can use General/NotificationWatcher.*

I did a search on "com.apple.General/HIToolbox.menuBarShownNotification" and found this page:

http://www.unsanity.org/archives/000045.php

which has pretty much what you said, except it gives a few more notifications.  Would you suggest that I trap all of the notifications on this page?
----
Yes, I would. The code on that page is pretty much what the code in my program looks like. It may not be necessary, but it doesn't hurt to check more often than strictly necessary.

As far as finding out what the notifications are, there's a neat trick you can do. If you register for a nil object, you get all notifications with the given name regardless of the object. If you register for a nil name, you get all notifications with the given object regardless of the name. If you register with nil for both name *and* object, you will get *all* notifications zinging around the system. I assume that whoever figured this out the first time did that and just watch what notifications went by when he switched apps.

----

Does anyone know how to do this now that Tiger's broken the notification system?

*It has? How?* **Click the cocoabuilder.com link above.**

----

Here's a really simple example that does this using carbon-
When an app changes, it moves all of it's windows to the front. - General/GusMueller

    
#import <Carbon/Carbon.h>
#import "General/MyObject.h"


static General/OSStatus handleAppFrontSwitched(General/EventHandlerCallRef inHandlerCallRef, General/EventRef inEvent, void *inUserData);

@implementation General/MyObject

- (void) setupAppChangeNotification {
    
    General/EventTypeSpec spec = { kEventClassApplication,  
        kEventAppFrontSwitched };
    
    General/OSStatus err = General/InstallApplicationEventHandler(General/NewEventHandlerUPP(handleAppFrontSwitched), 1, &spec, (void*)self, NULL);
    
    if (err) {
        General/NSLog(@"Uh oh...");
    }
}

- (void) appDidChange {
    
    General/NSDictionary *activeAppDict = General/[[NSWorkspace sharedWorkspace] activeApplication];
    General/ProcessSerialNumber    psn;
    
    psn.highLongOfPSN = General/activeAppDict objectForKey:@"[[NSApplicationProcessSerialNumberHigh"] intValue];
    psn.lowLongOfPSN  = General/activeAppDict objectForKey:@"[[NSApplicationProcessSerialNumberLow"] intValue];
    
    // bring all windows to front.
    General/SetFrontProcess( &psn );    
}

- (void) awakeFromNib {
    [self setupAppChangeNotification];
}

@end

static General/OSStatus handleAppFrontSwitched(General/EventHandlerCallRef inHandlerCallRef, General/EventRef inEvent, void *inUserData) {
    [(id)inUserData appDidChange];
    return 0;
}

----
Gus, I can't get this example to work for a background process that does not use a nib file, and consequently never has -awakeFromNib called.  Calling -setupAppChangeNotification from the controller's init method does nothing.