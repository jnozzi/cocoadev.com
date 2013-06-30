How do I receive mouseMoved: events in my General/NSTextView subclass when it is not the key view?  Currently, my mouseMoved:(General/NSEvent *)theEvent function only picks up mouse moved events when it is focused or key view, but I would like it to do so always.

- General/FranciscoTolmasky

----

Tell your view's window to accept mouse moved events, and get them there.