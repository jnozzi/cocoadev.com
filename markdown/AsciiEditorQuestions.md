I'm starting a personal project to familiarize myself with GUI
components and string handling in the Cocoa framework.  I figured
it would be interesting to create a pair of simplistic ASCII
editing objects from scratch, roughly analogous to General/NSText and
General/NSTextView.  This is a learning experience, not an exercise in
pragmatism, so "just use General/NSTextView" doesn't quite cut it. :)

I've written text editors before, and I've been a software developer
for ten years, so I'm fairly familiar with the principals (OO, MVC,
etc.), but not the specific practices in Cocoa and General/ObjC.

So, I'd like to get things started on the right foot by asking for
your assistance finding relevant resources.  In particular, I'm
interested in existing source code (surely others have done this
before me!), or links to discussions of the subject you may have
encountered on the web -- my attempts to Google up such things
have fallen flat, most likely because I only have vague notions
of what to search for!

Thanks!  -- General/PeatBakke

----

You'll need to familiarize yourself with the General/CocoaTextSystem - even if you don't want General/NSTextView, you probably don't want to discard *all* of it. Also look at General/NSResponder, General/NSEvent, General/NSView.

General/TextMate is the only Cocoa editor I know of that doesn't use General/NSTextView, but its source code is not available.

Also, Cocoa's native text string storage is in General/UniCode, not ASCII

General/BookCocoaProgramming has an entire chapter on the text system, with information on how to substitute your own classes for various parts.

----

The O'Reilly Safari service is pretty good for this sort of thing.  -- General/PeatBakke