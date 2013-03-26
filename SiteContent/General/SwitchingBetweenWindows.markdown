I am writing an application that has a login screen and the main gui.  Right now, I have the login window visible at launch and not visible for the main window.

code:
<code>
if (userid != nil) {
    [tryagain setHidden:YES];
    //[[NSLog]] (@"userid: %@", userid);
    [[username window] close];
    [s3NSWindow makeKeyAndOrderFront:self];
} else {
    //[[NSLog]] (@"try again");
    [tryagain setHidden:NO];
    [username selectText:self];
}
</code>
I was wondering if there is a better way of doing this, like launching the login window if approved then launch the main window and close the login window?  the reason for doing this is because I want to avoid all the unnecessary "init" calls from the main window even when the window isn't visible, plus I need the userid from the login window first.

----

This is largely a design issue - which means there are several right ways to do it and a hundred other wrong ways. Here's one way; whether it's right for you or not, you can decide. :)

Put the main window in a separate nib file and call it "[[MainWindow]].nib". You then need to create an [[NSWindowController]] subclass (let's call it [[MainWindowController]]) and set it as the [[MainWindow]].nib's file owner. To do this, select the "File's Owner" instance and change the custom class using Interface Builder's info palette. You can then use the following method to launch the main window after the user has submitted a valid name:

<code>
- (void)launchMainWindowWithUserName:([[NSString]] '')userName
{
	// This will create a [[MainWindowController]] instance
	// with the [[MainWindow]].nib file and apply it to
	// the mainWindowController instance variable.
	mainWindowController = [[[[MainWindowController]] alloc]
						initWithWindowNibName:@"[[MainWindow]]"];
	
	// Inform the main window controller of the user name
	// This could set an instance variable.
	[mainWindowController setUserName:userName];

	// Now show the window.
	[mainWindowController showWindow:self];
}
</code>

The "showWindow:" will load the window and end up calling the "windowDidLoad" method in your [[MainWindowController]]. You can implement this method and put all the setup code in there. Let me know if any of this doesn't make sense.


-- [[RyanBates]]


----

Ryan,

Thank you very much. Got it to work.

<code>

[[MainWindowController]] ''mainWindowController = [[[[MainWindowController]] alloc]
						initWithWindowNibName:@"[[MainWindow]]"];

</code>

Only place I needed to change.

Thx again.
sing