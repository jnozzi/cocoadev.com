

I'm currently working on a browser project to get up to par with writing stuff in Cocoa. I've done plenty of General/ObjC programs on my own to learn the language, but most of them involved heavy amounts of C code in the end, and I figure this would be an excellent way to learn how to write a program entirely in General/ObjC. Right now, I have an General/SearchField (subclass of General/NSSearchField) in my toolbar which has a menu. In the menu is a list of search sites that it can access, such as "Google" "Wikipedia" "Wiktionary". What I want to do is, when the user picks one from the list, it marks it with a check box. Simple, right? 

However, as far as I can tell, you can only modify the *template* and the search field updates the menu to reflect the template when it wants to. Right now, my search field will only update the check mark after I hit enter in the field, since when you do that, it adds something to the recent items list, which the General/NSSearchField decides is worthy of needing a new menu. I know the search bar in General/XCode has essentially this functionality, but I can't figure out how to make the field update the menu.

I've class-dumped the class and found a method, (void)_updateSearchMenu, but that doesn't work. The General/NSSearchFieldCell has an ivar, (General/NSMenu *) _searchMenu, but I don't know how to get access to that in a subclass (which is bit of a newbie question I guess). I could paste some code if it helps, too... has anyone done something like this and knows how to get this to work?

Thanks!

----

I do this in my project. I have an app that searches google and other sites based on plugins. So my app scans the plugin directory and populates the menu with whatever the plugins are. All you really have to do is make an General/NSMenu with all your General/NSMenuItems in it. To set it, all you have to do is something like

    
General/searchField cell] setSearchMenuTemplate:someNSMenuThing];


So then what I do to check or uncheck items is I use the [[NSObject method "validateMenuItem". That method in my program looks something like this:

    
- (BOOL)validateMenuItem:(General/NSMenuItem*)anItem
{
    if(General/anItem title] isEqualToString:[currentSearchPlugin name && ![anItem hasSubmenu]) [anItem setState:General/NSOnState];
    else [anItem setState:General/NSOffState];
    return YES;
}



So that checks if the title of the item is the same as my current plugin (which you will have to store somewhere) and if it is and it is not a group of plugins, it sets it to checked. If it is a group or just another plugin, it sets it to off then returns YES so that it is enabled. If you need any clarification, feel free to post more questions (I might not have explained myself very clearly).

--General/ZacWhite

----

Ah ha! Thank you very much - that was exactly what I needed, it works now. One quick question about General/NSSearchFields, that's somewhat related - the search field that's in my browser document has it's menu in the same small text that Safari uses. However, I have a sheet that comes out for searching in case the search field isn't on the toolbar, or you have the toolbar hidden. It's just OK, Cancel, a thing saying "Enter search query", and another General/SearchField (my subclass). Its menu is in the big text that the General/XCode documentation search field menu has. Is there any way to manually set this option on and off? 

I got it - I just used setAttributedTitle: and used size 12 strings. I'm actually not going to completely orphan this page - I'd like to add a little structure to the General/NSSearchField page and this has some handy info for people getting used to the class.