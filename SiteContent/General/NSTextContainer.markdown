An General/NSTextContainer defines a region where text is laid out. An General/NSLayoutManager uses General/NSTextContainer (s) to determine where to break lines, lay out portions of text, and so on. General/NSTextContainer defines rectangular regions, but you can create subclasses that define regions of other shapes, such as circular regions, regions with holes in them, or regions that flow alongside graphics.

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSTextContainer_Class/index.html#//apple_ref/doc/uid/TP40004132

----

I think of General/NSTextContainer as a sort of 'scratch pad' for General/NSLayoutManager  to work in before drawing to a view.

----
Has any one worked on irregular shaped text container??? 
----
The following is a sample that performs text layout and editing within a text container defined by an arbitrary closed convex Bezier path.  The sample is deliberately kept simple and uses a brute force technique.  There are suggestions for improvements in the code.  For a more general solution, mix this sample with arbitrary path filling logic.  The seminal Graphics GEMS series will aid with path filling.  The Opensource libArt project demonstrates an efficient way to handle concave paths, paths with voids (doughnuts), and vastly more efficient convex paths.  libArt conveniently "raterizes" to horizontal rectangles which are exacly what is needed for this sample.

* General/MyBezierTextContainer.h*
    
@interface General/MyBezierTextContainer : General/NSTextContainer 
{
   id          pathSource;
}

- (id)pathSource;
- (void)setPathSource:(id)aPathSource;

@end


* General/MyBezierTextContainer.m*
    
#import "General/MyBezierTextContainer.h"


@interface General/NSObject (General/MyBezierTextContainerPathSource)

- (General/NSBezierPath *)closedBezierPathForTextContainer:(id)aContainer;

@end


@implementation General/MyBezierTextContainer

- (void)dealloc
{
   [self setPathSource: nil];
   [super dealloc];
}

- (id)pathSource
{
   return pathSource; 
}

- (void)setPathSource:(id)aPathSource
{
   [aPathSource retain];
   [pathSource release];
   pathSource = aPathSource;
}

- (BOOL)isSimpleRectangularTextContainer
{
   return (nil != [self pathSource]);
}

- (BOOL)containsPoint:(General/NSPoint)aPoint
{
   BOOL        result = [super containsPoint:aPoint];
   
   if(result && nil != [self pathSource])
   {
      General/NSBezierPath *bezierPath = General/self pathSource] closedBezierPathForTextContainer:self];
      
      result = [bezierPath containsPoint:aPoint];
   }
   
   return result;
}

