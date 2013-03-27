I am struggling to draw an image with rounded corners. Basically I want to draw a rounded rect as a mask and then draw the image into it. I've been playing with all the General/NSComposite* enums and can't get it right. Any ideas?

----

See General/NSBezierPath and     addClip.

----

Thanks, that did the trick.