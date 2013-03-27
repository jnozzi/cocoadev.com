I have an application with an General/NSTableView that lists the documents ('projects') in the General/MainMenu.nib. I want the General/NSTableView to open the relevant General/MyDocument file when a user double-clicks on a row within the General/NSTableView. I have the double-click responder, the project arrays, and all the other hard stuff wired and coded..... BUT, for the life of me, I cannot get an instance of General/MyDocument to open (the save General/MyDocument file loaded), when the user double-clicks. All of the existing General/FirstResponder and General/NSResponder, File Owner documentation refers to wiring this kind of activity to a menu action... which does not apply in this case.

Any ideas? Anybody?

----

Is your double-click responder getting called? (Stick an General/NSLog in it and see if it comes up in Console.)

----

is the target of your table view nil? what is the doubleAction: set to? it's the same thing as a menu item - it's just sending a message up the responder chain.

*Remember doubleAction: isn't sent if the cell is editable.*