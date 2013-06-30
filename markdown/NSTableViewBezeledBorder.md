

How can I create table with a border like the one in iTunes. Although iTunes is carbon application, however, there must be some way to do it with cocoa as (off the top of my head) General/NewsFire and some other apps achieve the same effect. 

Anybody done this before? 

- General/JohnDevor

----

There are various General/AppKit drawing functions like     General/NSDrawWhiteBezel() that might work.

----

    General/NSDrawWhiteBezel() does not produce the same effect as in iTunes. However, I managed to produce the correct border by simply drawing the border myself.

- General/JohnDevor
----

I created an General/NSView subclass that does this...
    

#import "General/XBorderedView.h"

static General/NSColor * _topColor = nil;
static General/NSColor * _bottomColor = nil;
static General/NSColor * _sideColor = nil;
static General/NSColor * _interiorColor = nil;

@implementation General/XBorderedView

+ (void)initialize {
	if(self == General/[XBorderedView class]) {
		_bottomColor = General/[[NSColor colorWithCalibratedWhite:0.55 alpha:1.0] retain];
		_topColor = General/[[NSColor colorWithCalibratedWhite:0.94 alpha:1.0] retain];
		_sideColor = General/[[NSColor colorWithCalibratedWhite:0.87 alpha:1.0] retain];
		_interiorColor = General/[[NSColor colorWithCalibratedWhite:0.38 alpha:1.0] retain];
	}
}

- (id)initWithFrame:(General/NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
	[self packSubviews];
}

- (void)addSubview:(General/NSView*)subview {
	[super addSubview:subview];
	[self packSubviews];
}

- (void)packSubviews {
	General/NSArray * subViews = [self subviews];
	General/NSView * subView = [subViews lastObject];
	
	General/NSRect fullFrame = [self bounds];
	
	fullFrame.origin.x += 2.0;
	fullFrame.origin.y += 2.0;
	fullFrame.size.height -= 3.0;
	fullFrame.size.width -= 4.0;
	
	[subView setFrame:fullFrame];
}

- (void)drawRect:(General/NSRect)rect {
	General/NSRect lineRect = rect;
	
	lineRect.origin.x += 1.0;
	lineRect.size.width -= 2.0;
	lineRect.size.height = 1.0;
	
	[_topColor set];
	General/NSRectFill(lineRect);
	
	lineRect.origin.y += (rect.size.height - 1.0);
	
	[_bottomColor set];
	General/NSRectFill(lineRect);
	
	lineRect = rect;
	lineRect.origin.y += 1.0;
	lineRect.size.height -= 2.0;
	lineRect.size.width = 1.0;
	
	[_sideColor set];
	General/NSRectFill(lineRect);
	
	lineRect.origin.x += (rect.size.width - 1.0);
	General/NSRectFill(lineRect);
	
	General/NSRect insetRect = General/NSInsetRect(rect, 1.0, 1.0);
	[_interiorColor set];
	General/NSFrameRect(insetRect);
	
	[self packSubviews];
}

- (BOOL)mouseDownCanMoveWindow {
	return YES;
}


@end



-Julian

----

It's not kosher to delete other people's posts because you think them unnecessary.

*Agreed. Pruning digressions and non-sequiturs, however, is acceptable practice. The rest should stay. I feel the discussion regarding the GPL issue is valid and relevant because some do question what rights they have to write their *own* code that does exactly the same common thing, such as the metal bezel effect on this page. I vote we keep it here for others.*

----

The colors seemed off (to my untrained eye, YMMV) so I used the set below but this and General/CCDGradientSelectionTableView gets you pretty darn close to a "table with a border like the one in iTunes".

    
                _bottomColor = General/[[[NSColor whiteColor] shadowWithLevel:0.3] retain];
		_topColor = General/[[[NSColor whiteColor] shadowWithLevel:0.1] retain];
                _sideColor = General/[[[NSColor whiteColor] shadowWithLevel:0.1] retain];
                _interiorColor = General/[[NSColor grayColor] retain];


----

One has already been done by another project out there: http://cvs.sourceforge.net/viewcvs.py/cocoalicious/cocoalicious/UI/General/SFHFBezelView.m?view=markup