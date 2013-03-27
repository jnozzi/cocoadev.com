Hello there, I have an General/NSImage I create at run time of an image (http://catsdorule.torpedobird.com/img/blogpix/husky.jpg) all my code works except for one small problem. The Size of the General/NSImage is different then the actual image, running General/NSLog(@"%f",[backgroundImage size].width); shows that the width is 245.759995 when infact it is 1024.

Is there any way to fix this or to get the actual size so I can set it manually?

----

That is the actual size. What's going on is that the image has a high resolution set: 300DPI both ways. This means that a single image pixel doesn't match up with a single screen pixel.

If you want the number of pixels rather than the actual size, get the General/NSBitmapImageRep inside the General/NSImage and then use its     -pixelsWide and -    pixelsHigh methods.

----
Thank you, that worked.


Gentlemen
how should one actually change an image's size: make it 400px or 512px along the long side?
pete

Use -General/[NSImage setSize:newSize];
General/EnglaBenny
Don't forget setScalesIfResized.