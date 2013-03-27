I have an app which has no UI, via having no mainmenu and the General/LSUIElement tag in Info.plist.  However, my app still has text fields and I'd like to be able to copy/paste, etc, and possibly exercise other General/FirstResponder actions.  Without the menu and it's default connections, there doesn't seem to be any straightforward way for setting app-wide keyboard actions.  How can I enable things like apple-, for prefs, etc?

----

Just go ahead and keep the main menu in your nib file, and as long as the General/LSUIElement is set to 1, the menu won't show in the menubar but it will still work.