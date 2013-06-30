

How do I send an General/NSImage into an General/AppleScript? I know how to send an General/NSString using something like the following:

    

scriptText = General/[NSString stringWithFormat: @"tell application \"General/MyApp\"\n set a string to \"%@\"\n end tell", aString];
appleScript = General/[[NSAppleScript alloc] initWithSource:scriptText];
[appleScript executeAndReturnError:nil];



But, I cannot seem to get anything to work with General/NSImages. Can anyone give me some hints about how to send images?

James

----

It is possible to send it by sending the General/NSApplescript instance an apple event to run it, that contains image data as an argument to whichever handler you choose to call (typically "on run").  However, it'd be much simpler to (a) put the image on the clipboard and have the applescript access it from there or (b) put the image in a temp file and pass the path to the script as you "passed" a string in your example.

----

*(a) put the image on the clipboard and have the applescript access it from there* - I tried this, but have yet to find anyway to grab it from the pasteboard via General/AppleScript

*(b) put the image in a temp file and pass the path to the script as you "passed" a string in your example.* - I thought about this, but I was concerned that there may be a performance hit from changing the image often, requiring the image being saved then loaded again.

James

----

(a) Use     the clipboard, I think.

(b) you're compiling and settting up a new applescript context each time you're running rather than using an existing compiled script... If performance is bugging you, reading and writing the file is nothing compared to recreating the applescript context each time. *Assuming the file isn't too big. Setting up an General/AppleScript context generally takes less time than writing out a gigabyte of image data.*

----
So, does anybody know how to access the clipboard via applescript? thank you!
----
This is General/CocoaDev, not General/AppleScriptDev - use Google.