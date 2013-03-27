I had need recently to lay out a ( varying ) number of procedurally-generated same-size elements in a window such that the elements would layout out in a grid with an optimal number of rows and columns for window dimensions. These had to be General/NSView subclasses since some of them had to be able to hold arbitrary controls and some were just text views.

Having written layout managers before for General/BeOS and for Qt & for Java I decided why not attempt to make a general purpose "flow layout" for Cocoa...

Here's the header ( General/ZFlowLayout.h )

    

#import <Cocoa/Cocoa.h>

/*
	No spring will let elements stretch to fit width

	Left spring will push elements to right side, 
	with no stretching

	Right spring will push elements to left side,
	with no stretching.

	Spring on left & right will squish layout into center.
*/
typedef enum _ZFlowLayoutSpring
{
	General/ZNoSpring = 0,
	General/ZSpringLeft = 1,
	General/ZSpringRight = 2,
	General/ZSpringLeftRight = 3,
} General/ZFlowLayoutSpring;

typedef struct _ZFlowLayoutSizing
{
	General/NSSize minSize;
	int padding;
	int spring;
	bool oneColumn;
} General/ZFlowLayoutSizing;

static inline General/ZFlowLayoutSizing General/ZMakeFlowLayoutSizing( General/NSSize minSize, int padding, 
    int spring, BOOL oneColumn )
{
	General/ZFlowLayoutSizing sizing;
	sizing.minSize = minSize;
	sizing.padding = padding;
	sizing.spring = spring;
	sizing.oneColumn = oneColumn;
	return sizing;
}

/******************************************************************************
	General/ZFlowLayout
******************************************************************************/

@interface General/ZFlowLayout : General/NSView
{
	General/ZFlowLayoutSizing _sizing;
	General/NSSize _lastSize;
	int _numElements;
	unsigned int _gridMask;
	BOOL _ignoreThisLayoutPass, _alternatingRowColors;
	General/NSColor *_backgroundColor, *_gridColor;
}

- (void) setSizing: (General/ZFlowLayoutSizing) sizing;
- (General/ZFlowLayoutSizing) sizing;

/*
	Draw a solid background color
*/
- (void) setBackgroundColor: (General/NSColor *) color;
- (General/NSColor *) backgroundColor;

/*
	Draw background using system alternating row colors
*/
- (void) setUsesAlternatingRowBackgroundColors: 
	(BOOL)useAlternatingRowColors;

- (BOOL) usesAlternatingRowBackgroundColors;

- (void) setGridStyleMask:(unsigned int)gridType;
- (unsigned int) gridStyleMask;

- (void) setGridColor:(General/NSColor *)aColor;
- (General/NSColor *) gridColor;

@end




And here's the implementation ( General/ZFlowLayout.m ):

    

#import "General/ZFlowLayout.h"

/******************************************************************************
	General/ZFlowLayout

	General/ZFlowLayoutSizing _sizing;
	General/NSSize _lastSize;
	int _numElements;
	unsigned int _gridMask;
	BOOL _ignoreThisLayoutPass, _alternatingRowColors;
	General/NSColor *_backgroundColor, *_gridColor;

******************************************************************************/

@interface General/ZFlowLayout (Internal)

- (void) layout;
- (int) numElements;
- (void) forceLayout;

@end

@implementation General/ZFlowLayout

- (id)initWithFrame:(General/NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
		_sizing = General/ZMakeFlowLayoutSizing( General/NSMakeSize( 100, 100 ), 10, 0, NO );
		_lastSize = General/NSMakeSize( 0, 0 );
		_numElements = 0;
		_ignoreThisLayoutPass = NO;
		_alternatingRowColors = NO;
		_backgroundColor = nil;
		_gridColor = General/[[NSColor colorWithDeviceWhite: 0.5 alpha: 0.4] retain];
		_gridMask = General/NSTableViewGridNone;

	
		[self setPostsFrameChangedNotifications: YES];
		
		General/NSNotificationCenter *nc = General/[NSNotificationCenter defaultCenter];
		[nc addObserver:self 
			selector: @selector( frameSizeChanged: ) 
			name: General/NSViewFrameDidChangeNotification 
			object: nil ];

	}
	return self;
}

