[http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSGraphicsContext_Class/index.html]

The General/NSGraphicsContext class is the programmatic interface to objects that represent graphics contexts.




To avoid the following error in the console:

unlockFocus called too many time 

Make sure you're saving/restoring the graphics context properly.  Example:

	General/[NSGraphicsContext saveGraphicsState];
	
	General/[NSGraphicsContext setCurrentContext:General/[NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:NO]];

	// draw something

	General/[NSGraphicsContext restoreGraphicsState];