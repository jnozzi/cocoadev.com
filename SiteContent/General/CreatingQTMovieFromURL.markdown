

I am trying to load a movie from a URL and I am having a problem I don't quite understand.  
Here's the code:
    
// movieView is the General/QTMovieView
[movieView setMovie:General/[QTMovie movieWithURL:[NSURL General/URLWithString:@"http://www.myurl.com/movies/1.mov"]
                                    error:nil]];

And the error is 

    *** -General/[MovController setMovie:]: selector not recognized [self = 0x398180]

I looked on the net a bit, and can't find anyone who has had a similar problem.  I tried looking through Apple's General/QTKitPlayer example, but it throws an exception when I try loading a movie from a URL.  I double-checked the URL and it is correct.  I also tried with a local URL with no luck.
Any help or insight is appreciated.

Thanks, 

-- ez


----
It has nothing to do with the validity of the URL. The error is telling you that your comment is wrong.     movieView is not a General/QTMovieView, it is a General/MovController. Whatever that is (one of your classes, obviously), it does not understand the     setMovie: message, so it dies when you try to send it.

----
I think I'm missing something.  General/MovController is one of my classes, it extends General/NSWindowController.  I added a General/QTMovieView in Interface Builder and linked it to an outlet called     movieView of the General/QTMovieView type.  I don't get how it sees     movieView as a General/MovController.

Here is my relevant code in General/MovController.h
    
#import <Cocoa/Cocoa.h>
#import <General/QTKit/General/QTKit.h>

@interface General/MovController : General/NSWindowController {
    General/QTMovieView *movieView;
}

- (void)loadMovie;

@end


And in General/MovController.m
    
#import "General/MovController.h"

@implementation General/MovController

- (id)init
{
    self = [super initWithWindowNibName:@"Movie"];
    return self;
}

- (void)loadMovie
{
    [movieView setMovie:General/[QTMovie movieWithURL:[NSURL General/URLWithString:@"http://www.myurl.com/movies/1.mov"]
                                        error:nil]];   
}

@end


I'm sure it's a simple error, but I can't put my finger on it.  

Thanks, 

-- ez

EDIT: Forgot     General/IBOutlet.  I knew it was a simple mistake...

----
I'm not getting any errors or warnings anymore, but the General/QTMovieView does not appear to get updated.  When I created the .nib file, I set the     File: parameter to a local movie on my machine.  When I saw that it is working, I removed this parameter (    File: is now blank).  But, whatever URL I pass to     setMovie, it still plays the old local file.  I don't see where this reference is coming from, it's nowhere in my code.  Is there a QT cache or something similar that keeps playing the file?  Why is it not getting updated with     setMovie?

Thanks,

-- ez