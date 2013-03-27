

From Apple's documentation:

*The General/QTMovie class represents both a General/QuickTime movie and a movie controller. A movie is a collection of playable and editable media content. It describes the sources and types of the media in that collection and their spatial and temporal organization. These collections may be used for presentation (such as playback on the screen) or for the organization of media for processing (such as composition and transcoding to a different compression type). The collection may be as simple as a single file that plays at its natural size for its intrinsic duration, or it may be very complex (with multiple sources of content, rich composition rules, interactivity, and a variety of contingencies).

Just as a General/QuickTime movie contains a set of tracks, each of which defines the type, the segments, and the ordering of the media data it presents, a General/QTMovie object is associated with instances of the General/QTTrack class. In turn, a General/QTTrack object is associated with a single General/QTMedia object.

A General/QTMovie object can be initialized from a file, from a resource specified by a URL, from a block of memory, from a pasteboard, or from an existing General/QuickTime movie.

Once a General/QTMovie object has been initialized, it will typically be used in combination with a General/QTMovieView for playback.*

General/QTMovie, and its associated classes, requires General/QuickTime 7 or higher. For General/QuickTime 6.X and below, you must use General/NSMovie.

see also: General/QTMovieCategory

----

**About -initWithData **

If initWithData does not return a valid General/QTMovie, try this instead:

    
General/QTDataReference *ref = General/[QTDataReference dataReferenceWithReferenceToData:filedata
							name:filename General/MIMEType:mime];
General/NSError *movErr = nil;
movie = General/[[QTMovie alloc] initWithDataReference:ref error:&movErr];


Where mime is the original data's mime type, and filename is the original file's filename. If you fetched filedata using General/NSURLConnection, mime = [response General/MIMEType] and filename = [response URL]).

----

I find myself often having to debug the load state information to find out what's going on. Here's a handy function for converting a General/QTMovieLoadState to a string:

    
General/NSString *General/StringFromQTMovieLoadState(General/QTMovieLoadState state)
{
	switch (state) {
		case General/QTMovieLoadStateError:
			return @"General/QTMovieLoadStateError";
		case General/QTMovieLoadStateLoading:
			return @"General/QTMovieLoadStateLoading";
		case General/QTMovieLoadStateLoaded:
			return @"General/QTMovieLoadStateLoaded";
		case General/QTMovieLoadStatePlayable:
			return @"General/QTMovieLoadStatePlayable";
		case General/QTMovieLoadStatePlaythroughOK:
			return @"General/QTMovieLoadStatePlaythroughOK";
		case General/QTMovieLoadStateComplete:
			return @"General/QTMovieLoadStateComplete";
	}
	return @"Invalid state";
}
