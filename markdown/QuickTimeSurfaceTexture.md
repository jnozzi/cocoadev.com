

Is it  possible to use the General/NSMovieView as a surface texture in an opengl application?  Could i use the method createTexture:fromView:internalFormat: of class General/NSOpenGLContext to do this so far my i cant seem to get a to work properly.  I want to to this so i use the quicktime movie as a texture in my 3d scene.  Thanks.

I don't know if that could work especially without the view being visible, but if you look at http://www.withay.com/macosx/opengl/gl_qt.html there is a complete example of what you want. It extracts the current frame from a movie and loads it into a General/OpenGL texture buffer. General/HaRald

----

This example is pretty good, except for handling arrow keys. Rather than getting the time scale and dividing by 5 (what a hack!) the app should ask QT for the next "interesting" time. Something like this:

    
- (void)frameAdvance:(id)sender
{
	Movie movie = [mMovie General/QTMovie];
	General/TimeValue oldTime, newTime;
	General/OSType types[] = {General/VideoMediaType};

	// find the next sample
	oldTime = General/GetMovieTime(movie, NULL);
	General/GetMovieNextInterestingTime(movie, nextTimeMediaSample, sizeof(types) / sizeof(types[0]), types, oldTime, FLOAT_TO_FIXED(1.0), &newTime, NULL);
	if (oldTime < newTime) {
		General/SetMovieTimeValue(movie, newTime);
		[self setNeedsDisplay:YES];
	}
}

- (void)frameReverse:(id)sender
{
	Movie movie = [mMovie General/QTMovie];
	General/TimeValue oldTime, newTime;
	General/OSType types[] = {General/VideoMediaType};

	// find the next sample
	oldTime = General/GetMovieTime(movie, NULL);
	General/GetMovieNextInterestingTime(movie, nextTimeMediaSample, sizeof(types) / sizeof(types[0]), types, oldTime, FLOAT_TO_FIXED(-1.0), &newTime, NULL);
	if (oldTime > newTime) {
		General/SetMovieTimeValue(movie, newTime);
		[self setNeedsDisplay:YES];
	}
}


Condensing this down to one function is left as an exercise. Otherwise, I thought the demo was pretty good. 

-- Mike Trent


