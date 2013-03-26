Apple has some documentation on [[TransformProcessType]]: http://developer.apple.com/documentation/[[ReleaseNotes]]/Carbon/[[HIToolbox]].html

Process Manager
Header file ([[HIServices]]): Processes.h

[[TransformProcessType]] may be used to convert a [[UIElement]] or [[BackgroundOnly]] application into a regular foregroundable application with a menubar and Dock icon.  There are currently no facilities for doing the reverse transformation (i.e. turning a foreground app into a [[UIElement]] or [[BackgroundOnly]]).

NOTE: While available starting in 10.3 "Panther," calling [[TransformProcessType]] on a [[UIElement]] application in 10.3 or 10.4 will return paramErr, rendering it only usable on a full [[BackgroundOnly]] application.  Leopard supports foregrounding both [[UIElement]] and [[BackgroundOnly]] applications.

----

<code>
[[ProcessSerialNumber]] psn = { 0, kCurrentProcess }; 
[[OSStatus]] returnCode = [[TransformProcessType]](& psn, kProcessTransformToForegroundApplication);
if( returnCode != 0) {
    [[NSLog]](@"Could not bring the application to front. Error %d", returnCode);
}
</code>

----
----

This is my incantation for enabling and disabling the dock icon. It assumes you start off with [[LSUIElement]] in your Info.plist is set to true, because you can't disable the dock icon once it is going. I think the only downside of this approach (out of the available approaches), is that the dock icon won't bounce on startup, will just appear suddenly.

Of course, what we really need is for Apple to allow turning off the dock icon, as well as possibly the application launching code in OS-X to look somewhere other than in the App bundle (the preferences for example), for the initial condition of the dock icon.

<code>
-(id)init; {
        self = [super init];
	showDockIcon = ![[[[[[NSBundle]] mainBundle] infoDictionary] objectForKey:@"[[LSUIElement]]"] boolValue];
	[self setShowDockIcon:![[[[NSUserDefaults]] standardUserDefaults] boolForKey:PREF_HIDE_DOCK_ICON]];
        return self;
}

-(void)setShowDockIcon:(BOOL)show; {
	if (show) {
		if (!showDockIcon) {
			[[ProcessSerialNumber]] psn = { 0, kCurrentProcess }; 
			[[OSStatus]] returnCode = [[TransformProcessType]](& psn, kProcessTransformToForegroundApplication);
			if( returnCode == 0) {
				[[ProcessSerialNumber]] psnx = { 0, kNoProcess };
				[[GetNextProcess]](&psnx);
				[[SetFrontProcess]](&psnx);
				[self performSelector:@selector(setFront) withObject:nil afterDelay:0.5];
				[self willChangeValueForKey:@"showDockIcon"];
				showDockIcon = YES;
				[[[[NSUserDefaults]] standardUserDefaults] setBool:!show forKey:PREF_HIDE_DOCK_ICON];
				[[[[NSUserDefaults]] standardUserDefaults] synchronize];
				[self didChangeValueForKey:@"showDockIcon"];
			} else {
				[[NSLog]](@"Could not bring the application to front. Error %d", returnCode);
			}
		}
	} else {
		if (showDockIcon) {
			[[NSAlert]] ''alert = [[[[[NSAlert]] alloc] init] autorelease];
			[alert addButtonWithTitle:@"Restart"];
			[alert addButtonWithTitle:@"Cancel"];
			[alert setMessageText:@"You must now restart"];
			[alert setInformativeText:@"Dock Icon status change requires restart"];
			[alert setAlertStyle:[[NSWarningAlertStyle]]];
			[alert beginSheetModalForWindow:showButtons.window modalDelegate:self didEndSelector:@selector(restartDialogDidEnd:returnCode:contextInfo:) contextInfo:nil];
			[[[[NSUserDefaults]] standardUserDefaults] setBool:!show forKey:PREF_HIDE_DOCK_ICON];
			[[[[NSUserDefaults]] standardUserDefaults] synchronize];
		}
	}
}
-(void)setFront; {
	[[ProcessSerialNumber]] psn = { 0, kCurrentProcess };
	[[SetFrontProcess]](&psn);	
}
- (void)restartDialogDidEnd:([[NSAlert]] '')alert returnCode:([[NSInteger]])returnCode contextInfo:(void '')contextInfo {
	if ([[NSAlertFirstButtonReturn]] == returnCode) {
		// Not quite sure why we can't directly execute outselves, but
		// we seem to require the open command to make it work
		[[[NSTask]] launchedTaskWithLaunchPath:@"/bin/sh" arguments:[[[NSArray]] arrayWithObjects:@"-c", [[[NSString]] stringWithFormat:@"sleep 1 ; /usr/bin/open '%@'", [[[[NSBundle]] mainBundle] bundlePath]], nil]];
		[[[NSApp]] terminate:self];
	}
}

</code>