Does anyone know if there's a tool to spy on the various events a cocoa application might receive?   If anyone here is or used to be a win32 developer, i'm thinking of something along the lines of Spy++.

----

What kind of events? I've never seen Spy++ - is it something like General/NotificationWatcher?

---- 

Similar to that, i guess.  Spy++ will let you watch all incoming messages to any window you ask it to.   So for instance, if my selected window happens to be a button control, it would show the events for the mouse down, mouse up, singleclick, doubleclick, painting, et al using their standard window message names.   Things that aren't in the list of known api messages are shown as a their numeric value.

----

Maybe General/FScriptAnywhere is closer to what you want. There used to be something like this for OS<X, but it was never ported over.

----

oohhh wait i just remembered General/UIElementInspector - [http://www.apple.com/applescript/uiscripting/02.html] It doesn't log events but it's along the same lines.

----

A really handy mechanism is to set the General/NSTraceEvents default to "YES" for your application, then run it and watch the console. Example:    defaults write com.deallus.apps.points General/NSTraceEvents YES The output looks something like:

    
2005-01-29 09:38:05.536 points[23860] Received event: General/FlagsChanged at: 713.0,244.0 time: 24065 flags: 0x100108 win: 0 ctxt: 17c97
2005-01-29 09:38:05.537 points[23860]     In Application: General/NSEvent: type=General/FlagsChanged loc=(-533,265) time=103361.9 flags=0x100008 win=0 winNum=22098 ctxt=0x17c97 keyCode=55
2005-01-29 09:38:05.537 points[23860]     In Window: General/NSEvent: type=General/FlagsChanged loc=(-533,265) time=103361.9 flags=0x100008 win=0 winNum=22098 ctxt=0x17c97 keyCode=55
2005-01-29 09:38:05.537 points[23860] timeout = 62985277314.463295 seconds, mask = ffffffff, dequeue = 1, mode = General/NSModalPanelRunLoopMode
2005-01-29 09:38:05.741 points[23860] Received event: General/KeyDown at: 713.0,244.0 time: 24065 flags: 0x100108 win: 0 ctxt: 17c97 data: 0,0,0,100,2,100
2005-01-29 09:38:05.742 points[23860]     In Application: General/NSEvent: type=General/KeyDown loc=(-533,265) time=103362.1 flags=0x100008 win=0 winNum=22098 ctxt=0x17c97 chars="d" unmodchars="d" repeat=0 keyCode=2
2005-01-29 09:38:05.779 points[23860] timeout = 0.000000 seconds, mask = 20000, dequeue = 1, mode = General/NSGraphicsRunLoopMode


----

As with any user default key, you can also set it on the command line for a particular session:

    /Path/To/General/MyApp.app/Contents/General/MacOS/General/MyApp -General/NSTraceEvents YES