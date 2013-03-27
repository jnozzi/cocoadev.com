


    
- (void)drawString:(General/NSString *)string inRect:(General/NSRect)rect {

    static General/NSDictionary *att = nil;
    if (!att) {
        General/NSMutableParagraphStyle *style = General/[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:General/NSLineBreakByWordWrapping];
        [style setAlignment:General/NSCenterTextAlignment];
        att = General/[[NSDictionary alloc] initWithObjectsAndKeys:
                            style, General/NSParagraphStyleAttributeName, 
                            General/[NSColor whiteColor], General/NSForegroundColorAttributeName, nil];
        [style release];
    }
    [string drawInRect:rect withAttributes:att];

}



--zootbobbalu