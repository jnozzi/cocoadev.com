

I've having some trobles with image scaling.

I'm making a ftp server with directory browser, and I want it to look like the finder list with the icons.

the problem is that when i scale the images it doesnt have the same quality as finder, is there a way to keep tha quality.

    
General/NSImage *image = General/[[NSImage alloc] initWithSize:General/NSMakeSize(18, 18)];
General/NSBitmapImageRep *rep = General/[[NSBitmapImageRep alloc] initWithData:
     General/[[[NSWorkspace sharedWorkspace] iconForFileType:@"ext"] General/TIFFRepresentation]];
[rep setSize:General/NSMakeSize(18, 18)];
[image addRepresentation:rep];


I've tried this one, but the program is running slow when i use it.

tnx
----

I haven't tried this, but using this code you make fewer calls, and I think the image will select the appropriate icon size and scale from that (in this case, it should scale from the 32x32 member)

    
General/NSImage *icon = General/[[NSWorkspace sharedWorkspace] iconForFileType:@"ext"];
[icon setSize:General/NSMakeSize(18, 18)];


General/EnglaBenny

----

By all means, use 16x16 as your size. The native sizes for icon are 16, 32, 48 and 128 px (+ 256 since Tiger). If you use 16 px, you'll get an image scaled by the artist, which looks much better than the one scaled by the system (and it's faster, too!).

----

Instead of using     setSize: use     drawInRect:fromRect:operation:fraction:.

    
- (void)drawIcon:(General/NSImage *)image inRect:(General/NSRect)destRect {
    [image drawInRect:destRect 
            fromRect:General/NSMakeRect(0.0f, 0.0f, [image size].width, [image size].height)
            options:General/NSCompositeSourceOver
            fraction:1.0f];
}



----

You can use General/IconFamily which makes it much easier. It's also part of General/OmniFoundation.
http://homepage.mac.com/troy_stephens/software/objects/General/IconFamily/

----

I ended using a combination of the above methods: (Using General/IconFamily)
Unfortunately General/IconFamily does not _always_ give the small icon (if there is no small icon in the icns file I assume) so you have to explicity resize it. Otherwise this would be even simpler.

    

- (General/NSImage *)getIconForPath:(General/NSString *)path {
	//set the desired size of icon
	General/NSSize canvasSize = General/NSMakeSize(15.0, 15.0);

	General/IconFamily *iconFamily = General/[IconFamily iconFamilyWithIconOfFile:path];
	General/NSImage *theIcon = [iconFamily imageWithAllReps];
	General/NSRect srcRect = General/NSMakeRect(0.0f, 0.0f, [theIcon size].width, [theIcon size].height);
	General/NSRect destRect = General/NSMakeRect(0.0f, 0.0f, canvasSize.width, canvasSize.height);
	General/NSImage *canvas = General/[[[NSImage alloc] initWithSize:canvasSize] autorelease];
	[canvas lockFocus];
	[theIcon drawInRect:destRect fromRect:srcRect
			 operation:General/NSCompositeSourceOver fraction:1.0f];
	[canvas unlockFocus];
	return canvas;
}

