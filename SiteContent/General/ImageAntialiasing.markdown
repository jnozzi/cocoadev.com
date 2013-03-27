I have a number of pdf images which are normally rendered at full page with complete antialiasing and are properly antialiased when scaled by the finder/webkit/General/NSImageView etc.  In a General/NSView subclass I load the image and draw it in my view with drawInRect:fromRect:operation:fraction: using the General/NSCompositeSourceOver operation, and it renders all pixely (even with other compositing modes)... is there a way to turn on antialiasing that I am missing?

----

Antialiasing is very slow for most purposes... If you need your images antialiased however: General/[[NSGraphicsContext currentContext] setImageInterpolation:General/NSImageInterpolationHigh];