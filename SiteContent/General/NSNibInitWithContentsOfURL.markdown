Is there a use for General/NSNib's -(id) initWIthContentsOfURL, and if so are there security concerns? I can't really think of a use for it.

----

Aren't you now supposed to use General/URLs for referring to local files in some things now? Perhaps that's it's intended use.

----
Yes indeed, a great many General/APIs use General/URLs for local files just for... fun, or consistency. General/CoreFoundation in particular loves dealing with General/URLs instead of paths.