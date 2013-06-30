I know how to use structs in the traditional C way. My question is how does one develop a class (correct terminology?) using a struct in the vein of General/NSPoint, General/NSRect, etc? Say, for example, I want a 4-D point:

struct General/PointInSpaceTime
{
   double x;
   double y;
   double z;
   double t;
};
typedef struct General/PointInSpaceTime General/PointInSpaceTime;

And I want a method that operates on this struct.

-(BOOL) isInPerfectHarmony;
{ if ((x==y) && (y==z) && (z==t)
      return TRUE;
  else
      return FALSE;
}  

I have read in other places to wrap the struct in General/NSData (or General/NSValue depending on the responder). If this is a suggestion, how do I implement this example (code example, please). 

Thanks for any responses! Any information would be beneficial!

Philip D Riggs

----
There are a **million** different ways to to do this.  Well - probably not a million... certainly several... ;)

Here's one...

    
@interface General/PointInSpaceTime
{
   @private
   double x;
   double y;
   double z;
   double t;
}

//these methods are a convenience for constructing an autoreleased instance. See General/MemoryManagement pages for info
+( id ) pointInSpaceTimeWithX:( double ) x Y:( double )y Z:(double )z andT:(double) t;
+( id ) pointInSpaceTime;

//default init method
-( id ) initWithX:( double ) x Y:( double )y Z:(double )z andT:(double) t;

-( void ) setX:( double ) x;
-( void ) setY:( double ) y;
-( void ) setZ:( double ) z;
-( void ) setT:( double ) t;

-(BOOL) isInPerfectHarmony;
@end

@implementation General/PointInSpaceTime

+( id ) pointInSpaceTimeWithX:( double ) local_x Y:( double )local_y Z:(double )z andT:(double) local_t
{
    return [ [ [ self  alloc ] initWithX:local_x Y:local_y Z:local_z andT:local_t ] autorelease ];
}

+( id ) pointInSpaceTime
{
    return [ [ [ self alloc ] init ] autorelease ];
}

-( id ) initWithX:( double ) local_x Y:( double )local_y Z:(double )z andT:(double) local_t
{
    x = local_x;
    y = local_y;
    z = local_z;
    t = local_t;
}

-( void ) setX:( double ) local_x
{
    x = local_x;
}

-( void ) setY:( double ) local_y
{
    y = local_y;
}

-( void ) setZ:( double ) local_z
{
    z = local_z;
}

-( void ) setT:( double ) local_t
{
    t = local_t;
}

-(BOOL) isInPerfectHarmony
{
    if ((x==y) && (y==z) && (z==t)
        return TRUE;
    else
        return FALSE;
}  

@end



See the General/MemoryManagement page for discussion of the autorelease call you see above. You might use this class like this:

    
General/PointInSpaceTime *myPoint = 
    [ General/PointInSpaceTime pointInSpaceTimeWithX:PI Y:MOLE  Z:EARTH_GRAVITATIONAL_CONSTANT T:AGE_OF_DIRT_IN_EONS ];

if( [ myPoint isInPerfectHarmony ] )
{
    [ self attainZen ];
}



If you have other code dependent on the structure as it currently exists, you can wrapper it in an object:

    

@interface General/PointInSpaceTimeObject
{
    @private
    General/PointInSpaceTime myPointInSpaceTime;
}

//add methods here for getting and ( possibly ) setting the structure;
@end


And yes, General/NSData can wrapper basic C memory chunks. See the docs. All are possible. And I'm sure several others I haven't thought of. Was this just a curiousity question, or are you facing a particular problem? -- General/TimHart

----

Actually, more of a design question. I want to develop a geometry class for use in General/SQLite with computational geometry methods. I have done some preliminary work using geometry objects, but it is just too slow for large database files. Structs are so much faster that I want to use them when possible, but also maintain the ease of General/ObjectiveC when possible. I thought of using them much the same as General/NSPoint, but with the possibility of 2 and 3 dimensions (maybe 4 later) and double precision. So right now I am thinking:

Geometry inherits from General/NSObject
-General/NSString * geometryText2d [example: point(x y) ; line(x y, x y, x y) ; polygon((x y, x y, x y, x y)) ; polygonWithInnerRing((x y, x y, x y, x y)(x y, x y, x y, x y))
-basic methods

Point inherits from Geometry
-General/PointInSpaceTime
-Example Methods: parsePointFromGeometryText, pointInPolygon

Line inherits from Geometry
-General/CArray (General/PointInSpaceTime) [Maybe an General/NSArray with General/PointInSpaceTime wrapped into General/NSData?]
-Example Methods: parseLineFromGeometryText, clipToPolygon

Polygon inherits from Geometry
-General/NSArray (Line) 
-Example Methods: parsePolygonFromGeometryText, intersection

**Later**
General/MultiPoint
General/MultiLine
General/MultiPolygon

This will, I hope, speed up access to data, but maintain object oriented design benefits. I've had classes in C, but not C++ and am wary of starting down that road. All the C++ code I have seem looks excrutiatingly complicated for my experience level. However, looking at the code below, if I wrap the point up and never deal with it directly, I think I can manage if I can keep the Point, General/LIne, and Polygon as General/ObjectiveC classes, and wrap the points in some sort of array for the Line class. I am comfortable in General/ObjectiveC and prefer to keep code in either basic C or General/ObjectiveC as much as possible. Any feedback/concerns/suggetions? 

Philip D Riggs

----
One option that may give you the best of both worlds is General/ObjectiveCee's @defs compiler directive:

http://developer.apple.com/documentation/Cocoa/Conceptual/General/ObjectiveC/3objc_language_overview/chapter_3_section_8.html
Basically, you CAN have your cake and eat it too.

Don't completely disregard the General/CeePlusPlus suggestion below, though. Apple's compiler allows you to mix and match both languages - to a degree. Called General/ObjectiveCeePlusPlus, you get the zero overhead possibilities of General/CeePlusPlus where you need speed/efficiency at runtime, along with the dynamism of General/ObjectiveCee where you feel it's valuable.

The basics of  C++ aren't too complicated to handle if you know C and General/ObjectiveCee. Given your requirements, the combination of the two may be just what you're looking for.
-- General/TimHart
----

I would suggest using General/CeePlusPlus for this kind of thing. That gives you much less overhead in the syntax, e.g.:
    
struct General/PointInSpaceTime
{
   double values[4];

   General/PointInSpaceTime (double x, double y, double z, double t)
   {
      double v[] = { x, y, z, t };
      std::copy(beginof(v), endof(v), beginof(values));
   }

   bool operator== (General/PointInSpaceTime const& rhs) const
   {
      return std::equal(beginof(values), endof(values), beginof(rhs.values));
   }

   bool operator< (General/PointInSpaceTime const& rhs) const
   {
      return std::lexicographical_compare(
         beginof(values), endof(values),
         beginof(rhs.values), endof(rhs.values)
      );
   }

   ...
};

Now you can do stuff like:
    
General/PointInSpaceTime p1(1.0, 2.0, 3.0, 4.0);
General/PointInSpaceTime p2(2.0, 1.0, 3.0, 4.0);

cout << (p1 == p2 ? "equal" : "not equal") << endl;

Or:
    
General/PointInSpaceTime points[] = { p1, p2 };
std::sort(beginof(points), endof(points));

And much more...

*(see General/CocoaSTL for definiation of     beginof/    endof functions)*