- (void) awakeFromNib 
{
	General/NSScrollView *sv;
	if ( sv = [self enclosingScrollView] )
	{
		/*
			Resize self to fit scrollview
			And set width/height resizable
		*/
		
		General/NSSize contentSize = [sv contentSize];
		[self setFrameSize: contentSize];		
		[self setAutoresizingMask: 
			General/NSViewWidthSizable | General/NSViewHeightSizable];
	}   
}

- (void) setSizing: (General/ZFlowLayoutSizing) sizing
{
	if ( _sizing.minSize.width != sizing.minSize.width ||
	     _sizing.minSize.height != sizing.minSize.height ||
		 _sizing.padding != sizing.padding ||
		 _sizing.spring != sizing.spring ||
		 _sizing.oneColumn != sizing.oneColumn )
	{
		_sizing = sizing;
		[self forceLayout];
		[self display];
	}
}

- (General/ZFlowLayoutSizing) sizing
{
	return _sizing;
}

- (void) setBackgroundColor: (General/NSColor *) color
{
	[_backgroundColor autorelease];
	_backgroundColor = [color retain];
}

- (General/NSColor *) backgroundColor
{
	return _backgroundColor;
}

- (void) setUsesAlternatingRowBackgroundColors: 
	(BOOL)useAlternatingRowColors
{
	_alternatingRowColors = useAlternatingRowColors;
}

- (BOOL) usesAlternatingRowBackgroundColors
{
	return _alternatingRowColors;
}

- (void) setGridStyleMask:(unsigned int)gridType
{
	_gridMask = gridType;
}

- (unsigned int) gridStyleMask
{
	return _gridMask;
}

- (void) setGridColor:(General/NSColor *)aColor
{
	[_gridColor autorelease];
	_gridColor = [aColor retain];
}

- (General/NSColor *) gridColor
{
	return _gridColor;
}


///////////////////////////////////////////////////////////////////////
// Internal

- (BOOL) isOpaque
{
	if ( !_alternatingRowColors )
	{
		if ( !_backgroundColor ) return NO;
		return YES;
	}
	
	return YES;
}

- (void)drawRect:(General/NSRect)rect 
{
	General/NSRect bounds = [self bounds];
	General/NSBezierPath *fill = General/[NSBezierPath bezierPathWithRect: bounds];

	if ( !_alternatingRowColors )
	{
		if (!_backgroundColor) return;
		[_backgroundColor set];
		[fill fill];
	}
	else
	{
		General/NSArray *colors = General/[NSColor controlAlternatingRowBackgroundColors];
		General/NSColor *color = nil;
		
		int row = 0;
		float rowHeight = _sizing.minSize.height + _sizing.padding;
		General/NSRect rowRect = General/NSMakeRect( 0, bounds.size.height - rowHeight, 
                    bounds.size.width, rowHeight);
				
		while ( 1 )
		{
			color = [colors objectAtIndex: (row % [colors count])];
			General/NSBezierPath *fill = General/[NSBezierPath bezierPathWithRect: rowRect];

			[color set];
			[fill fill];
			
			rowRect.origin.y -= rowHeight;
			if ( rowRect.origin.y < -rowHeight ) break;
		
			row++;
		}
	}
	
	if ( _gridMask & General/NSTableViewSolidVerticalGridLineMask )
	{

	}
	
	if ( _gridMask & General/NSTableViewSolidHorizontalGridLineMask )
	{
		General/NSBezierPath *hLines = General/[NSBezierPath bezierPath];
		
		int row = 0;
		float rowHeight = _sizing.minSize.height + _sizing.padding, 
                    y = bounds.size.height - 0.5;
		
		while ( 1 )
		{
			if ( row > 0 )
			{			
				[hLines moveToPoint: General/NSMakePoint( 0, y )];
				[hLines lineToPoint: General/NSMakePoint( bounds.size.width, y )];
			}
			
			y-= rowHeight;
			
			if ( y <= 0 ) break;
			
			row++;
		}
		
		[_gridColor set];
		[hLines stroke];
	}
}

