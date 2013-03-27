


[Topic]

How drag-and-drop is achieved in Cocoa: 

The documentation of this is quite good:

file:///Developer/Documentation/Cocoa/Conceptual/General/DragandDrop/General/DragandDrop.html

-- General/DavidRemahl

This appears to have moved. In Jaguar, I found this at:

file:///Developer/Documentation/Cocoa/General/TasksAndConcepts/General/ProgrammingTopics/General/DragandDrop/index.html

-- General/NickKocharhook

Or, for Panther:

file:///Developer/ADC%20Reference%20Library/documentation/Cocoa/Conceptual/General/DragandDrop/index.html

Drag-and-drop with General/NSTableView:

Since a year ago, I've learned a bit about drag and drop.  The above link is good, but doesn't tell the whole story.  There are specific delegate methods to use for dragging in and out of an General/NSTableView, for example.  They are described in the documentation for data sources:

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Protocols/General/NSTableDataSource.html

You must remember to register any pasteboard types you create, as described in the docs that David linked to.

-- General/StevenFrank


I am grappling with this. So far I have gotten the table views (two of them) to see the drags and then evaluate them. One table view only accepts directories, the other movie files. Then it gets the pasteboard data. Now I am getting SIGBUS errors whenever I try to use the data I have.

Where do I actually work with the data source and add in the new data? Right now I am in -acceptDrop, but I am getting SIGBUS errors in places where it is impossible to have them.

Either I am going about it wrong or there is another app out there that is taking up RAM that it shouldn't have.

Any ideas?

-- General/SamGoldman

SIGBUS isn't necessarily specific to the table view, however: Make sure you're manipulating the correct tableview if your datasource services two of them.

<code>tableView:acceptDrop:(id <General/NSDraggingInfo>)info row:dropOperation:</code> is the place to be incorporating the data.

**Tips and tricks for Drag and Drop**

*General/TableViews: Remember that you need to subclass General/NSTableView and override 
<code>- (General/NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal </code>
in order to support dragging from your General/NSTableView to other applications (like the Finder).

*Pasteboards: Also remember that when using a pasteboard 'pb', you must call [pb types] before accessing the data. 

*in <code>tableView:acceptDrop:(id <General/NSDraggingInfo>)info row:dropOperation:</code>, you should use      [info draggingPasteboard];  instead of      General/[NSPasteboard  pasteboardWithName:General/NSDragPboard];  to get the drag pasteboard. The General/NSDragPboard isn't always right.


--General/MichaelMcCracken

REQUEST: We need some example code for General/NSTableView Drag & Drop. The documentation is good at explaining what one needs to implement, but it doesn't really give much information about the implementation in those methods. I am not sure I am doing the right things in the right places.

- General/SamGoldman

If noone's done this in a week and a half, I will (today is 6/5/02) - General/MichaelMcCracken (Working on it now over in General/DragAndDropTableView)


I have some working code here, if you haven't done too much don't worry about it  i just need to spruce it up a bit --General/HaRald

You may find the project called General/DragNDropOutlineView very useful. It's found in Mac OS X Developer CD->Developer->Examples->General/AppKit. It uses General/NSOutlineView instead, but clearly shows how/what can be done.

- Tito Ciuro

----
Here's a nifty trick which I couldn't find documented anywhere. If you want the entire General/NSTableView to highlight when being dragged over, instead of just a single row, do the following in your <code>tableView:validateDrop:proposedRow:proposedDropOperation:</code> method:

    
[tableView setDropRow: -1 dropOperation: General/NSTableViewDropOn];


By setting the drop row to -1, the entire table is highlighted instead of just a single row. 

- Greg Casey

If you want to achieve the same thing using an General/NSOutlineView instead of an General/NSTableView, try this:

    
[outlineView setDropItem:nil dropChildIndex:-1];


I didn't find this documented anywhere, so it's not quite as safe as the General/NSTableView method, but seems to work fine on Leopard.

- Andreas Varga

----
I'm trying to use General/DragAndDrop with an General/AddressBook Pallete, and a General/NSTableView how would that be done? --General/JoshaChapmanDodson@
----

How do i make the drag function not to highlight the table or any cells?

I assume you want to make it invalid to drop on top of an existing row? In tableView:validateDrop:proposedRow:proposedDropOperation: , check the value of the General/NSTableViewDropOperation argument against General/NSTableViewDropOn, and return General/NSDragOperationNone in that case. Then you can only drop in between rows.

----

How to make a custom highlighting of the drop target? For example like Address Book does when dropping contact to some group. I am subclassing the General/NSTableView to see which of the draw methods makes that ugly black drop destination rectangle. No luck. I can get rid of it only if I make an empty drawRect --General/AndreyBabak

bump - anyone know the answer to andrey's post above?

----

depends on the OS.  On Leopard you subclass General/NSTableView and implement

<code>
- (id)_highlightColorForCell:(General/NSCell *)cell;
{
    return nil;
}
</code>

----
Example of drag and drop from one General/TableView to another where one table is groups and the other is items:
http://web.mac.com/agerson/Site/General/CoreDataDNDWithGroups.html


----

there are some *cough* private methods that get rid of those black rectangles, which is never a good idea as things may break in the future.  However, for educational purposes, you can try overriding the following in your General/NSTableView subclass: _drawDropHighlightBackgroundForRow: as in

<code>
- (id)_drawDropHighlightBackgroundForRow:(id)unObject{
	return nil;
}
</code>