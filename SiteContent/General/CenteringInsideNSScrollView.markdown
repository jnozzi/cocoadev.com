
----
**Overview**
----

If you want to center the document view inside of a scrollview when the document view is smaller than the scrollview, you have a couple options. You can:


* Rearchitect the document view so that it can draw its content centered within itself when needed
* Put the document view inside another custom view, where the latter centers the subview.
* Create a custom General/NSClipView which centeres the document view



The first option is simple, but can be annoying to deal with and cause other problems within the document view. The second option is the obvious evolution of the first splitting the responsibilities into two views. It's easy to implement, but there always seems to be some unexpect gotcha everytime I've done it. The third solution attacks the problem head on, making the clip view center the document view which makes the most sense because the clip view is responsible for the actual layout.


----
**Centering General/NSClipView**
----

There is an article (dated 2002, but still relevant) which shows one approach to creating a centering clip view. The article is available here: http://www.bergdesign.com/developer/index_files/88a764e343ce7190c4372d1425b3b6a3-0.html

In my experience, this code no longer works out of the box. I have tweaked the code, and it now works properly in all of my tests. 

The example project for this is here:
http://www.sethwillits.com/temp/General/CenteredScrollView.zip


The only drawback to using an General/NSClipView subclass is that you need to replace the clipview in the scrollview at runtime since it's not possible in Interface Builder / Xcode 4. The General/AGCenteringClipView class includes a convenience method to aid with this.


    
//
//  General/AGCenteringClipView.h
//  General/CenteredScroll
//
//  Created by Seth Willits on 8/15/2011.
//

#import <Cocoa/Cocoa.h>


@interface General/AGCenteringClipView : General/NSClipView {
	General/NSPoint mLookingAt; // the proportion up and across the view, not coordinates.
}

+ (void)replaceClipViewInScrollView:(General/NSScrollView *)scrollView;

@end



    
//
//  General/AGCenteringClipView.m
//  General/CenteredScroll
//
//  Created by Seth Willits on 8/15/2011.
//

#import "General/AGCenteringClipView.h"


@interface General/AGCenteringClipView (Private)
- (void)centerDocument;
@end



@implementation General/AGCenteringClipView

