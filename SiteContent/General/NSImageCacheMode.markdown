

The <code>[[NSImageCacheMode]]</code> [[EnumeratedType]] describes how an <code>[[NSImage]]</code> caches its data. Note that all image caching is done by <code>[[NSImage]]</code>, ''not'' by <code>[[NSImageRep]]</code>.

You can get an image's cache mode with <code>-[[[NSImage]] cacheMode]</code> and change it with <code>-[[[NSImage]] setCacheMode:]</code>.

Due to a bug in <code>[[NSPDFImageRep]]</code>, you should always draw it without caching. There are a couple ways to do this:

* Change its containing image's cache mode to <code>[[NSImageCacheNever]]</code>.
* Always draw it using <code>[[NSImageRep]]</code>'s <code>-draw�</code> methods. Since caching is done by <code>[[NSImage]]</code>, <code>[[NSImageRep]]</code> ignores it.


You can also use <code>[[NSImageCacheAlways]]</code> to force the image to be preloaded before drawing.