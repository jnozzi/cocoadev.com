

I am looking to create (or find an existing) General/NSTextField subclass that shows the indented look (for metal windows).  I know this can be achieved by creating a duplicate of the text one pixel underneath it in pure white, but there must be a more efficient way than using two General/NSTextFields every time I want to put text on a metal window!  Should the General/NSTextField spawn another one below it with the white color, or what?  Any pointer in the right direction would be excellent.

----


Just subclass General/NSTextField and draw the field's (cell's) string value twice - first white then black. Here's what I hacked up a while back (it's messy - not to mention inefficient - but gets the job done):

    
@implementation General/EmbossedTextField

- (void)drawRect:(General/NSRect)rect {
    General/NSPoint basePoint = [self bounds].origin;
    General/NSPoint whitePoint = basePoint;
    whitePoint.y++;
    
    General/NSMutableAttributedString *whiteString = General/self attributedStringValue] mutableCopy];
    [[NSColor *whiteColor = General/[NSColor colorWithCalibratedWhite:1.0 alpha:0.7];
    
    [whiteString addAttribute:General/NSForegroundColorAttributeName value:whiteColor range:General/NSMakeRange(0, [whiteString length])];
    [whiteString drawAtPoint:whitePoint];
    [whiteString release];
    
    General/self attributedStringValue] drawAtPoint:basePoint];
}

@end


----

This seems good, but it does not account for wrapped text.  Any ideas?  Thanks.

----

[[AMRolloverButton in General/ObjectLibrary does something similar to what you want, I believe