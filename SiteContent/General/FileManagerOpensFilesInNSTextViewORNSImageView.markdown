How would I create an General/NSOutlineView that handles files like General/XCode?

----

Interesting how the subject and contents are totally different.

Here is the answer though:

In the developer folder, /Examples/General/AppKit/General/OutlineView. Just add some custom General/NSCell's into the outlineview and you should be able to produce everything you need. -- General/MatPeterson
----
I want to know how to I double click a row, then open in the proper General/NSView depending on its file type.

----

You mean to display the contents of the file? If you are using an General/NSSplitView, you just need to switch the views. Perhaps something like this:

    
[splitView replaceSubview:oldView with:newView];


-- General/RyanBates