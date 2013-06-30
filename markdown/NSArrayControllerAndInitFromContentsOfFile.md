 

Hi All,
So I have an internal General/NSArray that I want synced to an General/NSTableView.  I created an outlet to an General/NSArrayController and insert/remove from the array controller to keep everything synced with my General/NSArray and the General/NSTableview.  I can save files just fine (the General/NSArray just holds General/NSMutableDictionaries), but I am stuck in figuring out how to open them and read them into my General/NSArray and update the table.  Right now I have something like:

     ...
[myArrayController addObject: anObject];
//The above inserts an object into myArray and updates the tableview
...

//this doesn't seem to work (well it does if I 'Open' twice...wierd), I am doing this from memory so there may be a typo or two
[myArrayController removeObjects: myArray]; //clear the current table, works fine
[myArray release];
myArray = General/[NSArray initWithContentsOfFile: @"somefile.xml"]
[myArrayController setContent: myArray];
 

Any ideas on how I can manipulate myArray and let myArrayController know when I am done to let the bound General/NSTableView to update?

----

Sure. After you setContent, do the following:
    [myArrayController rearrangeObjects];

However, if you're directly manipulating the contents, you need to use proper KVO notifications. See the Apple documentation (Key-Value Observing) for more details - this really isn't difficult. You tell the array controller 'I'm going to change something', change something, then 'I'm done changing something'.

----

Ah ok, finally get it.  The "batch import array" section was useful here:

http://homepage.mac.com/mmalc/General/CocoaExamples/controllers.html