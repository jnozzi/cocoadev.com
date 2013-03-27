This article shows you the code that will open a movie file in the finder, assign the movie to an General/NSMovie, and then put this movie into an General/NSMovieView.

In addition to this code, you need to create an outlet for an General/NSMovieView (named myMovieView) in your header file.  You also need to put this code in a method that you attach to perhaps the "Open" item in the "File" menu.

    
//Declare op as a pointer to an General/NSOpenPanel.
General/NSOpenPanel *op;

//Create, initilize, and assign an General/NSOpenPanel to the pointer op.
op = General/[[NSOpenPanel alloc] init];

//Open an Open panel and record the file the user selected.
[op runModal];

//Assign the movie file to the General/NSMovie pointer named movie.
General/NSMovie *movie=General/[[NSMovie alloc] initWithURL: [op URL] byReference: YES];

//Put the movie into the General/NSMovieView.
[myMovieView setMovie:movie];

//Release the objects you allocated above.
[movie release];
[op release];


Back to General/HowToProgramInOSX