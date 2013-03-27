How do I get the cells withing a General/NSMatrix to autoresize like a normal view?  I tried just setting the coil thing settings on an General/NSMatrix, but the cells widths don't adjust with the window.... **use the "autosize cells" option in General/NSMatrix's attributes panel**
----
Actually on a related line of thinking, is there a good clean way to get a General/NSMatrix to adjust the number of rows it has based on the width of the cells and how many will fit.  For example, if I have a matrix with 4 cells of fixed width, is there a nice way to automatically set the horizontal spacing to expand as the matrix expands, and when it squishes to an amount of space that will only fit 3 cells, to make a second row with the fourth item? (Imagine "Icon Cell View" like Interface Builder's instance tab item, although it should work with any kind of cell.. buttons etc.)
----

I realize that this isn't exactly what you were asking for, but it might get you started on something that leads to success. :-)

I use this class to display a resizable matrix of clickable thumbnail images in a simple image cataloging application. The General/ThumbnailMatrix lives inside an General/NSScrollView, which in turn lives in an General/NSSplitView.

--- General/ThumbnailMatrix.h ---
    
#import <Cocoa/Cocoa.h>

@interface General/ThumbnailMatrix : General/NSMatrix

- (id)initWithFrame: (General/NSRect)frameRect;
- (void)viewDidEndLiveResize;
- (void)update;

@end

--- General/ThumbnailMatrix.h ---

--- General/ThumbnailMatrix.m ---
    
@implementation General/ThumbnailMatrix

#define COLUMNS 6

- (id)initWithFrame: (General/NSRect)frameRect;
{
	General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];
	float width = 0;

	[super initWithFrame: frameRect 
			mode: General/NSListModeMatrix 
		   prototype: General/[[[ImageActionCell alloc] init] autorelease]
		numberOfRows: 0 
	     numberOfColumns: COLUMNS];

	width = round(General/self superview] frame].size.width / (float)COLUMNS);
	[self setCellSize: [[NSMakeSize(width, width)];
	[self setIntercellSpacing: General/NSMakeSize(0, 0)];
	[self setAllowsEmptySelection: YES];
	[pool release];

	return self;
}

- (void)viewDidEndLiveResize;
{
	float width = round(General/self superview] frame].size.width / (float)COLUMNS);
	[[NSNotification * notification = General/[NSNotification notificationWithName: 
		@"thumbnailViewDidEndLiveResize" object: self];
	General/[[NSNotificationCenter defaultCenter] postNotification: notification];
	[self setCellSize: General/NSMakeSize(width, width)];
	[self sizeToCells];
	[self setNeedsDisplay];
}

- (void)update;
{
	float width = round(General/self superview] frame].size.width / (float)COLUMNS);
	[self setCellSize: [[NSMakeSize(width, width)];
	[self sizeToCells];
	[self setNeedsDisplay];
}

@end

--- General/ThumbnailMatrix.m ---

In the document that contains the matrix, you can add yourself as an observer for the "thumbnailViewDidEndLiveResize" notification:

    
	General/[[NSNotificationCenter defaultCenter] addObserver: self 
						 selector: (SEL)@selector(updateViews) 
						     name: @"thumbnailViewDidEndLiveResize" 
						   object: nil];


Then if you want to update any other views in your document after resizing, you can do so in your "updateViews" method.

--Tantle