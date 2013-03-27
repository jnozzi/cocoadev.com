

Hello all-
I am trying to develop a General/NSStatusItem that operates like Spotlight.  In other words, an application that resides in the main menu bar that, when clicked on, will display a search field followed by a list of items.

Now, it is easy to make an General/NSStatusItem with a custom view.  I started out with a General/NSPopUpButton with a menu loaded.  This works great for listing the items.  It also handles the button clicks and focus nicely.  Therefore, I was hoping to simply subclass General/NSMenu (or General/NSPopUpButton) and push down the item list to fit a search field.  However, I cannot seem to figure out how General/NSMenu draws itself (so that I can override it).  Or, how General/NSPopUpButton loads the menu (so I can override that).

Anyone have any ideas/ suggestions?  Or, a better way of doing this?  Kinda stumped...

Thanks in advanced.
-Ryan

----

See General/NSMenuExtra

----

Yeah, but General/NSMenuExtra is not really good to use.  It is more like a hack.  General/NSStatusItem works great, I just need a way to subclass an General/NSMenu to display something different.  Or, I have to write my own control.

-Ryan

*General/NSMenuExtra isn't a total hack...but that's not the issue here. Both General/NSMenuExtra and General/NSStatusItem use General/NSMenu to display their interface (by default, anyway). The way to do this might be to just show and hide a General/BorderlessWindow when the menu bar icon is clicked. --General/JediKnil*

----

You currently cannot place a custom view in an General/NSMenuItem, at least not in Cocoa, using the public API. I think that a custom General/NSWindow would be the best alternative in this situation. -DF