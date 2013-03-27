


General/AppleScript is a technology General/AppleComputer employs for allowing software to be controlled via scripts. The Carbon API for is General/OpenScripting, the Cocoa API is General/NSAppleScript.

General/CocoaScripting wraps and dispatches General/AppleScript commands to the appropriate places in your application, and collects the results and sends them back to the General/AppleScript engine.

Apple provides some starting points at http://developer.apple.com/referencelibrary/GettingStarted/GS_AppleScript/index.html.

In Mac OS X 10.2 you can use the General/NSAppleScript class to compile and execute scripts.
One can also make General/AppleEvents programmatically in Cocoa via General/NSAppleEventDescriptor,
which can then be sent to an General/NSAppleScript  object or other apps.
See Apple's sample code at http://developer.apple.com/samplecode/AttachAScript/index.html
for example.


The rest of the page is mainly on implementing scriptablity in a Cocoa app.
----
The General/AppleScript Language Guide:

http://developer.apple.com/documentation/AppleScript/Conceptual/AppleScriptLangGuide/

----

Check out the developer docs at http://developer.apple.com/documentation/Cocoa/Conceptual/Scriptability/index.html
or you can find them as part of your local developer documentation:

[Jaguar] file://Developer/Documentation/Cocoa/TasksAndConcepts/ProgrammingTopics/Scriptability/
[Panther] file:///Developer/Documentation/Cocoa/Conceptual/Scriptability/index.html
[Xcode] file:///Developer/ADC%20Reference%20Library/documentation/Cocoa/Conceptual/Scriptability/index.html

----

Among other resources, here's an old Applescript-in-Cocoa article in General/MacTech:

http://www.mactech.com/articles/mactech/Vol.16/16.07/AppleScripttoCocoa/

----

Here's a recent article at the O'Reilly Mac Devcenter:

http://www.oreillynet.com/pub/a/mac/2002/02/22/applescript.html
Integrating General/AppleScript and Cocoa

----

or another one here (General/KFAppleScriptHandlerAdditions):
http://homepage.mac.com/kenferry/software.html#KFAppleScript

----

Check out General/AppleScriptingCocoaApp for a brief guide to implementing General/AppleScript support in your app.

Also check out General/HowToSupportAppleScript for a more extensive guide.

----

General/AppleScript is leaky... General/NSAppleScriptMemoryLeak

----

"The Development of General/AppleScript" (W. Cook, 2006) [http://www.cs.utexas.edu/users/wcook/Drafts/2006/ashopl.pdf] is a recent paper by one of the original General/AppleScript designers that provides some excellent insights into the early history and original objectives and design of General/AppleScript and the General/OpenScriptingArchitecture.