
----

In my application i need to set toolbar at bottom of window(like iphoto application).i went through nstoolbar,nstoolbaritem class but i am unable to find in this or misssing!
So, any ideas how to basically implement?  Any other solutions?
----
---- 
You can't use an [[NSToolbar]] for this.  You are probably best using either an [[NSView]] with a bunch of [[NSButtons]] or if you want/need more control a custom [[NSView]] containing some custom [[NSButtons]].
---- 
There is an unsupported way to do this.  In [[NSWindow]] there is a hidden function [[[NSWindow]] _toolbarView] which allows you to get the [[NSToolbarView]] associated with the window.  You can then take that and set it's frame in order to reposition the toolbar anywhere in the window (making sure to repaint your window afterwards).

Since this is an unofficial API, I'd recommend doing a check to make sure that [[[NSWindow]] _toolbarView] actually exists before using it in your code.  However, we've happily been using it on Mac OS 10.3 and higher.
----