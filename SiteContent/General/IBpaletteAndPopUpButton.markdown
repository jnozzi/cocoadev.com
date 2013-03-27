I have palettized one General/PopUpButton. But i could not able to get menu items when it is double clicked (popUpButton has not been put in Test Interface mode) as like General/NSpopUpButton. 
----
Did your pop-up button have menu items in the palette's nib file? Seems like if it's a subclass of General/NSPopUpButton it would get the same field editor automatically. --General/JediKnil
----
I have subclassed General/NSButton. I need to get the field editor for it.
----
Ah, well, General/NSButton uses a different field editor. So, somehow you need to get the field editor for General/NSPopUpButton. You can find this out by putting     General/[[[[NSPopUpButton alloc] init] autorelease] editorClassName] somewhere in your plugin (it has to be in the context of IB). If you print this to the Console, you can then implement editorClassName yourself to return this. --General/JediKnil