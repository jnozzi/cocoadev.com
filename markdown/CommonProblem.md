**Common Cocoa Problems**

This page is a listing of common problems experienced while learning Cocoa or simply working with it.

If you're experiencing a problem and you think it might not be unique, check here first. If there's a page about a problem that you think is a common one, but it's not here, add it to the appropriate category below.

Please try to keep the page organized with simpler topics at the top and more advanced topics at the bottom. And please keep in mind that it's intended to be a list of common problems, not a master list of every problem/solution page on the site.

----

**Memory Management**

The bane of the newbie, and commonly the bane of the non-newbie. Without good memory management practices, your app will likely leak like crazy, crash at random, or both; but how do you track down these problems and fix them?


*General/MemoryManagement - *The* page with links to everything imaginable about the topic.
*General/DebuggingAutorelease - Crashing in NSP<nowiki/>opAutoreleasePool, can't find that extra release that shouldn't be there, this page is for you.
*General/NSZombieEnabled - A useful technique for autorelease bugs and just plain over-release bugs.
*General/MemoryLeaks - The opposite problem: not enough releases, and how to track them down.


----
**Why did my program crash?**

*General/SendEventCrashes - Application crashing while General/NSApplication is trying to send an event     sendEvent:
*General/SignalsSentOnCrash


----

**Interface Builder**

General/InterfaceBuilder is crazy powerful, but sometimes there are things you want to do, or problems that it causes, which are not obvious.


*General/IBOutletNSViewIsNil - You hooked up an outlet, but it doesn't work because it's nil, even after the nib loads. Here's how to fix it.
*General/MakingNibsTalkToEachOther - You have two nibs and you need them to communicate. Some general techniques on how to solve this.
*General/MenusAndDocuments - The menu bar is in General/MainMenu.nib, but you want to make a menu that talks to General/MyDocument.nib. This is how to do it.


----

**GUI Stuff**

Some GUI elements are everywhere in OS X, but they're not always easy to create.


*General/DrawRect - Your view draws strangely when a subview is clicked, or otherwise things don't appear how they should. You may have implemented this method wrong.
*General/BorderlessWindow - How to create a completely custom window, without the standard title bar, with weird shapes or transparency.
*General/NSToolbarSampleCode - For the longest time, General/InterfaceBuilder has no built-in way to create a toolbar, so you had to do it in code. This page shows you how to do both.


----

**Inter-Process Communication**

How to start and interact with other programs from yours.


*General/WrappingUnixApps - If you have a UNIX command-line program whose functionality you just have to include in your Cocoa GUI application, this page tells you how to do it.
*General/NSWorkspace - A very useful class which, among other things, provides information about other running applications, and also lets you launch applications and open General/URLs. (see also General/NSWorkspaceNotifications, a rich set of signals provided by the General/NSWorkspace notification center.)
*General/NSAppleScript - How to embed General/AppleScript in your application so you can manipulate other apps.
*General/HowToSupportAppleScript - The other way around: how to support General/AppleScript, so users can script your app.
*General/DistributedObjects - For client/server type communication


----

**Compilation and Linking**


*General/ParseError describes some common General/ObjectiveC-related errors
*General/ApplicationLinkingIssues refers you to several topics related to, you guessed it, General/ApplicationLinkingIssues


----

**Audio**


*Because of its hefty learning curve, lots of General/AudioQuestions get asked here about General/CoreAudio (not actually a part of Cocoa API)
*Try General/CoreAudioAndAudioUnitsTutorial to see if it can point you in the right direction on this unwieldy matter


----

**Discussion**

Here's my first attempt at this page, and I hope it's helpful. I tried to pull from both my own experience with things where I had trouble, and things where I see people on the site (and other places) getting into trouble frequently.

As I stated above, I tried to organize things with the simplest stuff at the top, and the more complicated things at the bottom. When possible, I linked to the "howto" page rather than the summary/link-to-docs page.

If anybody has suggestions for changing the page, removing things, adding things, etc., post them here, or since this is a wiki, go ahead and make the changes yourself. -- General/PrimeOperator