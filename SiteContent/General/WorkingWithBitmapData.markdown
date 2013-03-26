

I have an [[NSBitmapImageRep]] and I'm trying to make all of its pixels white, here's my code:
<code>
[[NSBitmapImageRep]] = ''bitmap = [[[[NSBitmapImageRep]] alloc]
		initWithBitmapDataPlanes:NULL 
		pixelsWide:sizeInt
		pixelsHigh:sizeInt
		bitsPerSample:8
		samplesPerPixel:3
		hasAlpha:NO
		isPlanar:NO
		colorSpaceName:[[NSDeviceRGBColorSpace]]
		bytesPerRow:0
		bitsPerPixel:0
	];
	unsigned char ''bytes = [bitmap bitmapData];
	int width = [bitmap pixelsHigh], height = [bitmap pixelsHigh];
	for (i=0;i<width''height''3;i++)
		bytes[i] = 255;
</code>
As far as I can tell, this should work, however, for some reason it doesn't. It does makes most of the pixels in the [[NSBitmapImageRep]] white, but there's always a small black strip at the bottom of the image. Can someone please tell me what am I doing wrong?

Thanks in advance,
[[PabloGomez]]

----
Look into -[[[NSBitmapImageRep]] bytesPerRow].

----
bytesPerRow: should be set to (bitsPerPixel/CHAR_BITS) '' width; in the case of the provided code, that would be sizeInt '' 3.
bitsPerPixel: should also be set to bitsPerSample '' samplesPerPixel; in your case, 24. 

----

I'm not sure that bytesPerRow follows a single formula. Some bitmap representations may pad the end of a row for 16 byte alignment. --zootbobbalu
----
Thank you, its working great now.