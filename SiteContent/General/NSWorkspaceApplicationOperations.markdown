

Some simple code to see if an application is running after being notified that a new application has launched.

<code>

- (void)awakeFromNib
{
    [[NSNotificationCenter]] ''notCenter;
    notCenter = [[[[NSWorkspace]] sharedWorkspace] notificationCenter];
    [notCenter addObserver:self selector:@selector(iTunesOn) name:nil object:nil];
}

- (void)iTunesOn
{
    int i, status;
    status = 0;
    for (i = 0; i < [[[[[NSWorkspace]] sharedWorkspace] launchedApplications] count]; i++)
    {
        if ([[[[[[[NSWorkspace]] sharedWorkspace] launchedApplications] objectAtIndex:i] objectForKey:@"[[NSApplicationName]]"] 
        isEqualToString:@"iTunes"])
        {
            status = 1;
        }
    }
// Do something here with the status.
}

</code>

----
That seems a little un-Cocoa-like. How about:
<code>
- (void)iTunesOn
{
    int status=0;
    [[NSEnumerator]] ''e=[[[[[NSWorkspace]] sharedWorkspace] launchedApplications] objectEnumerator];
    id ''cur;
    while (cur=[e nextObject]) {
        if ([[cur objectForKey:@"[[NSApplicationName]]"] isEqualToString:@"iTunes"]) {
            status=1;
        }
    }
//Do something here with the status
}
</code>
Saves 2 lines of code too!

----

If you can use a system with reasonable KVC (might require 10.3, I forget), then do this:

<code>
- (BOOL)iTunesOn
{
   return [[[[[[NSWorkspace]] sharedWorkspace] launchedApplications] 
                    valueForKey:@"[[NSApplicationName]]"] containsObject:@"iTunes"];
}
</code>

''I am tremendously incompetent. It took me four or five edits just to get the quotes on that code right. Sorry.''

----
Yeah, but you only have to do that once. If you observe the notification, you only have to do this from then on. --[[JediKnil]]
<code>
- (void)awakeFromNib
{
    [[NSNotificationCenter]] ''notCenter;
    notCenter = [[[[NSWorkspace]] sharedWorkspace] notificationCenter];
    [notCenter addObserver:self selector:@selector(workspaceDidLaunchApplication:) name:[[NSWorkspaceDidLaunchApplicationNotification]] object:nil];
}

- (void)workspaceDidLaunchApplication:([[NSNotification]] '')note
{
    // Probably safer to use the bundle ID
    if ([[[note userInfo] objectForKey:@"[[NSApplicationBundleIdentifier]]"] isEqual:@"com.apple.iTunes"])
    {
        // iTunes was activated
    }
}
</code>