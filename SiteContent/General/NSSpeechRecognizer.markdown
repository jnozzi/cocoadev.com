Describe General/NSSpeechRecognizer here.

ok so I have this code for my application that creates a General/NSSpeechRecognizer.

    
General/NSSpeechRecognizer *listen;
General/NSArray *cmds = General/[NSArray arrayWithObjects:@"next song",@"last song",nil];
listen = General/[[NSSpeechRecognizer alloc] init];
[listen setCommands:cmds];
[listen setDelegate:self];
[listen setListensInForegroundOnly:NO];
[listen startListening];
[listen setBlocksOtherRecognizers:YES];


This is the method that runs when a command is recognized. Does anyone know a method that
will run if the command is not recognized or the speech recognizer cannot understand what is being said.

    
- (void)speechRecognizer:(General/NSSpeechRecognizer *)sender didRecognizeCommand:(id)aCmd {
    if ([(General/NSString *)aCmd isEqualToString:@"next song"]) {
		General/NSLog(@"next song");
		[self performSelector:@selector(General/NextSong:)];
    }
	
    if ([(General/NSString *)aCmd isEqualToString:@"last song"]) {
		General/NSLog(@"last song");
		[self performSelector:@selector(General/LastSong:)];
    }
}


Thanks

----

My guess would be 'no'. ;-) For two reasons. 1 - Anything it heard, it'd be analyzing and unless it's a match, it'd constantly be 'not matching' for all the background sounds it hears, which is terribly inefficient like Homer Simpson's "Everything's OK Alarm" which sounds every three seconds unless something's *not* okay. 2 - There are no methods in the instance, delegate, or notifications sections of the docs for General/NSSpeechRecognizer. ;-)