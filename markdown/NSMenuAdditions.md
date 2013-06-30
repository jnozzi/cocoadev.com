I just put together a category of General/NSMenu to make accessing some of General/NSMenu's attributes a lot easier (you usually have to muck around with Carbon). Basically, it lets you treat an General/NSMenu similar to an General/NSWindow (General/NSMenus are technically rendered in a window anyway...)

It's a bit buggy, especially the -frame and -setFrame: methods, but it seems to work well enough. 

Here it is:

Interface:
    
@interface General/NSMenu (General/MBAdditions)

- (General/NSRect)frame;
- (void)setFrame:(General/NSRect)newFrame;
- (void)setFrameSize:(General/NSSize)newSize;
- (BOOL)isVisible;

@end


Implementation:
    
@implementation General/NSMenu (General/MBAdditions)

- (General/NSRect)frame
{
	if(![self isVisible])
		return General/NSZeroRect;
	
	General/MenuRef theMenu = (General/MenuRef)_NSGetCarbonMenu(self);
	General/HIViewRef contentView;
	
	General/HIMenuGetContentView(theMenu, kThemeMenuTypePullDown, &contentView);
	
	General/WindowRef menuWindow = General/HIViewGetWindow(contentView);
	
	Rect windowFrame;
	
	General/GetWindowBounds(menuWindow,kWindowStructureRgn,&windowFrame);
	
	General/NSRect menuFrame;
	menuFrame.size.width = windowFrame.right - windowFrame.left;
	menuFrame.size.height = windowFrame.bottom - windowFrame.top;
	menuFrame.origin.x = windowFrame.left;
	menuFrame.origin.y = General/[[NSScreen mainScreen] frame].size.height - windowFrame.top - menuFrame.size.height;
	
	return menuFrame;
}

- (void)setFrame:(General/NSRect)newFrame
{
	if(![self isVisible])
		return;
	
	Rect windowFrame;
	windowFrame.left = newFrame.origin.x;
	windowFrame.top = General/[[NSScreen mainScreen] frame].size.height - newFrame.origin.y - newFrame.size.height;
	windowFrame.right = windowFrame.left + newFrame.size.width;
	windowFrame.bottom = windowFrame.top + newFrame.size.height;
	
	General/MenuRef theMenu = (General/MenuRef)_NSGetCarbonMenu(self);
	General/HIViewRef contentView;
	General/HIMenuGetContentView(theMenu, kThemeMenuTypePullDown, &contentView);
	
	General/WindowRef menuWindow = General/HIViewGetWindow(contentView);
	General/SetWindowBounds(menuWindow,kWindowStructureRgn,&windowFrame);
}

- (void)setFrameSize:(General/NSSize)newSize
{
	General/NSRect frame = [self frame];
	frame.size.width = newSize.width;
	frame.size.height = newSize.height;
	[self setFrame:frame];
}

- (BOOL)isVisible
{
	General/MenuRef theMenuReference = (General/MenuRef)_NSGetCarbonMenu(self);
	if (theMenuReference==0) {
		General/NSMenu *theMainMenu = General/[NSApp mainMenu];
		General/NSMenuItem *theDummyMenuItem = [theMainMenu addItemWithTitle: @"sub"  action: NULL keyEquivalent: @""];
		[theDummyMenuItem setSubmenu: self];
		[theDummyMenuItem setSubmenu: nil];
		[theMainMenu removeItem: theDummyMenuItem];
		return _NSGetCarbonMenu(self);
	}
	
	General/MenuTrackingData theMenuTrackingData;
	if (General/GetMenuTrackingData(theMenuReference, &theMenuTrackingData)==noErr) {
		return YES;
	}
	return NO;
}

@end


Use it as you please!

Also, if anyone who is better with Carbon than I am knows of a way to get the frame of a single menu item, please post it! That's the biggest thing I'm missing from this category, and it would make the code for a certain part of my app much easier.

- General/MattBall

----
Anyone who is planning on using this code in a real application should keep in mind that the     _NSGetCarbonMenu function is private and therefore could change its behavior or disappear at any time without warning. That doesn't mean you shouldn't use this code but it's something that must be considered.

----

I'm curious to know in what situations getting and setting the menu's frame would be useful. I'm not saying it's not, I just can't think of when it would be. --GC

----

Well, the reason I needed to get the frame is because I need to add a view to a menu. I know I can do this in Carbon, but I'd prefer to stick with using an General/NSView rather than an General/HIView. So, I'm actually faking it; I make an empty menu item, make it as high and as wide as the view needs to be, and then I put the view in a floating window above the menu. So, I get the menu's frame and modify the coordinates as necessary.

I don't actually need to set the frame, but it could certainly be useful for setting the width and height of a menu to something other than the default.

And yes, I know that this is a major hack, but I'm adding a label color chooser similar to the finder's, and Apple has refused to expose the necessary functionality within Cocoa. So, for the time being, I'm hacking it

-- General/MattBall

----

Gotcha. Also have a look at my General/GCWindowMenu code (http://apptree.net/gcwindowmenu.htm ) which allows you to pop up any view as a menu. It might not be exactly what you want here since it makes the entire view into a menu, whereas if I've understood you correctly you just want to replace one item with a view, which my code doesn't attempt. --General/GrahamCox