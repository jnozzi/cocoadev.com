

Can I set an General/NSPopupButton to act as a drop target, or do I have to have a transparent General/NSView on top of it for this purpose?  I want to have a popup menu of folders, but also want the user to be able to drop a folder proxy icon into the popup itself, which would then be processed and added to the menu.

Thanks

----

Subclass it, implement the appropriate D&D methods.