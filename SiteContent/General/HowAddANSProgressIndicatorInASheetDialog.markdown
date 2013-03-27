I make a custom sheet dialog with a General/NSProgressIndicator to wait until my App is connected to a General/MySQL server. But because the sheet is a modal window, I can't do jobs for testing the connexion while the sheet runs. 
Can sombebody give me a starting point to implement this? 
Have I to use General/NSThread to accomplish this ?
----
Solved : it was simple. Just add      [progBarre setUsesThreadedAnimation:YES];  (where progBarre is the General/NSProgressIndicator animated progression bar)
    
/* progWindow is a General/NSWindow that contains the General/NSProgressIndicator, created in IB */
General/[NSApp beginSheet: progWindow
       modalForWindow: mainWindow
        modalDelegate: self
       didEndSelector: NULL
          contextInfo: nil];
    [progBarre setUsesThreadedAnimation:YES];
    [progBarre display];
    [progBarre startAnimation: self];
    
    /* General/MySQL server stuff */
    [serveur initLogin: loginPrefs];
    Err = [serveur erreursIntSQL];
    
    /* close the sheet */
    [progWindow orderOut: self];
    General/[NSApp endSheet: progWindow];


Now the next step is to create a General/NSTimer that close the sheet after a time delay if the server do not respond.
    -keefaz