I have a program that opens a file in a normal window with title, etc.; the user can also go to full screen.  I do it by closing the first window and then creating another window that is full screen and has the exactly same contentView.  The problem i am coming accross is that i can never seem to access the full screen's window controller afterwords.  My application keeps exiting from a SIGTRAP.
Here is he code that gets the key window to make a call to make it full Screen.

    
General/ViewController *controller = General/[[NSApp keyWindow] windowController];
if(controller != nil) {
     General/NSLog(@"Full Screen");
     [controller changeOrigBySize:(0)];
}


General/ViewController is a subclassed General/NSWindowController that holds the original window.  The program will get the SIGTRAP the second time I run through the above code to disable the full screen.

And this is how I make the full screen window (if it helps).

    
			General/NSRect rect = General/[[NSScreen mainScreen] frame];
			frame = [window frame];
			General/NSView *view = [window contentView];
			
			General/MovieWindow *fullScreen = General/[[MovieWindow alloc] initWithContentRect:rect styleMask: General/NSBorderlessWindowMask backing: General/NSBackingStoreBuffered defer:NO];
			[window close];
			window = fullScreen;
			
			if(fullScreen != nil) {
				[fullScreen setWindowController:self];
				[fullScreen setContentView:view];
			
				//make the full screen window visible and order to front
				[movieView setControllerVisible:NO];
				[fullScreen setLevel: General/NSScreenSaverWindowLevel - 1];
				[fullScreen makeKeyAndOrderFront:nil];
						
				//full Screen is now ON
				fullScreenOn = YES;
                    }


General/MovieWindow is a subclassed General/NSWindnow that overloads canBecomeKeyWindow to return YES always.
If anyone can figure out why I am getting this SIGTRAP it would help me a lot.

----

Well one thing I can see right off the bat is that you are not retaining the original window's content view. When you close the window, depending on its properties, it may be destroyed (released), taking the view with it before it's added to the fullscreen window (and retained by the window on add). Another thing I *think* might be wrong is that, though you set the window's window controller, you don't set the window controller's window. One should trigger the other in my mind, but you might want to double-check that for fact. Also, the documentation for General/NSWindowController's     setWindow  method says, *"You should generally create a new window controller for a new window and release the old window controller instead of using this method."*. So ... yeah.

----
I did put a retain on original window's content view and that did not fix the problem.  You said that when you create a new window then you should create a new controller.  But right now I have a document that holds a window controller and this has a window on it that starts with a bordered window.  What would be the best way then to make this window full screen and borderless?  There is a movie playing in the beginning window as well, and I would like it to stay at the same place in the timeline during the switch.  Sorry - I am bit confused, I am pretty inexperienced when working with windows.  If it helps... this is a document- based application as well.

----

Try not closing the window but rather just -orderOut: ...

----
If i use orderOut instead of close then no content is displayed on the full screen window, and i get  General/CGSGetSurfaceBounds failed and General/CGSOrderSurface failed errors.

----

This all seems very wrong, if you don't mind my saying so. ;-) I'm not sure there's enough to go on with the code you've provided.

----  
Well this happens only after I open up a new window and change it to full screen, and then try to do something else with that window.  So here is the code that it goes though

This is how I make the window controller in the General/NSDocument subclass
    
- (void)makeWindowControllers {
	General/NSLog(@"I am in makeWindowControllers");
	windowController = General/[[ViewController alloc] initWithWindowNibName:@"General/ViewController"];
	[self addWindowController:windowController];
	if(movieFile != nil) {
		General/NSLog(@"Setting movieView to movie");
		[windowController setMovieWithFile:movieFile];
	}
	else if(movieURL != nil){
		General/NSLog(@"Setting movieView for a General/URLfile");
		[windowController setMovieWithURL:movieURL];
	}
	else 
		General/NSLog(@"There is no movie variable yet");
}


This is how I create a document
    
-(General/IBAction)openMovie:(id)sender {
	General/NSArray *fileTypes = General/[NSArray arrayWithObjects:@"mov", @"mpg", @"mp3", @"jpg", nil];
	General/NSOpenPanel *openPanel = General/[NSOpenPanel openPanel];
	
	int result = [openPanel runModalForDirectory:General/NSHomeDirectory() file:nil types:fileTypes];
	if (result == General/NSOKButton) {
		General/NSString *movieFile = [openPanel filename];
						
		General/ViewerDoc *viewer = General/[ViewerDoc initWithFileMovie2:movieFile];
		// set up the document
		if (viewer)
		{
			// add the document
			General/[[NSDocumentController sharedDocumentController] addDocument:viewer];
			
			[viewer setTheMovie];
			// set up the document
			[viewer makeWindowControllers];
			[viewer showWindows];
		}
	}
}


And this is how I set the movie in the initial window for the window controller
    
-(void) setMovieWithFile:(General/NSString *)file {
	[self window];
	if(movieView == nil)
		General/NSLog(@"I am nil");
	General/NSLog(@"set movie using file");
	movie = General/[[QTMovie alloc] initWithFile:file error:nil];
	General/NSLog([movie attributeForKey:@"General/QTmovieFileNameAttribute"]);
	[movieView setMovie:movie];
	
	//set full Screen
	fullScreenOn = NO;
	
	window = (General/MovieWindow*) [movieView window];
	General/NSSize size = General/movie attributeForKey:@"[[QTMovieNaturalSizeAttribute"] sizeValue]; 
	[window setContentSize:size];
	frame = [window frame];
}


This is almost all the code that is run before the problem.  Everything seems to work fine though as long as I don't use the full screen methods that are shown above in my first post.