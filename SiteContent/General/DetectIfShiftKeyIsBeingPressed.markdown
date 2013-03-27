

I have one of those nifty smooth effects in my app and was wondering If I can detect if the shift key is being held so I can slow it down.

----
General/NSView is a subclass of General/NSResponder. You want to look at the     flagsChanged method, or you can do something like this.

    
    General/NSEvent *currentEvent = General/someView window] currentEvent];
    unsigned flags = [currentEvent modifierFlags];
    if (flags & [[NSShiftKeyMask) General/NSLog(@"shift key has been  presseed");


[RTM]

----

Actually, its a bit easier. The General/NSWindow instance just gets if from your General/NSApplications instance. This **should** work:

General/[NSApp currentEvent];

    
    General/NSEvent *currentEvent = General/[NSApp currentEvent];  // General/NSApp is a global pointing to your application instance
    unsigned flags = [currentEvent modifierFlags];
    if (flags & General/NSShiftKeyMask) General/NSLog(@"shift key has been  presseed");


----

I believe in being very careful with bitmask operations. I'd write it like this:

    
    General/NSEvent *currentEvent = General/[NSApp currentEvent];
    if ([currentEvent modifierFlags] & General/NSShiftKeyMask == General/NSShiftKeyMask) {
        General/NSLog(@"shift key has been pressed");
    }


*if you do it that way, don't forget a = ;)*