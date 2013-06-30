This page is a help page for problems with General/NSToolbar.
It hopefully be managed from time to time.
Unlike the other General/NSToolbar pages, this will be for problems with the source only.

For information about selecting a toolbar item or sending a toolbar action programmatically, see General/SelectingNSToolbarItem

----
Can you have a toolbar that uses many different controllers, that have different actions?
Such as 

Controller#1-------->(action#1)>                                Action#1

                                                        General/ToolbarController--<

Controller#2-------->(action#2)>                                Action#1

----

You can set the target in your toolbar setup code

    [ item setTarget: whateverController ];

----

How do I go about adding a General/NSSearchField and/or pulldown menus [like the action menu in xcode toolbar] into a toolbar for my app?

----

A toolbar item can contain an arbitrary General/NSView. Set up an General/NSSearchField or popup menu in Interface Builder and then shove them into your item when you set it up.

----

See General/NSToolbarItemSampleCode

See also General/GenericToolbar

See also General/NSToolbarTutorial