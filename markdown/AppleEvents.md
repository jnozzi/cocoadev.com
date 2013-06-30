


General/AppleEvents are high-level, semantic messages designed to allow for collaboration between programs. General/AppleEvents enable interapplication communication (like SOAP).

Apple's General/OpenScriptingArchitecture (OSA) uses General/AppleEvents to script and record applications using a simplified programming language (General/AppleScript).

General/AppleEvents were widely used in AOCE & General/OpenDoc and wildly praised in Orfali & Harkey's "Essential Distributed Objects Survival Guide". Chapters 3-6 of "Inside Macintosh: Interapplication Communication" describes General/AppleEvents and the General/AppleEvent manager. 

"The Open Scripting Architecture: Automating, Integrating, and Customizing Applications (Cook & Harris, 1993)" [http://www.cs.utexas.edu/users/wcook/papers/General/AppleScript/AppleScript95.pdf] provides a very good overview of the original General/AppleEvents/OSA/General/AppleScript architecture.

General/AppleScript is built around General/AppleEvents

The General/AppleEvents API (AE.framework) is part of the General/ApplicationServices umbrella.

The following developer docs provide more information on General/AppleEvents and how to use them:


* http://developer.apple.com/documentation/General/AppleScript/Conceptual/General/AppleScriptX/index.html
* http://developer.apple.com/documentation/General/AppleScript/Conceptual/General/AppleEvents/index.html


----

You can build and send General/AppleEvents with General/NSAppleEventDescriptor, Carbon functions (see General/AECreateAppleEvent, General/AEBuildAppleEvent, General/AESend, General/AESendMessage), the high-level General/ObjCAppscript bridge (10.3+) or General/ScriptingBridge (10.5+).

----

*You can also receive General/AppleEvents as General/NSAppleEventDescriptor<nowiki/>s by registering with General/NSAppleEventManager. General/NSApplication does this to turn     odoc,     rapp and other standard General/AppleEvents into delegate messages, or invoke default behaviour if needed.*

----

A C program can use General/AEMach.h to receive General/AppleEvents, however the initial oapp/odoc event will not be received there. As of Lion it's fetched from a separate mach port using the private _LSCopyLaunchModifiers function the first time General/[NSApplication run]/General/RunCurrentEventLoop is called. Thus there's no way to parse it except to use Cocoa or Carbon.