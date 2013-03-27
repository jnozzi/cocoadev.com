I'm writing a Cocoa class to manage newspaper ads and would like to provide a method to generate very simple placeholder General/TIFFs for ads that have not been completed yet. The tiffs aren't for display in my app (they'll be imported into Quark picture boxes), so they don't need a window or view during creation. 

I read the General/NSGraphicsContext documentation along with the General/NSBezierPath but can't figure out how to set up a context and draw to it. 

The General/NSGraphicsContext documentation says that it accepts General/NSData objects as drawing targets but I keep getting "Unsupported printing format specified" and "Currently only pathnames are allowd for General/NSPersistentGraphicsContext" in my attempts.

Basically here's what I'm trying to do:
- Draw a border around the ad rectangle
- Draw 3 or 4 lines of styled text centered horizontally and vertically in the ad rectangle

And here's the create placeholder method so far (such as it):
    
- (void) placeholderImage
{
	General/NSMutableData			*data;
	General/NSDictionary			*contextAttributes;
									
	General/NSGraphicsContext		*placeholderContext,
					*inContext;
						
	BOOL				inAntialias;
	General/NSImageInterpolation		inInterpolation;

	int				centH   = [self height] / 2,
					centV   = [self width] / 2;
					
	General/NSRect				bounds  = {{0, 0}, {[self height], [self width]}};
	General/NSBezierPath			*temp   = General/[NSBezierPath bezierPathWithRect: bounds];
	
	
	data				= General/[[NSMutableData alloc] init];
	contextAttributes		= General/[NSDictionary dictionaryWithObjectsAndKeys: 
						data, General/NSGraphicsContextDestinationAttributeName,
						General/NSGraphicsContextPDFFormat, General/NSGraphicsContextRepresentationFormatAttributeName,
						nil];
									
	placeholderContext		= General/[NSGraphicsContext graphicsContextWithAttributes: contextAttributes],
	inContext			= General/[NSGraphicsContext currentContext];
						
	inAntialias			= [inContext shouldAntialias];
	inInterpolation			= [inContext imageInterpolation];
	
	// set up the drawing environment
	[placeholderContext setShouldAntialias: YES];
	[placeholderContext setImageInterpolation: General/NSImageInterpolationHigh];
	[placeholderContext saveGraphicsState];
	
	General/self color] setStroke];
	
	[[[[NSColor blackColor] setStroke];
	
	[temp setLineWidth: 5];
	General/[NSBezierPath strokeRect: bounds];
	
	[data writeToFile: @"System (OS X)/Users/kentozier/Desktop/bobo.pdf" atomically: YES];
	[inContext restoreGraphicsState];
	[inContext setShouldAntialias: inAntialias];
	[inContext setImageInterpolation: inInterpolation];
}


Thanks for any help,

Ken

----

I think you're being over-complicated. You can draw into General/NSImage, so simply create a new General/NSImage, lockFocus on it, draw, unlockFocus, and ask it for some TIFF data.

----

I wasn't aware that you could draw text to an General/NSImage. How would you go about that? 

*The same way you'd draw text into a view. Lock focus on the image (this is normally done for you with a view), draw the text using General/NSString or General/NSAttributedString methods, unlock focus. Once you've done lockFocus on the image, all drawing can be done normally.*

----

also, that path is wrong. remove 'System (OS X)' and it will be correct. *--boredzo*

**And instead of relying on the current user being kentozier...     [@"~/Desktop/bobo.pdf" stringByExpandingTildeInPath]**

----

Here's an example of drawing into an image:

    
- (General/NSImage *) placeholderImageOfSize:(General/NSSize)aSize
{
    General/NSString  *text = @"Placeholder Text";
    General/NSDictionary *textAttributes = nil; // Lucida Grande 13pt. see General/NSAttributedString for dict keys...

    General/NSSize     textSize = [text sizeWithAttributes:textAttributes];

    General/NSPoint   midpoint = General/NSMakePoint(aSize.width / 2.0, aSize.height / 2.0);
    General/NSPoint   textOrigin = General/NSMakePoint(midpoint.x - (textSize.width / 2.0), midpoint.y - (textSize.height / 2.0));

    General/NSImage *placeholder = General/[[NSImage alloc] initWithSize:aSize];

    [placeholder setFlipped:YES]; // text likes to be drawn in flipped coords...
    [placeholder lockFocus];

    [text drawAtPoint:textOrigin withAttributes:textAttributes];

    [placeholder unlockFocus];

    return [placeholder autorelease];
}

// To actually save the tiff file out ...
- (void)saveTiffFileOut
{
   // Assumes someSize is a valid General/NSSize
   // Assumes path is a valid file path like @"~/Desktop/General/MyPic.tiff"
   General/[self placeholderImageOfSize:someSize] [[TIFFRepresentation] writeToFile:path atomically:YES];
}

