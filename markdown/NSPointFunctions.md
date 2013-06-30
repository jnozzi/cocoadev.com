

Functions and constants for General/NSPoint.

    
//NSPointFunctions_CocoaDevUsersAdditions.h

#import <Cocoa/Cocoa.h>
#import <math.h>
#import <float.h> /* Standard C lib that contains some constants, look at http://www.acm.uiuc.edu/webmonkeys/book/c_guide/2.4.html -- JP */

const General/NSPoint General/NSFarAwayPoint = {FLT_MAX, FLT_MAX}; // FLT_MAX = 1E+27.  -- JP

static inline General/NSPoint General/NSAddPoints(General/NSPoint firstPoint, General/NSPoint secondPoint)
{
     return General/NSMakePoint(firstPoint.x+secondPoint.x, firstPoint.y+secondPoint.y);
}

static inline General/NSPoint General/NSSubtractPoints(General/NSPoint firstPoint, General/NSPoint secondPoint)
{
     return General/NSMakePoint(firstPoint.x-secondPoint.x, firstPoint.y-secondPoint.y);
}

static inline General/NSPoint General/NSOffsetPoint(General/NSPoint point, float amountX, float amountY)
{
    return General/NSAddPoints(point, General/NSMakePoint(amountX, amountY));
}

static inline General/NSPoint General/NSReflectedPointAboutXAxis(General/NSPoint point)
{
    return General/NSMakePoint(-point.x, point.y);
}

static inline General/NSPoint General/NSReflectedPointAboutYAxis(General/NSPoint point)
{
    return General/NSMakePoint(point.x, -point.y);
}

static inline General/NSPoint General/NSReflectedPointAboutOrigin(General/NSPoint point)
{
    return General/NSMakePoint(-point.x, -point.y);
}

static inline General/NSPoint General/NSTransformedPoint(General/NSPoint point,General/NSAffineTransform *transform)
{
     return [transform transformPoint:point];
}

static inline General/NSPoint General/NSCartesianToPolar(General/NSPoint cartesianPoint)
{
    return General/NSMakePoint(sqrtf(cartesianPoint.x*cartesianPoint.x+cartesianPoint.y*cartesianPoint.y), atan2f(cartesianPoint.y,cartesianPoint.x));
}

static inline General/NSPoint General/NSPolarToCartesian(General/NSPoint polarPoint)
{
    return General/NSMakePoint(polarPoint.x*cosf(polarPoint.y), polarPoint.x*sinf(polarPoint.y));
}



**Maybe they should be split into General/NSPolarAngle(General/NSPoint point) and General/NSPolarRadius(General/NSPoint point) unless we're going to make an General/NSPolarPoint.**

*Personally, I don't care that much. (: But someone else can if they want, certainly.  Conversion between Cartesian and Polar coordinates would be nice, though, if a new struct were made.*

*Something should be done : split or new struct*

Isn't there some function for converting a point to a string? General/NSStringFromPoint() in the Foundation API

Otherwise this could be wrapped in a class with four methods returning the different co-ordinates. But if we did that it may as well handle more than two dimensions, and I suspect the whole point of these functions is that they're just little fast things to make the point that we don't need an General/NSPoint class. :)

-- General/AngelaBrett

If you want a class that handles an arbitrary number of dimensions, ask me about General/LSVector. It's a reasonably well-tested (although not with General/UnitTest<nowiki/>s) nesting vector class.

-- General/RobRix

How about using hypot(a, b) for the radius part of the cartesian-to-polar conversion?  It does the whole sqrt(a^2+b^2) thing for you pretty fast.  Plus its a whole lot easier to type.  Also, there is an issue with using atan(y/x), since nothing over Pi radians will be correct.  And when x is 0 there is a *minor* issue with infinity.  A cartesian to polar conversion isn't possible in one (efficient) line as far as I can figure out.

What I usually do is find the asin of fabs(y)/hypot, then put in a case for each quadrant.  For quadrant I, keep the asin, for II, it's pi - asin, for III, pi + asin, and for IV, 2*pi - asin.  That usually works out alright for me.  I have missed the conversion a lot of times before, though, so feel free to correct me.  And if you have a simpler method, I'd love to hear it.  Adios!

-- General/BrianMoore

Some changes on the cartesian to polar function�:

- x*x is more efficient than x^2

- atanf is a bad solution : return an angle between 0 and pi, not between 0 and 2*pi. Use atan2f instead.

-- General/DamienBob