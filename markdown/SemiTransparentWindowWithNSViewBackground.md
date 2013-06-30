

Hi,

I am trying to get a semi-transparent borderless window (which I intend to use as an inspector-type panel).

I started with Apple's "General/RoundTransparentWindow" sample, which uses an General/NSBorderlessWindowMask, and draws a ready-made image in a view inside the window via [pentaImage compositeToPoint:General/NSZeroPoint operation:General/NSCompositeSourceOver]; in the view's drawRect: method.

This image then effectively becomes the body of the window. (I'm sure a lot of people are already familiar with the General/RoundTransparentWindow sample).

This provided a good starting point for me, but my window is resizeable (code I have implemented myself) and so, using a static .png file to create the backround outline/body of the window is not feasible. Instead of compositing an General/NSImage in the General/NSView then, I simply tried to draw my window body using standard Cocoa drawing calls inside drawRect (stroking and filling General/NSBezierPaths). This works, and the Window resizes properly and everything is good.

The issue however is that when I place standard aqua components on top of this view (to add some controls to my inspector window) they do not redraw properly when used, drawing transparent surrounds around each component as they are dragged/interacted with. The image shows an General/NSSlider that has been dragged:

http://img84.imageshack.us/my.php?image=picture1iq5.png

Now, I believe this is because both the General/NSView under the component, and the General/NSWindow (borderless) under that both return NO on isOpaque, which the component takes to mean "ah - I don't have to bother about compositing what's underneath me properly because they're not visible anyway". At least, that's my guess.

I have endlessly tried fiddling with the isOpaque methods etc. no joy.

This behaviour is not exhibited when drawing an General/NSImage to the view via compositeToPoint:..., but it does show up when drawing in the view directly - is there some compositing setting that I can tweak for my General/NSView drawing?

Of course, when the window is resized again, and the General/NSView is forced to redraw, everything gets corrected, but I don't want to add a [bgView display] call every time one of the components in the window is used.

I would very gratefully receive any advice or pointers to further info on this, I have read the transparent window pages here on General/CocoaDev, and also looked through the Quartz drawing docs, but no joy.

Thanks for reading!

----
Not sure what setting you could tweak, but you could achieve the resizing you want by using images. If you create 4 images, one for each corner of your window. Then a square image for the titlebar. So 20x20 or 16x16, however tall your titlebar is. First composite the 4 corners in your General/NSView, then resize and composite the titlebar square image according to how large the window is minus your corner image lengths. After that, you can create fill two rectangles of your background colour to fill in the empty space. One will be the length of your window and the height will be the height minues your two corner image lengths. The second rectangle will be the same size as your titlebar image after being resized. Make sense? :D

This code will do what you want.
    
-(void)drawRect:(General/NSRect)rect
{
    //Louis Klaassen, 2006
	
	//All of our window interface images MUST BE 20x20
	//If not, then change all the values that = 20 to the width of your interface images, and change all the values that = 40 to double your interface images width
	//Interface images must be square, 20x20, 21x21, 35x35, 40x40, etc.....
	
	//First we'll clear what we've got already
    General/[[NSColor clearColor] set];
    General/NSRectFill([self frame]);
	
	//Open our eyes to what we've got to draw in
	General/NSRect window = [self frame];
	
	//Do our corners first
	General/[[NSImage imageNamed:@"bottomLeftCorner"] compositeToPoint:General/NSMakePoint(0,0) operation:General/NSCompositeSourceOver];
	General/[[NSImage imageNamed:@"bottomRightCorner"] compositeToPoint:General/NSMakePoint(window.size.width-20,0) operation:General/NSCompositeSourceOver];
	General/[[NSImage imageNamed:@"topLeftCorner"] compositeToPoint:General/NSMakePoint(0,window.size.height-20) operation:General/NSCompositeSourceOver];
	General/[[NSImage imageNamed:@"topRightCorner"] compositeToPoint:General/NSMakePoint(window.size.width-20,window.size.height-20) operation:General/NSCompositeSourceOver];
	
	//Allocate our titlebar image
	General/NSImage *titlebarImage = General/[NSImage imageNamed:@"titlebarImage"];
	[titlebarImage setScalesWhenResized:YES];
	[titlebarImage setFlipped:YES];

	//Resize it
	General/NSSize titlebarImageSize;
	titlebarImageSize.height = 20;
	titlebarImageSize.width = window.size.width-40;
	[titlebarImage setSize:titlebarImageSize];
	
	//And set
	[titlebarImage compositeToPoint:General/NSMakePoint(20,window.size.height-20) operation:General/NSCompositeSourceOver];
	
	//Work out our remaining voids and fit them to a rectangle
	//This one is the larger midplane area of the window
	General/NSRect homestretchOne = window;
	homestretchOne.size.height = (homestretchOne.size.height - 40);
	homestretchOne.origin.y = (homestretchOne.origin.y + 20);
	
	//This is the small strip left over at the bottom of the window
	General/NSRect homestretchTwo;
	homestretchTwo.size.height = 20;
	homestretchTwo.size.width = window.size.width-40;
	homestretchTwo.origin.x = 20;
	homestretchTwo.origin.y = 0;
	
	//Fill in our rectangles with a black colour with slight transparency (0.8 alpha)
	General/[[NSColor colorWithCalibratedHue:0 saturation:0 brightness:0 alpha:0.8] set];
    General/NSRectFill(homestretchOne);
	General/NSRectFill(homestretchTwo);
	
	//I hope this code works!
   }