- (void) layout
{
	General/NSRect bounds = [self bounds], elementRect;
	General/NSPoint origin;

	if ( bounds.size.width == _lastSize.width &&
		 bounds.size.height == _lastSize.height  )
	{
		return;
	}

	_lastSize = bounds.size;	
	
	int i, j, k, numRows, numCols, widthAccumulator, 
		heightAccumulator, count;

	float widthPad, minWidth;
	int innerWidth = bounds.size.width - ( 2 * _sizing.padding );
	int innerHeight = bounds.size.height - ( 2 * _sizing.padding );
	float remainingWidth = 0;
	
	/*
		Do one-column as an absurdly big minimum width
	*/
	minWidth = _sizing.oneColumn ? innerWidth : _sizing.minSize.width;
	if ( minWidth > innerWidth ) minWidth = innerWidth;
	
	count = [self numElements];
	
	/*
		Determine max number of rows and columns
	*/

	widthAccumulator = 0;
	numCols = 0;
	while ( widthAccumulator <= (innerWidth + _sizing.padding) )
	{
		widthAccumulator += minWidth + _sizing.padding;
		numCols++;		
	}
	
	if ( numCols > 1 ) numCols--;

	heightAccumulator = 0;
	numRows = 0;
	while ( heightAccumulator <= (innerHeight + _sizing.padding) )
	{
		heightAccumulator += _sizing.minSize.height + _sizing.padding;
		numRows++;
	}

	if ( numRows > 1 ) numRows--;
	
	if ( count < numCols )
	{
		remainingWidth = (float) (innerWidth + _sizing.padding) - 
                    ( count * (minWidth + _sizing.padding )); 
		widthPad = remainingWidth / (float) count;
	}
	else
	{	
		remainingWidth = (float) (innerWidth + _sizing.padding) - 
                    ( numCols * (minWidth + _sizing.padding )); 
		widthPad = remainingWidth / (float) numCols;
	}
	
	if ( remainingWidth < 0 ) remainingWidth = 0;
		
	elementRect.size.width = minWidth;
	elementRect.size.height = _sizing.minSize.height;
	
	if ( !(_sizing.spring & General/ZSpringLeft) && !(_sizing.spring & General/ZSpringRight) )
		elementRect.size.width += widthPad;


	origin.x = _sizing.padding;
	origin.y = _sizing.padding / 2;

	/*
		Set up origin for left & right springs
	*/

	// left spring only
	if ( (_sizing.spring & General/ZSpringLeft) && !(_sizing.spring & General/ZSpringRight))
	{
		origin.x = _sizing.padding + remainingWidth;
	}
	//right spring only
	else if ( !(_sizing.spring & General/ZSpringLeft) && (_sizing.spring & General/ZSpringRight))
	{
		origin.x = _sizing.padding;
	}
	//both left and right springs
	else if ( (_sizing.spring & General/ZSpringLeft) && (_sizing.spring & General/ZSpringRight))
	{
		origin.x = _sizing.padding + remainingWidth / 2.0;
	}
	
	/*
		Now, do layout on each element rect. Use slightly 
		different methods if in a scrollview or not. In
		a scrollview, we layout all elements, and resize 
		vertically to fit. Otherwise, drop any that
		don't fit.
	*/
	
	General/NSArray *views = [self subviews];

	if ( ![self enclosingScrollView] )
	{
		k = 0;
		for ( i = 0; i < numRows; i++ )
		{
			for ( j = 0; j < numCols; j++ )
			{
				if ( k >= count ) break;
			
				elementRect.origin.x = origin.x + 
					( j * (elementRect.size.width + _sizing.padding) );
				elementRect.origin.y = bounds.size.height - origin.y - 
				    ( (i + 1) * (elementRect.size.height) );
				if ( i > 0 ) elementRect.origin.y -= ( i * _sizing.padding);

				General/NSView *view = [views objectAtIndex: k];	
				[view setFrame: elementRect];
				[view setHidden: NO];
		
				k++;
			}

			if ( k >= count ) break;
		}
		
		/*
			Now, hide any element which was unable 
			to be fitted into the layout
		*/
		
		while ( k < count )
		{
			General/views objectAtIndex: k++] setHidden: YES];
		}
	}
	else
	{
		/*
			We're in a scrollview, need to layout differently.
		*/

		k = 0;
		i = 0;
		while ( k < count )
		{
			for ( j = 0; j < numCols; j++ )
			{
				if ( k >= count ) break;
			
				elementRect.origin.x = origin.x + 
					( j * (elementRect.size.width + _sizing.padding) );
				elementRect.origin.y = bounds.size.height - origin.y - 
					( (i + 1) * (elementRect.size.height) );
				if ( i > 0 ) elementRect.origin.y -= ( i * _sizing.padding);

				[[NSView *view = [views objectAtIndex: k];	
				[view setFrame: elementRect];
				[view setHidden: NO];
		
				k++;
			}
			
			i++; //bump row
		}
		
		float minHeight = ( i * ( elementRect.size.height + _sizing.padding ));
		General/NSSize contentSize = General/self enclosingScrollView] contentSize];
		
		/*
			One-time ignore, since changing our size, here, would 
			otherwise result in an infinite loop.
		*/
		_ignoreThisLayoutPass = YES;

		if ( minHeight > contentSize.height )
		{
			[self setFrameSize: [[NSMakeSize( contentSize.width, minHeight )];
		}
		else
		{
			[self setFrameSize: contentSize];
		}

	}
}

- (int) numElements
{
	return _numElements;
}

- (void) forceLayout
{
	_lastSize = General/NSMakeSize( 0, 0 );
	[self layout];
}

///////////////////////////////////////////////////////////////////////
// Override General/NSView

- (void) addSubview:(General/NSView *)aView
{
	[super addSubview: aView];
	_numElements++;
	[self forceLayout];
	[self display];
}

- (void)willRemoveSubview:(General/NSView *)subview
{
	[super willRemoveSubview: subview];
	_numElements--;
	if ( _numElements < 0 ) _numElements = 0;

	[self forceLayout];
	[self display];
}

- (void) frameSizeChanged: (General/NSNotification *) aNotification
{
	if ( _ignoreThisLayoutPass )
	{
		_ignoreThisLayoutPass = NO;
		return;
	}
	
	[self layout];
}


@end



Usage is straightforward enough, instead of adding elements via IB, you just create your object and add it via      [layout addSubview: someView]; 

--General/ShamylZakariya

----

I fixed a potential linker error situation with the General/ZMakeFlowLayoutSizing function. Strangely, it was linking from Objective-C++ just fine, but not pure Objective-C. --SZ

----
This is an awesome piece of code. Best example I've seen of a custom General/NSView. Thanks! 

One nit - I think [self forceLayout]; is what we want inside frameSizeChanged. This makes it work nicely when resizing the window.

----

**How can we add the ability to drag-reorder objects in a 'pretty' way? I mean, having everything slide out of the way smoothly like an General/NSToolbar, leaving room for the dropped element? 11/14/2005**

----

Instead of using notifications to get size change uh...notifications it works better to override

    
 (void)resizeSubviewsWithOldSize:(General/NSSize)oldBoundsSize;
