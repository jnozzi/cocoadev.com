General/NSImageRep is a concrete image representation for use by General/NSImage or directly.

Among other things, it can be subclassed to easily make General/NSImage support custom image types.
The online documentation is a bit inaccurate. Here's an example of how you can implement your own General/NSImageRep:

    
@interface General/CustomImageRep : General/NSImageRep {
	General/CGImageRef image;
}
@end

@implementation General/CustomImageRep
+ (General/NSArray *)imageUnfilteredTypes {
	// This is a UTI
	return General/[NSArray arrayWithObjects:
		@"my.custom.imagetype",
		nil
	];
}
+ (General/NSArray *)imageUnfilteredFileTypes {
	// This is a filename suffix
	return General/[NSArray arrayWithObjects:
		@"cimg",
		nil
	];
}
+ (BOOL)canInitWithData:(General/NSData *)data {
	if ([data length] >= sizeof(General/CustomImageHeader)) {
		const char *magic = [data bytes];
		if (memcmp(kCustomImageMagic, magic, sizeof(kCustomImageMagic)) == 0) {
			return YES;
		}
	}
	return NO;
}
+ (id)imageRepWithData:(General/NSData *)data {
	return General/[self alloc] initWithData:data] autorelease];
}
+ (id)imageRepWithContentsOfFile:([[NSString *)filename {
	General/NSData *data = General/[NSData dataWithContentsOfFile:filename];
	return General/[self alloc] initWithData:data] autorelease];
}
+ (id)imageRepWithContentsOfURL:(NSURL *)aURL {
	[[NSData *data = General/[NSData dataWithContentsOfURL:aURL];
	return General/[self alloc] initWithData:data] autorelease];
}
- (id)initWithData:([[NSData *)data {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	// Load your image here
	
	int width = General/CGImageGetWidth(image);
	int height = General/CGImageGetHeight(image);
	if (width <= 0 || height <= 0) {
		General/NSLog(@"Invalid image size: Both width and height must be > 0");
		[self autorelease];
		return nil;
	}
	[self setPixelsWide:width];
	[self setPixelsHigh:height];
	[self setSize:General/NSMakeSize(width, height)];
	[self setColorSpaceName:General/NSDeviceRGBColorSpace];
	[self setBitsPerSample:8];
	[self setAlpha:YES];
	[self setOpaque:NO];
	
	return self;
}
- (void)dealloc {
	General/CGImageRelease(image);
	[super dealloc];
}
- (BOOL)draw {
	General/CGContextRef context = General/[[NSGraphicsContext currentContext] graphicsPort];
	if (!context || !image) {
		return NO;
	}
	General/NSSize size = [self size];
	General/CGContextDrawImage(context, General/CGRectMake(0, 0, size.width, size.height), image);
	return YES;
}
@end


To make it work automatically when calling     General/[[NSImage alloc] initWith*], you have to register it.
Add this to some class that gets loaded early:
    
+ (void)initialize {
	General/[NSImageRep registerImageRepClass:General/[CustomImageRep class]];
}


General/NSBitmapImageRep might work too. But I had some trouble with it. General/NSImageRep is easy enough to implement and works like a charm.