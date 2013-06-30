Hi.

I'm looking for a way to set the cover artwork of, say, the current song in iTunes. I've tried a lot of things but never got it to work. The only thing that works is setting no artwork, meaning, deleting existing artwork. This is done like this:

General/[iTunes currentTrack] artworks] setArray:nil];

Now, it'd be great if somebody could help me figure out how to set actual artwork. Thanks!

----

Seems like nobody knows. Maybe time to file a bugreport at apple?

----

[[ScriptingBridge maps General/AEDescs of typePict, typeTIFF, typeJPEG, etc. to General/NSImage, so in theory you should be able to add an General/NSImage instance to the artworks 'array' via -addObject:. In practice, this probably won't work due to General/ScriptingBridge's behind-the-scenes implementation of -addObject: - iTunes is one of the applications known to run afoul of the blind assumptions it makes. See the following discussion threads:

http://lists.apple.com/archives/Applescript-implementors/2007/Nov/threads.html#00034

http://discussions.apple.com/thread.jspa?messageID=5806609

along with the ongoing discussion on the General/ObjCAppscript page (particularly the bit about General/ScriptingBridge's "leaky abstractions"). 

Also note that while -insertObject:atIndex: is sometimes proposed as an alternative solution where -addObject: doesn't work, it is not a reliable option as it only works on 'collections' that already contain one or more elements.

-- hhas