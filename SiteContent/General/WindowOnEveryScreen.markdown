

I am working on a project and I want to create and manage a window on every screen on the computer and update when / if screens are lost or gained. I hope some one can help...

I know that using [[[NSScreen]] screens] I can get an array of the screens at present and I imagine therefore that I can loop through the array something like this...

screens = [[[NSScreen]] screens];

for (i = 0; i < screens; i++ {
		
// get screen size
screenRect = [[[[NScreen]] i] frame];
		
// Create window
[[NSWindow]] ''SCREENNAME = [[[[NSWindow]] alloc] initWithContentRect:screenRect styleMask:[[NSBorderlessWindowMask]] backing:[[NSBackingStoreBuffered]] defer:NO screen:[[[NSScreen]] mainScreen]];
		
[SCREENNAME setBackgroundColor:[[[NSColor]] blackColor]];
[SCREENNAME setAlphaValue:0.0];
[SCREENNAME setLevel:[[NSScreenSaverWindowLevel]]-2];
[SCREENNAME setReleasedWhenClosed:NO];

}

Assuming that were to work then I imagine that I would simply put that in a function which I call on awakeFromNib in my [[AppController]] (to create the windows) and then also there must be a notification some thing like screensDidChange: which I could override and implement some form of update to my windows to add or remove windows on screens where applicable.

Additionally windows also need to be manageable i.e. I would need some way to get them to perform a adjustment i.e. setting the color or adjusting the alpha value.

Now I know someone is going to say why don't you use [[CGCaptureAllDisplays]]() but as far as I could work out there is no way to adjust this window i.e. alpha value. which I need as I want to be able to fade the screens from 0 to 1 or 0 to 0.75 using [[NSTimer]] to incrementally fade out/in.

I hope you guys can help I am very new to all this and whilst I have a comprehension of what I need to do I am very unsure as to how to actually implement this. Your help would be much appreciated!

----

If the point is purely to fade different screens in/out, why not use the function for that purpose, <code>[[CGDisplayFade]](...);</code>? --GC

----

Thanks for that I was already aware of this soloution however in the past I have had an issue of switching from the fade to the [[CDCaptureAllDisplays]]() creating a short flash of the non black window. However this is gone now! Thanks.

I would like to ask though is there a way to get a pointer to the windows [[CGCaptureAllDisplays]] puts in as I actually need to set it to be semi transparent. I have spent alot of time looking to no avail.

----

The parameter <endBlend> doesn't need to be 0 or 1, it can be something in between. This leaves the display in a partially faded state. However if you plan to draw other windows on top at full brightness (like e.g. Dashboard) I'm not sure if that would work. There is a function <code>[[CGShieldingWindowID]]()</code> which seems to imply that there is a window associated with a captured display, and the function <code>[[CGShieldingWindowLevel]]()</code> would allow you to place a window above it. However, both of these functions come with warnings discouraging their use in apps, so it's unclear if it's a good approach. Sorry I don't know much about this - I have captured displays and faded them but only for full screen mode use and haven't tried what you seem to be attempting. Maybe someone more expert can step in here? --GC

----

Thanks for your help so far I hate to say it but I am quite new although I have a good grasp of what I am trying to do I have in fact tried the very same thing you suggested it seems that there is little to no functionality in the [[CDShieldingWindowID]] it all seems to cause a crash.

I have been looking for a long time which is why I came up with the idea of an array of screens which I could loop through as most users will only have 1 display for my application it would probably not be to taxing on the computer and most computers rarely if ever have more than 4 displays. My issue is I simply don't have the knowledge or experience to create the idea I had in my original post by my self so if any one can indeed help me to create a loop through the displays which adds a window and sends messages to them and also detects when displays are connected or removed and appropriately adjust this then I would very much appreciate it. I will obviously continue working on this my self but if any one has any pointers or can help please do.

----

I have been working on this in a little mini app and this is what I have come up with it manages to create a window on every screen now all I need to do is work out how to loop thorugh them using a timer to fade I can see this would get quite resource intensive should the user have a larger number of displays as it will be calling a function every 0.1 seconds for every display 75 times in my case to fade from 0.0 to 0.75 in 0.1 fractions. I may try reducing this until the smoothness of the animation is just about to be comprimised.

Heres my work inprogress code for my [[AppController]]... 

<code> 
- (void)awakeFromNib
{
	// Get all screens
	windows = [[[[NSMutableArray]] alloc] init];
	[[NSArray]] ''screens = [[[NSScreen]] screens];
	int i;
		
	for (i = 0; i < [screens count]; i++) {
		[[NSWindow]] ''newWindow = [self addWindowOnScreen:[screens objectAtIndex:i]];
		[windows addObject:newWindow];
	}
	
}

- ([[NSWindow]] '')addWindowOnScreen:([[NSScreen]] '')screen
{
	// Create new window
	[[NSRect]] size;
	size = [screen frame];
	size.origin = [[NSZeroPoint]];
	
	[[NSWindow]] ''newWindow = [[[[NSWindow]] alloc] initWithContentRect:size //[screen frame]
													  styleMask:[[NSBorderlessWindowMask]]
														backing:[[NSBackingStoreBuffered]]
														  defer:NO
														 screen:screen];
	// Define new window	
	[newWindow setBackgroundColor:[[[NSColor]] blackColor]];
	[newWindow setAlphaValue:0.75];
	[newWindow setLevel:[[NSScreenSaverWindowLevel]]-2];
	[newWindow makeKeyAndOrderFront:nil];
	
	return newWindow;
}
</code>

----

WOOP! I did it all by my self pretty much!

I would appreciate some feedback on how well coded it is.

<code>
#import "[[AppController]].h"

@implementation [[AppController]]

- (void)awakeFromNib
{
	// Move the window control window just below the screensaver level
	[window center];
	[window setLevel:[[NSScreenSaverWindowLevel]]-1];
	
	// Capture all the displays (includes fading in)
	[self captureAllDisplays];
}

- ([[IBAction]])quit:(id)sender
{
	// Release all the displays (includes fading out)
	[self releaseAllDisplays];
}

- (void)captureAllDisplays
{
	windows = [[[[NSMutableArray]] alloc] init];
	[[NSArray]] ''screens = [[[NSScreen]] screens];
	int i;
	
	// Loop through the each screen
	for (i = 0; i < [screens count]; i++) {
		// Create a new window using addWindowOnScreen:
		[[NSWindow]] ''newWindow = [self addWindowOnScreen:[screens objectAtIndex:i]];
		// Add the window pointer to the windows array
		[windows addObject:newWindow];
	}
	
	// Fade in the windows using a timer
	timer = [[[[NSTimer]] scheduledTimerWithTimeInterval:0.03
											  target:self
											selector:@selector(fadeIn:)
											userInfo:nil
											 repeats:YES] retain];
}

- (void)releaseAllDisplays
{
	// Fade out the windows using a timer
	timer = [[[[NSTimer]] scheduledTimerWithTimeInterval:0.03
											  target:self
											selector:@selector(fadeOut:)
											userInfo:nil
											 repeats:YES] retain];
}

- ([[NSWindow]] '')addWindowOnScreen:([[NSScreen]] '')screen
{
	// Define the size of the window and set it in the corner of the screen
	[[NSRect]] size;
	size = [screen frame];
	size.origin = [[NSZeroPoint]];
	
	// Create a borderless window on the appropriate screen
	[[NSWindow]] ''newWindow = [[[[NSWindow]] alloc] initWithContentRect:size
													  styleMask:[[NSBorderlessWindowMask]]
														backing:[[NSBackingStoreBuffered]]
														  defer:NO
														 screen:screen];
	// Define new windows characteristics
	[newWindow setBackgroundColor:[[[NSColor]] blackColor]];
	[newWindow setAlphaValue:0.0];
	[newWindow setLevel:[[NSScreenSaverWindowLevel]]-2];
	
	// Show the window
	[newWindow makeKeyAndOrderFront:nil];
	
	// Return a pointer to the new window
	return newWindow;
}

- (void)fadeIn:([[NSTimer]] '')theTimer;
{
	int i;
	
	// If the alpha is greater than 0.7 then stop fading
	if ([[windows objectAtIndex:0] alphaValue] > 0.69) {
		[timer invalidate];
		[timer release];
	} else {
		// Loop through each window increasing the alpha value by 0.03 while the value is less than 0.7
		for (i = 0; i < [windows count]; i++) {
			if ([[windows objectAtIndex:i] alphaValue] < 0.7) {
				[[windows objectAtIndex:i] setAlphaValue:[[windows objectAtIndex:i] alphaValue]+0.03];
			}
		}
	}
}

- (void)fadeOut:([[NSTimer]] '')theTimer;
{
	int i;
	
	// If the alpha is less than 0.1 then stop fading
	if ([[windows objectAtIndex:0] alphaValue] < 0.01) {
		[timer invalidate];
		[timer release];
		[[[NSApp]] terminate:nil];
	} else {
		// Loop through each window decreasing the alpha value by 0.03 while the value is greater than 0.0
		for (i = 0; i < [windows count]; i++) {
			if ([[windows objectAtIndex:i] alphaValue] > 0.0) {
				[[windows objectAtIndex:i] setAlphaValue:[[windows objectAtIndex:i] alphaValue]-0.03];
			}
		}
	}
}

- (void)dealloc
{
	[windows release];
	[super dealloc];
}

@end
</code>