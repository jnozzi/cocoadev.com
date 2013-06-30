Describe General/InitWithFrameNSOpenGL here.

Any particular reason why my custom General/NSOpenGLView is not getting it's (id)initWithFrame:(General/NSRect)frameRect method called? All my other overriden methods are getting called just fine (like mouseDown:, keyDown:).  I know it's something simple, but I can't figure it out.

David


----
The general answer:
Read up on the concept of *Designated Initializer*.
http://developer.apple.com/documentation/Cocoa/Conceptual/General/CocoaObjects/Articles/General/ObjectCreation.html

Initializing an General/NSOpenGLView
� initWithFrame:pixelFormat:
Initializes a newly allocated General/NSOpenGLView with frameRect as its frame rectangle and format as its pixel format.

The specific answer: (Are you using a custom view or an General/NSOpenGLView with Interface Builder ?)
See also http://developer.apple.com/qa/qa2004/qa1167.html