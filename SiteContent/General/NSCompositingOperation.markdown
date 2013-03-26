

<code>[[NSCompositingOperation]]</code> is an [[EnumeratedType]] defined by [[NSImage]] that describes how drawing is to be done.

The constants are described in terms of having source and destination images, each having an opaque and transparent region. The destination image after the operation is defined in terms of the source and destination before images as follows:
* <code>[[NSCompositeSourceOver]]</code>: '''Commonly used.''' Draws the source atop the destination, with transparency. 
* <code>[[NSCompositeCopy]]</code>: '''Commonly used.''' Draws completely replacing the destination. If the source has transparency, the destination also ''becomes'' transparent.
* <code>[[NSCompositeClear]]</code>: For clearing out an area.
* <code>[[NSCompositeDestinationAtop]]</code>
* <code>[[NSCompositeDestinationIn]]</code>
* <code>[[NSCompositeDestinationOut]]</code>
* <code>[[NSCompositeDestinationOver]]</code>
* <code>[[NSCompositeHighlight]]</code>
* <code>[[NSCompositePlusDarker]]</code>
* <code>[[NSCompositePlusLighter]]</code>
* <code>[[NSCompositeSourceAtop]]</code>
* <code>[[NSCompositeSourceIn]]</code>
* <code>[[NSCompositeSourceOut]]</code>
* <code>[[NSCompositeXOR]]</code>: Exclusive-OR of source and destination. Both must be black and white images. Quartz doesn't really support this mode anyway.


An example is on your HD at file:///Developer/Examples/[[AppKit]]/[[CompositeLab]].

Many drawing functions let you specify the operation to use, including <code>-[[[NSImage]] compositeToPoint:fromRect:operation:fraction:]</code>, <code>-[[[NSImage]] drawInRect:fromRect:operation:fraction:]</code>, and <code>[[NSRectFillUsingOperation]]()</code>.

Prior to 10.4, functions that don't take an operation parameter will choose their own. <code>[[NSBezierPath]]</code> uses <code>[[NSCompositeSourceOver]]</code>, while <code>[[NSRectFill]]()</code> uses <code>[[NSCompositeCopy]]</code>. See [[FillRectVsNSRectFill]].

On 10.4 and later, functions that don't take an operation parameter will usually use <code>[[NSGraphicsContext]]</code>'s, which can be changed with <code>-[[[NSGraphicsContext]] setCompositingOperation:]</code>. The default is <code>[[NSCompositeSourceOver]]</code>. <code>[[NSRectFill]]()</code> ''ignores'' <code>-[[[NSGraphicsContext]] compositingOperation]</code> and continues to use <code>[[NSCompositeCopy]]</code>.

If you need to draw a <code>[[NSBezierPath]]</code> with a specific <code>[[NSCompositingOperation]]</code> on 10.3 or earlier, you can do so like this:
<code>
[[[NSGraphicsContext]] saveGraphicsState];
[bezierPath addClip];
[[NSRectFillUsingOperation]]([bezierPath bounds], operation);
[[[NSGraphicsContext]] restoreGraphicsState];
</code>

----
These are the classic Porter-Duff rules for digital image compositing upon which modern imaging is built. The original 1984 paper can found at http://www.keithp.com/~keithp/porterduff/.