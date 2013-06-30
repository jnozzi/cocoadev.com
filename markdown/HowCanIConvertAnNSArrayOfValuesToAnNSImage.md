

Sorry, I've tried the docs, searching the General/CocoaDev website and the Cocoa-dev list archives, but haven't found much pertaining to my problem. This must be a really strange request. 

I have an General/NSArray of values that I want to convert to an General/NSImage, preferable TIFF format?, for drawing in an General/NSView. How can I do this? I believe the key is setting up an General/NSCustomImageRep. But what then?

Example

array value   General/NSColor

1                 General/[NSColor redColor]

2                 General/[NSColor greenColor]

.
.
.
.


I'm able to understand most Cocoa classes enough to begin to use them and then gain understanding, but General/NSImage beyond simple import and display is eluding me.

Thanks for any help.

----

Hmm.  I'm not quite sure what you mean.  There's no natural meaning of "convert a value to an image".  I suppose for a color, you might want to create an image with some particular dimensions filled solid with that color?  Is that what you're after?

----

I think your description is correct. I'll try to elaborate further.

I have a 2x2 matrix of elevation values stored in an 1-dimensional General/NSArray where each value represents the elevation within that square area, say 10 x 10 feet. Now I want to make a gray-scale image where higher elevations are light and lower elevations are dark. So I want to make an image where each value is represented by a single pixel (which represents the 10x10 feet area) and I want to make all pixels with a particular elevation value the same shade of gray.

I want to also extend this so that instead of gray-scale, I can assign a particular color to each pixel representing a certain value.

I hope this makes more sense.

----

Try something like this (I recommend that you supplement this with a quick visit to Apple's online docs):


* Create an empty General/NSImage using     initWithSize:.
* Create an General/NSBitmapImageRep with the required dimensions, colorspace and so on (the initializer for doing this has one of the longest signatures in Cocoa:     initWithBitmapDataPlanes:pixelsWide:pixelsHigh:bitsPerSample:samplesPerPixel:hasAlpha:isPlanar:colorSpaceName:bytesPerRow:bitsPerPixel:.
* Add the General/NSBitmapImageRep to the General/NSImage.
* Get yourself ready to draw your data.
* Call the     lockFocusOnRepresentation: method of your General/NSImage. This method basically tells Cocoa and General/CoreGraphics to treat the General/NSImageRep as the current drawing canvas.
* Draw your data using the General/AppKit drawing functions (eg. General/NSRectFill) or General/CoreGraphics.
* Call the     unlockFocus method of your General/NSImage, to restore the previous drawing canvas.
* Your General/NSImage has a method called     General/TIFFRepresentation, which will give you an General/NSData object containing TIFF data.


-General/ToM

----
I found an example of something similar to what I wanted to do here: http://www.macdevcenter.com/pub/a/mac/2002/08/06/cocoa.html . It does exactly what General/ToM outlined, but includes sample code which I needed to understand the process.

Thanks General/ToM. You got me along the correct path.