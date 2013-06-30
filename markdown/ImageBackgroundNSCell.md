

How do i make an image background in a General/NSCell? Like the album list in iTunes.

*Seems like the easiest way is to subclass General/NSCell, then draw an General/NSImage (possibly using General/NSImageCell) whenever     drawInteriorWithFrame:inView: is called --General/JediKnil*