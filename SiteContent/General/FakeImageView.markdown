I wrote General/FakeImageView to give me true proportional scaling and a few other features. 

General/FakeImageView.h:
    
#import <General/AppKit/General/AppKit.h>

@interface General/FakeImageView : General/NSView
{
    General/NSImage *_image;
    General/NSColor *_bgColor;
    General/NSImageScaling _scaling;
}
- (void)setImage:(General/NSImage*)image;
- (void)setImageScaling:(General/NSImageScaling)newScaling;
- (void)setBackgroundColor:(General/NSColor*)color;
- (General/NSImage*)image;
- (General/NSColor*)backgroundColor;
- (General/NSImageScaling)imageScaling;
@end


General/FakeImageView.m
    
#import "General/FakeImageView.h"

@implementation General/FakeImageView

- (id)initWithFrame:(General/NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgColor = General/[[NSColor blackColor] retain];
        _scaling = General/NSScaleProportionally;
    }

    return self;
}

- (void)dealloc
{
    [_image release];
	[_bgColor release];
    [super dealloc];
}

- (void) setImage:(General/NSImage*)image
{
    if (_image) {
        [_image autorelease];
        _image = nil;
    }

    _image = [image retain];
    [_image setScalesWhenResized:YES];
    [self setNeedsDisplay:YES];
}

- (General/NSImage*)image
{
    return _image;
}

- (void)setImageScaling:(General/NSImageScaling)newScaling
{
    _scaling = newScaling;
    [self setNeedsDisplay:YES];
}

- (General/NSImageScaling)imageScaling
{
    return _scaling;
}

- (void)setBackgroundColor:(General/NSColor*)color
{
    if (_bgColor) {
        [_bgColor autorelease];
        _bgColor = nil;
    }

    _bgColor = [color retain];
    [self setNeedsDisplay:YES];
}

- (General/NSColor*)backgroundColor
{
    return _bgColor;
}

- (void) drawRect:(General/NSRect)rects
{
    General/NSRect bounds = [self bounds];

    [_bgColor set];
    General/NSRectFill(bounds);
    
    if (_image) {
        General/NSImage *copy = [_image copy];
        General/NSSize size = [copy size];
        float rx, ry, r;
        General/NSPoint pt;

        switch (_scaling) {
            case General/NSScaleProportionally:
                rx = bounds.size.width / size.width;
                ry = bounds.size.height / size.height;
                r = rx < ry ? rx : ry;
                size.width *= r;
                size.height *= r;
                [copy setSize:size];
                break;
            case General/NSScaleToFit:
                size = bounds.size;
                [copy setSize:size];
                break;
            case General/NSScaleNone:
                break;
            default:
                ;
        }

        pt.x = (bounds.size.width - size.width) / 2;
        pt.y = (bounds.size.height - size.height) / 2;
        
        [copy compositeToPoint:pt operation:General/NSCompositeCopy];
        [copy release];
    }
}

@end


When necessary, I create a General/FakeImageView subclass of General/NSView in IB and set image views to that custom class. Maybe it would have been better to subclass General/NSImageView ... but oh well. Your mileage may vary.

-- General/MikeTrent

----
Here is how to add Drag and Drop support to this class (from finder).
Insert this into the init function:


    

    [self registerForDraggedTypes:General/[NSArray arrayWithObject:General/NSFilenamesPboardType]];


Then implement the following methods:
    

- (unsigned int)draggingEntered:(id <General/NSDraggingInfo>)sender {
        if (General/sender draggingPasteboard] availableTypeFromArray:[[[NSArray arrayWithObject:General/NSFilenamesPboardType]]) {
            return General/NSDragOperationCopy;
        }
return General/NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <General/NSDraggingInfo>)sender {
    General/NSPasteboard *pb = [sender draggingPasteboard];
    General/NSString *type = [pb availableTypeFromArray:General/[NSArray arrayWithObject:General/NSFilenamesPboardType]];
    General/NSArray *array = General/pb stringForType:type] propertyList];
    [[NSImage *testImage;
    // Try to make a Image out of first filename on pasteboard:
    if (testImage = General/[[NSImage alloc] initWithContentsOfFile:[array objectAtIndex:0]])
    {
        [testImage release];
        [self setImage:testImage];
        return YES;
    }
    return NO;
}

- (BOOL)prepareForDragOperation:(id <General/NSDraggingInfo>)sender {
    return YES;
}


If you want to implement archiving support for this class change the @Implementation line to look like this:
    
@interface General/FakeImageView : General/NSView <General/NSCoding>

And add the following methods:
    
-(void)encodeWithCoder:(General/NSCoder *)coder
{
[super encodeWithCoder:coder];
[coder encodeObject:_image];
[coder encodeObject:_bgColor];
[coder encodeValueOfObjCType:@encode(General/NSImageScaling) at:&_scaling];

}

-(id)initWithCoder:(General/NSCoder *)coder
{
if (self = [super initWithCoder:coder])
    {
        [self setImage:[coder decodeObject]];
        [self setBackgroundColor:[coder decodeObject]];
        [coder decodeValueOfObjCType:@encode(General/NSImageScaling) at:&_scaling];

    }
return self;
}


Any optimizations encouraged :)

Also I suggest replacing General/NSRectFill(bounds); with General/[NSBezierPath fillRect: [self bounds]]; because the latter allows you to set background to clearColor.

General/GormanChristian

----
Some suggestions to clean up the mutator calls a bit: http://goo.gl/General/OeSCu
    
