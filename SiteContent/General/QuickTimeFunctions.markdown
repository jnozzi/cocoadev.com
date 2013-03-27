

Hi people...

I wanted to get a General/QuickTime bar to play a MP3 in my app. So I took a sample code from somewhere (I don't remember, I will add it here if I find it) and I tweaked it to fit in my code.

Now, I want to be able to move the reading head accurately on the bar. For example, move the head to the timer "2:45.12".

I read the General/QuickTime API documentation, but argh, it's about 4000 pages long. I'm lost. Has anyone did something like this before ? Or anyone that has experience with General/QuickTime calls. Any hint will be appreciated... Thanks...

-- Trax

----

You might want to take a look at
    
void General/SetMovieTime (
     Movie            theMovie,
     const General/TimeRecord *newtime );   


and to get the General/TimeRecord, try using <code>General/GetMovieTime</code>.

It's from http://developer.apple.com/techpubs/quicktime/qtdevdocs/APIREF/SOURCESIV/timerecord.htm and http://developer.apple.com/techpubs/quicktime/qtdevdocs/APIREF/SOURCESIII/setmovietime.htm

Here's something that might work if you're using an General/NSMovie.
    
#import <General/QuickTime/General/QuickTime.h>

General/NSMovie *theMovie; // assume this exists
Movie qtMovie = [theMovie General/QTMovie];

if (General/EnterMovies() == noErr)
{
    General/TimeRecord timeRecord;
    General/TimeValue currentTime = General/GetMovieTime(qtMovie, &timeRecord);
    // do something with timeRecord and/or currentTime
    General/SetMovieTime(qtMovie, timeRecord);
}


Keep in mind that I've never used the General/QuickTime General/APIs in my life :).