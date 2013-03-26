 

Hi,

is there some convenience method somewhere to turn an [[NSRect]] into a [[CGRect]] ([[CoreGraphics]])?

Thanks for any pointers.

----

From Mac OS X 10.5 (Leopard) onwards, Apple provide an inline function to do this:

<code>
[[CGRect]] [[NSRectToCGRect]]([[NSRect]] nsrect);
</code>

as well as the matching function:

<code>
[[NSRect]] [[NSRectFromCGRect]]([[CGRect]] cgrect);
</code>

----
Apple's documentation talks about this (http://developer.apple.com/releasenotes/Cocoa/[[AppKitOlderNotes]].html)
<code>
[[NSRect]] vs [[CGRect]]

We intend to fold these two types into one. However, this has not happened for Public Beta. For situations where you need to pass these back and forth, we recommend you use a macro or inline function which basically does something like:
''([[CGRect]] '')&nsRect
''([[NSRect]] '')&cgRect
</code>

--zootbobbalu

----

1. Potentially dangerous typecast (Method, that is used in Apple CG examples):
<code>
''([[CGRect]] '')&nsRect;
</code>
Aside from being dangerous if the definition of [[NSRect]] or [[CGRect]] changes, this method is dangerous because it can cause bugs due to "type punning" (see http://en.wikipedia.org/wiki/Type_punning). A safer approach would use a "union" (see below).

2. Inline function:
<code>
static inline [[CGRect]] [[NSRectToCGRect]]([[NSRect]] nsRect)
{
 [[CGRect]] cgRect;

cgRect.origin.x = nsRect.origin.x;
cgRect.origin.y = nsRect.origin.y;
cgRect.size.width = nsRect.size.width;
cgRect.size.height = nsRect.size.height;

return cgRect;
}

</code>

3. Macro:
<code>
#define [[NSRectToCGRect]](r) [[CGRectMake]](r.origin.x, r.origin.y, r.size.width, r.size.height)
</code>

4. An alternate, union-based macro.

<code>
#define [[NSRectToCGRect]](r) (((union {[[NSRect]] a; [[CGRect]] b;})r).b)
</code>

This union uses a GCC approved safe type pun through a union. See here: http://gcc.gnu.org/onlinedocs/gcc-4.1.1/gcc/Optimize-Options.html#index-fstrict_002daliasing-542

-- JP

-- Point 4 and Point 1 comments by MG

Why not an inline function like�:
<code>
static inline [[CGRect]] [[NSRectToCGRect]]([[NSRect]] nsRect)
{
    return ''([[CGRect]]'')&nsRect;
}
</code>

-- DB

----

Wow, that's fantastic, thanks!

I suppose the only way to turn an [[NSBezierPath]] to a CG path is to go the inline function route and contruct a new cg path to return point by point from the points in the [[BezierPath]]?

But thanks for this, it's great.

----
'''Note''': Core Graphics already has an inline [[CGRectMake]]. That being said, [[NSRect]], [[HIRect]] and [[CGRect]] all carry the same definition ([[HIRect]] is just a typedef of [[CGRect]]).

To answer your question, [[NSBezierPath]] is NOT bridged to a CG, So yes you would need to create and build a new [[CGMutablePathRef]], or just use [[CGPathRef]]'s to begin with.

----

There is a more usable, though perhaps less portable, way.  Assuming Apple will eventually merge these types, this just plans for the future.  In a precompiled header, or in any case before importing any foundation headers, include these three #define lines:

<code>
#include <[[CGGeometry]].h>

#define _NSPoint [[CGPoint]] [[NSPoint]]; inline void _IgnoreNSPoint( void )
#define _NSSize [[CGSize]] [[NSSize]]; inline void _IgnoreNSSize( void )
#define _NSRect [[CGRect]] [[NSRect]]; inline void _IgnoreNSRect( void )

#import <[[NSGeometry]].h>
</code>

The dummy functions are inline so they can be in a [[CodeWarrior]] precompiled header, but that may not work with strict C.  I also wrapped the whole precompiled header in some #pragmas so I can keep unused variable warnings:

<code>
#pragma warn_unusedvar off

...

#pragma warn_unusedvar reset
</code>

I avoid Xcode like the plague, but if you must use it there may be similar #pragmas and #defines to accomplish the same thing.

Once these #defines are in place an [[NSRect]] is a typedef of [[CGRect]] so you can use them interchangeably.  Just remember to convert for coordinate systems and the like.  The benefit of this ugly code is that you do not have to edit [[NSGeometry]].h directly.

Enjoy

Eric Cole