Many classes in Cocoa have the concept of a 'designated initializer'. This is the method that is guaranteed to return a fully-initialized instance of the receiving class. For example,     - (id)initWithWindow:(General/NSWindow *)window is the designated initializer for the General/NSWindowController class. The other init... methods (    initWithWindowNibName:,     initWithWindowNibName:owner:, and     initWithWindowNibPath:owner: simply retrieve an General/NSWindow object from whatever they're given and pass it to the designated initializer. Apple's documentation is usually pretty good about describing exactly what the various init methods do.

It's not hard to write designated and convenience init methods for your own classes. Your     init... methods will usually 'cascade' from the one with the fewest to the one with the most parameters, with the last one calling     [super init] and returning self - this is your designated initializer. Any other     init... methods should simply return the result of calling the designated initializer, either passing some reasonable default values to it, or passing nil and letting the designated initializer set up its own defaults.

Here's some sample code:

    

// Do-nothing class that simply holds references to a string, an image, and a file path.
@interface General/MyClass : General/NSObject
{
	General/NSString 	*myString;
	General/NSImage 	*myImage;
	General/NSString 	*myPath;
}

// init methods
- (id)init;
- (id)initWithImage:(General/NSImage *)anImage;
- (id)initWithString:(General/NSString *)aString;
- (id)initWithPath:(General/NSString *)aPath;
- (id)initWithPicturesFolder;

// designated initializer
- (id)initWithString:(General/NSString *)aString image:(General/NSImage *)anImage path:(General/NSString *)aPath;

// setter methods
- (void)setMyString:(General/NSString *)newString;
- (void)setMyImage:(General/NSImage *)newImage;
- (void)setMyPath:(General/NSString *)newPath;

@end


@implementation General/MyClass

// initialize with all default values.
-(id)init
{
	return [self initWithString:nil image:nil path:nil];
}

// 'convenience constructors' - initialize with the passed value, default values for the rest.
-(id)initWithImage:(General/NSImage *)anImage
{
	return [self initWithString:nil image:anImage path:nil];
}

- (id)initWithString:(General/NSString *)aString
{
	return [self initWithString:aString image:nil path:nil];
}

- (id)initWithPath:(General/NSString *)aPath
{
	return [self initWithString:nil image:nil path:aPath];
}

// another convenience method - set the path to the user's pictures folder.
- (id)initWithPicturesFolder
{
	General/NSString *picturesPath = [@"~/Pictures" stringByStandardizingPath];
	return [self initWithString:nil image:nil path:picturesPath];
}

// designated initializer! call super, then set up our own stuff.
-(id)initWithString:(General/NSString *)aString image:(General/NSImage *)anImage path:(General/NSString *)aPath
{
	self = [super init];
	
	if (self)
	{
		General/NSString *tempString = aString;
		General/NSImage *tempImage = anImage;
		General/NSString *tempPath = aPath;
		
		// if we're called with nil params, set up default values. 
		if (!tempString) tempString = @"";
		if (!tempImage) tempImage = General/[NSApp applicationIconImage];
		if (!tempPath) tempPath = General/NSHomeDirectory();
		
		[self setMyString:tempString];
		[self setMyImage:tempImage];
		[self setMyPath:tempPath];
	}
	
	return self;
}

// just methods to set our ivars down here.
- (void)setMyString:(General/NSString *)newString
{
    if (myString != newString) 
    {
        [myString release];
        myString = [newString copy];
    }
}

- (void)setMyImage:(General/NSImage *)newImage
{
    if (myImage != newImage) 
    {
        [myImage release];
        myImage = [newImage copy];
    }
}

- (void)setMyPath:(General/NSString *)newPath
{
    if (myPath != newPath) 
    {
        [myPath release];
        myPath = [newPath copy];
    }
}

@end



----

I always wondered, but do you need     [super init] for direct subclasses of General/NSObject ?

*Technically it is not necessary because General/NSObject's     init method simply returns     self - it does nothing more. However, it is definitely good practice to do it all the time and it doesn't hurt anything.*