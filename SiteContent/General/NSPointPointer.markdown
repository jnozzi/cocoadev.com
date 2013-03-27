Hi, all. I'm trying to override     - (General/NSImage *)dragImageForRowsWithIndexes:(General/NSIndexSet *)dragRows tableColumns:(General/NSArray *)tableColumns event:(General/NSEvent*)dragEvent offset:(General/NSPointPointer)dragImageOffset and have everything working wonderfully except one thing: I can't adjust the dragImageOffset. I see that it's an General/NSPointPointer but the documentation is about as descriptive as a ... well ... a very non-descriptive thing.

Just how exactly do I set the x or y members of the point the point pointer points to? ;-)

----
    
dragImageOffset->x = 42.0;
dragImageOffset->y = 99.0;


D'oh! ... Thanks. Retired discussion. ;-)