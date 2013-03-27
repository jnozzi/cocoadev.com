Hello, how would I go about putting a General/ColorWell in a General/TableView column? Do I need to subclass General/NSActionCell somehow? Thanks allot for any help you can provide!

----

Yes I guess you would have to subclass General/NSActionCell and create your own color well cell since General/NSColorWell is one of the few General/NSControl classes that does not use a cell for it's internal workings. 

It would be nice if someone could post a tutorial (or a link to one) on creating your own controls with a cell counterpart (ideally complete with a IB-palette). I just get confused by all the methods in the relevant classes that I don't really know where to begin.I can make it work but don't really know how to make it work the way it should work... -Gabbe

Well, tell us how you've done it and we'll comment and eventually refactor down to a tutorial. It's the spirit of Wiki! -- General/KritTer

----

Here is how I have done this:
    

@interface General/MyColorCell : General/NSCell
@end

@implementation General/MyColorCell

// Draw the rectangle:
- (void)drawInteriorWithFrame:(General/NSRect)inCellFrame
                       inView:(General/NSView *)inControlView
{
    General/NSGraphicsContext *currentContext
            = General/[NSGraphicsContext currentContext];
    [(General/NSColor*)[self representedObject] set];
    --inCellFrame.size.height;
    ::General/CGContextFillRect((General/CGContextRef)[currentContext graphicsPort],
                        *((General/CGRect*) &inCellFrame));
}

@end

- (void)awakeFromNib
{
    // Set the color column:
    General/MyColorCell *colorCell = General/[[MyColorCell allocWithZone:NULL]
                                  initImageCell:nil];
    General/mTableView tableColumnWithIdentifier:kColorColumnIdentifier_]
            setDataCell:colorCell];
    [colorCell release];
}

// Nice and simple. Neo

Yeah, I guess we could now comment and refactor :)

Although staring at it, I'm impressed by its author. How **does** it work?

-- [[KritTer

Whoa. Where's the cell's represented object getting set? I assume that must be done externally... I figure if you're creating a new cell anyhow, you might as well make the colour be an ivar and leave -representedObject in General/ClientSpace like it's supposed to be.

-- General/RobRix

I have a basic implementation of a General/ColorWellCell here: http://github.com/lakshmivyas/lvcolorwellcell

--Lakshmi Vyas