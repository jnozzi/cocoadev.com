


I just recently figured out how to update windows in the dock in their minimized state. It is rather simple, but to save people some time, here is how to do it:

There is a private method which is part of the [[NSWindow]] class: - (void)updateInDock;

So somewhere create a category for the [[NSWindow]] class:

<code>
@interface [[NSWindow]] ([[DockUpdateAddition]])
- (void)updateInDock;
@end
</code>

Now to actually update your window, first you must turn off the One Shot option so the backing store for your window sticks around even while it is minimized.

And in your code simply do:

<code>
if( [mWindow isMinimized] )
{
	[mWindow display];
	[mWindow updateInDock];
}
</code>

And kazaam! The window should update now. I must note that updating a window in the dock is rough on the processor as it has to redraw the window contents and scale it, so try not to abuse it :P

-dustin

----

Just an additional tip on the same subject for Java/Cocoa programmers...  The method mentioned above doesn't exist on the Java version of [[NSWindow]].  Here's a work-around I've come up with.  It doesn't quite work the same, however, so it would be nice if someone could figure out how to actually invoke the right method!  Dustin's warning about performance is well-placed for this technique as well...

<code>

// The "window" method should return the window in question...

        [[NSWindow]] window = this.window();
        [[NSRect]]   frame  = window.frame();
        int x = 0;
        int y = 0;
        int height = (int) frame.height();
        int width = (int) frame.width();
        int diff = 0;
        
        // This makes sure that the image is centered and scaled proportionately.
        if (frame.width() > frame.height()) {
            diff = width - height;
            y = - (diff / 2);
            height = width;
        } else if (frame.width() < frame.height()) {
            diff = height - width;
            x = - (diff / 2);
            width = height;
        }
        
        window.setMiniwindowImage(new [[NSImage]](window.dataWithPDFInsideRect(
            new [[NSRect]](x, y, width, height))));

</code>

-- [[AndrewMiner]]