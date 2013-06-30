


Apple neglected a very simple method in General/QTMovie, that it actually supported in General/NSMovie: isPlaying.  It just returns whether or not the movie is currently playing.

Header File
    
@interface General/QTMovie (General/SimpleAccessorsAdditions)

- (BOOL)isPlaying;

@end

 

implementation file
    
@implementation General/QTMovie (General/SimpleAccessorsAdditions)

- (BOOL)isPlaying
{
	return [self rate] != 0;
}

@end
