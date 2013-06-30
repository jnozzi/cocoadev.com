I'm looking to do some General/OpenGL drawing in a window. I've already got a General/NSView subclass that I assign as the contentView in my General/NSWindow, and it works perfectly.

The problem I have now is that I want to make the General/OpenGL view part of a viewport in my window, i.e. I want to assign my General/OpenGL view as a subview of another General/NSView.

I've done this, but now each time I call General/[NSOpenGLContext setView: myCustomView] it fails with the message "invalid drawable", which never occurred before. The *only* code difference here is that my window looks like:

General/NSWindow -> someView -> myOpenGLView

instead of

General/NSWindow -> myOpenGLView

like it was before.

I've scoured the net for some clue as to why this is happening, but all of the failure cases I've seen on Google seem to happen in the simpler case, whereas mine only fails on the more complex case.

Thanks in advance.

----
Sounds to me like you're calling that when your view isn't yet in a real window-server-sees-it window. But without your code it's hard to say for sure, so General/PostYourCode.