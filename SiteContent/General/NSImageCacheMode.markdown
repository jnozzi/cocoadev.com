

The     General/NSImageCacheMode General/EnumeratedType describes how an     General/NSImage caches its data. Note that all image caching is done by     General/NSImage, *not* by     General/NSImageRep.

You can get an image's cache mode with     -General/[NSImage cacheMode] and change it with     -General/[NSImage setCacheMode:].

Due to a bug in     General/NSPDFImageRep, you should always draw it without caching. There are a couple ways to do this:

* Change its containing image's cache mode to     General/NSImageCacheNever.
* Always draw it using     General/NSImageRep's     -draw� methods. Since caching is done by     General/NSImage,     General/NSImageRep ignores it.


You can also use     General/NSImageCacheAlways to force the image to be preloaded before drawing.