

Hi, I'm new to General/ObjC and I was wondering how to do something.

The situation:

I'm creating an application that (should be) fairly straight forward. It's an application that allows the user to drag and drop files onto a custom view and then files are processed and only the General/JPGs are added into an General/NSTableView. All of my components work on their own, but it fails when I try to make it all work together.

Nib Design:

The Nib is very simple. There's one window that has a General/NSTableView dropped on it, and then a custom view (custom class: General/FileDragDrop) that sits behind it, allowing users to drag and drop files "into" the table view. The General/NSTableView is not editable by users--only through dragging and dropping in this manner.

File setup:

* General/AppController: a sub-class from General/NSObject and is instantiated in General/MainMenu.nib; this takes care of the actions to process the files (in this case adding a meta tag to them).
* General/FileDragDrop: the class for the custom view that lays behind the General/NSTableView that receives the drag and drop action
* General/DataSource: the dataSource for the General/NSTableView
* General/PhotoFile: a class that creates an object to represent each JPEG file; when files are dragged onto the custom view, the JPEG file paths are used to create this object, and then the resulting object is stored in an array


The problem:

Now, like I said earlier, all of these components work individually. Testing with General/NSLog(), I can see that all the data exists within the class. My problem is how do I link all the data together? General/DataSource and General/FileDragDrop both need access to the General/NSMutableArray that contains all of the General/PhotoFile objects. The General/FileDragDrop needs to be able to tell General/DataSource that new files have been dropped and that it's time to update the view. How do I make it so that all of these objects can talk to each other?

----
You can put all those items inside your Nib files. Create outlets in your controller for them. Make sure all of your objets also have outlets for the controller. Then, any object (such as the drag-n-drop view) can see the controller. The controller can then relay the data to another object (such as the data source). In addition, it can tell the display to update itself once the new data is there.
----