Can any body know how to get General/NSData from General/CIImage?


----
First, you'll have to convert General/CIImage to General/NSImage, like so:
    
General/NSImage *image = General/[[[NSImage alloc] initWithSize:[ciImage extent].size]
	autorelease];
[image lockFocus];
General/CGContextRef contextRef =
	General/[[NSGraphicsContext currentContext]
	graphicsPort];
General/CIContext *ciContext =
	General/[CIContext contextWithCGContext:contextRef
	options:General/[NSDictionary dictionaryWithObject:
	General/[NSNumber numberWithBool:YES]
	forKey:kCIContextUseSoftwareRenderer]];
[ciContext drawImage:ciImage
	atPoint:General/CGPointMake(0, 0) fromRect:[ciImage extent]];
[image unlockFocus];

Then you'll get an General/NSData object when using [image General/TIFFRepresentation].
Of course, this is just one of thousands of possibilities.

Take care,
--General/MatthiasGansrigler

----
Yes it works. But I found that the step [image General/TIFFRepresentation] to get tiff data is slow. Is there other way to get image data?.

----
When someone comes up with a valid answer to your question but that answer does not work for you, that means that you have insufficiently specified your question.

Be more specific than "get image data". If speed is a requirement, state it. Tell us what *kind* of image data you want, and what you need to do with it. Then maybe we can give you an answer that you want.

----
Additionally, read General/MailingListMode and consider taking this to an actual mailing list. This is not a basic Q&A site, it's a wiki.
----
You could play around with General/NSImageReps, maybe that helps somewhere... Here is an updated way to convert a General/CIImage to an General/NSImage. (here: http://www.eternalstorms.at/developers/page39/page39.html you can get an General/NSImage (and General/CIImage) category that does all this and more for you. If advertisement, please remove and my apologies).

    
General/CIImage *myCIImage;
General/NSImage *img = General/[[NSImage alloc] initWithSize:[myCIImage extent].size];
General/NSCIImageRep *rep = General/[NSCIImageRep imageRepWithCIImage:myCIImage];
[img addRepresentation:rep];

This is less code and probably a little faster.

Take care,

--General/MatthiasGansrigler