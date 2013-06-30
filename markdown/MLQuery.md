

Part of the iPhone General/MusicLibraryFramework. Without any filter predicates set, General/MLQuery returns all tracks.

    
General/MLQuery* query = General/[[MLQuery alloc] init];
int numberOfTracks = [query countOfEntities];
int i;

for ( i = 0; i < numberOfTracks; ++i )
{
  General/MLTrack* track = [query entityAtIndex:i];
  General/NSLog(@"Artist: %@, Title: %@, file path: %@", [track artist], [track title], [track path]);
}


<code>- (id)init;</code>

<code>- (int)countOfEntities;</code>

<code>- (General/MLTrack*)entityAtIndex:(int)idx;</code>