the url posted above (http://www.withay.com/macosx/opengl/gl_qt.html) is now defunct.  Anyone know where that content might now be found?

General/EcumeDesJours

----
General/OpenGL and General/QuickTime, on Mac OS X

Mac OS X

General/CiphSafe Developer Tools General/LIOService CFFP NFS client NFS server ssh-agent General/OpenGL
Other SW

Java General/FreeCiv General/SWebRedirD
Miscellaneous

Spam reports Calvin & Hobbes PGP key Home
Contents

See Also
Summary
The Files
Startup Code
General/OpenGL Initialization
Drawing the Scene
Controlling the Demo
Cleanup
See Also

Be sure to also have a look at:
QT ValuePak2 - shows a number of techniques for using General/QuickTime in games (including, of course, General/OpenGL use)
Apple's General/OpenGL Movie - General/QuickTime with General/OpenGL, in Carbon
Summary

This is a little demo that shows how to use General/QuickTime code to generate textures for General/OpenGL, so you can have movies in 3D programs. A couple of screenshots are available (but note they're a bit boring since static shots of a moving image obviously don't capture the movement).

What this code does is texture map the movie onto two surfaces, a simple 3D rectangle (front and back) and a sphere. When running, you can pause/play the movie with the spacebar, start/stop the spinning with the S key, fast-forward/rewind with the right and left arrow keys, and change the volume with the up and down arrow keys. In the upper-left corner is a frame rate display, so you can see how different movie file formats and sizes affect performance.

When first run, it will open a window requesting a movie to use. Find one (anything General/QuickTime supports, but the extensions allowed in the code are mov, mpg, mpeg, mp4, dv, and avi), and choose it. The program will then open a window and start the movie. You can toggle full screen and windowed mode with Ctrl-Cmd-F.

The Files

All the code, and associated Project Builder files, are in the zipfile (15KB). The base Cocoa+General/OpenGL code is from the ports I've done of General/NeHe's General/OpenGL tutorials. Only the interesting code is shown and discussed here.

The compiled application is also available in a zipfile (19KB), if you don't feel like compiling it.

Startup Code

When it starts, the first interesting bit of code is in GL_QTController.m, in awakeFromNib:

if( General/EnterMovies() != noErr ) [ self createFailed:@"Failed to initialize General/QuickTime" ];
This is how General/QuickTime is initialized. It's balanced by a call to General/ExitMovies() in dealloc.

One note, while we're looking at awakeFromNib, is that the General/OpenGL view is created with 32 color bits and 32 depth bits, which doesn't work on all systems (especially the depth bits). Also, when switching to full screen (in setFullScreen:), the mode used is 1280x1024, which also doesn't work universally. If the program doesn't start, try changing the depth bits to 16, or 8, or 4, or 2, or even 1. If full screen doesn't work, try dropping the resolution to one you know your system supports.

Back to initialization, when the General/OpenGL view is created, the first thing it does (in GL_QTView.m, method initWithFrame:colorBits:depthBits:fullscreen:) is to get the shared General/NSOpenPanel to ask for a movie.

openPanel = [ General/NSOpenPanel openPanel ]; [ openPanel setAllowsMultipleSelection:NO ]; if( [ openPanel runModalForTypes:[ General/NSArray arrayWithObjects:@"mov", @"mpg", @"mpeg", @"mp4", @"dv", @"avi", nil ] ] == General/NSCancelButton ) [ General/NSApp terminate:self ];
We quit if the user hits cancel. Once we have a file, we call loadMovie:, which, if you haven't figured out from the method name, loads the given movie:

- (BOOL) loadMovie:(General/NSString *)movieFile { General/CFURLRef movieURLRef; General/FSRef urlFSRef; General/FSSpec movieFileSpec; movieURLRef = General/CFURLCreateFromFileSystemRepresentation( kCFAllocatorDefault, [ movieFile cString ], [ movieFile length ], FALSE ); General/CFURLGetFSRef( movieURLRef, &urlFSRef ); General/FSGetCatalogInfo( &urlFSRef, kFSCatInfoNone, NULL, NULL, &movieFileSpec, NULL ); General/CFRelease( movieURLRef ); General/OpenMovieFile( &movieFileSpec, &movieRefNum, fsRdPerm ); General/NewMovieFromFile( &theMovie, movieRefNum, NULL, NULL, 0, NULL ); return TRUE; }
(The error checking code has been removed for simplicity). What this code does it create an General/FSSpec for the file (via CFURL, as that's a simple way of doing this in Cocoa), and passes it to General/OpenMovieFile which returns a movie file reference (closed in dealloc). Finally, this reference is sent to General/NewMovieFromFile, returning what we need, a Movie, which we can play, stop, display, and so on (disposed of in dealloc).

Back in initWithFrame:colorBits:depthBits:fullscreen:, we call setupOffscreenGWorld to create an offscreen General/GWorld into which General/QuickTime draws the actual video part of the movie:

- (BOOL) setupOffscreenGWorld { gworldMem = calloc( movieBox.right * movieBox.bottom * 4, 1 ); General/QTNewGWorldFromPtr( &offscreenGWorld, k32ARGBPixelFormat, &movieBox, NULL, NULL, 0, gworldMem, movieBox.right * 4 ); General/SetMovieGWorld( theMovie, offscreenGWorld, NULL ); gworldPixMap = General/GetGWorldPixMap( offscreenGWorld ); General/LockPixels( gworldPixMap ); gworldPixBase = General/GetPixBaseAddr( gworldPixMap ); return TRUE; }
This code creates the General/GWorld, tells General/QuickTime to draw our movie there, then retrieves a pointer to the buffer where this data resides, so we can make it into a texture.

General/OpenGL Initialization

General/OpenGL initialization begins in initGL which first creates a simple, black texture. It's used to initialize the movie texture so there are no odd pixels in it later when we update the texture.

glGenTextures( 1, texture ); glBindTexture( GL_TEXTURE_2D, texture[ 0 ] ); texSize[ 0 ].width = [ self nextPowerOf2:movieBox.right ]; texSize[ 0 ].height = [ self nextPowerOf2:movieBox.bottom ]; texBytes[ 0 ] = calloc( texSize[ 0 ].width * texSize[ 0 ].height, 3 ); glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, texSize[ 0 ].width, texSize[ 0 ].height, 0, GL_RGB, GL_UNSIGNED_BYTE, texBytes[ 0 ] ); glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR ); glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR ); free( texBytes[ 0 ] );
To determine the size of this texture, we need to set it to a power of 2 (required for an General/OpenGL texture), and make sure it is at least as large as the movie; eg, if the movie's width is 240 pixels, the texture will be 256 pixels wide.

Next, we calculate the ratio between the movie size and texture size. This ratio will be used as part of the texture coordinates when texture mapping in drawRect later.

texMovieWidthRatio = (General/GLfloat) movieBox.right / texSize[ 0 ].width; texMovieHeightRatio = (General/GLfloat) movieBox.bottom / texSize[ 0 ].height;
Nothing else interesting in initGL except we create a quadric for drawing the sphere.

Drawing the Scene

The first things done in drawRect are to start the movie if necessary, and to move the position to the beginning of the movie if we've reached the end.

if( !General/GetMovieActive( theMovie ) && !moviePaused ) General/StartMovie( theMovie ); if( General/IsMovieDone( theMovie ) ) General/GoToBeginningOfMovie( theMovie );
After this, we enable texturing, select our movie texture, then update that texture if the movie is currently playing.

glEnable( GL_TEXTURE_2D ); glBindTexture( GL_TEXTURE_2D, texture[ 0 ] ); // Select our texture if( !moviePaused ) [ self updateTexture ];
updateTexture is the interesting part here, it's where the movie image is taken from General/QuickTime and moved over to General/OpenGL:

