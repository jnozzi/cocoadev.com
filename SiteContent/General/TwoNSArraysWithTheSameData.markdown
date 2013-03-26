

I have a set of data in an [[NSMutableArray]], titled [[DataArray]].  I also have two other arrays, [[AllArray]] and [[SubsetArray]].  When the program starts up, it grabs all of the data from the preferences, and sets it as the [[DataArray]].  Immediately, the [[AllArray]] is set equal to the [[DataArray]].

Then, I have a search box.  When the user enters any text in the search box, it searches through the [[DataArray]], and any item that matches the search critera, are placed into the [[SubsetArray]] using [[[SubsetArray]] addObject:object]; .  Now, if the user edits any item from the [[SubsetArray]], it is changed.  However, the item still has the old data in the [[DataArray]] and, thus, when a user does a search, their data isn't saved.

So, is there any way that both the [[AllArray]] and the [[SubsetArray]] can be pointers to the [[DataArray]] objects, or something of this nature?  Otherwise, do you guys have any other ideas?  Thanks for the help.
----
I'm not sure if I understand 100%, but I'll try my best.

All of the Cocoa collections do shallow copying whenever -copy, etc. messages are sent to them. If you "shallow copy" array A that contains pointers to objects at, for example, memory addresses 0x1, 0x2, 0x3, etc. to make array B, then array B simply contains pointers to objects at memory addresses 0x1, 0x2, 0x3, etc... as well. So in otherwords, the objects pointed to in each array are the same ones. To do deep copying (i.e. to create new copies of the objects in the array), you'd have to do something a bit fancier.

This all leads me to wonder: what have you done to those arrays to force deep copying, as it sounds is what you've done, since the objects are different in all those arrays? Or maybe I'm just confused?

--[[KevinPerry]]
----
Here's some code to help you out...

prefs = [[[[NSUserDefaults]] standardUserDefaults] retain];
if ( [prefs objectForKey:@"Data"] != nil )
	[[DataArray]] = [[[[NSMutableArray]] alloc] initWithArray:[prefs objectForKey:@"Data"]];
else
	[[DataArray]] = [[[[NSMutableArray]] alloc] init];
[[AllArray]] = [[DataArray]];

then, when you the search is started, it goes through [[DataArray]], one by one, and if the object meets the search critera, it does [[[SubsetArray]] addObject:object];

So does addObject: do the hard copy that you discuss?  Because, otherwise, when an item in [[SubsetArray]] is edited, the same item in [[AllArray]] changes, but this is not the case.

----

addObject will not copy an item, it will simply retain the object and add a pointer to the array. If you have an object you're tossing back and fourth between arrays like this, you can be sure it's not being copied unless you implement the appropriate copying protocol in the class, and explicitly copy it. With that being said, are you sure you're updating the view after each change, or in the case of bindings, using the correct KVO mutators?

----

ahhh.... i see where the error was.  since it was pointers after all, i was set.  the way i "edit" an item is to create a new one with the new info, delete the old one, and add the new one.  since i was only adding it to the [[AllArray]], it wasn't getting added to the [[DataArray]].  thank you very much for all the help.