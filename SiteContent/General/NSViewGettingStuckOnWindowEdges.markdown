I have a view which is a subview of a semitransparent General/NSView. When i use General/AMViewAnimation to animate the innermost view (i have more than one instance of the view), the view becomes constrained to the width of the containing window.

http://img170.imageshack.us/img170/442/nsviewconstrainmy3.gif

The image above shows how the right side of the departing view is being stopped by the right side of the window.

I think it may have something to do with my use of General/NSMaxX etc... in:

    
General/NSRect bgRect = [self frame];
bgRect = General/NSInsetRect(Rect,5,5);

int minX = General/NSMinX(bgRect);
int midX = General/NSMidX(bgRect);
int maxX = General/NSMaxX(bgRect);
int minY = General/NSMinY(bgRect);
int midY = General/NSMidY(bgRect);
int maxY = General/NSMaxY(bgRect);
float radius = 15.0;

General/NSBezierPath *bgPath = General/[NSBezierPath bezierPath];
		
// Bottom edge and bottom-right curve
[bgPath moveToPoint:General/NSMakePoint(midX, minY)];
[bgPath appendBezierPathWithArcFromPoint:General/NSMakePoint(maxX, minY) 
					 toPoint:General/NSMakePoint(maxX, midY) 
					  radius:radius];
// Right edge and top-right curve
[bgPath appendBezierPathWithArcFromPoint:General/NSMakePoint(maxX, maxY) 
					 toPoint:General/NSMakePoint(midX, maxY) 
					  radius:radius];
// Top edge and top-left curve
[bgPath appendBezierPathWithArcFromPoint:General/NSMakePoint(minX, maxY) 
					 toPoint:General/NSMakePoint(minX, midY) 
					  radius:radius];
// Left edge and bottom-left curve
[bgPath appendBezierPathWithArcFromPoint:bgRect.origin 
					 toPoint:General/NSMakePoint(midX, minY) 
					  radius:radius];

[bgPath closePath];


Any ideas?

Thanks, John

----

This fragment looks OK, but looking at the animation code, perhaps you're supplying the incorrect frame there? Need to see more of the code that works with this to understand the issue. --General/GrahamCox

----

Perhaps you're not supplying a frame that is larger than your viewable area? Try extending the frame so that it starts the drawing of the box before it enters the viewable area, and stops after it leaves.
Or you might have to have two drawing modes, one where it doesn't draw and arc or a side when entering and leaving, and the other where it draws and arc and side when the box is in the viewable area.

----

I think i have traced the problem to the following two lines of code:

    
General/NSRect bgRect = [self frame];
bgRect = General/NSInsetRect(Rect,5,5);


On the second line i believe that it should say 

    
bgRect = General/NSInsetRect(**bgRect**,5,5);


Also, the call of <code>[self frame]</code> is only giving me the rect inside the actual window, not any part of the view which is outside the windows frame.

Any thoughts on how I could get a General/NSRect for my view which includes "out-of-super" areas?

Thanks
--General/JohnCassington

----
If     [self frame] returns a rect that's entirely within the window, then you *have no* "out-of-super" areas. Your animation code is actually shrinking the view, not just moving it around. Fix that and you should be set.