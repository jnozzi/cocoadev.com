

I have a custom subclass of %%BEGINCODESTYLE%%[[NSView]]%%ENDCODESTYLE%% in which my users draw lines with the mouse.  These lines are converted into one or more %%BEGINCODESTYLE%%[[NSBezierPath]]%%ENDCODESTYLE%% objects and are drawn into the %%BEGINCODESTYLE%%[[NSView]]%%ENDCODESTYLE%% subclass.  When the user clicks a save button, I would like to convert whatever doodlings they have made into a bitmap and save them to the hard disk.  Currently my code looks like this:

(note: fileName is an [[NSString]] with a valid path and filename)

<code>
- ([[IBAction]])save:(id)sender
{
	[self lockFocus];
	[[NSBitmapImageRep]]'' image = 
		[[[[NSBitmapImageRep]] alloc] initWithFocusedViewRect:[self bounds]];
	[self unlockFocus];
	
	[[NSData]]'' imageData = [image representationUsingType:[[NSBMPFileType]] properties:nil];
	if(!imageData)
	{
		[[NSLog]](@"could not convert image to BMP format");
	}
	
	BOOL success = [imageData writeToFile:fileName atomically:NO];
	if(success)
	{
		[[NSLog]](@"image successfully written to \"%@\"", fileName);
	}
	else
	{
		[[NSLog]](@"error writing to file \"%@\"", fileName);
	}
}
</code>

When I test this code, the [[NSData]] object always comes back as nil.

Is this the correct approach?  Can anyone see what the problem might be?

----

I'm not 100% sure, but you could try this

<code>
[[NSData]]'' imageData = [[image representationUsingType:[[NSBMPFileType]] properties:nil] bitmapData];
</code>

Hope this helps,

David Giffin http://www.davtri.com

''[[NSData]] doesn't have a <code>bitmapData</code> class or instance method.''

----
You're doing your error checking beginning with [[NSData]]'' <code>imageData</code>. Have you checked [[NSBitmapImageRep]]'' <code>image</code> to make sure it's not nil? If so, maybe what <code>self</code> is referring to here isn't actually the view you're trying to save?

----

I added a simple if after the [[NSBitmapImageRep]] is created.  The object is created as expected.  I simply had [[NSLog]] write the pointer to the log, output as follows:

<code>
...snip
	[self lockFocus];
	[[NSBitmapImageRep]]'' image = [[[[NSBitmapImageRep]] alloc] initWithFocusedViewRect:[self bounds]];
	[self unlockFocus];
	
	if(!image)
	{
		[[NSLog]](@"could not create [[NSBitmapImageRep]]'' image");
	}
	else
	{
		[[NSLog]](@"image: %@", image);
	}
snip...
</code>

<code>
2004-11-07 17:55:09.104 Strokes[4648] image: [[NSBitmapImageRep]] 0x3450a0 Size={250, 250} [[ColorSpace]]=[[NSCalibratedRGBColorSpace]] BPS=8 Pixels=250x250 Alpha=NO
2004-11-07 17:55:09.104 Strokes[4648] could not convert image to BMP format
2004-11-07 17:55:09.104 Strokes[4648] error writing to file "/Users/admin/Desktop/user-a-2.bmp"
</code>

Those sizes and color settings sound right to me for the image I should be getting back, so I'm pretty sure this has something to do with the creation of the [[NSData]] object.  

I looked through the paramerts that can be passed in the [[NSData]] init call, but they all pertain to TIFF and JPG and GIF images, not bitmaps.  I thought maybe that the function just didn't like getting nil, so I tried passing in an empty [[NSDictionay]], but no luck.
----
Using nil for the bitmap image properties is correct and the fact that your image is 8-bit with no alpha is also right. You might take a look at: http://lists.apple.com/archives/cocoa-dev/2003/Sep/msg01359.html -- seems [[NSBitmapImageRep]] can be a little touchy about what it accepts as input. Googling "representationUsingType:[[NSBMPFileType]]" will get you some work around code involving a roundabout conversion via a PNG but maybe somebody else here would know what you need to do provide the right input. Good luck!

(If you happen to get this worked out, please take the time to post your solution here and on the [[NSBitmapImageRep]] page for the next guy...)

----

It will be quite obvious to most of you, but it took me several minutes to realise that the image should be there before you can capture it
so:
<code>
//	[imageview setNeedsDisplay:YES];	// does NOT work
// but
	[imageview display];			// does
	
	[imageview lockFocus];
	[[NSBitmapImageRep]] ''tmpRep = [[[[NSBitmapImageRep]] alloc] initWithFocusedViewRect:[imageview frame]];
	[imageview unlockFocus];
</code>
As a help to people as ignorant as I am, [[PaulCD]]

----