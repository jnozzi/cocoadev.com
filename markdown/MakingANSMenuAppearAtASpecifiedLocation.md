Hi.

I've been playing around with General/NSMenu's +popUpContextMenu:withEvent:forView: but don't seem to quite reach my goal. Here's what that is:
Let's take the Dock for example. When you right click on it, or hold your mouse button down for a while on a tile, it'll show the menu always at the same location - above the tile, no matter where you clicked on the tile. And that's exactly the behaviour I desire for my menu.
You right-click (or click-and-hold) on a view no matter where on the view and the menu will always pop up at the same location, let's say, [view frame].origin.x and [view frame].origin.y + [view frame].size.height.

I tried implementing it with popUpContextMenu:etc:etc with an General/NSEvent object, but it only works for menus with a small amount of menu items in it. Meaning, if the menu is rather large, it ignores the location of the event...

Any help is greatly appreciated.

Another question: Is there a way to set the size of the General/NSMenu?

----

Take a look at General/NSMenuItemCategory and see if you can use the undocumented     _NSGetCarbonMenu(General/NSMenu *) function (all     General/NSMenu<nowiki/>s are backed by a Carbon     General/MenuRef).  There's a     General/CalcMenuSize(General/MenuRef) function in the Carbon Menu Manager: http://developer.apple.com/documentation/Carbon/Reference/Menu_Manager/index.html#//apple_ref/doc/uid/TP30000227

----

Not sure if I've understood fully, but are you saying that your menu position is getting modified because it runs into the edge of the screen? This is normal and can't be changed - you'll see it affects dock menus and pop-up menus alike. The idea is to make sure the menu is always fully on-screen. When a menu gets large chances are it will run into a screen edge and so its position gets modified to try and prevent this. If it gets so large that it can't fit a screen, it starts to become scrollable. --GC

----

Yes, I know, I'm aware of that. The main part of my question is, how can I make my menu appear where I want, not where the user clicked? If the Dock does it, it has to be feasible. Also, General/TextMate can do it - press control-shift-c and the menu will appear at the mouse cursor. One has to be able to change the point where the context menu gets drawn when the user right-clicks onto a view... and what I'm trying to find out is how...

They somehow managed to tell the menu that the absolute border is not the bottom edge of the screen, but the Dock's height...

----
General/SetMenuSize(General/MenuRef aRef) doesn't seem to be working for me... the menu ref I get from General/NSGetCarbonMenu is not nil, so that shouldn't be an issue... Do I have to do anything else after setting the menu size? I do it before the menu is actually shown...

But what's really on my mind is how to set the menu's "origin", the lower left point of it....

Your advice is greatly appreciated. Thanks.

----

Did you try using Carbon to actually display the menu (as a context menu, maybe?).

----
At the risk of being obvious, there's no reason to talk about the Dock; Cocoa does this constantly, in the menu bar and in popup buttons.

And this leads to a solution: use an General/NSPopUpButtonCell and tell it to pop up a menu. It knows how to pop a menu at a certain position, and you aren't required to actually draw the thing, just tell it to act when you want.

----

If the menu is ultimately being displayed using Carbon, then the Carbon function is     General/PopUpMenuSelect, which takes a top and left location parameter. A "proper" Cocoa solution would be better though, and if you've tried setting up the General/NSEvent with the location you want and that doesn't work, then there doesn't seem to be an obvious documented way. (Edit: surely setting the event's location should do it, because it's the only information the menu has as to where to place itself (???) Just "fake" a mousedown event and convert the location back to the window's base coordinates. Doesn't that work? Why not - what happens?) --GC

Further edit: I just tried it, seems to work fine:

    

- (void)	mouseDown:(General/NSEvent*) event
{
	General/NSPoint wp = {0,0};
	
	wp = [self convertPoint:wp toView:nil];
	
	General/NSEvent* fake = General/[NSEvent mouseEventWithType:General/NSLeftMouseDown
						location:wp
						modifierFlags:0 timestamp:[event timestamp]
						windowNumber:[event windowNumber]
						context:[event context]
						eventNumber:[event eventNumber]
						clickCount:[event clickCount]
						pressure:[event pressure]];
	
	
	
	General/[NSMenu popUpContextMenu:_theMenu withEvent:fake forView:self];
}




This is just popping up a menu I added in IB hooked to an outlet called _theMenu. The important bit is creating the fake event. Doing this, the menu never moves no matter where I click - it's anchored to the bottom left corner of the test view that this code is part of. I made the menu both small and big - its size doesn't affect the result. --GC

