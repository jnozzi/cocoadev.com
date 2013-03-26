
I am designing a document-based application that sub-classes [[NSDocument]] and [[NSWindowController]] called [[ViewController]], but i am having a problem.
When I make a new [[NSDocument]] it runs through the initializing messages just fine and it goes though makeWindowControllers just fine,
but after everything is said and done.  It seems that the [[NSWindowController]] outlets do no seem to work at all, they are all nil.

<code>
In the makeWindowControllers i have
makeWindowControllers { 
	[[NSLog]](@"I am in makeWindowControllers"); 
	windowController = [[[[ViewController]] alloc] initWithWindowNibName:@"[[MovieController]]"]; 
	[self addWindowController:windowController]; 
	if(movieFile != nil) { 
		[[NSLog]](@"Setting movieView to movie"); 
		[windowController setMovieWithFile:movieFile]; 
	} 

	else 
		[[NSLog]](@"There is no movie variable yet");
}
</code>

The problem i am coming across is in the code of setmovieWithFile.  which is
<code>
-(void) setMovieWithFile:([[NSString]] '')file {
	if(movieView == nil)
		[[NSLog]](@"I am nil");
	[[NSLog]](@"set movie using file");
	movie = [[[[QTMovie]] alloc] initWithFile:file error:nil];
	[[NSLog]]([movie attributeForKey:@"[[QTmovieFileNameAttribute]]"]);
	[movieView setMovie:movie];
}
</code>

it ends up saying movieView is nil, and obvious nothing else will work.
So when does the connections from IB connect during the code.  And when should i be able to use movieView, which is
connected to a [[QTMovieView]] in IB.

Sorry if this is a pretty stupid question, i am pretty new to cocoa and i am having trouble understanding why this isn't working.
Thanx for the help.
~
Stargex

----

Did you override <code>initWithWindowNibName:</code> in V<nowiki/>iewController? Did you remember to call <code>super</code>? It's the little stuff like this that always screws up my projects. --[[JediKnil]]


----
no i did not overload initWIthWindowNibName, should I have?  My [[QTMoviewView]] is getting its [[QTMovie]] file from an [[NSString]] that is in a Controller file in the [[MainMenu]].nib....   So i didn't see why i should overload that method. 
~
Stargex

----

[[NSWindowController]] loads its nib lazily. You aren't doing anything in your code to force the nib to load, so your outlets are all nil. Try inserting <code>[self window]</code> at the beginning of <code>setMovieWithFile:</code> to force the nib to load.

----

Thanx a bunch that self window message worked.  I was wondering what was wrong.
~
Stargex