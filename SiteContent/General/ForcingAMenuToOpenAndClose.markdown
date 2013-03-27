Hi, i am creating a search function for my program and i need the results to display in a menu under the searchfield, but i have no clue on how to force it to open when there is results and to close when there is none. Any help would be great.

--General/TomHancocks

----

That's not how menus are meant to be used. There is no easy way to do that. Use a table view in a drawer or sheet instead.

----

I guess spotlight should be removed from tiger then eh?

----

That's not a menu.

----

If you are using an General/NSSearchField, it is plausible that you might want the down arrow key to pop open the menu (as I did in General/AcidSearch). This would not be completely against OS X's style guidelines, as Safari does it in the location bar. I achieved this by sending a "fake" mouseUp: event to the Search Field. --General/RobinHP

----

I think most people implement drop-downs like these with General/NSTableViews in a borderless window.

----

Thanks all, i shall keep all this mind -- General/TomHancocks