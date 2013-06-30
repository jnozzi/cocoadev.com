Hit Detection

It's often necessary to be able to detect if a point lies on an arbitrary path. At first glance, the -General/[NSBezierPath containsPoint:] selector might appear to be just the ticket.  Unfortunately, it only tells you if your point is contained within the path, not on the path.  What seems to be needed is an -General/[NSBezierPath intersectsPoint] method.

So here's one.  Make a category on General/NSBezierPath containing the following, and Bob's your auntie.  The more observant may notice that this is only implemented for straight segments - I'll post the curve section later.

    

/*" Returns true if and only if this path intersects with
    the point passed in.  Intersection is defined by the 
    distance from the point to the and drawn segment on the 
    path being less than the current line width.  Thus if the 
    point lies on a 'moveToPoint' or 'closePath' segement of 
    the path, this will not return true unless it also lies 
    on or close enough to some drawn segment.
"*/
- (BOOL) intersectsPoint:(General/NSPoint) point {
 int count;
 BOOL intersectionFound = NO;
 General/NSPoint currentPoint = General/NSMakePoint(0,0);

 // Iterate through the elements for this path, and see if
 // the point intersects
 for (count = 0; (count < [self elementCount]) && !intersectionFound; count++)
   {
     General/NSPoint elementPoints[3];
     General/NSBezierPathElement element;

     element = [self elementAtIndex:count associatedPoints:elementPoints];
    
     // We don't like a switch statement, but General/NSBezierPathElement isn't a 
     // class, so we have to use one.  Pah!
     switch (element)
       {
       case General/NSMoveToBezierPathElement:    
         currentPoint = elementPoints[0];
         break;
       case General/NSLineToBezierPathElement: 
         intersectionFound = [self lineFrom:currentPoint
                                         to:elementPoints[0]
                            intersectsPoint:point];
         currentPoint = elementPoints[0];
         break;
       case General/NSCurveToBezierPathElement:
         intersectionFound = [self curveFrom:currentPoint
                                          to:elementPoints[0]
                                     control:elementPoints[1]
                                     control:elementPoints[2]
                             intersectsPoint:point];
         currentPoint = elementPoints[0];
         break;
       case General/NSClosePathBezierPathElement:
         break;
       }
   }
 return intersectionFound;
}

/*" Does a line between 'from' and 'to' intersect 'point' given
    the current line width? "*/
- (BOOL) lineFrom:(General/NSPoint)from
               to:(General/NSPoint)to
  intersectsPoint:(General/NSPoint)point {
      #warning This could probably be heavily optimised
  double ratio;
  double distancesqr;
  General/NSPoint intersection;
  float dx = to.x-from.x;
  float dy = to.y-from.y;
    
//            (Cx-Ax)(Bx-Ax) + (Cy-Ay)(By-Ay)
//        r = -------------------------------
//                          L^2


  ratio = (((point.x-from.x)*(dx)
                       +(point.y-from.y)*(dy)) /
           ((dx)*(dx)+(dy)*(dy)));

  if (ratio < 0)
    intersection = from;
  else if (ratio > 1)
    intersection = to;
  else
    {
      intersection = General/NSMakePoint(from.x + ratio * (dx),
                                 from.y + ratio * (dy));
    }
  
  distancesqr = pow(point.x - intersection.x, 2) + pow(point.y - intersection.y, 2);
  maxdistancesqr = pow([self lineWidth], 2);
  
  return (distancesqr <= maxdistancesqr) ? YES : NO;
}

/*" Does a curve between 'from' and 'to' with control points
    'control1' and 'control2' intersect 'point' given the current line
    width? 
"*/
- (BOOL) curveFrom:(General/NSPoint)from
                to:(General/NSPoint)to
           control:(General/NSPoint)control1
           control:(General/NSPoint)control2
   intersectsPoint:(General/NSPoint)point {
    Point2 testedPoint = { point.x, point.y };
    Point2 bezier[4] = {
    	{from.x, from.y},
    	{to.x, to.y},
    	{control1.x, control1.y},
    	{control2.x, control2.y}
    };
    float distancesqr;
    float maxdistancesqr;
    Point2 nearPoint;

    nearPoint = General/NearestPointOnCurve( testedPoint, bezier );
    distancesqr = pow( nearPoint.x - testedPoint.x, 2 )
               + pow( nearPoint.y - testedPoint.y, 2 );

    maxdistancesqr = pow( [self lineWidth], 2 );
    
    return (distancesqr <= maxdistancesqr) ? YES : NO;
}



Enjoy.  tufty

----

I added the necessary code to the curveFrom:to:control:control:intersectsPoint: method above. It uses the General/NearestPoint.c code, which in turn requires the General/GraphicsGems.h and General/GGVecLib.c code. All those files are available from the following place:

http://www.acm.org/pubs/tog/General/GraphicsGems/gems/

It requires some minor changes (mainly #ifndef-ing out some duplicate #defines), but works fine. If anyone would like the modified files, please contact me (david@ittpoi.com).

I also have a question on the code as a whole...Why is the critical distance from the line [self lineWidth]? Should it not be half of that? Only half of the line lies on either side of the middle of the line, if you understand what I mean...

-- General/DavidRemahl

I just made some efficiency changes (removing the costly sqrt() calls and using some temp variables). Oh, and if you want performance, do remove the pow() calls in favour of making temp variables and multiplying manually. pow is about twice as costly.

-- General/DavidRemahl

I just tried this out and when doing hit detection on a sharp bezier curve, it is significantly out - the curve it seems to check is flatter than what the General/NSBezierPath draws. I would have thought that the curve geometry would be standard.

-- Gideon King


since 10.4 there is a function in quartz 2d for better/easy hit detection: General/CGContextPathContainsPoint. there is also an example on adc which tells you how to convert General/NSBezierPath to General/CGPathRef and how to use the function: http://developer.apple.com/documentation/Cocoa/Conceptual/General/CocoaDrawingGuide/Paths/chapter_6_section_7.html#//apple_ref/doc/uid/TP40003290-CH206-DontLinkElementID_81

you can also use General/CGPathContainsPoint.

-- li