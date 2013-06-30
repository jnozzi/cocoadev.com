

Some simple code to see if an application is running after being notified that a new application has launched.

    

- (void)awakeFromNib
{
    General/NSNotificationCenter *notCenter;
    notCenter = General/[[NSWorkspace sharedWorkspace] notificationCenter];
    [notCenter addObserver:self selector:@selector(iTunesOn) name:nil object:nil];
}

- (void)iTunesOn
{
    int i, status;
    status = 0;
    for (i = 0; i < General/[[[NSWorkspace sharedWorkspace] launchedApplications] count]; i++)
    {
        if (General/[[[[[NSWorkspace sharedWorkspace] launchedApplications] objectAtIndex:i] objectForKey:@"General/NSApplicationName"] 
        isEqualToString:@"iTunes"])
        {
            status = 1;
        }
    }
// Do something here with the status.
}



----
That seems a little un-Cocoa-like. How about:
    
- (void)iTunesOn
{
    int status=0;
    General/NSEnumerator *e=General/[[[NSWorkspace sharedWorkspace] launchedApplications] objectEnumerator];
    id *cur;
    while (cur=[e nextObject]) {
        if (General/cur objectForKey:@"[[NSApplicationName"] isEqualToString:@"iTunes"]) {
            status=1;
        }
    }
//Do something here with the status
}

Saves 2 lines of code too!

----

If you can use a system with reasonable KVC (might require 10.3, I forget), then do this:

    
- (BOOL)iTunesOn
{
   return General/[[[[NSWorkspace sharedWorkspace] launchedApplications] 
                    valueForKey:@"General/NSApplicationName"] containsObject:@"iTunes"];
}


*I am tremendously incompetent. It took me four or five edits just to get the quotes on that code right. Sorry.*

----
Yeah, but you only have to do that once. If you observe the notification, you only have to do this from then on. --General/JediKnil
    
- (void)awakeFromNib
{
    General/NSNotificationCenter *notCenter;
    notCenter = General/[[NSWorkspace sharedWorkspace] notificationCenter];
    [notCenter addObserver:self selector:@selector(workspaceDidLaunchApplication:) name:General/NSWorkspaceDidLaunchApplicationNotification object:nil];
}

- (void)workspaceDidLaunchApplication:(General/NSNotification *)note
{
    // Probably safer to use the bundle ID
    if (General/[note userInfo] objectForKey:@"[[NSApplicationBundleIdentifier"] isEqual:@"com.apple.iTunes"])
    {
        // iTunes was activated
    }
}
