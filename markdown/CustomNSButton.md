

**This discussion is mostly about custom General/NSButton *appearance* rather than about subclassing General/NSButton**

*There is also a scheme for a General/ChooseYourOwnPrefix General/ButtonWithThreeStatesAndTwoAlternateImages*

It looks like I have to override General/NSControl�s cellClass method, which means I have to make 4 tif files for my button : normal, selected, pressed and pressed selected (if i want to handle mouseover and mousedown).

I know how to add the tif to the nib, load them with General/NSBundle, but what then?

I decided to subclass General/NSButton but I don't know what is best : subclassing General/NSView, General/NSControl or General/NSButton?

If anybody knows where to find a little sample code for this very popular request, it would be really nice.
In fact such code would definitely have its place on General/CocoaDev! - General/StephaneDassieu

----

Subclass General/NSButton, use     -setImage:(General/NSImage *)image to set the image, use General/NSView methods to handle rollover

----

It is working fine except my button has a 'squared mask' which means when I click on it, a white square is drawn behind my image. As my image is like an Apple circular button (like the General/DownloadReveal button in Safari) it's really annoying. How can I change this? Maybe I need to subclass both General/NSButton and General/NSButtonCell? - Stephane

I tried making it an General/NSToggleButton to remove the white border. -NS �> *but I don't want it to behave as toggle button.. There must be a way to do this properly.*

**Incorrect. Set it to "Momentary Change". This will give you the correct behavior.**

----

Yeah but once again I'll have the white background right?
It looks like the right way to do this is to subclass General/NSActionCell and set it to a General/NSButton subclass.. I started to do this and I already made some progress but it's pretty complicated (at least for me). I would appreciate some help on this (code is coming soon) and anyway, if I manage to do this, I'll post the full code in the tutorial section here because it's really something a lot of persons are trying to do and I couldn't find much info about it on the net. - Stephane

**No, if it's a standard button, there is *no* reason to mess with any of General/NSButton's parts nor even to subclass General/NSButton. The standard General/NSButton class can easily handle this - you just have to tell it when to change its image if you want to support more than the normal and pressed (alternate) images. Are you sure the tif image has the correct alpha mask? I build buttons like this many times in each project ... it's as simple as setImage:myImageForThisState, really. If it's still displaying incorrectly (ie, filling in the transparent areas when pressed), you might want to just try experimenting with a standard button (in Momentary Change mode).**

----

You were right!! It's working really well and it's so simple! I made several mistakes, that's why I thought it wasn't working (the image has an alpha channel but i misstyped the name of the alternate state - plus, the button wasn't on Momentary Change but on Momentary Push In, so it was just inverting my Icon with a horrible white background).

Thanks  - Stephane

**Don't worry about it - I speak with such authority on this subject only because it was a hard-learned lesson for me too. I just couldn't conceive of this being so simple - the General/NSButton class being so flexible out of the box. But I know better now. Rather, I know Cocoa better now. ;-)**

----

Does anyone know how to create buttons like these:

http://homepage.mac.com/meddiecatsoft/popupbutton.gif

http://homepage.mac.com/meddiecatsoft/checkmark.gif

http://homepage.mac.com/meddiecatsoft/regularbutton.gif

Is there code on how to subclass an General/NSButton to make it look like those?

----

Simply override the appropriate drawing methods and draw whatever you want.  This is mostly just a matter of obtaining the images for the buttons, not the actual code? -- or am I missing something?

----

I got the three images for normal and three images for pressed. Here is the code I am doing to composite those images.

    

- (General/NSImage *)getButtonImageWithLeft:(General/NSImage *)leftImage
							  right:(General/NSImage *)rightImage
							 center:(General/NSImage *)centerImage
							 button:(General/NSButton *)theButton
{
	General/NSColor *bgColor = General/[NSColor clearColor];
	General/NSImage *bg = General/[[[NSImage alloc] initWithSize:[theButton frame].size] autorelease];
	
	[bg lockFocus];
	[bgColor set];
	
	General/NSRectFill(General/NSMakeRect(0, 0, [bg size].width, [bg size].height));
	
       [leftImage compositeToPoint:General/NSMakePoint(0, [bg size].height - [leftImage size].height) 
					  operation:General/NSCompositeSourceOver];
       [rightImage compositeToPoint:General/NSMakePoint([bg size].width - [rightImage size].width, 
											 [bg size].height - [rightImage size].height) 
					   operation:General/NSCompositeSourceOver];
	
	General/NSColor *middleColor = General/[NSColor colorWithPatternImage:centerImage];
       [middleColor set];
       General/[[NSGraphicsContext currentContext] setPatternPhase:General/NSMakePoint([bg size].width, [bg size].height)];
       General/NSRectFill(General/NSMakeRect([leftImage size].width, [bg size].height - [leftImage size].height, 
                          [bg size].width - [leftImage size].width - [rightImage size].width, 
                          [leftImage size].height));
	[bg unlockFocus];
	
	return bg;
}



I send the normal images and the pressed images to this method to get composited. When I get the normal image it looks great

This is the unpressed image i get:
http://homepage.mac.com/meddiecatsoft/General/NormalGradient.gif

