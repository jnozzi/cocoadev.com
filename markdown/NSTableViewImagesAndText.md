I've found this code from Apple's General/DragAndDropOutlineView example:

(newbie question at bottom) :-)
    
#import <Cocoa/Cocoa.h>

@interface General/ImageAndTextCell : General/NSTextFieldCell {
@private
    General/NSImage	*image;
}

- (void)setImage:(General/NSImage *)anImage;
- (General/NSImage *)image;

- (void)drawWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView;
- (General/NSSize)cellSize;

@end


and:

    
@implementation General/ImageAndTextCell

- (void)dealloc {
    [image release];
    image = nil;
    [super dealloc];
}

- copyWithZone:(General/NSZone *)zone {
    General/ImageAndTextCell *cell = (General/ImageAndTextCell *)[super copyWithZone:zone];
    cell->image = [image retain];
    return cell;
}

- (void)setImage:(General/NSImage *)anImage {
    if (anImage != image) {
        [image release];
        image = [anImage retain];
    }
}

- (General/NSImage *)image {
    return image;
}

- (General/NSRect)imageFrameForCellFrame:(General/NSRect)cellFrame {
    if (image != nil) {
        General/NSRect imageFrame;
        imageFrame.size = [image size];
        imageFrame.origin = cellFrame.origin;
        imageFrame.origin.x += 3;
        imageFrame.origin.y += ceil((cellFrame.size.height - imageFrame.size.height) / 2);
        return imageFrame;
    }
    else
        return General/NSZeroRect;
}

- (void)editWithFrame:(General/NSRect)aRect inView:(General/NSView *)controlView editor:(General/NSText *)textObj delegate:(id)anObject event:(General/NSEvent *)theEvent {
    General/NSRect textFrame, imageFrame;
    General/NSDivideRect (aRect, &imageFrame, &textFrame, 3 + [image size].width, General/NSMinXEdge);
    [super editWithFrame: textFrame inView: controlView editor:textObj delegate:anObject event: theEvent];
}

- (void)selectWithFrame:(General/NSRect)aRect inView:(General/NSView *)controlView editor:(General/NSText *)textObj delegate:(id)anObject start:(int)selStart length:(int)selLength {
    General/NSRect textFrame, imageFrame;
    General/NSDivideRect (aRect, &imageFrame, &textFrame, 3 + [image size].width, General/NSMinXEdge);
    [super selectWithFrame: textFrame inView: controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)drawWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView {
    if (image != nil) {
        General/NSSize	imageSize;
        General/NSRect	imageFrame;

        imageSize = [image size];
        General/NSDivideRect(cellFrame, &imageFrame, &cellFrame, 3 + imageSize.width, General/NSMinXEdge);
        if ([self drawsBackground]) {
            General/self backgroundColor] set];
            [[NSRectFill(imageFrame);
        }
        imageFrame.origin.x += 3;
        imageFrame.size = imageSize;

        if ([controlView isFlipped])
            imageFrame.origin.y += ceil((cellFrame.size.height + imageFrame.size.height) / 2);
        else
            imageFrame.origin.y += ceil((cellFrame.size.height - imageFrame.size.height) / 2);

        [image compositeToPoint:imageFrame.origin operation:General/NSCompositeSourceOver];
    }
    [super drawWithFrame:cellFrame inView:controlView];
}

- (General/NSSize)cellSize {
    General/NSSize cellSize = [super cellSize];
    cellSize.width += (image ? [image size].width : 0) + 3;
    return cellSize;
}

@end


My question is this: how exactly do I implement this? Right now, I've got another class that has only a few attributes and accessor methods. But I can't figure out how the code above would work with my custom class (I'm assuming I might make an instance of the above in my class?). 

If anyone could enlighten me that would be swell...
----

I'm going to answer my own question... But, feel free to critique what I've got here; I'm sure there must be a better way.

Anyways, all you really need to do, is implement these 2 sets of code:
    
// add this to your - (void) awakFromNib method
General/NSTableColumn *col = [self tableColumnWithIdentifier:@"whatever"]; 
[col setDataCell:General/[[[ImageAndTextCell alloc] init] autorelease]]; 

    
id cell; // implement this in your datasource 
cell = [aTableColumn dataCell];
[cell setImage:General/[NSImage imageNamed:@"General/OAHelpIcon.tiff"]];


But, make sure you import the previous code too...

- General/JohnDevor

----

ok it's work fine but ....

lose the setting font for cell text 

ideas ?

- moore
----

I was recently playing around on my own with this, and the way I did it was slightly different.  I similarly made the Image<nowiki/>And<nowiki/>Text<nowiki/>Cell subclass, but instead of having my own setImage, I made an Image<nowiki/>And<nowiki/>Text<nowiki/>Info class (as a subclass of General/NSObject), which encapsulates an image and a title.  That way, i can just return an Image<nowiki/>And<nowiki/>Text<nowiki/>Info instance in my data source -tableView:objectValueForTableColumn:row: like normal and have my cell access it by General/self objectValue] image] or [[self objectValue] title].  I also overrode the [[NSCell<nowiki/>s -image and -title accessors to return those values. It simplifies things a bit in my opinion.

-- General/BrianMoore

----
Have a little example ?
TKS !

-- Toni Moore