

Hi, I have an General/NSMenu object, I want to cause it to open programmatically. It's set to be the menu for an General/NSView. I've searched, but can't find anything like [menu display] or similar.

There must be a way to do this?

Thanks!

----
If you open General/NSMenu.h, one of the first methods you find is this:

    
+ (void)popUpContextMenu:(General/NSMenu*)menu withEvent:(General/NSEvent*)event forView:(General/NSView*)view;


----

Stupid-day, sorry.
--Sheepish--