This is the pressed image:
http://homepage.mac.com/meddiecatsoft/General/PressedGradient.gif

I am using the exact same images everyone else is using to create these buttons, please help

**Rather than using 'patternImage', why don't you just adjust the size of the middle image to stretch from left to right? Remember General/NSImage's setScalesWhenResized: to YES.**

----

Also, it looks like the pressed image is being drawn one pixel lower, although that's not the only problem. Somehow the two outside images have to change (kind of obvious...). --General/JediKnil

----
The outside images did change, they just aren't composited right.  They're darker in the second shot.  Also, I think this is a separate question from the one about image compositing.

----

Can anyone explain to me how to draw a custom button bezel like in the pictures at the top of the page from iTunes? I have subclassed General/NSButton and General/NSButtonCell, and am attempting to draw it but I can't seem to get it to work right. Source code would be appreciated. I don't know what to do next and nowhere seems to have a solid answer to doing this. --General/LoganCollins

----
*Have you implemented drawBezelWithFrame: to do your custom drawing?*
----

Yeah, and It seems to be working alright, I drew my bezel just like I have when drawing other controls, and started looking at drawInteriorWithFrame: for the text of the button. Is there a special way to draw the button's text, or can you just draw it with General/NSString's drawInRect:?

----

I would not expect you to need to override drawInteriorWithFrame: or draw text yourself (though -General/[NSString drawInRect:] would be fine).  If you override -General/[NSCell titleRectForBounds:], you can specify where the title ought to be, and the standard drawInteriorWithFrame: should do all the work.

----

Here is a button cell subclass I have used to do custom button drawing. It only uses one image so it will not answer your compositing questions. I have had one strange problem with subclassing General/NSButton. It will not archive images I set in IB, I end up having to set them in code. If anyone understands why I would love to hear it. Also, this code does not respect text positioning performed in IB. I think the right way to do this is by applying the appropriate General/NSParagraphStyle in attributedTitle. I could not find a lot of documentation on the right way to subclass General/NSButton and I was a little short on time so I stopped once it met my immediate needs.

--General/TKinch

    

@implementation General/AVNRstatusbarButtonCell

- (General/NSAttributedString *)attributedTitle {

	// set default attributes & alignment
	if (!attributedTitle) {

		General/NSFont *smallFont = General/[NSFont controlContentFontOfSize:
			General/[NSFont systemFontSizeForControlSize: General/NSSmallControlSize]];

		General/NSMutableDictionary *attributes = General/[[NSDictionary dictionaryWithObjectsAndKeys:
			smallFont, General/NSFontAttributeName,
			General/[NSColor blackColor] , General/NSForegroundColorAttributeName,
			nil] mutableCopy];

		General/NSMutableParagraphStyle *pStyle = General/[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		
		[pStyle setAlignment: [self alignment]];
		[attributes setValue: pStyle forKey: General/NSParagraphStyleAttributeName];
		[pStyle release];
		[attributes autorelease];
		
		return General/[[[NSAttributedString alloc] initWithString: [self title] attributes: attributes] autorelease];
	}
	
	return attributedTitle;
}

- (void) setAttributedTitle: (General/NSAttributedString *) theAttributedTitle {
    if (attributedTitle != theAttributedTitle) {
        [attributedTitle autorelease];
        attributedTitle = [theAttributedTitle retain];
    }
}

- (void)drawInteriorWithFrame:(General/NSRect)rect inView:(General/NSView *)controlView {

	General/NSImage *backgroundImage = General/[NSImage imageNamed: @"statusbar_background"];

	[backgroundImage setFlipped: YES];
	[backgroundImage setScalesWhenResized: YES];
	[backgroundImage setSize: rect.size];
	[backgroundImage drawInRect: rect fromRect: rect operation: General/NSCompositeSourceOver fraction: 1.0];

	General/self attributedTitle] drawInRect: [self titleRectForBounds: rect;
	
	if ([self image]) {
		General/NSImage *fgImage = [self image];
		[fgImage setFlipped: General/self controlView] isFlipped;
		[fgImage drawInRect: [self imageRectForBounds: rect] fromRect: General/NSZeroRect operation: General/NSCompositeSourceOver fraction:1.0];
	}
}

@end



----

The easiest way to create a custom button appearance when your buttons will have a fixed size, for example the +/- buttons in Spotlight, or the play controls in iTunes and similar:

Create two graphics for the button, one normal state and one pressed state. Make sure your background is transparent and saved with the file, either in TIFF or PNG format. Add these graphics to your project. In Interface Builder, drag an General/NSButton to your window. In the inspector, choose "Rounded Bevel Button" as the button's type, "Momentary Change" as its behaviour, and uncheck the "Bordered" box. Set the "Icon" field to the name of your normal button state graphics (minus the file extension) and set the "Alt. Icon" field to the pressed state graphic. Using the Size section of the inspector, make the button the same dimensions as your graphics.

Test run your window in Interface Builder (cmd-R) and it should work just fine. I find it very convenient that this can be done without a single line of code. Of course, if you want buttons that can be resized you'll have to resort to other methods.