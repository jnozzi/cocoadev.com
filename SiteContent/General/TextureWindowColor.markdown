Does anyone know how to get the texture window color? I know that you can get it using windowBackgroundColor when the window already has texture bgd, but is there any way to get it when you have a pinstripe window?

Jacob

----

You could always create an invisible window with <code>[[NSTexturedBackgroundWindowMask]]</code> and get the color from that.

----

I was wondering, if I could somehow get the color as data, and save it in a plist inside the bundle?

Jacob

<code>[window backgroundColor]</code> returns a [[NSColor]] object, you can archive that with [[NSArchiver]] and save it.

----

Keep in mind that the texture is copyrighted artwork, so you don't have the right to distribute it.

----

So [[PerversionTracker]] is in deep trouble! :)

----

When I posted this way back when, the purpose was to use the color to draw it in an [[NSView]] subclass that was messing up the texture background below it.

Jacob