

hi. so, the problem. i have an Cocoa/Carbon/C++ application, which is normal with running from the terminal - application is starting. but when i'm trying to start it by clicking on .app icon - it crashes with "may be damaged or incomplete"... what's wrong?

----

That means that it is missing something from the package structure.  Try creating a basic *Hello World* app in General/XCode (the default Cocoa application template should be good enough) and then take a look at what is in that .app bundle to get an idea of what you are missing.

--General/JeffDisher

----
nothing new. was builded, was clicked - nothing. was runned from terminal - it's ok. i'v scaned .app directory for getting structure - it's ok - like in my old application (i meen on the contrary). what's wrong i don't know...

----
Your Info.plist is broken.

Also, is it that hard to type capital letters, proper punctuation, and attempt to spell decently?

----
The best way to check Info.plist consistency is to open it with Property List Editor app, that comes with Xcode package. If there are any errors (typo's) in it you will the an alert - fix them in any text editor.

-- General/DenisGryzlov

----
This is good but not sufficient. It won't catch, for example, a mismatch between the Info.plist's General/CFBundleExecutable entry and the actual executable's name.

----
Sorry my english, i'm not speeking well yet )) I checked Info.plist - all is ok, General/CFBundleInfoExecutable is ok... No errors so far... 
    
General/CFBundleDevelopmentRegion    String    English
General/CFBundleExecutable                 String    mybinary
General/CFBundleIconFile                     String   
General/CFBundleIdentifier                   String    home
General/CFBundleInfoDictionaryVersion  String    6.0
General/CFBundleName                         String    mybinary
General/CFBundlePackageType              String    APPL
General/CFBundleSignature                   String    ????
General/CFBundleVersion                      String    1
General/NSMainNibFile                          String    General/MainMenu
General/NSPrincipalClass                       String    General/NSApplication

And what's strange is that General/HelloWord not runnig too! I meen by clicking. On the another system. The main word is ANOTHER SYSTEM. On the home it's ok
----
General/ZeroLink? (i.e. are you building a Debug/Development version or a Release/Deployment version?)

----
Release (zerolink disabled). Also i'm building with makefile (meen just compiling and linking) - the same effect