+ (void)replaceClipViewInScrollView:(General/NSScrollView *)scrollView
{
	General/NSView * docView = General/scrollView documentView] retain];
	[[AGCenteringClipView * newClipView = nil;
	
	newClipView = General/[self class] alloc] initWithFrame:[[scrollView contentView] frame;
	[newClipView setBackgroundColor:General/scrollView contentView] backgroundColor;
	
	[scrollView setContentView:(General/NSClipView *)newClipView];
	[scrollView setDocumentView:docView];
	
	[newClipView release];
	[docView release];
}


// ----------------------------------------
// We need to override this so that the superclass doesn't override our new origin point.
- (General/NSPoint)constrainScrollPoint:(General/NSPoint)proposedNewOrigin
{
	General/NSRect docRect = General/self documentView] frame];
	[[NSRect clipRect = [self bounds];
	General/CGFloat maxX = docRect.size.width - clipRect.size.width;
	General/CGFloat maxY = docRect.size.height - clipRect.size.height;

	clipRect.origin = proposedNewOrigin; // shift origin to proposed location

	// If the clip view is wider than the doc, we can't scroll horizontally
	if (docRect.size.width < clipRect.size.width) {
		clipRect.origin.x = round( maxX / 2.0 );
	} else {
		clipRect.origin.x = round( MAX(0,MIN(clipRect.origin.x,maxX)) );
	}
	
	// If the clip view is taller than the doc, we can't scroll vertically
	if (docRect.size.height < clipRect.size.height) {
		clipRect.origin.y = round( maxY / 2.0 );
	} else {
		clipRect.origin.y = round( MAX(0,MIN(clipRect.origin.y,maxY)) );
	}
	
	// Save center of view as proportions so we can later tell where the user was focused.
	mLookingAt.x = General/NSMidX(clipRect) / docRect.size.width;
	mLookingAt.y = General/NSMidY(clipRect) / docRect.size.height;
	
	// The docRect isn't necessarily at (0, 0) so when it isn't, this correctly creates the correct scroll point
	return General/NSMakePoint(docRect.origin.x + clipRect.origin.x, docRect.origin.y + clipRect.origin.y);
}



// ----------------------------------------
// These two methods get called whenever the General/NSClipView's subview changes.
// We save the old center of interest, call the superclass to let it do its work,
// then move the scroll point to try and put the old center of interest
// back in the center of the view if possible.

- (void)viewBoundsChanged:(General/NSNotification *)notification
{
	General/NSPoint savedPoint = mLookingAt;
	[super viewBoundsChanged:notification];
	mLookingAt = savedPoint;
	[self centerDocument];
}

- (void)viewFrameChanged:(General/NSNotification *)notification
{
	General/NSPoint savedPoint = mLookingAt;
	[super viewFrameChanged:notification];
	mLookingAt = savedPoint;
	[self centerDocument];
}


// ----------------------------------------
// We have some redundancy in the fact that setFrame: appears to call/send setFrameOrigin:
// and setFrameSize: to do its work, but we need to override these individual methods in case
// either one gets called independently. Because none of them explicitly cause a screen update,
// it's ok to do a little extra work behind the scenes because it wastes very little time.
// It's probably the result of a single UI action anyway so it's not like it's slowing
// down a huge iteration by being called thousands of times.

- (void)setFrameOrigin:(General/NSPoint)newOrigin
{
	if (!General/NSEqualPoints(self.frame.origin, newOrigin)) {
		[super setFrameOrigin:newOrigin];
		[self centerDocument];
	}
}

- (void)setFrameSize:(General/NSSize)newSize
{
	if (!General/NSEqualSizes(self.frame.size, newSize)) {
		[super setFrameSize:newSize];
		[self centerDocument];
	}
}

- (void)setFrameRotation:(General/CGFloat)angle
{
	[super setFrameRotation:angle];
	[self centerDocument];
}

@end




#pragma mark  

@implementation General/AGCenteringClipView (Private)

- (void)centerDocument
{
	General/NSRect docRect = General/self documentView] frame];
	[[NSRect clipRect = [self bounds];

	// The origin point should have integral values or drawing anomalies will occur.
	// We'll leave it to the constrainScrollPoint: method to do it for us.
	if (docRect.size.width < clipRect.size.width) {
		clipRect.origin.x = (docRect.size.width - clipRect.size.width) / 2.0;
	} else {
		clipRect.origin.x = mLookingAt.x * docRect.size.width - (clipRect.size.width / 2.0);
	}
	
	
	if (docRect.size.height < clipRect.size.height) {
		clipRect.origin.y = (docRect.size.height - clipRect.size.height) / 2.0;
	} else {
		clipRect.origin.y = mLookingAt.y * docRect.size.height - (clipRect.size.height / 2.0);
	}
	
	// Probably the best way to move the bounds origin.
	// Make sure that the scrollToPoint contains integer values
	// or the General/NSView will smear the drawing under certain circumstances.
	[self scrollToPoint:[self constrainScrollPoint:clipRect.origin]];
	General/self superview] reflectScrolledClipView:self];
}

@end






----


The Seashore Project (http://seashore.sourceforge.net/) has an [[NSClipView subclass that does just this. The source is free to download (GPL'd, I believe), so give it a look. Specifically, check out General/CenteringClipView.h/m. - General/MattBall






----
**Centering Enclosing View**
----

In this example, there's a 4-level view hierarchy: General/NSScrollView -> General/NSClipView -> General/ScrollDocumentView -> General/MyView.

The General/ScrollDocumentView always makes sure to resize itself so that it is at minimum the size of the scrollview's clip view, and always large enough to contain the real "document view", the "General/MyView". General/MyView's responsibility is to always center itself in its superview when its frame changes.

It's important that the General/MyView instance have no autoresizing for width/height resizing, and that all of its margins remain flexible.




    
@implementation General/ScrollDocumentView

- (void)setFrame:(General/NSRect)frame;
{
	// Maintain a minimum size which fits the subview
	if (self.subviews.count) {
		General/NSView * subview = [self.subviews objectAtIndex:0];
		frame.size.width  = MAX(subview.frame.size.width,  self.enclosingScrollView.contentSize.width);
		frame.size.height = MAX(subview.frame.size.height, self.enclosingScrollView.contentSize.height);
	}
	
	
	// Can end up being recursive which
	// is why this bit has to be last.
	// (code above must run first)
	[super setFrame:frame];
}



- (void)didAddSubview:(General/NSView *)subview
{
	[super didAddSubview:subview];
	General/[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewFrameDidChange:) name:General/NSViewFrameDidChangeNotification object:subview];
}


