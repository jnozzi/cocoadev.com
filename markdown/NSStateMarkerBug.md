_NSStateMarker is something that I didn't even know existed until recently, and I still don't know what it does, but it's causing a weird bug in my app.
From Google searches, I've found that the class points out selection information for General/NSArrayControllers.
I modified the General/GraphicBindings example by mmalc to work as a Keynote-like slide editor, and I've bound objects and colors to each slide. For example, I just copied the existing methods for binding my General/NSColor value to the General/NSView subclass:

    
- (General/NSObject *)colorContainer
{
    return colorContainer; 
}
- (void)setColorContainer:(General/NSObject *)aColorContainer
{
    if (colorContainer != aColorContainer) {
        [colorContainer release];
        colorContainer = [aColorContainer retain];
    }
}

- (General/NSString *)colorKeyPath
{
    return colorKeyPath; 
}
- (void)setColorKeyPath:(General/NSString *)aColorKeyPath
{
    if (colorKeyPath != aColorKeyPath) {
        [colorKeyPath release];
        colorKeyPath = [aColorKeyPath copy];
    }
}

- (void)bind:(General/NSString *)bindingName
	toObject:(id)observableObject
 withKeyPath:(General/NSString *)observableKeyPath
	 options:(General/NSMutableDictionary *)options
{
	//General/NSLog(@"binding %@", bindingName);
    if ([bindingName isEqualToString:@"graphics"])
	{
		
		[self setGraphicsContainer:observableObject];
		[self setGraphicsKeyPath:observableKeyPath];
		[graphicsContainer addObserver:self
							forKeyPath:graphicsKeyPath
							   options:(General/NSKeyValueObservingOptionNew |
										General/NSKeyValueObservingOptionOld)
							   context:General/GraphicsObservationContext];
		[self startObservingGraphics:[graphicsContainer valueForKeyPath:graphicsKeyPath]];
		
    }
	else if ([bindingName isEqualToString:@"selectionIndexes"])
	{
		[self setSelectionIndexesContainer:observableObject];
		[self setSelectionIndexesKeyPath:observableKeyPath];
		[selectionIndexesContainer addObserver:self
									forKeyPath:selectionIndexesKeyPath
									   options:nil
									   context:General/SelectionIndexesObservationContext];
    }
	else if ([bindingName isEqualToString:@"background"])
	{
		[self setBackgroundContainer:observableObject];
		[self setBackgroundKeyPath:observableKeyPath];
		[backgroundContainer addObserver:self
									forKeyPath:backgroundKeyPath
									   options:nil
									   context:General/BackgroundObservationContext];
    }
	else if ([bindingName isEqualToString:@"backgroundScaling"])
	{
		[self setBackgroundScalingContainer:observableObject];
		[self setBackgroundScalingKeyPath:observableKeyPath];
		[backgroundScalingContainer addObserver:self
							  forKeyPath:backgroundScalingKeyPath
								 options:nil
								 context:General/BackgroundScalingObservationContext];
    }
	else if ([bindingName isEqualToString:@"color"])
	{
		[self setColorContainer:observableObject];
		[self setColorKeyPath:observableKeyPath];
		[colorContainer addObserver:self
									forKeyPath:colorKeyPath
									   options:nil
									   context:General/ColorObservationContext];
    }
	
	[super bind:bindingName
	   toObject:observableObject
	withKeyPath:observableKeyPath
		options:options];
	
    [self setNeedsDisplay:YES];
}



So here's what happens:
everything is fine and dandy until the user goes and clicks on the desktop or another window (taking away the focus from the document and view), and then tries to refocus on the application (thus calling my view's displayRect: method). At that point, my drawing code calls General/self color] set], but that no longer returns the [[NSColor, but instead returns a copy of General/NSStateMarker. That brings my app's drawing to a grinding halt until I figured out that I must change the selection in the General/NSArrayController (by clicking on the table view). After doing that, it is able to draw again... until I click outside of that document window again. Why would the General/NSArrayController lose the selected object when I click outside of the window? or, is there some way that I can get useful information out of that General/NSStateMarker for me to figure out what's going on?

----
I don't see any of your drawing code here, nor the implementation of     [self color], wouldn't it be better to actually include the code that's going wrong?

----
Okay, here it is, and very long... don't say I didn't warn you ;)

    