- (void) updateTexture { register int index; register int boxsize = movieBox.bottom * movieBox.right; register uint32_t *readPos = (uint32_t *) gworldPixBase; register uint32_t *changePos = (uint32_t *) textureBuf; General/MoviesTask( theMovie, 0 ); for( index = 0; index < boxsize; index++, changePos++, readPos++ ) *( changePos ) = ( ( *readPos & 0xFFFFFF ) << 8 ) | ( ( *readPos >> 24 ) & 0xFF ); glTexSubImage2D( GL_TEXTURE_2D, 0, 0, 0, movieBox.right, movieBox.bottom, GL_RGBA, GL_UNSIGNED_BYTE, textureBuf ); }
Not a huge amount of code, but quite a bit of work is going on. General/MoviesTask() tells General/QuickTime to update to the next part of the movie, which means the offscreen General/GWorld receives the current video frame. The for loop converts the General/GWorld image format, which is ARGB, to a format usable by General/OpenGL, namely, RGBA. It does this by reading data from the offscreen General/GWorld in 32 bit chunks (the uint32_t types), shifting the data around using bitwise operations, and loading that into our texture buffer (textureBuf). This is then passed to the General/OpenGL function glTexSubImage2D, which updates the texture image to include the new video frame.

Back in drawRect, we do quite a bit of typical General/OpenGL code after updating the texture. Set things up, move around, draw a sphere, draw the 3D rectangle, print the current frame rate, and update the rotation variables if spinning is enabled. The only part of this which is interesting is the selection of texture coordinates, where we use the ratios calculated in initGL:

glTexCoord2f( 0.0, texMovieHeightRatio ); glVertex3f( -SCREENX, -SCREENY, SCREENZ ); glTexCoord2f( texMovieWidthRatio, texMovieHeightRatio ); glVertex3f( SCREENX, -SCREENY, SCREENZ ); glTexCoord2f( texMovieWidthRatio, 0.0 ); glVertex3f( SCREENX, SCREENY, SCREENZ ); glTexCoord2f( 0.0, 0.0 ); glVertex3f( -SCREENX, SCREENY, SCREENZ );
The use of texMovieHeightRatio and texMovieWidthRatio cause General/OpenGL to only use the movie image itself, instead of using the entire texture. Recall from initGL that the texture dimensions are powers of 2, which usually will be larger than the movie. If we used the entire texture, there'd be empty black areas above and to the right of the movie image instead of the movie taking the entire space.

Controlling the Demo

When the spacebar is pressed, pauseMovie is called, which toggles playback. This is accomplished by calling one of two General/QuickTime functions:

- (void) pauseMovie { moviePaused = !moviePaused; if( moviePaused ) General/StopMovie( theMovie ); else General/StartMovie( theMovie ); }
The left and right arrows cause the current position in the movie to be changed; the left arrow calls backupMovie and the right arrow calls advanceMovie. Each of these methods do basically the same thing, except backupMovie uses negation of the argument

- (void) backupMovie { [ self changeMoviePosition:-General/GetMovieTimeScale( theMovie ) / 5 ]; }
General/GetMovieTimeScale() returns the time scale for the movie, which we divide by 5 as it would otherwise jump around pretty fast. changeMoviePosition actually moves the current movie position:

- (void) changeMoviePosition:(General/TimeValue)byValue { General/TimeValue currentMovieTime = General/GetMovieTime( theMovie, NULL ); if( currentMovieTime + byValue <= movieDuration && currentMovieTime + byValue >= 0 ) { General/SetMovieTimeValue( theMovie, currentMovieTime + byValue ); [ self updateTexture ]; } }
First, we check to make sure moving the position won't move it beyond the range of the movie, and if not, call General/SetMovieTimeValue() to do the move. Then we call updateTexture to update the texture.

Finally, the up and down arrow keys modify the volume of the movie (if it has an audio track). They each change the volume by 5 units; like backupMovie and advanceMovie, decreaseVolume and increaseVolume only differ in direction.

- (void) decreaseVolume { [ self changeMovieVolume:-5 ]; }
changeMovieVolume first makes sure the volume won't go beyond legal values, and if not, changes the volume:

- (void) changeMovieVolume:(int)byValue { short currentMovieVolume = General/GetMovieVolume( theMovie ); if( currentMovieVolume + byValue <= kFullVolume && currentMovieVolume + byValue >= kNoVolume ) General/SetMovieVolume( theMovie, currentMovieVolume + byValue ); }
Cleanup

When the program quits, the cleanup includes (in GL_QTView's dealloc):

General/UnlockPixels( gworldPixMap ); General/DisposeGWorld( offscreenGWorld ); free( gworldMem ); General/DisposeMovie( theMovie ); General/CloseMovieFile( movieRefNum );
Basically, we free up the General/GWorld, free up the memory which was used by it, and dispose of the movie and the movie file reference.

Also, GL_QTController's dealloc calls General/ExitMovies() to close out General/QuickTime.

http://www.withay.com/macosx/opengl/gl_qt.html
Copyright � 1999-2003 Bryan L Blackburn. All Rights Reserved.
----

Found it in an archive (http://web.archive.org/web/20031022224826/http://www.withay.com/macosx/opengl/gl_qt.html), mirrored here.