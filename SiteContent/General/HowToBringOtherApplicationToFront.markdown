Let's say I want to bring Mail.app to front -- how would I do that?

If I use General/NSWorkSpace to launch it, it probably gets a re-activate event, which could cause opening of a new window and currently I have the problem that even though the application does activate, the windows are not brought to front.

----

You could always embed an applescript in your application using the General/NSAppleScript class. This is how I remove songs from iTunes in iSweep and it works fairly well. Given my preference, I would use an Objective-C framework or class api to connect to and manipulate iTunes, but I wasn't able to find one, so I had to rely on General/AppleScript for this part of iSweep's functioncality.

-- General/DaveGiffin

----

You can get the app's General/ProcessSerialNumber via General/NSWorkspace and then use Carbon General/ProcessManager calls to activate it.

----

General/AppleScript really is the easiest way here. Just execute it using General/NSAppleScript

    
tell application "Mail" to activate


----

Unfortunately General/AppleScript has a noticeable startup delay on "slower" machines. Try this on your machine (from Terminal.app):
    
time osascript -e 'current date'


So I've done the General/ProcessManager solution, which is (``anApp`` being the dictionary I get from General/NSWorkSpace):
    
struct General/ProcessSerialNumber psn = {
   General/anApp objectForKey:@"[[NSApplicationProcessSerialNumberHigh"] unsignedLongValue],
   General/anApp objectForKey:@"[[NSApplicationProcessSerialNumberLow" ] unsignedLongValue],
};
General/SetFrontProcess(&psn);
