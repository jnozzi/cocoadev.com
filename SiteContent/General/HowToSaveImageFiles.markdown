After changing the effects of an image by reducing its size or saturation, how to save that altered image as an image file?

----

If you're working with an General/NSImage, ask for a representation (which is given to you as an General/NSData) and write that out as you would any General/NSData. This information becomes immediately apparent when you read the documentation for General/NSImage.

----
Actually in my application I am using General/CIImage. Then how to save the General/CIImage into a file?

----

Simply wrap the General/CIImage in an General/NSCIImageRep, add that to an General/NSImage, and go from there.

----

I can save the image and open it in Preview application when I don't apply any filters for the image. But when I applied the filters(like General/CIBlur, General/CIDistortionEffect etc) to the image I could able to save the image, but I could not able to open the image in preview application.