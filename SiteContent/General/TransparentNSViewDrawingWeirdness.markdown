Currently i have a semitransparent [[NSView]] subclass which contains other custom [[NSView]]'s. The interior views draw properly the first time, but then when they are redrawn they have weird fully transparent sections around the curved corners. This also happens with a normal [[NSTextField]].

Images of what the window looks like before and after the redraw:
BEFORE: 
http://img145.imageshack.us/img145/8231/beforeredrawyz9.jpg
 AFTER: 
http://img143.imageshack.us/img143/113/afterredrawog6.jpg

The redraw of the views is caused by either the user dragging files on the rounded views or clicking on the clear text field.

Here is the code for how i add the rounded views and text field, called during my [[AppController]]
<code>
-(void)insertViews {
	int i = 0;
	for (i=0;i<[allItems count];i++) {
		myView ''newView = [[myView alloc]
initWithFrame:[[NSMakeRect]](20,i''70,[mainWindow
frame].size.width-40,70)];
		[myView setAutoresizingMask:[[NSViewWidthSizable]]];
		[[mainWindow contentView] addSubview:myView];
		[myView release];
	}
	
	myClearTextField ''textField = [[myClearTextField alloc]
initWithFrame:[[NSMakeRect]](50,[mainWindow frame].size.height -
(i''71),[mainWindow frame].size.width-40,20)];
	[[mainWindow contentView] addSubview:textField];
}
</code>

Here is how the rounded view redraws itself:
<code>
- (void)drawRect:([[NSRect]])rect
{
   //erase whatever graphics were there before with clear (i have
tried using different combinations of these 3 lines, but all have the
same result)
   [[NSEraseRect]]([self frame]);
   [[[[NSColor]] blackColor] set];
   [[NSRectFill]]([self frame]);
	
   rect = [[NSInsetRect]]( rect, 5, 5 );
   [[NSColor]] ''bgColor = [[[NSColor]] colorWithCalibratedWhite:1.0 alpha:0.1];
   [[NSRect]] bgRect = rect;
   int minX = [[NSMinX]](bgRect);
   int midX = [[NSMidX]](bgRect);
   int maxX = [[NSMaxX]](bgRect);
   int minY = [[NSMinY]](bgRect);
   int midY = [[NSMidY]](bgRect);
   int maxY = [[NSMaxY]](bgRect);
   float radius = 10.0; // correct value to duplicate Panther's App Switcher
   [[NSBezierPath]] ''bgPath = [[[NSBezierPath]] bezierPath];


   // Bottom edge and bottom-right curve
   [bgPath moveToPoint:[[NSMakePoint]](midX, minY)];
   [bgPath appendBezierPathWithArcFromPoint:[[NSMakePoint]](maxX, minY)
                                    toPoint:[[NSMakePoint]](maxX, midY)
                                     radius:radius];


   // Right edge and top-right curve
   [bgPath appendBezierPathWithArcFromPoint:[[NSMakePoint]](maxX, maxY)
                                    toPoint:[[NSMakePoint]](midX, maxY)
                                     radius:radius];


   // Top edge and top-left curve
   [bgPath appendBezierPathWithArcFromPoint:[[NSMakePoint]](minX, maxY)
                                    toPoint:[[NSMakePoint]](minX, midY)
                                     radius:radius];


   // Left edge and bottom-left curve
   [bgPath appendBezierPathWithArcFromPoint:bgRect.origin
                                    toPoint:[[NSMakePoint]](midX, minY)
                                     radius:radius];
   [bgPath closePath];


   [bgColor set];
   [bgPath fill];


    [bgPath setLineWidth:2.0];
    [[[[NSColor]] colorWithCalibratedWhite:0.75 alpha:0.4] set];	
    [bgPath stroke];
}
</code>

If anybody has any idea how/why this is happening, please help.
Thanks [[JohnCassington]]

----

Eliminate the initial call to [[NSEraseRect]]. It's pointless and probably the cause of the problem.

----

Definitely the cause of the problem.  Every view is drawing to the same destination, which is the window backing store.  When it comes time to redraw a rect, Cocoa erases that region of the backing store and asks each view that sits over that region to draw in turn (modulo optimizations for opaque views).  If you paint with clear color (or erase rect) in composite copy mode, which is what you're doing, you're knocking out any drawing that superviews may have done.  

----

Thank, i think i understand what you are saying. However, i'm not quite sure what method i should use. I took out all three lines...

<code>
   [[NSEraseRect]]([self frame]);
   [[[[NSColor]] blackColor] set];
   [[NSRectFill]]([self frame]);
</code>

... but it still draws in the same way as before (see second image above). I think it may have something to do with a [[NSView]] being placed over the contentView of the [[NSWindow]]. I do this to create the rounded effect.

----

What do you mean "placed over"?  Overlapping sibling views are not supported, and may lead to this sort of problem.  There should be no need for overlapping siblings.. the smaller views should be subviews of the larger.

----
A hint here: 
add:
    printf("%f, %f, %f, %f\n", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
in 
    - (void)drawRect:([[NSRect]])rect{}
Then look at the output. I think you will understand ;). I will put more info when I have time.