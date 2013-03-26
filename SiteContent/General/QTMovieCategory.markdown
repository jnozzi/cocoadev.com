


Apple neglected a very simple method in [[QTMovie]], that it actually supported in [[NSMovie]]: isPlaying.  It just returns whether or not the movie is currently playing.

Header File
<code>
@interface [[QTMovie]] ([[SimpleAccessorsAdditions]])

- (BOOL)isPlaying;

@end

</code> 

implementation file
<code>
@implementation [[QTMovie]] ([[SimpleAccessorsAdditions]])

- (BOOL)isPlaying
{
	return [self rate] != 0;
}

@end
</code>