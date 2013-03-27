Why do I get a "Can't cache image" error when I try alloc'ing an General/NSImage?

----
It's a bit difficult to answer this question because General/NSImage is a complex class and you haven't provided any code, so it is not known exactly what you're doing wrong. It sounds like you're only alloc'ing and initing an General/NSImage without adding any imagerep to it (e.g. an General/NSBitmapImageRep). If so, the page on this site describing General/NSBitmapImageRep has some example code showing how to create an imagerep suitable for drawing. You might find it useful.

----
I get a "Can't cache image" error when the size of my image is 0.0 or negative in either dimension.

----
The reason for this exception is given in the documentation of General/NSImage:

    - (id)initWithSize:(General/NSSize)aSize

Discussion

This method does not add any image representations to the image object.. It is permissible to initialize the receiver by passing a size of (0.0, 0.0); **however, the receiver�s size must be set to a non-zero value before the General/NSImage object is used or an exception will be raised.**

----
Removed non-essential parts in this discussion.