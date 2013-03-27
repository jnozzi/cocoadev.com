I found the conventional way to add 'Help' to an application a bit difficult. Recently I did the following:
in the .h file (of the windows controller, myDocument or whatever)

    
General/IBOutlet General/WebView		*htmlView;
General/IBOutlet General/NSPanel		*htmlPanel;
- (General/IBAction) myHelpMenu:(id) sender;

connect myHelpMenu to the help menu item in the nib file as usual.

in the nib file add a panel with a General/WebView, connect them to the views above.

in the .m file add

    
- (General/IBAction) myHelpMenu:(id) sender
{
	[htmlPanel  makeKeyAndOrderFront:nil];
	General/NSString *st = [ General/[NSBundle mainBundle] resourcePath];
	st = General/[NSString stringWithFormat:@"%@%@", st, @"/myHelpMenu/Help.html"];
	NSURL *cgiUrl = [NSURL fileURLWithPath:st];
	General/NSMutableURLRequest *postRequest = General/[NSMutableURLRequest requestWithURL:cgiUrl];
	General/htmlView mainFrame] loadRequest:postRequest];
}


Now produce a folder 'myHelpMenu' or whatever with as a root html file 'Help.html'
Do not add this folder to the [[XCode project, but insert it in the finished
application (control click the application, show package contents, add to the folder 'resources')
For me, this did the trick. General/PaulCD
---- 

This could also be done by adding the help folder to the project and making sure it gets copied to the right place with 'copy files' build phase.
---- 

In my experience that does copy the files, but not the folders, ruining the hierarchy.

----
Depends on whether you add folders as groups (ruins the hierarchy) or folder references (preserves it). This is chosen with a set of radio buttons in the sheet that appears when you add it to your project.

----

Why not just override -showHelp: somewhere in the responder chain (i.e. the app delegate)?