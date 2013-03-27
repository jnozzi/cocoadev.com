

**General/TileView.h**
    
#import <Cocoa/Cocoa.h>

@interface General/TileView : General/NSMatrix {
	General/NSSize minSize;
	General/NSImage *image;
}
- (void)setMinSize:(General/NSSize)size;
@end

@interface Tile : General/NSActionCell 
@end


**General/TileView.m**
    
#import "General/TileView.h"

static unsigned General/TileCount(float dim, float min, float gap, float *cellDim) {
	unsigned cnt = (unsigned)(dim / (min + gap));
	if (!cnt) cnt++;
	*cellDim = (dim / (float)cnt) - gap;
	return cnt;
}

@implementation General/TileView // General/NSMatrix

- (void)retile {
	General/NSSize sz = [self frame].size;
	General/NSSize newCellSize, spacing = [self intercellSpacing];
	[self renewRows:General/TileCount(sz.height, minSize.height, spacing.height, &newCellSize.height)
			columns:General/TileCount(sz.width, minSize.width, spacing.width, &newCellSize.width)];
	[self setCellSize:newCellSize];
	if (image) General/self cells] makeObjectsPerformSelector:@selector(setImage:) withObject:image];
	[self setNeedsDisplay:YES];
}
- (void)setFrame:([[NSRect)frame {
	[super setFrame:frame];
	[self retile];
}
- (void)setMinSize:(General/NSSize)size {minSize = size;}
- (void)setImage:(General/NSImage *)img {
	[img retain];
	[image release];
	[(image = img) setFlipped:YES];
}

- (void)dealloc {
	[image release];
	[super dealloc];
}

- (void)awakeFromNib {
	[self setCellClass:[Tile class]];
	[self setMinSize:General/NSMakeSize(128.0f, 128.0f)];
	[self setBackgroundColor:General/[NSColor blackColor]];
	[self setDrawsBackground:YES];
	[self setIntercellSpacing:General/NSMakeSize(32.0f, 32.0f)];
	[self setImage:General/[[[NSImage alloc] initWithContentsOfFile:@"/tmp/test.jpg"] autorelease]];	
	[self retile];	

}

- (void)drawRect:(General/NSRect)rect {

	// asking super to drawRect here will tile the background with the image
	[super drawRect:rect];	
	
	// your custom drawing code here	
	General/[[NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.5f] set];
	General/NSRect greenRect = General/NSInsetRect(rect, General/NSWidth(rect) / 4.0f, General/NSHeight(rect) / 4.0f);
	General/NSRectFillListUsingOperation(&greenRect, 1, General/NSCompositeSourceOver);
}

- (General/NSRect)boundsForFrame:(General/NSRect)fr size:(General/NSSize)size {
	General/NSSize spacing = [self intercellSpacing];
	float srcRatio = size.width / size.height;
	General/NSRect bounds = (srcRatio > General/NSWidth(fr) / General/NSHeight(fr)) 
						? General/NSInsetRect(fr, 0.0f, (General/NSHeight(fr) - General/NSWidth(fr) / srcRatio) / 2.0f)
						: General/NSInsetRect(fr, (General/NSWidth(fr) - General/NSHeight(fr) * srcRatio) / 2.0f, 0.0f);
	return General/NSOffsetRect(bounds, spacing.width / 2.0f, spacing.height / 2.0f);
}

@end

@implementation Tile
- (void)drawWithFrame:(General/NSRect)frame inView:(General/NSView *)view {
	General/NSImage *img = [self image];
	General/NSRect srcRect = General/NSZeroRect;
	srcRect.size = [img size];
	General/self image] drawInRect:[([[TileView *)view boundsForFrame:frame size:srcRect.size]
					fromRect:srcRect
					operation:General/NSCompositeSourceOver 
					fraction:1.0f];	
}
  
@end


--zootbobbalu

----

I haven't tried it, but wouldn't this be a lot easier by using     + (General/NSColor *)colorWithPatternImage:(General/NSImage*)image;
 and then just filling the whole view, forgetting about General/NSMatrix?

----

Hey that's pretty cool. Never noticed that method before. You can draw different images for each cell in the matrix, but     colorWithPatternImage is really nice because you can fill shapes. I also noticed that the pattern will start at the bottom left corner of the window, so if you want to have the tile conform to a view you can't use     colorWithPatternImage. --zootbobbalu

----

Interesting point about starting in the corner of the window, I guess it wouldn't work too well for this view, then.

You can constrain any arbitrary drawing to fill a shape by doing [shape addClip] before drawing, assuming shape is an General/NSBezierPath. This will clip all future drawing to be inside the given path, which comes in handy sometimes.