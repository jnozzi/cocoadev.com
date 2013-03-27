Hi.

I have a toolbar in my app, one of the General/NSToolBarItems is used like a button. This is great - General/NSToolBar is doing a great job. However, I want this General/NSToolBar item to be able to change its displayed title string (and its icon too hopefully) because it toggles a process on and off - and I want the button to show the status of the process. (ie. I want the text of the General/NSToolBarItem to toggle between "Start process" and "Stop process"). Unfortunately, I can find no way of forcing the General/NSToolbar to refresh.

I put code in - (General/NSToolbarItem *)toolbar:(General/NSToolbar *)toolbar itemForItemIdentifier:(General/NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag

(just an "if... then" which changes the title depending on the state of the above process) which correctly gives the right title for the General/NSToolbarItem, but only when it's a new 'General/ToolBar button' being dropped off the customisation pallette. How can I update the toolbar so that the General/ToolbarItem shows what I want it to at that specific moment in time?

Genuine thanks for any help offered,

-Peter 

----

Put the code in your toolbar's     validateVisibleItems method