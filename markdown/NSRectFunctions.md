

Functions and constants for General/NSRect.

    
General/NSPoint  General/UKCenterOfRect( General/NSRect rect )
{
	return General/NSMakePoint( General/NSMidX(rect), General/NSMidY(rect) );
}

General/NSPoint  General/UKTopCenterOfRect( General/NSRect rect )
{
	return General/NSMakePoint( General/NSMidX(rect), General/NSMaxY(rect) );
}

General/NSPoint  General/UKTopLeftOfRect( General/NSRect rect )
{
	return General/NSMakePoint( General/NSMinX(rect),General/NSMaxY(rect) );
}

General/NSPoint  General/UKTopRightOfRect( General/NSRect rect )
{
	return General/NSMakePoint( General/NSMaxX(rect), General/NSMaxY(rect) );
}

General/NSPoint  General/UKLeftCenterOfRect( General/NSRect rect )
{
	return General/NSMakePoint( General/NSMinX(rect), General/NSMidY(rect) );
}

General/NSPoint  General/UKBottomCenterOfRect( General/NSRect rect )
{
	return General/NSMakePoint( General/NSMidX(rect), General/NSMinY(rect) );
}

General/NSPoint  General/UKBottomLeftOfRect( General/NSRect rect )
{
	return rect.origin;
}

General/NSPoint  General/UKBottomRightOfRect( General/NSRect rect )
{
	return General/NSMakePoint( General/NSMaxX(rect), General/NSMinY(rect) );
}

General/NSPoint  General/UKRightCenterOfRect( General/NSRect rect )
{
	return General/NSMakePoint( General/NSMaxX(rect), General/NSMidY(rect) );
}

General/NSRect General/NKScaleRect(General/NSRect inRect, float scaleX, float scaleY)
{	
	General/NSRect outRect = inRect;
	outRect.size.width  += scaleX * inRect.size.width;
	outRect.size.height += scaleY * inRect.size.height;
	
	outRect.origin.x -= (outRect.size.width - inRect.size.width) / 2.0;
	outRect.origin.y -= (outRect.size.height - inRect.size.height) / 2.0;
	
	return outRect;
}


----

Based on code by John C. Randolph, but prettied up, renamed and debugged.

----

Shouldn't this page be named General/UKRectFunctions?

----

Wow, one would want to go through the trouble of linking against a library with these functions? So,     General/UKRightCenterOfRect(rect) is that much faster to type then     General/NSMakePoint(General/NSMaxX(rect), General/NSMidY(rect))? And I didn't even use     General/UKBottomLeftOfRect() as an example!!

Silly if you ask me...
----
It's not that they're that much faster to write, it's that they're faster to *read*.  When you see "bottom left", it's a tad more obvious than General/NSMaxX()/General/NSMidY().  

----

You could just #import "General/UKRectFunctions.h"

----

Syntax help: No 
Explanation: No 
How to use: No 
 ---Perhaps this page is useless...

*Perhaps you need to learn how to use a C function.*
----
Also, I think these functions are sort of wrong!     General/NSMax(r) returns     General/NSMinX(r) + General/NSWidth(r). When I ask for the top-right point I expect to get     General/NSMinX(r) + General/NSWidth(r) - 1, but maybe that is just me?
----
It's consistent with how     General/NSMaxRange() works. Apple sez: *Returns range.location + range.length�in other words, the number 1 greater than the maximum value within the range.*
----
I was referring to the UK-functions, not     General/NSMaxX. Is the top right corner one greater than the corner inside the view? I guess things get more complicated by the fact that the view coordinate system doesn't really match the screen coordinate system, so filling a single pixel in the top right corner would anyway not be as simple as using the actual coordinate for that place ;)