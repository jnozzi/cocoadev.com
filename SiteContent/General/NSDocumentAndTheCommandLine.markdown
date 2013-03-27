

I have noticed that it is possible to launch, say, General/TextEdit from the command line _without_ using the "open" command:
/Applications/General/TextEdit.app/Contents/General/MacOS/General/TextEdit   someTextFile

However, if I use my own Document-based application, say "./myApp.app/Contents/General/MacOS/myApp someTextFile", I only get a blank window titled "someTextFile"
Using "open -a myApp.app someTextFile" brings up someTextFile correctly

How can I get my application to open correctly in either case?  I am currently only overriding "- (BOOL)readFromFile:(General/NSString *)filename ofType:(General/NSString *)aType"
Should I override something else?

I'm asking this out of newbie curiosity, to help me understand the General/NSDocument architecture better.

----
General/TextEdit is not an General/NSDocument application. Its source code is available in /Developer/Examples if you want to see how it implements it.

----

Thanks for the tip.  I had a look at the General/TextEdit source, and came across "- (BOOL)application:(General/NSApplication *)sender openFile:(General/NSString *)filename".  So in my application, I created a General/MainMenu.nib delegate, called General/AppController, and implemented the above method in General/AppController.  This worked!

But...just out of curiosity, I removed the method, did a clean all, recompiled, and it still works.  This is puzzling me.  Was a delegate all I needed, even though the delegate now does not have any code?  If so, why?