- (void)drawRect:(General/NSRect)rect
{
	
	if (General/self color] isMemberOfClass:[_NSStateMarker class) {
		General/NSLog(@"bindings bug");
		General/self superview] updateSelection];
		//return;
	}
	if ([[self background] isMemberOfClass:[_NSStateMarker class) {
		General/NSLog(@"bindings bug");
		General/self superview] updateSelection];
		//return;
	}
	
	wratio = 800 / [self bounds].size.width;
	hratio = 600 / [self bounds].size.height;
	
	[[NSRect myBounds = [self bounds];
	/*General/NSDrawLightBezel(myBounds,myBounds);
	
	General/NSBezierPath *clipRect =
		General/[NSBezierPath bezierPathWithRect:General/NSInsetRect(myBounds,2.0,2.0)];
	[clipRect addClip];	*/
	
	General/self color] set];
	[[NSRectFill(myBounds);
	
	if (General/self background] previewImage]) {
		float framewidth = [self bounds].size.width;
		float frameheight = myBounds.size.height;
		// Draw the preview image of the background file...
		//[[NSImage * drawImage = General/[[NSImage alloc] initWithSize:rect.size];
		//[drawImage setFlipped:YES];
		//[drawImage lockFocus];
		if ([backgroundScaling isEqualToString:@"Proportional to Fit"]) {
			// make sure the image scales up in proportion until hitting the inner bounds of the slide
			float imagewidth = General/[self background] previewImage] size].width;
			float imageheight = [[[self background] previewImage] size].height;
			float imageRatio = imagewidth / imageheight;
			//[[NSLog(@"image ratio: %f", imageRatio);
			float finalwidth = 50;
			float finalheight = 50;
			
			if (imagewidth > imageheight) {
				// image is wide
				if (framewidth > frameheight) {
					finalwidth = framewidth;
					finalheight = finalwidth / imageRatio;
				}
			} else if (imageheight > imagewidth) {
				// image is tall
				if (framewidth > frameheight) {
					finalheight = frameheight;
					finalwidth = finalheight * imageRatio;
				}				
			} else {
				// image is square or something...
				if (framewidth > frameheight) {
					finalheight = frameheight;
					finalwidth = finalheight * imageRatio;
				}				
			}
			
			float xmidpoint = (framewidth / 2) - (finalwidth / 2);
			float ymidpoint = (frameheight / 2) - (finalheight / 2);
			
			General/[self background] previewImage] drawInRect:[[NSMakeRect(xmidpoint,ymidpoint,finalwidth,finalheight) fromRect:General/NSMakeRect(0,0,General/[self background] previewImage] size].width,[[[self background] previewImage] size].height) operation:[[NSCompositeSourceOver fraction:1.0];
			
		} else if ([backgroundScaling isEqualToString:@"Stretch to Fit"]) {
			// stretch/distort the image to fit the bounds of the slide
			General/[self background] previewImage] drawInRect:[[NSMakeRect(0,0,rect.size.width,rect.size.height) fromRect:General/NSMakeRect(0,0,General/[self background] previewImage] size].width,[[[self background] previewImage] size].height) operation:[[NSCompositeSourceOver fraction:1.0];
		} else if ([backgroundScaling isEqualToString:@"Actual Size"]) {
			// show the image at its original pixel size in the slide
			int width = General/[self background] previewImage] size].width;
			int height = [[[self background] previewImage] size].height;
			float xmidpoint = (rect.size.width / 2) - (width / 2);
			float ymidpoint = (rect.size.height / 2) - (height / 2);
			
			[[[self background] previewImage] drawInRect:[[NSMakeRect(xmidpoint,ymidpoint,width,height) fromRect:General/NSMakeRect(0,0,width,height) operation:General/NSCompositeSourceOver fraction:1.0];
		}
		
		//[drawImage unlockFocus];
		//[drawImage drawInRect:rect fromRect:General/NSMakeRect(0,0,rect.size.width,rect.size.height) operation:General/NSCompositeSourceOver fraction:1.0];
	}
	
	// draw "intersect lines" for mouse...
	//General/NSLog(@"drawing");
	General/NSRect horizontalLine = General/NSMakeRect(0.0,mousePoint.y,[self bounds].size.width,1.0);
	General/NSRect verticalLine = General/NSMakeRect(mousePoint.x,0.0,1.0,[self bounds].size.height);
	/*if (!dragging) {
		General/[[NSColor lightGrayColor] set];
		General/[NSBezierPath fillRect:horizontalLine];
		General/[NSBezierPath fillRect:verticalLine];
	}*/
	
	
	/*
	 Draw graphics
	 */
	General/NSArray *graphicsArray = [self graphics];
	//General/NSLog(@"number of graphics: %d", [graphicsArray count]);
	General/NSEnumerator *graphicsEnumerator = [graphicsArray objectEnumerator];
	// apparently, when i merely declare the protocol on General/NSObject, it doesn't work, so we need to specify "element"...
	element *graphic;
    while (graphic = [graphicsEnumerator nextObject])
	{
		wratio = 800 / [self bounds].size.width;
		hratio = 600 / [self bounds].size.height;
		General/NSRect graphicDrawingBounds = [graphic drawingBounds];
		
		[graphic setWRatio:wratio];
		[graphic setHRatio:hratio];
		[graphic drawInView:self];
    }
	
	
	// filling the dragRect, when dragging...
	
	// color separation courtesy of Wil Shipley...
	// Take the color apart
	General/NSColor *alternateSelectedControlColor = General/[NSColor
		alternateSelectedControlColor];
	float hue, saturation, brightness, alpha;
	General/alternateSelectedControlColor
      colorUsingColorSpaceName:[[NSDeviceRGBColorSpace] getHue:&hue
												  saturation:&saturation brightness:&brightness alpha:&alpha];
	
	// Create synthetic darker and lighter versions
	General/NSColor *lighterColor = General/[NSColor colorWithDeviceHue:hue
											 saturation:MAX(0.0, saturation-.12) brightness:MIN(1.0,
																								brightness+0.30) alpha:0.1];
	General/NSColor *darkerColor = General/[NSColor colorWithDeviceHue:hue
											saturation:MIN(1.0, (saturation > .04) ? saturation+0.12 :
														   0.0) brightness:MAX(0.0, brightness-0.045) alpha:alpha];
	
	[lighterColor set];
	General/[NSBezierPath fillRect:dragRect];
	[darkerColor set];
	General/NSBezierPath * path = General/[NSBezierPath bezierPathWithRect:dragRect];
	[path setLineWidth:0.3];
	[path stroke];
	
	
	
	/*
	 Draw a box around items in the current selection.
	 Selection should be handled by the graphic, but this is a
	 shortcut simply for display.
	 */
	
	General/NSIndexSet *currentSelectionIndexes = [self selectionIndexes];
	if (currentSelectionIndexes != nil)
	{
		General/NSBezierPath *path = General/[NSBezierPath bezierPath];
		unsigned int index = [currentSelectionIndexes firstIndex];
		while (index != General/NSNotFound)
		{
			graphic = [graphicsArray objectAtIndex:index];
			General/NSRect graphicDrawingBounds = [graphic drawingBounds];
			if (General/NSIntersectsRect(rect, graphicDrawingBounds))
			{
				[path appendBezierPathWithRect:graphicDrawingBounds];
			}
			index = [currentSelectionIndexes indexGreaterThanIndex:index];
		}
		
		General/[[NSColor blueColor] set];
		[path setLineWidth:5];
		[path stroke];
		
	}
}



----
I still don't see the implementation for     [self color]. Is it this non-obvious what the important code is, even when it's pointed out?

----
Well, that probably doesn't do much, but okay:

    

- (General/NSColor *)color
{
	return [colorContainer valueForKeyPath:colorKeyPath];
}



... wouldn't it raise an error at this point if the data it recieves isn't the same as what it expects (seeing as how I told it to expect General/NSColor)?

----
*You* know that it doesn't do much. *I* didn't know this until you posted it, and even though it doesn't do much I had no idea what not-much it actually did until you showed the code. You're having trouble solving this problem with the entire app in front of you; imagine how difficult it is for everybody else, seeing only bits of the code. Showing every relevant piece is essential.

The General/NSColor * is purely a compile time construct that is used by the compiler to do some very basic static checking on your code. There are no runtime consequences to assigning an object of one type to a variable of another.

As far as your problem, it's either memory management or somebody is changing the value for that key path. Use General/NSZombieEnabled to search for the former, and see if you can poke around in the debugger and use logging to search for the latter.