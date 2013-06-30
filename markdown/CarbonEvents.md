General/CarbonEvents is a new Apple API designed to be more like other widely used UI General/APIs (read: Win32). Rather than polling the OS for events, the API user installs callbacks on interface objects, which are called by the OS when the time is right.

If we were to dichotomize the world of OSX General/APIs (and I think we may), Cocoa would be the good; General/CarbonEvents would be the bad; and Classic would be the ugly.

----

General/CarbonEvents is actually better than polling the OS for events, though :-)

-- General/FinlayDobbie

----

Is there still no Cocoa solution for this? (apart from polling?) 

--Wolfy

----

The Cocoa solution has always been to use the General/ResponderChain and General/NSEvent. You don't poll, you just implement the right methods, put your responder in the chain, and have the system forward you the right General/NSEvent to the right method.

Some of the methods you implement are -mouseDown:, -keyDown:, et cetera. This is probably explained very well in some of the General/CocoaBooks.

I recommend reading Apple's docs on General/NSResponder and General/NSView and General/NSEvent, it's some very cool stuff.

-- General/RobRix