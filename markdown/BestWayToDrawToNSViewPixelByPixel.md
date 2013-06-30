

Hi,

What is the easiest way to change the color of just one pixel in an General/NSView? Should I use an General/NSBezierPath constrained to just one pixel? a Rect of some sort? Or is there something else?

Thanks for any help!

- P

----

draw an General/NSBitmapImageRep in the view if you want to control a matrix of pixels. But if you only want to draw a single dot, use an General/NSBezierPath and fill a rect or an oval.