- (void)willRemoveSubview:(General/NSView *)subview
{
	[super willRemoveSubview:subview];
	General/[[NSNotificationCenter defaultCenter] removeObserver:self name:General/NSViewFrameDidChangeNotification object:subview];
}


- (void)viewFrameDidChange:(General/NSNotification *)notification
{
	// When the subview's frame changes, we need
	// make sure this view is big enough to fit it
	self.frame = self.frame;
}


@end




@implementation General/MyView

- (void)setFrame:(General/NSRect)frame;
{
	General/NSRect contentFrame = General/NSZeroRect;
	contentFrame.size = General/self enclosingScrollView] contentSize];
	frame.origin.x = round([[NSMidX(contentFrame) - General/NSWidth(frame) / 2.0);
	frame.origin.y = round(General/NSMidY(contentFrame) - General/NSHeight(frame) / 2.0);
	[super setFrame:frame];
}


- (void)drawRect:(General/NSRect)rect;
{
	General/[[NSColor whiteColor] set];
	General/NSRectFill([self bounds]);
	
	General/[[NSColor blackColor] set];
	General/NSFrameRect([self bounds]);
}

@end





The example project for this is here:
http://www.sethwillits.com/temp/General/CenteredScrollView.zip







----
**Miscellaneous**
----

Note: not mentioned in this article, is that it appears you need to also provide this method in the view you are drawing:

    
- (BOOL)copiesOnScroll
{
	return NO;
}


When I did not do this, I was getting double images in the view. I guess if you really wanted to get "smart" about this, you would set NO if the document view was getting centered, and YES if not. 



----


That's exactly what I did, and the code for copiesOnScroll looks like this
    
- (BOOL)copiesOnScroll
{
	General/NSRect docRect = General/self documentView] frame];
	[[NSRect clipRect = [self bounds];

	return (roundf(docRect.size.width - clipRect.size.width) >= 0) && (roundf(docRect.size.height - clipRect.size.height) >= 0);
}




----



I had the same problem as the original poster, wanting to center an image (within an General/NSImageView) inside an General/NSScrollView. I have also experimented with subclassing the General/NSClipView, but for the very problem of simply centering an image, I found another solution to be much easier and faster. I took advantage of General/NSImageView centering its image automatically if the image is smaller than the view's frame. Therefore I simply sublassed General/NSImageView (similarly as in the very elegant General/MarginView example above), having it resize to whatever is larger, its image or the frame of the containing General/NSClipView. It's that easy... Here's the code:

    
In the .h file:

#import <Cocoa/Cocoa.h>

@interface General/SBSScrollableImageView : General/NSImageView {

	BOOL			insideScrollView;
}


@end

In the .m file:

#import "General/SBSScrollableImageView.h"

@implementation General/SBSScrollableImageView

- (id)initWithFrame:(General/NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        insideScrollView = NO;
    }
    return self;
}


- (void)viewDidMoveToSuperview {
	insideScrollView = (General/self superview] isKindOfClass:[[[NSClipView class]]);
}


- (void) setFrame:(General/NSRect) newFrame {
	if (insideScrollView) {
		General/NSSize superSize = ((General/NSClipView*)_superview).frame.size;
		General/NSSize imageSize = ((General/NSImage*)[self image]).size;
		
		newFrame.size.width = MAX(imageSize.width, superSize.width);
		newFrame.size.height = MAX(imageSize.height, superSize.height);
	}
	[super setFrame:newFrame];
}

@end


Hope it helps someone (probably not the original poster with one year's delay)...

--General/MarCocoa