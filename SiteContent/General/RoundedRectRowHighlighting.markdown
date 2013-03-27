 Anyone know how to implement custom row highlighting using General/RoundedRectangles?
I have the General/BezierPath sorted with:
 General/[[NSBezierPath bezierPathWithRoundedRect:[self rectOfRow:row] cornerRadius:50] fill];

But now I just need to get it in a tableview and override the default row highlighting with drawRow:(int)row clipRect:(General/NSRect)rec
Any help, tips, or examples for doing this? Its being used alot more recently, but there doesn't seem to be much information about how todo it.

----

I'd subclass a cell and override highlight:withFrame:inView: then make the General/NSTableColumn(s) use the subclass as the dataCell.

----

Take a look at General/OAGradientTableView in General/OmniAppKit. That will show you which General/NSTableView methods you need to override in your subclass. Then, use the General/RoundedRectangles category discussed on this site.

----

I looked at General/OAGradientTableView and it is not so clear which methods need to be overridden.  :-(

----

I think the following are sufficient:

- (id)_highlightColorForCell:(General/NSCell *)cell;

- (void)highlightSelectionInClipRect:(General/NSRect)rect;

_highlightColorForCell: should return nil, so the table doesn't draw the normal selection, and you can override highlightSelectionInClipRect to draw the selection however you like.

----

there is a solution for replacing the ugly black rect highlights when dragging over a row with nicer, iTunes-style highlights in General/UglyBlackHighlightRectWhenDraggingToNSTableView