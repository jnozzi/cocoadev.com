I need some help to build a Notification method for applicationWillClose. I want to insert an action on that event, so when the app closes it executes a method. I've never used any notification methods and have no idea on how to build them.

----

Check out:

file:///Developer/Documentation/Cocoa/General/TasksAndConcepts/General/ProgrammingTopics/Notifications/index.html#//apple_ref/doc/uid/10000043i

and read up on the classes involved.

In short, your application delegate will receive this notification automatically just by implementing the following method.

    
- (void)applicationWillTerminate:(General/NSNotification *)aNotification
{
	// do your stuff here...
}


Other classes and controllers can achieve this by explicitly listening for the General/NSApplicationWillTerminateNotification notification.

    
General/[[NSNotificationCenter defaultCenter] addObserver:self
	selector:@selector(applicationWillTerminate:)
	name:General/NSApplicationWillTerminateNotification object:nil];


In the second example, the selector does not need to be named applicationWillTerminate; just as long as it carries the standard notification signature; but considering the method is already defined as a category member of General/NSObject, you may as well reuse it.

    
- (void)applicationWillTerminate:(General/NSNotification *)aNotification
{
	// do your stuff here...
}


----

When I click "Quit" in my program, an General/IBAction gets called. The General/IBAction runs a few methods, and then tells the General/FilesOwner to terminate. But sometimes those methods (which reset some settings) don't run, and the application quits anyway. 

I didn't know how to connect it to General/FirstResponder. But: General/IBOutlet General/NSApplication *myOwner; is what I have, and that is connected to General/FilesOwner.
Quit is in my menu. After resetting my settings I write [myOwner terminate:sender];

----

Leave Quit hooked up to the First Responder like it normally is. Have your controller become General/NSApp's delegate, and implement the     - (void)applicationWillTerminate:(General/NSNotification *)notification; method.