

I'm writing an app that searches for some files and displays them in an General/NSTableView. I want to put in a column that shows the file's kind like the Finder's list view does (e.g. "Folder", "disk image", "General/StuffIt Archive", "JPEG Image", etc.), but I can't find any way to have the system give that string to me. I've tried General/NSWorkspace's getInfoForFile and something from General/NSFileManager, but all they do is return something not terribly useful: the file's extension, HFS type code, or the application that opens it. Is this going to have to be done with a Carbon call or an Applescript?

-- General/OwenYamauchi

----

I believe General/LSCopyKindStringForURL is what you want. --General/KevinWojniak

*In general, General/LaunchServices (which the above function is from) has a lot of useful Finder-type stuff that isn't found in General/NSWorkspace (or General/NSFileManager). Besides "kind strings," you can also find the default application for a file *type* (instead of a specific file), test if an application thinks it can open a file, and retrieve some more specific file info than what you'd get normally (like, is the file invisible in the Finder?). You can use General/LaunchServices by including the General/ApplicationServices framework, which also includes a few other Carbon-esque things that are shared with Cocoa, like General/CoreGraphics and General/PrintCore and stuff. --General/JediKnil*