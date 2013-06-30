

    General/NSCompositingOperation is an General/EnumeratedType defined by General/NSImage that describes how drawing is to be done.

The constants are described in terms of having source and destination images, each having an opaque and transparent region. The destination image after the operation is defined in terms of the source and destination before images as follows:
*     General/NSCompositeSourceOver: **Commonly used.** Draws the source atop the destination, with transparency. 
*     General/NSCompositeCopy: **Commonly used.** Draws completely replacing the destination. If the source has transparency, the destination also *becomes* transparent.
*     General/NSCompositeClear: For clearing out an area.
*     General/NSCompositeDestinationAtop
*     General/NSCompositeDestinationIn
*     General/NSCompositeDestinationOut
*     General/NSCompositeDestinationOver
*     General/NSCompositeHighlight
*     General/NSCompositePlusDarker
*     General/NSCompositePlusLighter
*     General/NSCompositeSourceAtop
*     General/NSCompositeSourceIn
*     General/NSCompositeSourceOut
*     General/NSCompositeXOR: Exclusive-OR of source and destination. Both must be black and white images. Quartz doesn't really support this mode anyway.


An example is on your HD at file:///Developer/Examples/General/AppKit/General/CompositeLab.

Many drawing functions let you specify the operation to use, including     -General/[NSImage compositeToPoint:fromRect:operation:fraction:],     -General/[NSImage drawInRect:fromRect:operation:fraction:], and     General/NSRectFillUsingOperation().

Prior to 10.4, functions that don't take an operation parameter will choose their own.     General/NSBezierPath uses     General/NSCompositeSourceOver, while     General/NSRectFill() uses     General/NSCompositeCopy. See General/FillRectVsNSRectFill.

On 10.4 and later, functions that don't take an operation parameter will usually use     General/NSGraphicsContext's, which can be changed with     -General/[NSGraphicsContext setCompositingOperation:]. The default is     General/NSCompositeSourceOver.     General/NSRectFill() *ignores*     -General/[NSGraphicsContext compositingOperation] and continues to use     General/NSCompositeCopy.

If you need to draw a     General/NSBezierPath with a specific     General/NSCompositingOperation on 10.3 or earlier, you can do so like this:
    
General/[NSGraphicsContext saveGraphicsState];
[bezierPath addClip];
General/NSRectFillUsingOperation([bezierPath bounds], operation);
General/[NSGraphicsContext restoreGraphicsState];


----
These are the classic Porter-Duff rules for digital image compositing upon which modern imaging is built. The original 1984 paper can found at http://www.keithp.com/~keithp/porterduff/.