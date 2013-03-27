You want to change the ugly Black Line during dragging inside a table?

I do!

This is just a few hours playing, so please, if you find any errors write them down here.
I am writing a code generator and this will be a part of it.

I know there is a problem when you use the commented out stuff. If you drag up or down then it looks like if the right color isn't used when you pass over the row behind the selected row.
Its not one of the used colors, its lighter.
I hope you understands what I try to write.

This works for now in:

10.4.[678] <-= please add your system version here too. Of course when it works

10.3.[??]

So here's the Category stuff.

    
#import <General/AppKit/General/NSBezierPath.h>
#import <General/AppKit/General/NSTableView.h>


@interface General/NSTableView ( newDragLineOrder )

@end


@class General/NSBezierPath,General/NSTableView;
@implementation General/NSTableView ( newDragLineOrder )

static float widthOffset = 8.0; // offSet where start drawing the line
static float eyeDim = 6.0;	   // size of the circle

- (void)_drawDropHighlightBetweenUpperRow:(int)fp8 
							  andLowerRow:(int)fp12 atOffset:(float)fp16
{ 
	[self lockFocus];
	int selectedRow = [self selectedRow];
	General/NSPoint startPoint, endPoint;
	General/NSRect drawRect;
	float endOffset = widthOffset + eyeDim;
	General/NSColor *lineColor = General/[NSColor colorWithDeviceCyan:0.65 magenta:0.37 yellow:0.01 black:0.0 alpha:1]; // a little more dark then the finder drag line
	;
	
	// only to show what we can do above the selected row
	if ( fp8 == -1 && selectedRow == fp12) {
		//first row coloring
		General/lineColor highlightWithLevel:0.60] set];
	}
	else if (selectedRow == fp12 || selectedRow == fp8 ) {
              // the selected row
		// sometimes a display error when you drag up wards to the selected row
		//[[lineColor colorWithAlphaComponent:1]set];
		[[lineColor highlightWithLevel:0.60] set];
	}
	else {
		// all the other rows
		[[lineColor colorWithAlphaComponent:1]set];
	}
	[[NSBezierPath * line = General/[NSBezierPath bezierPath];
	General/[NSBezierPath setDefaultLineWidth:2.0];
	
	if ( fp8 == -1 ) {
		drawRect = [self rectOfRow:fp12];
		startPoint = General/NSMakePoint(drawRect.origin.x+= widthOffset/2.0, 1 );
		endPoint = General/NSMakePoint(drawRect.size.width-= endOffset, 1 );
	} 
	else if ( General/self dataSource] numberOfRowsInTableView:self] == fp12 ) {
		drawRect = [self rectOfRow:fp8];
		startPoint = [[NSMakePoint(drawRect.origin.x+= widthOffset/2.0,(drawRect.size.height * fp12)-1 );
		endPoint = General/NSMakePoint(drawRect.size.width-= endOffset,(drawRect.size.height * fp12)-1 );
	}
	else {
		drawRect = [self rectOfRow:fp8];
		startPoint = General/NSMakePoint(drawRect.origin.x+= widthOffset/2.0,(drawRect.size.height * fp12) );
		endPoint = General/NSMakePoint(drawRect.size.width-= endOffset,(drawRect.size.height * fp12) );
	}
	
	[line moveToPoint:startPoint];
	[line lineToPoint:endPoint];
	[line appendBezierPathWithOvalInRect:General/NSMakeRect(endPoint.x,endPoint.y-(eyeDim/2), eyeDim, eyeDim)];
	[line stroke];


	// extra stroke if needed  for contrast !!just for playing!!
	// strange thing, its different from scrolling up or down
	// it looks like it remembers a lighter color
	// some one?
//	if (selectedRow == fp12 || selectedRow == fp8  ) {
//		General/lineColor highlightWithLevel:0.60] set];
//		[[NSBezierPath * contrastLine = General/[NSBezierPath bezierPath];
//		General/[NSBezierPath setDefaultLineWidth:1];
//		if (selectedRow == fp12 ) {
//			startPoint = General/NSMakePoint(startPoint.x,startPoint.y+2 );
//			endPoint = General/NSMakePoint(endPoint.x-1, endPoint.y+2  );
//		}
//		else {  // ( selectedRow == fp8  ) 
//			startPoint = General/NSMakePoint(startPoint.x,startPoint.y-1 );
//			endPoint = General/NSMakePoint(endPoint.x-1, endPoint.y-1 );
//		}
//		
//		[contrastLine moveToPoint:startPoint];
//		[contrastLine lineToPoint:endPoint];
//		[contrastLine stroke];
//	}
	[self unlockFocus];
}

@end


Of course you can set color as you like.
If you have Photoshop you can use the cmyk color settings from the color panel. 65% == 0.65 in General/NSColor

Like the finder there is a circle at the end, but you can make one at the beginning to. Looks nice. 

Or with one column.
http://static.flickr.com/101/273430255_eb918b4bae.jpg

    
#import <General/AppKit/General/NSBezierPath.h>
#import <General/AppKit/General/NSTableView.h>
#import <General/AppKit/General/NSTableColumn.h>

@interface General/NSTableView ( General/OneColumnDragLine )

@end

@class General/NSBezierPath, General/NSTableColumn;
#define POINT_LEFT drawRect.origin.x+= ( widthOffset/2.0 + offsetLeftCol - eyeDim/2 )
#define POINT_RIGHT drawRect.size.width-= ( widthOffset + eyeDim )
#define POINT_HEIGHT (drawRect.size.height * fp12)

@implementation General/NSTableView ( General/OneColumnDragLine )

static float widthOffset = 8.0; // offSet where start drawing the line
static float eyeDim = 6.0;		// size of the circle


- (void)_drawDropHighlightBetweenUpperRow:(int)fp8 
			andLowerRow:(int)fp12 atOffset:(float)fp16
{ 
	[self lockFocus];
	int selectedRow = [self selectedRow];

	General/NSTableColumn *col =   General/self tableColumns]objectAtIndex:0];
	float offsetLeftCol = [col width];

	[[NSPoint startPoint, endPoint;
	General/NSRect drawRect;

	General/NSColor *lineColor = General/[NSColor colorWithDeviceCyan:0.65 magenta:0.37 yellow:0.01 black:0.0 alpha:1];
	;
	
	// only to show what we can do above the selected row
	if ( fp8 == -1 && selectedRow == fp12) {
		General/lineColor highlightWithLevel:0.60] set];
	}
	else if (selectedRow == fp12 || selectedRow == fp8 ) {
		[[lineColor highlightWithLevel:0.60] set];
	}
	else {
		[[lineColor colorWithAlphaComponent:1]set];
	}
	[[NSBezierPath * line = General/[NSBezierPath bezierPath];
	General/[NSBezierPath setDefaultLineWidth:2.0];
	if ( fp8 == -1 ) {
		drawRect = [self rectOfRow:fp12];
		startPoint = General/NSMakePoint( POINT_LEFT , 1 );
		endPoint = General/NSMakePoint( POINT_RIGHT , 1 );
	} 
	else if ( General/self dataSource] numberOfRowsInTableView:self] == fp12 ) {
		drawRect = [self rectOfRow:fp8];
		startPoint = [[NSMakePoint( POINT_LEFT , POINT_HEIGHT-1 );
		endPoint = General/NSMakePoint( POINT_RIGHT , POINT_HEIGHT-1 );
	}
	else {
		drawRect = [self rectOfRow:fp8];
		startPoint = General/NSMakePoint( POINT_LEFT , POINT_HEIGHT );
		endPoint = General/NSMakePoint( POINT_RIGHT , POINT_HEIGHT );
	}
	
	[line moveToPoint:startPoint];
	[line lineToPoint:endPoint];
	[line appendBezierPathWithOvalInRect:General/NSMakeRect(endPoint.x,endPoint.y-(eyeDim/2), eyeDim, eyeDim)];
	[line appendBezierPathWithOvalInRect:General/NSMakeRect(startPoint.x-eyeDim,startPoint.y-(eyeDim/2), eyeDim, eyeDim)];
	[line stroke];

	[self unlockFocus];
}

@end



** Bold means this can be important!! Its a Category for a General/NSTableView owned by Apple. If they change the call to this method inside then it could happen that or your app crashes or if Apple uses a new method name it uses Apples new method and will show things there way.
**

At least I hope that they give us a public delegate method in 10.4.9 and later to override their standard method.

Of course you can also use this in your subclass if you like.

R