I'm trying to get an General/NSImageView to resize itself to fit the graphical content inside it. I can't think of any way to do this without writing a method to generate an General/NSRect from the dimensions of the graphic, and I would really like to avoid going through something like that if there is already a good solution. If you happen to have a thought on this subject, please add it below. If you are sure nothing like this exists, I'll be happy to write it up and add it in, but please let me know.

-- General/QetiPadgu

----

I wonder if the original poster will see this since he posted it 6 months ago!!

    
+ (General/NSRect)centeredFrameForBounds:(General/NSRect)bounds imageSize:(General/NSSize)imageSize {
    float viewRatio = General/NSWidth(bounds) / General/NSHeight(bounds);
    float ratio = imageSize.width / imageSize.height;
    float dx = 0.0f, dy = 0.0f;
    if (viewRatio > ratio) dx = (General/NSWidth(bounds) - General/NSHeight(bounds) * ratio) / 2.0f;
    else dy = (General/NSHeight(bounds) - General/NSWidth(bounds) / ratio) / 2.0f;
    return General/NSInsetRect(bounds, dx, dy);
}


I looked around for this function too, but I couldn't find one. Since I saw this page I thought I would put my solution here.  --zootbobbalu