----
OK, I just realized something fundamental: When you "give the menu a location", the TOP LEFT corner will be position there, not the lower left corner, as you'd expect.
Now it's a matter of getting the height of the menu (I always get -1... this isn't right. General/MenuRef != nil...) and adding that to the y-coordinate...

Slightly different subject: anybody know how to make the menu display the triangle like the dock's menu does?

----

Ah, I just realised the exact nature of your question ;-) Menus position based on their top, left point, views (by default) use bottom left. That's just a Cocoa/Carbon difference. It looks as if you'll have to delve into Carbon-land for both of your questions - the menu height is probably only valid when the menu is being displayed. That's pretty useless for positioning purposes, but I believe it's a consequence of the fact that Carbon asks the menu definition to calculate the menu size "just in time" so that it can allow for dynamically changing contents. One somewhat hacky solution is to "show" it offscreen, take the measurement then use that to work out the desired position onscreen. Alternatively if you can assume a fixed height per item (not unreasonable in most cases) you can multiply this by the number of items. As for the triangle, I think that's probably down to a custom MDEF (or whatever the modern HI equivalent is called) that the Dock is using. General/MDEFs are very old-school and from a Cocoa perspective not that straightforward, but when you get down to it more tedious than difficult. --GC

----
Hm, don't have the slightest idea where to start with General/MDEFs... could you give me a starting point?

----
I'm still wondering how I can tell the menu not to use all the space that's available, but be smaller, so if my view is near the menu bar and i right-click to get the menu, the menu doesn't overlap my view, but resizes so that it's still above my view...

----

Not sure I entirely follow what you want here - are you saying the menu should scale to fit the available space above your view if there's less than the full height available? What would it do - make the items smaller or start scrolling? Either way it's very non-standard, so the user might find the effect unexpected. I think given the situation as described, the standard menu just isn't going to bend to your will. Faced with this, (and notwithstanding a consideration of the UI issues in a more general sense) I'd forego using General/NSMenu/Carbon and just use a custom window for the whole lot. Doing that is likely to be less work than an MDEF and probably easier to work with in a Cocoa environment. You'll still have a lot of customising to do for both the window shape and dealing with the height problem but at least you can do it using General/NSView and friends. As a starting point the custom pop-up code I wrote a while back might be useful: http://apptree.net/code/General/GCWindowMenuTest.zip On the general UI question you'll have to make a judgement, but I wonder if repositioning the menu to the right or left when it gets close to the screen edges might be a better solution than forcing it into a very small space? --GC

Update: I hacked around with my code to see if recreating the dock menu shape was possible wih a custom pop-up window, and it's pretty easy. If I get time I'll try and work the code up into something a bit more presentable, but here's a quick category on General/NSBezierPath that will at least give you the desired outline (you might want to tweak the parameters to get the exact shape you want):

    

#import <Cocoa/Cocoa.h>


@interface General/NSBezierPath (Dockmenu)

+ (General/NSBezierPath*)		bezierPathWithDockMenuInRect:(General/NSRect) bounds triangleSize:(General/NSSize) trSize side:(int) side offset:(float) offset;
+ (General/NSBezierPath*)		bezierPathWithStandardDockMenuInRect:(General/NSRect) bounds;

@end

// values for side parameter:

enum
{
	kGCDockmenuTriangleOnBottom		= 0,
	kGCDockmenuTriangleOnLeft		= 1,
	kGCDockmenuTriangleOnRight		= 2,
	kGCDockmenuTriangleOnTop		= 3
};

#define kGCStandardTriangleSize		General/NSMakeSize( 32, 16 )



And the implementation:

    

//
//  General/NSBezierPath+Dockmenu.m
//  General/GCWindowMenuTest
//
//  Created by Graham on 7/11/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "General/NSBezierPath+Dockmenu.h"


@implementation General/NSBezierPath (Dockmenu)


+ (General/NSBezierPath*)		bezierPathWithStandardDockMenuInRect:(General/NSRect) bounds
{
	return General/[NSBezierPath bezierPathWithDockMenuInRect:bounds triangleSize:kGCStandardTriangleSize side:kGCDockmenuTriangleOnBottom offset:0.1];
}


