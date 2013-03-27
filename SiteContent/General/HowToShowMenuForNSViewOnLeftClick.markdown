

I just know this is gonna be a dumb question but:

I have a General/NSView subclass that I just want to show a menu when it receives a     mouseDown: event, but I can't find any way to just tell a General/NSMenu to show itself...

I'm using     General/[NSMenu popUpContextMenu:[self menu] withEvent:theEvent forView:self] in my mouseDown, but that shows a contextual menu, with items added by CMM plugins, which I *don't* want. I need to either get rid of those or just show a regular menu. Is there any way to do that?

This is for a General/NSStatusItem, but I need to use a view so I can support General/DragAndDrop.

----

To my knowledge, Cocoa actually doesn't allow this since General/NSMenuView has been deprecated. However, General/MenuManager has functions for popping up regular menus at arbitrary locations.

*I've gotten it working, more or less. The solution was to have my view contain a General/NSPopUpButtonCell, set the menu on that, and send it a     performClickWithFrame:inView: message in my view's mouseDown. The menu's positioning is still wierd, but I suppose fiddling with the frame I pass to the cell might do something... Where are the General/MenuManager functions documented? Is it Carbon? Can I pass it a General/NSMenu?*

General/MenuManager is the Carbon menu API. Its functions take a General/MenuRef, but there's some General/UndocumentedGoodness on the General/NSMenu page that lets you get a General/MenuRef from an General/NSMenu.

----

In 10.3+, there's General/NSStatusItem's     -popUpStatusItemMenu: for just this purpose.  -- Bo