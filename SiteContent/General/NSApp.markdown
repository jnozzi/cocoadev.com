General/NSApp is a global variable that points to the instance of your General/NSApplication.

It is initialized in the call to General/NSRunApplication() that is installed in your main() function by default.

General/NSApp is of type General/NSApplication, or of whatever you set as your project's Principal Class.

In rare cases, General/NSApplication should be overridden, but most often there are other ways to solve the problem, using the App's delegate.

----

The General/NSApplication instance can also be retrieved with     General/[NSApplication sharedApplication]

----

Wondering why the linker is complaining about an "unresolved external reference to _NSApp"? Probably because Cocoa wasn't included as a framework.