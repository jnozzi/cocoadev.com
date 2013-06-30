General/NSBrowserCell is a subclass of General/NSCell used by default to display data in the columns of an General/NSBrowser. (Each column contains an General/NSMatrix filled with General/NSBrowserCell objects.)

see General/IconAndTextInTableCell for much more information

----

How do I show an image and text in the same column and row? I don't want the image to be shown in one column and text in another of the same row. Which cell class I should use?

----

One way is to use an General/NSBrowserCell, return the text you want to display from your data source normally and override the delegate method -tableView:willDisplayCell:forTableColumn:row: to set the image (by calling -setImage: on the cell).  -- Bo

----

While I didn't try this yet, it should be possible to just use an General/NSAttributedString with an image as attachment. Anyone actually did this? --General/AndreasMayer

----

I have, you can see it in action in App Switcher's pref pane. It works just fine. My method was rather cumbersome, but you can see a better way of adding an image to an General/NSAttributedString at

http://www.jabberstudio.org/cgi-bin/viewcvs.cgi/nitro/General/ChatWindowController.m?rev=1.2

(scroll to the -addEmoticon method). -- General/MikeAsh

Could try file:///Developer/Examples/General/AppKit/General/DragNDropOutlineView/General/ImageAndTextCell.h