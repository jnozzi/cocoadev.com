Is it possible to encode an General/NSImage in a file with other data using General/NSKeyedArchiver?
----
Yes.
Grab General/NSData from any or all of the General/NSImage's image reps and archive the data.
The following link may be helpful to understanding what General/NSImage is:
http://www.cocoabuilder.com/archive/message/cocoa/2005/6/23/139845
See General/NSImage - (General/NSData *)General/TIFFRepresentation or - (General/NSImageRep *)bestRepresentationForDevice:(General/NSDictionary *)deviceDescription
and then encode the image rep.
----
Is the image vector or bitmap ?

----

OK, thanks!

It's a bitmap image.