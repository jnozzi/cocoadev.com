

Here is some sample code to load a movie (anything that General/QuickTime supports) and start playing it (only audio though).

Please note, General/NSMovie and General/NSMovieView are obsolete in favor of General/QTMovie.

    
- (void)setMovie:(General/NSMovie *)movie
{
	if (_movie != movie)
	{
		[_movie release];
		_movie = [movie retain];
	}
}

- (void)setTimer:(General/NSTimer *)timer
{
	if (_timer != timer)
	{
		if (_timer) [_timer invalidate];
		[_timer release];
		_timer = [timer retain];
	}
}

- (void)resetTimer
{
	General/NSTimer *timer = General/[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkForEndOfMovie:) userInfo:nil repeats:YES];
	General/[[NSRunLoop currentRunLoop] addTimer:timer forMode:General/NSEventTrackingRunLoopMode];
	[self setTimer:timer];
}	

- (void)play
{
	[self setMovie:General/[[[NSMovie alloc] initWithURL:[NSURL fileURLWithPath:General/self track] location byReference:YES] autorelease]];
	if (_movie != nil)
	{
		General/StartMovie([_movie General/QTMovie]);
		[self resetTimer];
	}
}

- (void)checkForEndOfMovie:(General/NSTimer *)timer
{
	General/MoviesTask([_movie General/QTMovie], 500);
	
	if (General/IsMovieDone([_movie General/QTMovie]))
	{
		[timer invalidate];
		
		// notify delegate (update UI?)
		SEL sel = @selector(trackPlayerDidEnd:);
		if ([_delegate respondsToSelector:sel])
			[_delegate performSelector:sel withObject:self];
	}
}


The timer (which checks for the end of the movie) is added to the current run loop, so that when the window is resizing, and other GUI stuff is happening, the movie keeps playing. This is important if you want to have smooth playback. The General/QuickTime functions used are General/StartMovie(), General/StopMovie(), General/IsMovieDone() and General/MoviesTask(). General/MoviesTask is used to keep playing the movie.