

Has anyone been able to get General/QTMovieView to play a movie with transparency without it drawing a background color?

With General/NSMovieView, I can load a movie with transparency into an General/NSMovieView in a transparent General/NSWindow (set using [window setOpaque:NO] and [window setBackgroundColor:General/[NSColor clearColor]]) and it when played, it will essentially composite the movie over top of whatever other windows were visible behind it.

I have had no success in trying to get General/QTMovieView to behave simmilarly. If I set the view's fill color to be clear (using [movieView setFillColor:General/[NSColor clearColor]]), when I load a movie with transparency, it will draw the background as white. If I set the fill color in Interface Builder to be a clear color, the view will initially appear transparent, but as soon as I load a movie, it will draw a white background. I can't find anything in the documentation for either General/QTMovieView or General/QTMovie that has to do with allowing transparency. 

I would really prefer to use the General/QTKit classes over General/NSMovieView because of their expanded functionality, but I really need transparent Quicktime playback for an application I'm writing. Has anyone had any luck making General/QTMovieView play nice with transparency?

---nate
----
It doesn't really answer your question, but you can use General/QuartzComposer and a General/QuartzComposer view to accomplish what you want.  You can also do it yourself programatically using General/OpenGL an QT.