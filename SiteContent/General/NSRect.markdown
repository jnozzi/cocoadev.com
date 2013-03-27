Foundation's General/NSRect structure, defined in General/NSGeometry.h.

    
typedef struct  {
    General/NSPoint origin;
    General/NSSize size;
} General/NSRect;


The General/NSRect struct differs from General/QuickDraw's Rect struct in two important ways:



* The General/NSRect struct is a rectangle defined by an origin expressed as coordinates and by its height and width. General/QuickDraw's Rect defines all four sides of its rectangle as coordinates. Having used both systems for a while I do find the origin/size strategy a little more convenient than the four-coordinates strategy -- but one can convert between the two with ease.

* The elements of General/NSRect (origin.x, origin.y, size.width, size.height) are all float types. General/QuickDraw's Rect coordinates are all integer numbers. Rect was designed in a time when integer math was vastly faster and addressing individual pixels was all that could be done, whereas Cocoa and General/CoreGraphics work in a resolution-independent space with the ability to address the areas between pixels.



General/NSGeometry.h defines a number of helper functions for working with General/NSRect structs. Some commonly used functions include:

    

* General/NSRect General/NSMakeRect(float x, float y, float w, float h)
* General/NSRect General/NSRectFromString(General/NSString *aString)
* BOOL General/NSEqualRects(General/NSRect aRect, General/NSRect bRect)
* General/NSRect General/NSIsEmptyRect(General/NSRect aRect)
* General/NSRect General/NSInsetRect(General/NSRect aRect, float dX, float dY)
* General/NSRect General/NSUnionRect(General/NSRect aRect, General/NSRect bRect)
* General/NSRect General/NSIntersectionRect(General/NSRect aRect, General/NSRect bRect)
* General/NSString *General/NSStringFromRect(General/NSRect aRect)



General/NSStringFromRect is most handy when used in conjunction with General/NSLog for printing debug messages:

    
General/NSLog(@"frameRect = %@", General/NSStringFromRect(frameRect));


Note that unlike Carbon API all of these API pass the entire structure on the stack. In Carbon, one typically passes the address of a Rect around. Don't let that trip you up.

Foundation also defines the global variable:

    
General/NSZeroRect


Which is occasionally useful when performing set arithmetic with the aforementioned functions and the like.

----
*Discussion*

I cleaned up the page a bit to incorporate the bit about "Carbon's Rect" being incorrect or ambiguous. I also reworked the part that talked about how Rect was faster because it used ints, since integer math hasn't been faster than floating point math for well over a decade.