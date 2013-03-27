I have an object that uses the shared General/NSColorPanel.      -orderFrontColorPanel opens it alright and it seems to function properly.
My object implements     -(void)changeColor:(id)sender and accepts first responder status.

However when I make a color selection in the panel my     changeColor: method isn't getting called.

On a related note, when I use the code
    General/[[NSColorPanel sharedColorPanel] setPickerMask: (General/NSColorPanelRGBModeMask || General/NSColorPanelWheelModeMask)];
I get an error stating that "General/NSColorPanel might not respond to -setPickerMask" or something to that effect.

Thanks.

----

Try this:

    

- (General/IBAction)colorPanelAction:(id)sender {
	General/NSLog(@"<%p>%s:", self, __PRETTY_FUNCTION__);
}

- (void)awakeFromNib {
	General/NSColorPanel *colorPanel = General/[NSColorPanel sharedColorPanel];
	[colorPanel setTarget:self];
	[colorPanel setAction:@selector(colorPanelAction:)];
	General/[NSApp orderFrontColorPanel:self];
}


Also, you are getting a compile warning because you are asking an instance of     General/NSColorPanel to perform a class method. Your code should be:

    
General/[NSColorPanel setPickerMask:General/NSColorPanelRGBModeMask | General/NSColorPanelWheelModeMask];


You also are using the logical OR operator     || when you should be using the bitwise inclusive OR operator     |

--zootbobbalu

----

Is there any way to get access to the color "chips" at the bottom of the General/NSColorPanel?

I'd like to be able to save off the colors found there and replace them with a new set of colors.

----

They're the user's favorite colors; why do you want to mess with them? If you need a special list of colors look at General/NSColorPanel's     - (void)attachColorList:(General/NSColorList *)colorList method

----

I'm working on a color design application. Essentially, I want to use the colorPanel as a way of holding colors designed in my app for use in other applications. I can use colorList for this (and that's what I may end up doing) but the color chips are pretty simple and convenient for the user. So I'm just trying to see what it might take to use them, the intention being that I'd save whatever's already there so it could be restored.

----

If you're writing a color design app, you should consider making it a General/NSColorPanel plugin.

Of course... all the design programs I've used on the Mac are Carbon and ignore the General/NSColorPanel... so what I would do would have a standalone app and have an optional color panel plugin that's automatically installed, and shares the same interface and functionality. 

Just a suggestion.

Also, I spent about 20 minutes in "detective" mode and I couldn't figure out where the colors are stored on disk.. It's baffling. Clearly, they're stored somewhere, but where?

----

Colors are a standard pasteboard type (General/NSColorPboardType). The color panel is the wrong place to put user's work, IMO. (Assuming your UI requirements go beyond a General/NSColorPicker plugin) I'd make a separate window in my app to hold the colors and just allow dragging/copying the colors.

----

The General/ColorPanel provides the "continuous" mode, which provides a for some applications a good user feedback. But, how can I couple this nicely with the undo-manager? If I register every continuous movement in the color wheel as an undo item, the list of undo's might get enormous. So, how an I get notified on the mouse-up event in the color wheel? Any ideas?