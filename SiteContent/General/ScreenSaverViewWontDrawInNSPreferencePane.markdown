

Hi,
I'm trying to get a screensaver view loaded from a bundle to display in the window of my General/NSPreferencePane. With this code I get a black box:
    
-(void) didSelect
{
	General/SSBundle = General/[NSBundle bundleWithPath:@"/Users/josephduchesne/Library/Screen Savers/uDG Screensaver.saver"];
       General/NSLog(@"Bundle Info\n%@",[ [ General/SSBundle infoDictionary ] description ] );
	Class General/SSBundleClass=[ General/SSBundle principalClass ];
	newView = General/[[SSBundleClass alloc] initWithFrame:General/NSMakeRect(251,111,320,240) isPreview:YES];
	General/self mainView] addSubview:newView];
	[newView startAnimation];
}


but as soon as I call [newView animateOneFrame]; I get the following errors:

*** Assertion failure in -[uDGScreenSaver lockFocus], [[AppKit.subproj/General/NSView.m:3248

lockFocus sent to a view whose window is deferred and does not yet have a corresponding platform window

I the window IS being displayed, although I believe it is deferred, it is on screen and thus that shouldn't be a problem. I know this can be done because, of course, Apple did it.

Basically I just want newView to draw in [self mainView], but it seems that locking the focus (as screensavers are supposed to) can't work in the given conditions. 

How should I fix this?