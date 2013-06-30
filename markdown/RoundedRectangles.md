A category for General/NSBezierPath which allows for very simple drawing of rectangles with arced corners -- like the bezel service popups.

"Ouch. Didn't notice this page until I added General/NSBezierPathCategory. Sorry."

The interface & implementation:

    

@interface General/NSBezierPath(General/RoundedRectangle)

/**
	Returns a closed bezier path describing a rectangle with curved corners
	The corner radius will be trimmed to not exceed half of the lesser rectangle dimension.
*/
+ (General/NSBezierPath *) bezierPathWithRoundedRect: (General/NSRect) aRect cornerRadius: (double) radius;

@end



@implementation General/NSBezierPath(General/RoundedRectangle)

+ (General/NSBezierPath *) bezierPathWithRoundedRect: (General/NSRect) aRect cornerRadius: (double) cRadius
{
	double left = aRect.origin.x, bottom = aRect.origin.y, width = aRect.size.width, height = aRect.size.height;
	
	//now, crop the radius so we don't get weird effects
	double lesserDim = width < height ? width : height;
	if ( cRadius > lesserDim / 2 )
	{
		cRadius = lesserDim / 2;
	}

	//these points describe the rectangle as start and stop points of the
	//arcs making up its corners --points c, e, & g are implicit endpoints of arcs
	//and are unnecessary
	General/NSPoint a = General/NSMakePoint( 0, cRadius ), b = General/NSMakePoint( 0, height - cRadius ),
		d = General/NSMakePoint( width - cRadius, height ), f = General/NSMakePoint( width, cRadius ),
		h = General/NSMakePoint( cRadius, 0 );

	//these points describe the center points of the corner arcs
	General/NSPoint cA = General/NSMakePoint( cRadius, height - cRadius ),
		cB = General/NSMakePoint( width - cRadius, height - cRadius ),
		cC = General/NSMakePoint( width - cRadius, cRadius ),
		cD = General/NSMakePoint( cRadius, cRadius );
			
	//start
	General/NSBezierPath *bp = General/[NSBezierPath bezierPath];
	[bp moveToPoint: a ];
	[bp lineToPoint: b ];
	[bp appendBezierPathWithArcWithCenter: cA radius: cRadius startAngle:180 endAngle:90 clockwise: YES];
	[bp lineToPoint: d ];
	[bp appendBezierPathWithArcWithCenter: cB radius: cRadius startAngle:90 endAngle:0 clockwise: YES];
	[bp lineToPoint: f ];
	[bp appendBezierPathWithArcWithCenter: cC radius: cRadius startAngle:0 endAngle:270 clockwise: YES];
	[bp lineToPoint: h ];
	[bp appendBezierPathWithArcWithCenter: cD radius: cRadius startAngle:270 endAngle:180 clockwise: YES];	
	[bp closePath];

	//Transform path to rectangle's origin
	General/NSAffineTransform *transform = General/[NSAffineTransform transform];
	[transform translateXBy: left yBy: bottom];
	[bp transformUsingAffineTransform: transform];

	return bp; //it's already been autoreleased
}

@end



I hope somebody will find this useful. See the snapshot below:

http://home.earthlink.net/~zakariya/files/General/RoundedRects.gif

This demonstrates a neat feature: notice that in the first shot, it's a circle, in the second it's a lozenge, and the third, it's a rectangle with rounded corners -- this is because it trims the corner radius to best fit the rectangle size. Cool, eh?


--General/ShamylZakariya

----

Maybe it could be made to use General/NSAffineTransform instead of the 20 or so adds. Or alternatively, store the points in an array and use a loop.

----

Optimization concerns aside, *awesome*. I love a good sample.

-- General/RobRix

I just read up on the affine transformation -- it makes sense, so I think I'll test it and should it work, I'll update the example code. And General/RobRix, thanks for the support!

UPDATE -- I changed the code to use an General/NSAffineTransform

--General/ShamylZakariya

----

You might be able to simplify it further by a) getting rid of the lineToPoint: (which are implicit when you add a new arc) and b) by using General/NSInsetRect rather than calculate each end corner, i.e. the code I have here goes something like:
    
+ (General/NSBezierPath*)bezierPathWithRoundRectInRect:(General/NSRect)aRect radius:(float)radius
{
   General/NSBezierPath* path = [self bezierPath];
   radius = MIN(radius, 0.5f * MIN(General/NSWidth(aRect), General/NSHeight(aRect)));
   General/NSRect rect = General/NSInsetRect(aRect, radius, radius);
   [path appendBezierPathWithArcWithCenter:General/NSMakePoint(General/NSMinX(rect), General/NSMinY(rect)) radius:radius startAngle:180.0 endAngle:270.0];
   [path appendBezierPathWithArcWithCenter:General/NSMakePoint(General/NSMaxX(rect), General/NSMinY(rect)) radius:radius startAngle:270.0 endAngle:360.0];
   [path appendBezierPathWithArcWithCenter:General/NSMakePoint(General/NSMaxX(rect), General/NSMaxY(rect)) radius:radius startAngle:  0.0 endAngle: 90.0];
   [path appendBezierPathWithArcWithCenter:General/NSMakePoint(General/NSMinX(rect), General/NSMaxY(rect)) radius:radius startAngle: 90.0 endAngle:180.0];
   [path closePath];
   return path;
}


----

*You win ;)* -- General/ShamylZakariya

----

Speaking of roundRects... Is there a simple way to display selection General/RoundRects around items in a text field, like Mail.app does when hovering the mouse around e-mail addresses? (The small triangle with the pop-up menu would also be neat).

Or is this advanced stuff?

Thanks,

-- Andr�s

Here is some gal's implementation of this feature: http://www.harmless.de/cocoa.html#rollover *Actually, the author of this site and its referenced projects is male ... look up the name's etymology. :-)*

** In Tiger, you now have General/NSTokenField for this.**

----

Any tips for getting this in a tableview like acquisition, cssedit etc.?

Thanks :)

See General/RoundedRectRowHighlighting

----

**Leopard adds + bezierPathWithRoundedRect:xRadius:yRadius: and � appendBezierPathWithRoundedRect:xRadius:yRadius:.**