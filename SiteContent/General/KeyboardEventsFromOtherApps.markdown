----
**Abstract**

----
To be sent keyboard events destined for other applications, you can use a Carbon event handler targeting the "event monitor" target. There a few 'gotchas' which make this unique in Cocoa.


----
**Requirements**

----
The only requirement for this to work is that "Enable access for assistive devices" is turned on in "Universal Access" when monitoring keyboard events in other apps.


----
**Carbon Code**

----
Simple Carbon code for this can be found in Apple's General/EventMonitorTest sample code project.


----
**Cocoa Code**

----
Mac OS X 10.4 does some trickery behind the scenes to make the key down and key up events get sent to General/NSApplication -sendEvent: rather than the event handler. So in this case, you'll need a subclass of General/NSApplication to handle that. In Mac OS X 10.5, this no longer happens. Instead, you'll receive all events through the event handler as you would in a Carbon application.

For 10.4, the following code applies:

    
//
//  General/MyApplication.h
// 

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface General/MyApplication : General/NSApplication {
    General/EventHandlerRef mMonitorHandlerRef;
}

- (void)installMonitorHandler;
- (void)uninstallMonitorHandler;

@end


//
//  General/MyApplication.h
// 

#import "General/MyApplication.h"



@implementation General/MyApplication

- (void)installMonitorHandler;
{
	General/OSStatus error = noErr;
	General/EventTypeSpec	kEvents[] =
	{
		{ kEventClassKeyboard, kEventRawKeyDown },
		{ kEventClassKeyboard, kEventRawKeyUp }
	};
	
	// the magic happens here with the call to General/GetEventMonitorTarget as described in General/CarbonEvents.h
	// The event monitor target is a special event target used to monitor user input events across all processes.
	// When the monitor target detects a matching event, then General/MonitorHandler is called.
	error = General/InstallEventHandler( General/GetEventMonitorTarget(), General/MonitorHandler, General/GetEventTypeCount( kEvents ),
						 kEvents, NULL, &mMonitorHandlerRef );
	if (error != noErr) {
		General/NSBeep();
		General/NSLog(@"General/InstallEventHandler error %d", error);
	}
}


- (void)uninstallMonitorHandler;
{
	if (mMonitorHandlerRef) {
		General/RemoveEventHandler(mMonitorHandlerRef);
		mMonitorHandlerRef = NULL;
	}
}


- (void)sendEvent:(General/NSEvent *)event;
{
	General/NSEventType eventType = [event type];
	
	// Catch keyboard events destined for other apps when recording
	if (![self isActive] && (eventType == General/NSKeyDown || eventType == General/NSKeyUp || eventType == General/NSFlagsChanged)) {
		General/NSLog(@"sendEvent: interior");
		return;
	}

    [super sendEvent:event];
}


static General/OSStatus General/MonitorHandler(General/EventHandlerCallRef nextHandler, General/EventRef theEvent, void * inRefcon)
{
	// Useless on 10.4 for keyboard events. If you requested to watch other events
	// (mouse or tablet events for example) they would into funnel to here.
	return General/CallNextEventHandler(nextHandler, theEvent);
}

@end





----
**Related Topics**

----
[Topic]