- (void) setImage:(General/NSImage*)image
{
    General/NSImage *temp = [image retain];

    [_image release];
    _image = temp;
    [_image setScalesWhenResized:YES];
    [self setNeedsDisplay:YES];
}

- (void)setBackgroundColor:(General/NSColor*)color
{
    General/NSColor *temp = [color retain];

    [_bgColor release];
    _bgColor = temp;
    [self setNeedsDisplay:YES];
}


Saves you a few autorelease pool dependencies which could make debugging trickier (I hate it when something crashes outside of the event loop because of an autorelease mistake).  It also makes the code a little cleaner.

Also, a bit of a technicality, but there should probably be a super call in the drawRect: method.  Since the background is being redrawn by this code it might not matter but it is always nice in case the General/NSView implementation in the future wants to do something else.

Almost forgot that this will require that you set _image to nil in the initWithFrame: method (and the initWithCoder: if you are using that).

Someone else can insert these modifications in place if they want to but I didn't want to step on any toes in case you guys had some reason for doing it this way.

-Jeff.

----

Here is some code to allow the use of the rest of the image drag and drop destination functionality.  I haven't tested it all myself since I don't have any pict or eps on my drive but it should work.

Firstly, the initWithFrame:
    
- (id)initWithFrame:(General/NSRect)frame
{
    self = [super initWithFrame:frame];
    if (nil != self)
    {
        _bgColor = General/[[NSColor blackColor] retain];
        _scaling = General/NSScaleProportionally;
        _image = nil;
        [self registerForDraggedTypes:General/[NSArray arrayWithObjects:General/NSPostScriptPboardType,
                                                       General/NSPICTPboardType, General/NSPDFPboardType,
                                                       General/NSFileContentsPboardType, General/NSTIFFPboardType,
                                                       General/NSFilenamesPboardType, nil]];
    }
    return self;
}


Then the performDragOperation:
    
- (BOOL)performDragOperation:(id <General/NSDraggingInfo>)sender
{
    General/NSPasteboard *paste = [sender draggingPasteboard];
    General/NSArray *types = General/[NSArray arrayWithObjects: General/NSPostScriptPboardType, General/NSPICTPboardType,
                                                General/NSPDFPboardType, General/NSFileContentsPboardType,
                                                General/NSTIFFPboardType, General/NSFilenamesPboardType, nil];
    General/NSString *desiredType = [paste availableTypeFromArray:types];
    General/NSImage *newImage = nil;

    if ([desiredType isEqualToString:General/NSFilenamesPboardType])
    {
        General/NSArray *fileArray = [paste propertyListForType:@"General/NSFilenamesPboardType"];
        General/NSString *path = [fileArray objectAtIndex:0];
        newImage = General/[[NSImage alloc] initWithContentsOfFile:path];
    
        if (nil == newImage)
        {
            //complain since it failed (panel or something)
            return NO;
        }
    }
    else
    {
        General/NSData *carriedData = [paste dataForType:desiredType];

        if (nil == carriedData)
        {
            //data was invalid so complain
            return NO;
        }
        else
        {
        newImage = General/[[NSImage alloc] initWithData:carriedData];
            if (nil == newImage)
            {
                return NO;
            }
        }
    }
    [self setImage:newImage];
    [newImage release];    
    [self setNeedsDisplay:YES];    //redraw us with the new image
    return YES;
}


That should work.  More information on Drag and Drop Destinations can be found in this tutorial:
http://cocoadevcentral.com/articles/000056.php

-Jeff.

----
See also: General/NSImageViewIsJustKidding

----

Why doesn't this page wrap properly (in mozilla)?

Because of the HTML preformatted text tag. It doesn't wrap. We're (sort of) working on it... -- General/RobRix

Easiest way to fix that is to manually wrap the long line ... -- General/SimonWoodside

Did it. -- General/UliKusterer

----

*Wouldn't it be more efficient to apply an General/NSAffineTransform to the view rather than copy the whole image?*

You tell me. Implement the change, measure its performance, and post the results. -- General/MikeTrent

----

I didn't make the suggestion, but I implemented image scaling and translation (user dragging the image around the view) with General/NSAffineTransform and it's incredibly fast.  I don't have hard numbers, but I was able to update the image so quickly I could see screen tearing when dragging the image around the view. On my dual 2.0, both processors were hovering round 25-30% while dragging continuously using General/NSAffineTransform as opposed to 50-60% for the copy.

I actually had to slow it down and only '[self setNeedsDisplay: YES];' every _other_ call to mouseDragged, it was too fast.

----

Visible screen-tearing doesn't tell you much about the code's speed - in fact it could indicate the redraw is slow. All it means is that the video scan overtook the redraw of the graphic in question. If that graphic moved a noticeable distance between one repaint and the next, it will look torn. So the amount of tearing can be related to the speed at which you move the mouse! In fact if the graphics are updating very fast, the amount that the mouse can have moved between frames will be less, so the tearing will be less - therefore noticeable tearing = slow updates. The fact is this isn't a reliable indicator of performance. The only way to know for sure is to profile the two approaches under identical conditions (which probably means driving the motion automatically rather than manual mouse dragging). 
----

if you want the same apearance as with General/NSImageView, use General/NSCompositeSourceOver instead of General/NSCompositeCopy

----

I think this would be better as a category. Maybe modify the first category on the General/NSImageCategory page so that it can do either type of scaling. Then you could use a normal General/NSImageView for display and that first category would actually be useful.

*I figured since I suggested it I might as well just do it. You can always revert General/NSImageCategory if it's not ok to borrow. :)*