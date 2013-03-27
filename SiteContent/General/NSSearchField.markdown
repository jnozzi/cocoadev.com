If you haven't noticed there is now a General/NSSearchField in Panther.  This is the control that is used in the popular Apple apps (iTunes, Mail, etc.).  Unfortunately there seems to be no documentation yet.  Has anyone been able to determine any of the API?  And if so (being a newbie), how did you determine it?

Thanks,

General/EricFreeman

----

You can always look at /System/Library/Frameworks/General/AppKit.framework/Headers/General/NSSearchField.h. Presumably. I don't have Panther, and if I did I wouldn't be able to talk about it.

----

General/NSSearchField documentation is available at http://developer.apple.com/documentation/Cocoa/Conceptual/General/SearchFields/index.html

-- General/SashaGelbart

----

I am sure there is a replacement for General/NSSearchField out there that has all the features but runs on Jaguar too. The problem is I can't find it. :(

Does anybody hav a url? -- Martin H�cker

----

General/WBSearchTextField

Look in General/ObjectLibrary - [http://s.sudre.free.fr/Software/General/DevPotPourri.html]
----
If you want to have a Recent Searches menu, like Safari, you have a General/NSSearchField
and then you create a General/NSMenu, and connect the General/NSMenu to the General/NSSearchField as a searchMenuTemplate, then add three General/NSMenuItem's to it like this

*Recent Searches - Tag 1000
*Recents - Tag 1001
*Clear Recent Searchs - Tag 1002

The API handles the rest!

--General/JoshaChapmanDodson
----
General/NSSearchField menu templates are better explained here.

http://developer.apple.com/documentation/Cocoa/Conceptual/General/SearchFields/Articles/General/MenuTemplate.html

and here

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSSearchFieldCell.html

e.g. In code, the tags are General/NSSearchFieldRecentsTitleMenuItemTag, General/NSSearchFieldRecentsMenuItemTag, General/NSSearchFieldClearRecentsMenuItemTag, as well as General/NSSearchFieldNoRecentsMenuItemTag.
----
I tried, but still nobody wants to take my information. :(

=General/JoshaChapmanDodson