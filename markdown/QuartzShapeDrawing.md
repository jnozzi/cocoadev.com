I am looking to draw a rectangle with Quartz and rotate it using a timer loop.  Any tips as to where I can find the proper trig funcs to cause an intelligent rotation of a rectangle to take place?  Thanks.

blakespot

----

If you are using General/CGPoint etc. just as the c struct it is, the rotation matrix works like this for your rotations in Quartz2D:
    

[ x  ]             [ cos( t )  -sin( t )    0  ]        [ x0  ]

[  y  ]   =       [  sin( t )    cos( t )   0  ]    �  [  y0  ]

[ 1  ]             [    0           0       1  ]        [ 1    ]



where your original point is in the column vector on RHS and your transformed vector is on the LHS and t is your rotation angle.

For an "intelligent rotation" you may need to compose an "intelligent" function parametric in t to replace t above.

Or even several such transformations in succession, keeping in mind that matrix multiplication is not commutative.

To rotate the rectangle, just rotate each point making up its "path".
This also assumes that the "tail" of your vector is located at the origin. If it is not, you should put it there first and move it back afterwards.

General/AffineMess deals with this too, but using General/NSPoint, General/NSBezierPath and General/NSAffineTransform

----
In my opinion, General/AffineMess is a better example than the manual matrix composition described above.
Manually constructing a transformation matrix is a rare thing these days.  The Quartz libraries contain all of the matrix manipulation you might ever want: Also see General/NSAffineTransform.

� rotateByDegrees:

� rotateByRadians:

� scaleBy:

� scaleXBy:yBy:

� translateXBy:yBy:

� appendTransform:

� prependTransform:

� invert


� set
Sets the current transformation matrix to the receiver�s transformation matrix.

� concat
Appends the receiver�s matrix to the current transformation matrix stored in the current graphics context, replacing the current transformation matrix with the result.


There is no substitute for reading and understanding an introductory computer graphics text book and/or studying the general fields of linear algebra and signal processing which form the foundation of computer graphics.

However, for the specific question, take this example:

To rotate the coordinate system about a particular point:
    
- (void)rotateDegrees:(float)degrees aboutPoint:(General/NSPoint)centerOfRotation
{
   General/NSAffineTransform     *transform = General/[NSAffineTransform transform];
   
   [transform translateXBy:centerOfRotation.x yBy:centerOfRotation.y];
   [transform rotateByDegrees: degrees];
   [transform translateXBy:-centerOfRotation.x yBy:-centerOfRotation.y];
   [transform concat];
}


- (void)drawNextFrame:(id)dummy
{
   [self display];
}

-(void)drawRect:(General/NSRect)aRect
{
   static float    counter = 0;
   static General/NSRect rectToDraw = General/NSMakeRect(35.0f, 100.0f, 50.0f, 60.0f);
   
   // Erase the background
   General/[[NSColor blackColor] set];
   General/[NSBezierPath fillRect:aRect];   

   // Draw a filled rect in a transformed coordinate system
   [self rotateDegrees:fmod(counter, 360.0f) aboutPoint:General/NSMakePoint(General/NSMidX(rectToDraw), General/NSMidY(rectToDraw))];
   General/[[NSColor redColor] set];
   General/[NSBezierPath fillRect:rectToDraw];  

   // Increment animation counter and schedule next display
   counter += 1.0f;
   [self performSelector:@selector(drawNextFrame:) withObject:nil afterDelay:0.05f];
}


1) Create a custom General/NSView
2) Put the code above into the view's implementation
3) Put an instance or two of the custom view in a window that is visible.
4) Build and run your application to enjoy.