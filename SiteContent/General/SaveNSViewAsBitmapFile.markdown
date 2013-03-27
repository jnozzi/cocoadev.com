

I have a custom subclass of <code>General/NSView</code> in which my users draw lines with the mouse.  These lines are converted into one or more <code>General/NSBezierPath</code> objects and are drawn into the <code>General/NSView</code> subclass.  When the user clicks a save button, I would like to convert whatever doodlings they have made into a bitmap and save them to the hard disk.  Currently my code looks like this:

(note: fileName is an General/NSString with a valid path and filename)

    
- (General/IBAction)save:(id)sender
{
	[self lockFocus];
	General/NSBitmapImageRep* image = 
		General/[[NSBitmapImageRep alloc] initWithFocusedViewRect:[self bounds]];
	[self unlockFocus];
	
	General/NSData* imageData = [image representationUsingType:General/NSBMPFileType properties:nil];
	if(!imageData)
	{
		General/NSLog(@"could not convert image to BMP format");
	}
	
	BOOL success = [imageData writeToFile:fileName atomically:NO];
	if(success)
	{
		General/NSLog(@"image successfully written to \"%@\"", fileName);
	}
	else
	{
		General/NSLog(@"error writing to file \"%@\"", fileName);
	}
}


When I test this code, the General/NSData object always comes back as nil.

Is this the correct approach?  Can anyone see what the problem might be?

----

I'm not 100% sure, but you could try this

    
General/NSData* imageData = General/image representationUsingType:[[NSBMPFileType properties:nil] bitmapData];


Hope this helps,

David Giffin http://www.davtri.com

*General/NSData doesn't have a     bitmapData class or instance method.*

----
You're doing your error checking beginning with General/NSData*     imageData. Have you checked General/NSBitmapImageRep*     image to make sure it's not nil? If so, maybe what     self is referring to here isn't actually the view you're trying to save?

----

I added a simple if after the General/NSBitmapImageRep is created.  The object is created as expected.  I simply had General/NSLog write the pointer to the log, output as follows:

    
...snip
	[self lockFocus];
	General/NSBitmapImageRep* image = General/[[NSBitmapImageRep alloc] initWithFocusedViewRect:[self bounds]];
	[self unlockFocus];
	
	if(!image)
	{
		General/NSLog(@"could not create General/NSBitmapImageRep* image");
	}
	else
	{
		General/NSLog(@"image: %@", image);
	}
snip...


    
2004-11-07 17:55:09.104 Strokes[4648] image: General/NSBitmapImageRep 0x3450a0 Size={250, 250} General/ColorSpace=General/NSCalibratedRGBColorSpace BPS=8 Pixels=250x250 Alpha=NO
2004-11-07 17:55:09.104 Strokes[4648] could not convert image to BMP format
2004-11-07 17:55:09.104 Strokes[4648] error writing to file "/Users/admin/Desktop/user-a-2.bmp"


Those sizes and color settings sound right to me for the image I should be getting back, so I'm pretty sure this has something to do with the creation of the General/NSData object.  

I looked through the paramerts that can be passed in the General/NSData init call, but they all pertain to TIFF and JPG and GIF images, not bitmaps.  I thought maybe that the function just didn't like getting nil, so I tried passing in an empty General/NSDictionay, but no luck.
----
Using nil for the bitmap image properties is correct and the fact that your image is 8-bit with no alpha is also right. You might take a look at: http://lists.apple.com/archives/cocoa-dev/2003/Sep/msg01359.html -- seems General/NSBitmapImageRep can be a little touchy about what it accepts as input. Googling "representationUsingType:General/NSBMPFileType" will get you some work around code involving a roundabout conversion via a PNG but maybe somebody else here would know what you need to do provide the right input. Good luck!

(If you happen to get this worked out, please take the time to post your solution here and on the General/NSBitmapImageRep page for the next guy...)

----

It will be quite obvious to most of you, but it took me several minutes to realise that the image should be there before you can capture it
so:
    
//	[imageview setNeedsDisplay:YES];	// does NOT work
// but
	[imageview display];			// does
	
	[imageview lockFocus];
	General/NSBitmapImageRep *tmpRep = General/[[NSBitmapImageRep alloc] initWithFocusedViewRect:[imageview frame]];
	[imageview unlockFocus];

As a help to people as ignorant as I am, General/PaulCD

----