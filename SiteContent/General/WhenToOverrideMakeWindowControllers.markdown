Hi, been fighting with this one for several hours.  I have an [[NSDocument]] which has multiple nibs.  Each nib has an associated [[NSWindowController]]. I want to show one of these nibs (windows) when the document loads, but not the others.

I've overridden <code>makeWindowControllers</code> in the [[NSDocument]], initialized all of my [[NSWindowControllers]], and called <code>addWindowController</code> on each.  I'm thinking this is not the way to go about it, since every [[NSWindowController]] subclass that overrides <code>windowNibName</code> shows itself when I create a new document or load one.  I just want ONE of them to show.  Ticking "visible at launch" on the windows doesn't seem to make any difference.

Should I be overriding <code>makeWindowControllers</code> here?  Would it make more sense to create one nib with multiple windows (that would get really messy I'm afraid)?  Instead, should I have a menu item (for example) initialize an alternate [[NSWindowController]], then add it to my [[NSDocument]] w/ <code>addWindowController</code>?  Or is there some way to load a nib without actually displaying it?

Thanks!

----

As far as I can tell, you're doing everything correctly, if you've been turning off "visible at launch" in Interface Builder.

You're '''only''' creating the instances of your [[NSWindowController]] subclasses in your override of <code>-[[[NSDocument]] makeWindowControllers]</code>, right?  And you're not also trying to use an [[NSDocument]] nib file, just the ones owned by your [[NSWindowController]] subclasses, right?  If so, the only thing I can suggest is to make sure you're not invoking <code>-[[[NSWindowController]] showWindow:]</code> or <code>-[[[NSWindow]] makeKeyAndOrderFront:]</code> until you actually want your windows to be displayed.

If you've made sure of all of that, it would probably help to post your code.

----

Apparently the shared [[NSDocumentController]] was calling <code>-[[[NSDocument]] showWindows:]</code> as the document was opened.  I overwrote that method in my [[NSDocument]] subclass to open ''only'' the window I wanted.