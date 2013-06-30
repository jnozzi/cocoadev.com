General/NSImageView

An General/NSImageView displays a single General/NSImage in a frame and can optionally allow a user to drag an image to it. http://goo.gl/General/OeSCu

----

To display an image from the application bundle using an General/NSImageView use the following code:

    
// Header
General/IBOutlet *General/NSImageView imageView;

// Source
General/NSImage *imageFromBundle = General/[NSImage imageNamed:@"your_image.tif"];

[imageView setImage: imageFromBundle];


----

To download and display an image from a server using an General/NSImageView use the following code:

    
// Header
General/IBOutlet *General/NSImageView imageView;

// Source
NSURL *imageURL = [NSURL General/URLWithString:@"http://www.someserver.com/image.tif"];
General/NSData *imageData = [imageURL resourceDataUsingCache:NO];
General/NSImage *imageFromBundle = General/[[NSImage alloc] initWithData:imageData];

if (imageFromBundle)
{
    // The image loaded properly, so lets display it.
    [imageView setImage:imageFromBundle];
    [imageFromBundle release];
}
else  //  if (!imageFromBundle)
{
    // The image did not load properly, so lets send an error to the log.
    // At this time, we could either load a copy of the image from the bundle,
    // or simply display an error sheet.
    General/NSLog(@"imageView could not be loaded.");
}


----

Other failure modes:  URL, Data?

----

The code is just meant to be a simple examples showing how to do a few things with General/NSImageView.

----

**General/FakeImageView**

Despite my efforts the following statement refuses to live up to itself:

* General/NSScaleProportionally. If the image is too large, it shrinks to fit inside the frame. If the image is too small, it expands. The proportions of the image are preserved.

It shrinks to fit inside the frame, but it does NOT expand to fill the frame.

----

This is the intended, if poorly documented, behavior of General/NSImageView. It's worked that way in General/OpenStep as well. Feelings of mistrust or betrayal are natural.

I ended up writing my own class, which I call General/FakeImageView, to implement this and a few other features I wanted. Click through for more details.

When necessary, I create a General/FakeImageView subclass of General/NSView in IB and set image views to that custom class. Maybe it would have been better to subclass General/NSImageView ... but oh well. Your mileage may vary. 

-- General/MikeTrent

----

I liked the Drag and Drop support of General/NSImageView -- I'm going to try to add that functionality to your General/FakeImageView.

----

Is there a way to repeat an image over the X axis, forming a pattern?

----

Sure. If I was doing it, I'd add that to General/NSImageCategory though.     +patternImage: alongAxis: size:, maybe.

----

See General/NSColor's colorWithPatternImage: method.

----

I needed an image view to use in a General/CoreData project that would let me get and set the path of the displayed image (because I wanted to use discrete image files instead of ballooning the CD store). Here's what I came up with.

    
//// Header
#import <Cocoa/Cocoa.h>

@interface General/PRImageView : General/NSImageView
{
	General/AliasHandle mImageAlias;
	BOOL mDraggingFlag;
}

- (General/NSString*)imagePath;
- (NSURL*)imageURL;
- (General/AliasHandle)imageAlias;
- (BOOL)getImageRef:(General/FSRef*)outRef;

- (void)setImageFromPath:(General/NSString*)inPath;
- (void)setImageFromURL:(NSURL*)inURL;

@end

//// Implementation
//
//  General/PRImageView.m
//
//  Created by Gregory Weston on 3/5/08.
//

#import "General/PRImageView.h"


@implementation General/PRImageView

- (void)cacheAliasFromURL:(NSURL*)inURL
{
	General/FSRef theRef = {};
	General/CFURLGetFSRef((General/CFURLRef)inURL, &theRef);
	General/OSErr theError = General/FSNewAlias(NULL, &theRef, &mImageAlias);
	if(theError != noErr) General/NSLog(@"General/FSNewAlias: %d", theError);
}

- (void)clearCachedAlias
{
	if(mImageAlias)
	{
		General/DisposeHandle((Handle)mImageAlias);
		mImageAlias = NULL;
	}
}

- (void)dealloc
{
	General/DisposeHandle((Handle)mImageAlias);
	[super dealloc];
}

- (void)setImage:(General/NSImage*)inImage
{
	if(mDraggingFlag == NO) [self clearCachedAlias];
	[super setImage:inImage];
}

- (void)concludeDragOperation:(id <General/NSDraggingInfo>)sender
{
	[self clearCachedAlias];

	General/NSPasteboard* thePasteboard = [sender draggingPasteboard];
	General/NSArray* theTypes = [thePasteboard types];
	if([theTypes containsObject:General/NSFilenamesPboardType])
	{
		General/NSArray* thePaths = [thePasteboard propertyListForType:General/NSFilenamesPboardType];
		General/NSString* thePath = [thePaths objectAtIndex:0];
		NSURL* theURL = [NSURL fileURLWithPath:thePath];
		[self cacheAliasFromURL:theURL];
	}

	mDraggingFlag = YES;
	[super concludeDragOperation:sender];
	mDraggingFlag = NO;
}

- (General/NSString*)imagePath
{
	General/NSString* theResult = nil;
	NSURL* theURL = [self imageURL];
	if(theURL && [theURL isFileURL])
	{
		theResult = [theURL path];
	}
	return theResult;
}

- (NSURL*)imageURL
{
	NSURL* theResult = nil;
	General/FSRef theRef = {};
	if([self getImageRef:&theRef])
	{
		General/CFURLRef theURL = General/CFURLCreateFromFSRef(kCFAllocatorDefault, &theRef);
		if(theURL)
		{
			theResult = [(NSURL*)theURL autorelease];
		}
	}
	return theResult;
}

- (General/AliasHandle)imageAlias
{
	return mImageAlias;
}

- (BOOL)getImageRef:(General/FSRef*)outRef
{
	BOOL theResult = NO;
	if(mImageAlias && outRef)
	{
		Boolean theChangeFlag = false;
		if(General/FSResolveAlias(NULL, mImageAlias, outRef, &theChangeFlag) == noErr)
		{
			theResult = YES;
		}
	}
	return theResult;
}

- (void)setImageFromPath:(General/NSString*)inPath
{
	if(inPath)
	{
		General/NSImage* theImage = General/[[NSImage alloc] initWithContentsOfFile:inPath];
		if(theImage)
		{
			[self setImage:theImage];
			[self clearCachedAlias];
			NSURL* theURL = [NSURL fileURLWithPath:inPath];
			[self cacheAliasFromURL:theURL];
		}
	}
}

- (void)setImageFromURL:(NSURL*)inURL
{
	if(inURL)
	{
		General/NSImage* theImage = General/[[NSImage alloc] initWithContentsOfURL:inURL];
		if(theImage)
		{
			[self setImage:theImage];
			[self clearCachedAlias];
			if([inURL isFileURL]) [self cacheAliasFromURL:inURL];
		}
	}
}

@end

