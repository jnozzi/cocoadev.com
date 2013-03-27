http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSApplication_Class/index.html

General/NSApplication inherits from: General/NSResponder: General/NSObject

----

An General/NSApplication object manages an application's main event loop in addition to resources used by all of that application's objects.

General/NSApplication has some useful delegate methods that allow customisation of an application's launching & quitting behaviour.

To have your application quit when there are no windows open (which should only be used for single-window desk accessory-type apps, never document based apps - think Calculator, not General/TextEdit) you can use the General/NSApplication delegate method:

    
-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(General/NSApplication *)theApplication
{
    return YES;
}


you can also do some interesting stuff with General/NSApplication like change the application's icon. (like iCal)

Pass your image to     General/[NSApp setApplicationIconImage:(General/NSImage *)theImage]


----

General/NSApp runs in     General/NSModalPanelRunLoopMode while waiting to exit or while calling **-applicationShouldTerminate:**. In this mode, queued selectors or timers won't usually get invoked. If you want them to be invoked, create them for the     General/NSModalPanelRunLoopMode mode instead of     General/NSDefaultRunLoopMode.

The run loop mode will go back to     General/NSDefaultRunLoopMode if you return     General/NSTerminateCancel from **-applicationShouldTerminate:**.

-- General/DustinVoss

----

Getting General/NSApp to quit your app good and proper is covered in General/TerminateOrStopGood.

----

After searching high and lo, I am desperate enough to ask here -- how do I "hook up" my controller to be a delegate to my app?  Specifically:  I have created my applicationShouldTerminate method (exactly as described here and in many other webpages), and declared it in myController.h along with the other methods, but it's just not getting called.  I'm sure there's something I'm supposed to do in IB to "hook it up", but for the life of me I can't figure out what!  Any advice would be much appreciated.  --General/DarelRex@gmail.com
----
My advice is to work through one or two introductory Cocoa tutorials.  The File's Owner in the General/MainMenu.nib is typically the application's shared instance of General/NSApplication.  Just drag a connection from File's owner to your controller instance and set the File's Owner's delegate outlet to your controller.  You can also do this programatically: General/[[NSApplication sharedApplication] setDelegate:myController];
----
Thanks!  I will try those.  (I have worked through the Currency Converter tutorial, but it doesn't cover this topic.)  --Darel
[UPDATE:  Worked great!  Thanks again.]