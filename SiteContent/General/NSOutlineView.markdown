General/NSOutlineView topics:
[Topic]

General/NSOutlineView inherits from : General/NSTableView  :  General/NSControl  :  General/NSView  :  General/NSResponder  : General/NSObject.

http://developer.apple.com/documentation/Cocoa/Conceptual/OutlineView/Articles/Art/outlineview.gif

Class Reference for General/NSOutlineView at ADC:

http://developer.apple.com/documentation/Cocoa/Reference/ApplicationKit/Classes/NSOutlineView_Class/Reference/Reference.html

Conceptual Docs:

http://developer.apple.com/documentation/Cocoa/Conceptual/OutlineView/index.html

Docs for the <General/NSOutlineViewDataSource> Protocol:
http://developer.apple.com/documentation/Cocoa/Reference/ApplicationKit/Protocols/NSOutlineViewDataSource_Protocol/Reference/Reference.html
http://developer.apple.com/documentation/Cocoa/Conceptual/OutlineView/Articles/UsingOutlineDataSource.html
----

There are samples for General/NSOutlineView in your local developer's documentation:

file:///Developer/Examples/General/AppKit/General/OutlineView/

and

file:///Developer/Examples/General/AppKit/General/DragNDropOutlineView/

For a more human explanation of how to implement an General/NSOutlineView see this post on the Apple Cocoa-Dev list:

http://cocoa.mamasam.com/COCOADEV/2002/03/1/27771.php (Dead Link)

----

The description for **setIndentationMarkerFollowsCell:** is confusing. It should read:

*Sets whether the indentation marker symbol displayed in the outline column should be indented along with the  cell contents, or always displayed left-justified in the column.  The default is YES, the indentation marker is indented along with the cell contents.*

----

General/NSOutlineView asks the General/DataSource for the number of items (and the actual items) by sending NIL as the item. Thus, in your datasource, you should create an array of the 'root items', and if item is nil, return one of those. This allows you to have a 'rootless' General/NSOutlineView, which is far more useful than the root-ed one Apple sends you with the General/OutlineView example.

*How would you do this?*

- (int)outlineView:(General/NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item

if item is nil, return the number of root items,


- (id)outlineView:(General/NSOutlineView *)outlineView child:(int)index ofItem:(id)item

if item is nil, return the nth root item

----

How do you make a gradiented outline view? General/ScotlandSoftware has some sample code to make a table view use a gradient, but it doesn't work well with outline views: the leftmost part, the one with the disclosure triangle, is not painted. Any ideas?

*See http://amonre.org/2005/07/30/using-a-nsoutlineview-as-a-source-list/ *

----

I found that Wil Shipley's discussion of the General/NSTableView subclass with special highlighting at http://wilshipley.com/blog/2005/07/pimp-my-code-part-3-gradient.html seems to be the most useful. For a general General/NSOutlineView example, I couldn't understand the pages that the above links led to, but Aaron Hillegass' example on http://www.bignerdranch.com/examples.shtml is really good, really simple, and easy to understand. If you aren't getting the examples that Apple provides, you might like the Big Nerd Ranch example, as I did.

----

I've got a question about General/RecursiveSelectionOfCheckboxesInNSOutlineView .  I was hoping someone could help me out.

----

I'm wondering if someone could help me with my General/NSOutlineViewMemoryLeaks

----

If you're changing the height of rows in an General/NSOutlineView using setRowHeight and you find your cell drawing is getting screwed up, try calling reloadData after calling setRowHeight. That seems to fix the problem (found and tested under 10.4.8). This doesn't seem to be documented.

----

General/NSOutlineView implements some drawing optimizations during live resizing (unlike General/NSTalbeView). For some General/NSCell subclasses this can cause drawing artifacts. You can disable the live resize optimizations by subclassing General/NSOutlineView and returning NO from - (BOOL)inLiveResize.

----

How can I get the output of the nodes in the XML format

----

Here's the new URL to Aaron's example of how to use General/NSOutlineView, called General/OutlineMe: http://www.bignerdranch.com/source/outline.tgz
 (Dead Link)
----

The following worked better for me than overriding inLiveResize:

    
@implementation General/MySourceListOutlineView

- (void)resizeWithOldSuperviewSize:(General/NSSize)oldSize
{
	[super resizeWithOldSuperviewSize:oldSize];
	// circumvent drawing optimizations that prevent General/NSOutlineView from live resizing
	if ([self inLiveResize])
		[self sizeLastColumnToFit];
}

@end


----

I've written an example General/NSOutlineView datasource that is very simple and should be easily followed: http://www.stupendous.net/archives/2009/01/11/nsoutlineview-example/

The basic idea is that the root node is an General/NSDictionary, with a tree of General/NSDictionary/General/NSArray/General/NSString objects from that. Modify the root node as you see fit (or load it's data from a plist or whatever) then send a reloadItem message to the General/NSOutlineView.