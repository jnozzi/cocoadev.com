I have a General/NSOutlineView and want to draw the cells myself, including a background for the parent/child combinations for the whole width of the View.

I have subclassed General/NSTextFieldCell to draw the main content including the background shown here:

http://dev.degrees.org.uk/outlineview.jpg

My problem is the General/OutlineCell that General/NSOutlineView uses to draw the small triangles and that is responsible for the expanding/collapsing of the rows. 
Obviously from the screenshot you can see I need to be able to draw the background in these cells to match up with the General/NSTextFieldCell.

Any ideas how to do this?