- ([[NSRect)lineFragmentRectForProposedRect:(General/NSRect)proposedRect sweepDirection:(General/NSLineSweepDirection)sweepDirection movementDirection:(General/NSLineMovementDirection)movementDirection remainingRect:(General/NSRectPointer)remainingRect
{
   General/NSRect         result = General/NSZeroRect;
   
   if(nil == [self pathSource])
   {
      result = [super lineFragmentRectForProposedRect:proposedRect sweepDirection:sweepDirection movementDirection:movementDirection remainingRect:remainingRect];
   }
   else
   {
      General/NSBezierPath      *bezierPath = General/self pathSource] closedBezierPathForTextContainer:self];
      
      if(NULL != remainingRect)
      {
         *remainingRect = [[NSZeroRect;
      }
      
      result = General/NSIntersectionRect(proposedRect, [bezierPath bounds]);
      
      if(result.size.height < proposedRect.size.height)
      {
         result = General/NSZeroRect;
      }
      else
      {
         General/NSPoint     topLeft = result.origin;
         General/NSPoint     topRight = result.origin;
         topRight.x += result.size.width;
         General/NSPoint     bottomLeft = result.origin;
         bottomLeft.y += result.size.height;
         General/NSPoint     bottomRight = topRight;
         bottomRight.y += result.size.height;
         
         // Improvement: Use binary search or "quad" tree instead of brute force search
         while(![bezierPath containsPoint:topLeft] && (topLeft.x < topRight.x))
         {
            topLeft.x += 1.0f;
         }
         bottomLeft.x = topLeft.x;
         while(![bezierPath containsPoint:bottomLeft] && (bottomLeft.x < bottomRight.x))
         {
            bottomLeft.x += 1.0f;
         }
         topLeft.x = bottomLeft.x;
         while(![bezierPath containsPoint:topRight] && (topLeft.x < topRight.x))
         {
            topRight.x -= 1.0f;
         }
         bottomRight.x = topRight.x;
         while(![bezierPath containsPoint:bottomRight] && (bottomLeft.x < bottomRight.x))
         {
            bottomRight.x -= 1.0f;
         }
         topRight.x = bottomRight.x;
         
         result = General/NSMakeRect(topLeft.x, topLeft.y, MAX(1.0f, bottomRight.x - topLeft.x), bottomRight.y - topLeft.y);
         
         if(General/NSIsEmptyRect(result))
         {
            result = General/NSZeroRect;
         }
      }
   }
   
   return result;
}

@end


To test the custom text container, create a standard Cocoa multi-document application and add the following code to the document class: (You will want to connect the *textView* outlet to a text view within the document nib.
*General/MyDocument.h*
    
@class General/MyBezierTextView;


@interface General/MyDocument : General/NSDocument
{
   General/NSBezierPath                  *bezierPath;
   General/IBOutlet General/NSTextView           *textView;
}

- (General/NSBezierPath *)bezierPath;
- (void)setBezierPath:(General/NSBezierPath *)aBezierPath;

@end


* General/MyDocument.m*
    
- (id)init
{
    self = [super init];
    if (self) 
    {
       // Use the following line instead of the complex path made of curves if you want something simple
       //[self setBezierPath:General/[NSBezierPath bezierPathWithOvalInRect:General/NSMakeRect(20.0f, 0.0f, 300.0f, 600.0f)]]; 
       
       // Define a complex path using curves and lines
       General/NSBezierPath     *newPath = General/[NSBezierPath bezierPath];
       
       srandom((int)General/[NSDate timeIntervalSinceReferenceDate]);
       [newPath moveToPoint:General/NSMakePoint(100.0f + fmod(random(), 100.0f), -1.0f)];
       float      curveWidth = 100.0f + fmod(random(), 200.0f);
       float      curveHeight = 100.0f + fmod(random(), 200.0f);
       [newPath relativeCurveToPoint:General/NSMakePoint(curveWidth, curveHeight) controlPoint1:General/NSMakePoint(curveWidth, 0.0f) controlPoint2:General/NSMakePoint(0.0f, curveHeight)];
       [newPath lineToPoint:General/NSMakePoint(400.0f, 400.0f)];
       [newPath lineToPoint:General/NSMakePoint(300.0f, 400.0f)];
       curveWidth = -100.0f - fmod(random(), 200.0f);
       curveHeight = -100.0f - fmod(random(), 200.0f);
       [newPath relativeCurveToPoint:General/NSMakePoint(curveWidth, curveHeight) controlPoint1:General/NSMakePoint(curveWidth, 0.0f) controlPoint2:General/NSMakePoint(0.0f, curveHeight)];
       [newPath closePath];
       [self setBezierPath:newPath]; 
    }
    return self;
}

- (void)dealloc
{
   [self setBezierPath: nil];
   [super dealloc];
}

- (void)windowControllerDidLoadNib:(General/NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    
   // Swap out the IB genertade text view's text container for our custom container
   General/NSAssert(nil != textView, @"Failed to connect textView in IB");
   General/MyBezierTextContainer  *textContainer = General/[[[MyBezierTextContainer alloc] initWithContainerSize:[textView bounds].size] autorelease];
   
   [textContainer setPathSource:self];
   [textContainer setWidthTracksTextView:YES];
   General/textView layoutManager] addTextContainer:textContainer];
   while(1 < [[[textView layoutManager] textContainers] count])
   {
      [[textView layoutManager] removeTextContainerAtIndex:0];
   }
   
   [textView replaceTextContainer:textContainer];
   
   if([textView respondsToSelector:@selector(setPathSource:)])
   {
      [(id)textView setPathSource:self];
   }
}

- ([[NSBezierPath *)bezierPath
{
   return bezierPath; 
}

- (void)setBezierPath:(General/NSBezierPath *)aBezierPath
{
   [aBezierPath retain];
   [bezierPath release];
   bezierPath = aBezierPath;
}

- (General/NSBezierPath *)closedBezierPathForTextContainer:(id)aContainer
{
   return [self bezierPath];
}

@end


If you want to be able to see the path in which the text flows, use the following simple subclass of General/NSTextView instead of the base General/NSTextView class:
*General/MyBezierTextView.h*
    
@interface General/MyBezierTextView : General/NSTextView 
{
   id          pathSource;
}

- (id)pathSource;
- (void)setPathSource:(id)aPathSource;

@end


*General/MyBezierTextView.m*
    
#import "General/MyBezierTextView.h"


@interface General/NSObject (General/MyBezierTextContainerPathSource)

- (General/NSBezierPath *)closedBezierPathForTextContainer:(id)aContainer;

@end


@implementation General/MyBezierTextView

- (void)dealloc
{
   [self setPathSource: nil];
   [super dealloc];
}

- (id)pathSource
{
   return pathSource; 
}

- (void)setPathSource:(id)aPathSource
{
   [aPathSource retain];
   [pathSource release];
   pathSource = aPathSource;
}

- (void)drawRect:(General/NSRect)rect 
{
   [super drawRect:rect];
   General/[[NSColor blackColor] set];
   General/[self pathSource] closedBezierPathForTextContainer:self] stroke];
   [[[[NSColor grayColor] set];
   General/NSFrameRect([[[self pathSource] closedBezierPathForTextContainer:self] bounds]);
}

@end
