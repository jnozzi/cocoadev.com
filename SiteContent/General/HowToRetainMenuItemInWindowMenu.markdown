

Sorry for very basic question, but I cant' figure out what I have to do. I have an app with a single window, and when I close the window, it disappears from "window" menu. I want it to stay there, so i can bring it back later, and for this i tried to create a menu item for this window in IB, but then I have two menu items at runtime - one I created in IB and second is created automatically. 
Should I destroy the automatically created menu item or there is a way to tell it to stay even after window closing?

----

Change your window to a [[NSPanel]] (or tell it to <code>setExcludedFromWindowsMenu:YES</code>) and add your own menu item to the Window menu for your window.

----

Though that won't set the state, you'll have to add code to set the state yourself.

----

IMO in this case, you should change the menu item's title to reflect its action, not simply check/uncheck the item.

<code>
+----------------+
| Show Window 1  |
| Hide Window 2  |
+----------------+
</code>

is much clearer than

<code>
+----------------+
| v Window 1     |
|   Window 2     |
+----------------+
</code>

You should also track the window's minimization state, and set that appropriately.

----
''Thanks for your help. I did use'' <code>setExcludedFromWindowsMenu:YES</code> ''and added my own menu item to the Window menu. It works.

I agree that this way is clearer:''
<code>
+----------------+
| Show Window 1  |
| Hide Window 2  |
+----------------+
</code>
''But I was looking at Apple's Address Book and iTunes, and there it is done that way:''
<code>
+----------------+
| v Window 1     |
|   Window 2     |
+----------------+
</code>
''So i think i will stick with Apple's way for now :) ''

----
Relevant HIG link: [http://developer.apple.com/documentation/[[UserExperience]]/Conceptual/[[OSXHIGuidelines]]/[[XHIGMenus]]/chapter_7_section_3.html#//apple_ref/doc/uid/TP30000356/TPXREF121]

----

You don't really need to do anything with the window's state. If the item is selected and the window's closed, open it, if it's open, bring it to the front. This is what [[FontBook]] does.

----

Remember, when using <code>setExcludedFromWindowsMenu:</code>, you must call it after the nib has been loaded, or else it won't work.