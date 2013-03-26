Many classes in Cocoa have the concept of a 'designated initializer'. This is the method that is guaranteed to return a fully-initialized instance of the receiving class. For example, <code>- (id)initWithWindow:([[NSWindow]] '')window</code> is the designated initializer for the [[NSWindowController]] class. The other init... methods (<code>initWithWindowNibName:</code>, <code>initWithWindowNibName:owner:</code>, and <code>initWithWindowNibPath:owner:</code> simply retrieve an [[NSWindow]] object from whatever they're given and pass it to the designated initializer. Apple's documentation is usually pretty good about describing exactly what the various init methods do.

It's not hard to write designated and convenience init methods for your own classes. Your <code>init...</code> methods will usually 'cascade' from the one with the fewest to the one with the most parameters, with the last one calling <code>[super init]</code> and returning self - this is your designated initializer. Any other <code>init...</code> methods should simply return the result of calling the designated initializer, either passing some reasonable default values to it, or passing nil and letting the designated initializer set up its own defaults.

Here's some sample code:

<code>

// Do-nothing class that simply holds references to a string, an image, and a file path.
@interface [[MyClass]] : [[NSObject]]
{
	[[NSString]] 	''myString;
	[[NSImage]] 	''myImage;
	[[NSString]] 	''myPath;
}

// init methods
- (id)init;
- (id)initWithImage:([[NSImage]] '')anImage;
- (id)initWithString:([[NSString]] '')aString;
- (id)initWithPath:([[NSString]] '')aPath;
- (id)initWithPicturesFolder;

// designated initializer
- (id)initWithString:([[NSString]] '')aString image:([[NSImage]] '')anImage path:([[NSString]] '')aPath;

// setter methods
- (void)setMyString:([[NSString]] '')newString;
- (void)setMyImage:([[NSImage]] '')newImage;
- (void)setMyPath:([[NSString]] '')newPath;

@end


@implementation [[MyClass]]

// initialize with all default values.
-(id)init
{
	return [self initWithString:nil image:nil path:nil];
}

// 'convenience constructors' - initialize with the passed value, default values for the rest.
-(id)initWithImage:([[NSImage]] '')anImage
{
	return [self initWithString:nil image:anImage path:nil];
}

- (id)initWithString:([[NSString]] '')aString
{
	return [self initWithString:aString image:nil path:nil];
}

- (id)initWithPath:([[NSString]] '')aPath
{
	return [self initWithString:nil image:nil path:aPath];
}

// another convenience method - set the path to the user's pictures folder.
- (id)initWithPicturesFolder
{
	[[NSString]] ''picturesPath = [@"~/Pictures" stringByStandardizingPath];
	return [self initWithString:nil image:nil path:picturesPath];
}

// designated initializer! call super, then set up our own stuff.
-(id)initWithString:([[NSString]] '')aString image:([[NSImage]] '')anImage path:([[NSString]] '')aPath
{
	self = [super init];
	
	if (self)
	{
		[[NSString]] ''tempString = aString;
		[[NSImage]] ''tempImage = anImage;
		[[NSString]] ''tempPath = aPath;
		
		// if we're called with nil params, set up default values. 
		if (!tempString) tempString = @"";
		if (!tempImage) tempImage = [[[NSApp]] applicationIconImage];
		if (!tempPath) tempPath = [[NSHomeDirectory]]();
		
		[self setMyString:tempString];
		[self setMyImage:tempImage];
		[self setMyPath:tempPath];
	}
	
	return self;
}

// just methods to set our ivars down here.
- (void)setMyString:([[NSString]] '')newString
{
    if (myString != newString) 
    {
        [myString release];
        myString = [newString copy];
    }
}

- (void)setMyImage:([[NSImage]] '')newImage
{
    if (myImage != newImage) 
    {
        [myImage release];
        myImage = [newImage copy];
    }
}

- (void)setMyPath:([[NSString]] '')newPath
{
    if (myPath != newPath) 
    {
        [myPath release];
        myPath = [newPath copy];
    }
}

@end

</code>

----

I always wondered, but do you need <code>[super init]</code> for direct subclasses of [[NSObject]] ?

''Technically it is not necessary because [[NSObject]]'s <code>init</code> method simply returns <code>self</code> - it does nothing more. However, it is definitely good practice to do it all the time and it doesn't hurt anything.''