+ (General/NSBezierPath*)		bezierPathWithDockMenuInRect:(General/NSRect) bounds triangleSize:(General/NSSize) trSize side:(int) side offset:(float) offset
{
	General/NSRect	mr = bounds;
	General/NSRect	tr;
	
	General/NSBezierPath* path = General/[NSBezierPath bezierPath];
	
	// swap width/height of triangle if on the side so the size is consistent independent of orientation
	
	if ( side == kGCDockmenuTriangleOnLeft || side == kGCDockmenuTriangleOnRight )
	{
		float temp = trSize.width;
		trSize.width = trSize.height;
		trSize.height = temp;
	}

	tr.size = trSize;
	
	switch( side )
	{
		case kGCDockmenuTriangleOnBottom:
			mr.size.height -= trSize.height;
			mr.origin.y += trSize.height;
			tr.origin.y = General/NSMinY( bounds );
			tr.origin.x = General/NSMinX( mr ) + (( General/NSWidth( mr ) - trSize.width ) * offset );
			[path moveToPoint:mr.origin];
			[path lineToPoint:General/NSMakePoint( General/NSMinX( tr ), General/NSMinY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMidX( tr ), General/NSMinY( tr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( tr ), General/NSMinY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( mr ), General/NSMinY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( mr ), General/NSMaxY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMinX( mr ), General/NSMaxY( mr ))];
			break;
		
		case kGCDockmenuTriangleOnLeft:
			mr.size.width -= trSize.width;
			mr.origin.x += trSize.width;
			tr.origin.x = General/NSMinX( bounds );
			tr.origin.y = General/NSMinY( mr ) + (( General/NSHeight( mr ) - trSize.height ) * offset );
			[path moveToPoint:mr.origin];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( mr ), General/NSMinY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( mr ), General/NSMaxY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMinX( mr ), General/NSMaxY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMinX( mr ), General/NSMaxY( tr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMinX( tr ), General/NSMidY( tr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMinX( mr ), General/NSMinY( tr ))];
			break;
		
		case kGCDockmenuTriangleOnRight:
			mr.size.width -= trSize.width;
			tr.origin.x = General/NSMaxX( mr );
			tr.origin.y = General/NSMinY( mr ) + (( General/NSHeight( mr ) - trSize.height ) * offset );
			[path moveToPoint:mr.origin];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( mr ), General/NSMinY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( mr ), General/NSMinY( tr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( tr ), General/NSMidY( tr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( mr ), General/NSMaxY( tr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( mr ), General/NSMaxY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMinX( mr ), General/NSMaxY( mr ))];
			break;
		
		case kGCDockmenuTriangleOnTop:
			mr.size.height -= trSize.height;
			tr.origin.y = General/NSMaxY( mr );
			tr.origin.x = General/NSMinX( mr ) + (( General/NSWidth( mr ) - trSize.width ) * offset );
			[path moveToPoint:mr.origin];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( mr ), General/NSMinY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( mr ), General/NSMaxY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMaxX( tr ), General/NSMaxY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMidX( tr ), General/NSMaxY( tr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMinX( tr ), General/NSMaxY( mr ))];
			[path lineToPoint:General/NSMakePoint( General/NSMinX( mr ), General/NSMaxY( mr ))];
			break;
	}

	[path closePath];
	
	return path;
}

@end



The only thing that might need a bit of explanation is the     offset: parameter - that sets the relative distance along the side that the triangle appears at. You can set this between 0..1 to position it anywhere. 0.5 centres it. Hope this is useful,  --GC

----
One last question, then I'll finally shut up ;)

I really want to set the low border of the menu. You know, currently, it's the screen's bottom edge. But, with the Dock, it is the Dock's height. So when you click on a tile, the menu won't overlap with the Dock but open up above it, careless how big the menu is in size. Here, when I try, for small menus it works, but larger ones "push" the bottom line of the Menu down to the screen's bottom... How can I tell the menu that the absolute border is my "Dock's height", not the screen bottom?

----

    General/GetAvailableWindowPositioningBounds();,     General/[[NSScreen mainScreen] visibleFrame]; --GC

----

Yeah that gets him the dimensions of the working area, but it doesn't help him force the menu to stay in that area.  Unless, of course, he re-implements the menu as a fake menu.

Speaking of the working area, are you trying to avoid the dock, or are you using the dock as an analogy?  It was a little unclear.  You'll probably find that attempting to avoid the dock is a fruitless endeavor; for one, I have my dock on my General/MacBook Pro set to autohide and maximum magnify.  I'd love to see your program attempt to avoid that.

----

Since the earlier part of this discussion was about implementing a custom menu either using an MDEF or a pop-up window, I'm assuming that at some stage the positioning of the thing will have to be calculated and so you need to get the working area. If that's not the case, the standard menu MDEF already does this. The working area takes account of dock hiding and magnification, so as long as you don't cache its value, it will correctly avoid the dock at all times - though in practice if the menu is being popped up from some other window, in your case the dock will always be hidden at that time. (i.e. you can't be using both the dock and your app's controls simultaneously). --GC