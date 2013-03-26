

[[CWilbur]] is really cwilbur, but wikis do not like words that are all in lower case.

cwilbur has plenty of experience programming, primarily in C and Perl, and is determined to learn Cocoa by discovering every gotcha in the Application Kit.

Things that cwilbur has learned:

[[NSWindowController]], [[NSDocument]], Nib files:

Nib files are particular about what sort of class File's Owner is.  Even if you use the standard [[NSWindowController]] class to load a window nib file rather than subclassing it, it's a bad idea to set File's Owner to anything but the window controller.

You should always check to be sure an [[NSWindow]] or [[NSPanel]]'s "window" outlet is set correctly in the nib file.  Not doing this can lead to odd errors, among them windows that show up only once and then never again. While you ''can'' say <code>[window showWindow: self]</code> even if you haven't set that outlet, it doesn't do much good, and will fail silently, if window is nil.   At least in my searching I also found out that I was not the only one with this problem:  http://www.cocoabuilder.com/archive/message/cocoa/2003/8/14/81919

A short program that I wrote do demonstrate this problem, including all the text sources viewable online and all nib files, is (no longer) available for perusal at (dead link) http://homepage.mac.com/cwilbur/[[FloatingInspector]]/ should you care to (not) see it. This example was based loosely on Apple's "Sketch" example, but contains only the code necessary to implement the inspector window part of the program.  ''NOTE: This code was intended as demonstration of the problem.  To make this code work correctly, you need to open Inspector and connect File's Owner's 'window' outlet to the panel.''