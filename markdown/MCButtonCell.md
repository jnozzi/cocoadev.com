For explaination and sample use see: General/ClickThroughButtonInTableView

    


//  2005 by St�phane BARON - General/MacAvocat .
//  Derivated from work by Erik Doernenburg
//  Derivated from work by Omnigroup
//  Derivated from work by Eric Petit
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
 
#import <Cocoa/Cocoa.h>

@interface General/MCButtonCell : General/NSActionCell { 
	
	General/NSRect imageRect;
	General/NSMutableDictionary *theAttributes;
	General/NSImage *currentImage;
	General/NSImage *image;
	General/NSImage *alternateImage;
//	General/NSImage *rolloverImage;
	
}

-(General/NSImage *)image;
-(void)setImage:(General/NSImage *)anImage;
-(General/NSImage *)alternateImage;
-(void)setAlternateImage:(General/NSImage *)anImage;
//-(General/NSImage *)rolloverImage;
//-(void)setRolloverImage:(General/NSImage *)anImage;
-(General/NSImage *)currentImage;
-(void)setCurrentImage:(General/NSImage *)anImage;
-(BOOL)isPointInImageRect:(General/NSPoint)location forCell:(General/NSRect)cellFrame;
- (void) mouseDown: (General/NSEvent *)theEvent;
- (void) mouseUp: (General/NSEvent *)theEvent;


@end


#import "General/MCButtonCell.h"

#define TEXT_VERTICAL_OFFSET (-1.0)
#define FLIP_VERTICAL_OFFSET (-9.0)
#define BORDER_BETWEEN_EDGE_AND_IMAGE (3.0)
#define BORDER_BETWEEN_IMAGE_AND_TEXT (3.0)
#define SIZE_OF_TEXT_FIELD_BORDER (1.0)

static General/NSMutableParagraphStyle *General/MCTParagraphStyle = nil;
General/NSString *General/MCTStringKey = @"string";

@implementation General/MCButtonCell



-(id)init
{
	
    if ([super initTextCell:@""] == nil)
        return nil;
	return self;
	
}

-(void)awakeFromNib;
{
	
	[self setCurrentImage:image];
	
}

-(BOOL)isPointInImageRect:(General/NSPoint)location forCell:(General/NSRect)cellFrame;
{
	General/NSSize theSize=[currentImage size];
	if((location.x>theSize.width+cellFrame.origin.x) || (location.x<BORDER_BETWEEN_EDGE_AND_IMAGE+cellFrame.origin.x))
	{
		return NO;
	}
	else
		return YES;
}


-(General/NSSize)imageSize;
{
return [currentImage size];
}

-(General/NSImage *)image;
{
	return image;
}

-(void)setImage:(General/NSImage *)anImage;
{
    if (anImage == image)
        return;
    [image release];
    image = [anImage retain];
}

-(General/NSImage *)currentImage;
{
return currentImage;
}

-(void)setCurrentImage:(General/NSImage *)anImage;
{
    if (anImage == currentImage)
        return;
    [currentImage release];
    currentImage = [anImage retain];
}

-(General/NSImage *)alternateImage;
{
return alternateImage;
}

-(void)setAlternateImage:(General/NSImage *)anImage;
{
    if (anImage == alternateImage)
        return;
    [alternateImage release];
    alternateImage = [anImage retain];
}

- (void)setControlView:(General/NSView*)view
{
[super controlView];
}

- (void)drawInteriorWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView
{

if(currentImage==nil)
{
[self setCurrentImage:image];
}


	General/NSPoint        point;
	General/NSSize        size;
	General/NSPoint        origin;	
	origin = cellFrame.origin;
	imageRect=General/NSMakeRect(origin.x+BORDER_BETWEEN_EDGE_AND_IMAGE,origin.y,[currentImage size].width,[currentImage size].height);
	General/NSRect textRect=General/NSMakeRect(origin.x+[currentImage size].width+BORDER_BETWEEN_EDGE_AND_IMAGE+BORDER_BETWEEN_IMAGE_AND_TEXT,origin.y,cellFrame.size.width-([currentImage size].width+BORDER_BETWEEN_EDGE_AND_IMAGE+BORDER_BETWEEN_IMAGE_AND_TEXT),cellFrame.size.height);

    textRect = General/NSInsetRect(textRect, 1.0, 0.0);

    if (![controlView isFlipped])
        textRect.origin.y -= (textRect.size.height + FLIP_VERTICAL_OFFSET);


	if (currentImage != nil)
       {
       size = [currentImage size];
       point.x = origin.x+BORDER_BETWEEN_EDGE_AND_IMAGE;
       point.y = origin.y+size.height+((cellFrame.size.height-size.height)/2);
       [currentImage compositeToPoint: point operation:  General/NSCompositeSourceOver];
       point.x = point.x + size.width;
       }
   else
       {
       point.x = origin.x;
       }
   point.y = origin.y;


	General/NSMutableAttributedString *label = General/[[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringValue]];
    General/NSRange labelRange = General/NSMakeRange(0, [label length]);
    if (General/[NSColor respondsToSelector:@selector(alternateSelectedControlColor)]) 
	{
        General/NSColor *highlightColor = [self highlightColorWithFrame:cellFrame inView:controlView];
        BOOL highlighted = [self isHighlighted];

        if (highlighted && [highlightColor isEqual:General/[NSColor alternateSelectedControlColor]]) 
		{
            [label addAttribute:General/NSForegroundColorAttributeName value:General/[NSColor alternateSelectedControlTextColor] range:labelRange];
        }
    }

    [label addAttribute:General/NSParagraphStyleAttributeName value:General/MCTParagraphStyle range:labelRange];
    [label drawInRect:textRect];
    [label release];

}


- (void)setObjectValue:(id <General/NSObject, General/NSCopying>)obj;
{

    if ([obj isKindOfClass:General/[NSString class]] || [obj isKindOfClass:General/[NSAttributedString class]]) {
        [super setObjectValue:obj];
        return;
    } else if ([obj isKindOfClass:General/[NSDictionary class]]) {
        General/NSDictionary *dictionary = (General/NSDictionary *)obj;
        
        [super setObjectValue:[dictionary objectForKey:General/MCTStringKey]];
    }

}


- (void) mouseDown: (General/NSEvent *)theEvent;
{
[self setCurrentImage:alternateImage];
}

- (void) mouseUp: (General/NSEvent *)theEvent
{
[self setCurrentImage:image];
}

+ (void)initialize;
{
	General/MCTParagraphStyle = General/[[NSMutableParagraphStyle alloc] init];
    General/[MCTParagraphStyle setLineBreakMode:General/NSLineBreakByTruncatingTail];
}
@end


