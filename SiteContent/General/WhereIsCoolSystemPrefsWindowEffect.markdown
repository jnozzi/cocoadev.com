

This is linked from the more basic topic [[WindowPosition]] and is discussed again in [[AutoWindowResizing]]

I remember a while ago seeing a tutorial on how to get the cool effect seen in System Preferences.app which resizes the window with a neat animation and changes its view to a different panel when you select an icon.

----

Just do <code>[window setFrame:([[NSRect]])frameRect display:(BOOL)YES animate:(BOOL)YES]</code> and set the window's contentView afterwards

----

<code>
[window setFrame:[[NSMakeRect]]([window frame].origin.x, [window frame].origin.y, 382, 431)
	display:(BOOL)YES animate:(BOOL)YES];
</code>

This is called when the user selects an option requiring the window to grow to a new height. Unfortunately, it does not grow from the bottom, it is the top that goes shooting off, the bottom of the window stays rock solid where it was.

To have the bottom of the window extend, and not the top:

''Change the rect. In Quartz, drawing coordinates begin at the bottom-left of a window, instead of the top-left like in [[QuickDraw]]. You can also flip coordinate systems, but that might be more work than you want.''

----

Here is how to resize by growing down and right. This is from a subclass of an [[NSWindowController]] I have that gets passed a new size. �[[TimothyHatcher]]

<code>
- (void) _resizeWindowForContentSize:([[NSSize]]) size {
	[[NSRect]] windowFrame = [[[NSWindow]] contentRectForFrameRect:[[self window] frame]
		styleMask:[[self window] styleMask]];
	[[NSRect]] newWindowFrame = [[[NSWindow]] frameRectForContentRect:
		[[NSMakeRect]]( [[NSMinX]]( windowFrame ), [[NSMaxY]]( windowFrame ) - size.height, size.width, size.height )
		styleMask:[[self window] styleMask]];
	[[self window] setFrame:newWindowFrame display:YES animate:[[self window] isVisible]];
}
</code>

----

'''Resizing Window'''

I am attempting to add a plugin manager to my application. It will have the same look and feel as System Preferences. I can find and load/instantiate all of my plugins, but I am having issues with resizing the window to the correct size as determined by the plugin's view. Essentially, I want the height to change like in Sys Prefs. The plugins have a method that returns the preferences view. The controller sets the content view of the window to the view returned by the selected plugin. Resizing is completely screwed. If I switch between 2 plugins multiple times, the window gradually becomes smaller and smaller and then segfaults.

Is the view inside the plugin getting resized each time (so it's size gets smaller and smaller with each loading?

----

What's your view-switching code? Are you using [[NSToolbar]]? If I was writing plugins, I would have each one have a function, <code>view:</code>, which returned an [[NSView]]. Then I would use the view in the following code:
<code>
// Assume an [[NSView]] pointer called view that points to the current panel's view.
[window setContentView:view]; // ...where window is your prefs window. You already know this...
[window setContentSize:( [view frame].size )]; // setContentSize will also resize the window.
</code>
That's how I would do it. If you ''aren't'' using [[NSToolbar]], but you have something else that allows switching between plugins INSIDE the window (like system prefs), you have to remember to account for that when setting the size. If my code is identical to yours (except for superficial differences), then I'm sorry for wasting your time. --[[JediKnil]]

----

Yes, I am using an [[NSToolbar]]. Yes, my plugins have a method that returns an [[NSView]]. My code basically matches yours, except I only want to resize the height (like Sys Prefs). Basically I can switch between the two plugins I currently have and it works fine - once. After that, when I get the view from the plugin and call [view frame].size on it, it appears to have been adjusted to some other set of values.

OK, I have gotten the resize code to work correctly. I still need to make it so the top-left corner of the window does not move (right now the window resizes from the bottom-left). I am still having issues with the segfault. If I switch back and forth from one plugin to the other, it works fine through 2 cycles, but on the third it crashes. I can't figure out why. While debugging, I noticed that the 3rd iteration returns a frame with an x value of some extremely small number (ie 2.5668382e-36). All the other values appear to be correct. Any thoughts?

Here's my code:

<code>
[[NSView]] ''prefsView = [[[[[[PluginController]] sharedPluginController] pluginInstances] objectAtIndex:pluginIndex] pluginPrefsView];

[[NSSize]] prefsSize = [prefsView frame].size;
// Set the width of the view to the min width of the window (the window's width does not change when selecting plugins)
prefsSize.width = [[self window] contentMinSize].width;

// Check to see if the plugin's view is shorter than the min height of the window (just in case - might be removed later)
if((prefsSize.height) < [[self window] contentMinSize].height)
	prefsSize.height = [[self window] contentMinSize].height;

[[self window] setContentView:prefsView];
[[self window] setContentSize:prefsSize];
</code>

It appears to have something to do with the fact that one of my plugins is using an [[NSWindow]] and returning its contentView whereas the other plugin is just using an [[NSView]] and passing it back. I'm really not sure what is going on here. Any help would be greatly appreciated!

----

Wild guess: Your code looks something like this:
<code>
// get the window's content view to pass it back
view = [window contentView];
[view removeFromSuperview]; // '''''''
return view;
</code>
At the marked line, <code>view</code> will be destroyed because the only thing retaining it was its superview. You need to retain it before removing it from the window. ''If'' you're doing something like that, then this is probably your problem.

----

My code looks like this: return [window contentView];, but you nailed the problem. If you look at the documentation for [[NSWindow]]'s setContentView: it states:

This method causes the old content view to be released; if you plan to reuse it, be sure to retain it before sending this message and to release it as appropriate when adding it to another [[NSWindow]] or [[NSView]].

So I'm assuming what was happening was the plugin passed the contentView from its window to the plugin window (which set it as its own contentView). After selecting a different item in the toolbar, the window would release the view and it would be destroyed. I guess this is not an issue if the plugin uses an [[NSView]] instead of an [[NSWindow]] because it can re-grab it from the nib?

----

It's not an issue if it's an [[NSView]] because the [[NSView]] is a top-level nib object and is therefore implicitly retained by File's Owner. The content view of an [[NSWindow]] is only retained by that window, and when you move it to another window then it'll be dropped, since a view can only be in one window at a time.

----

I've gotten the issue with the top-left corner of the window moving all over the place (as the coordinate system starts from the bottom-left so a resize adjusts the top) fixed.

Here's the code if anyone wants it:

<code>
[[NSObject]]<[[IQEiVotePluginProtocol]]> ''plugin = [[[[[PluginController]] sharedPluginController] pluginInstances] objectAtIndex:pluginIndex];

[[NSSize]] prefsSize = [[plugin pluginPrefsView] frame].size;
[[NSRect]] frame = [[self window] frame];
prefsSize.width = [[self window] contentMinSize].width;

// Make sure the plugin's height is larger than the minimum window height
if((prefsSize.height) < [[self window] contentMinSize].height)
	prefsSize.height = [[self window] contentMinSize].height;

// We have to retain the view because setContentView: releases it (which destroys it)
[[plugin pluginPrefsView] retain];
[[self window] setContentView:[plugin pluginPrefsView]];

// Set the new height to the height of the loaded view + height of the toolbar + height of the window bar (22)
float newHeight = prefsSize.height + [self toolbarHeightForWindow:[self window]] + 22;
// Adjust the origin to the proper height so the top-left corner of the window does not move
frame.origin.y += frame.size.height - newHeight;
frame.size.height = newHeight;
frame.size.width = prefsSize.width;
[[self window] setFrame:frame display:YES animate:YES];
</code>

The toolbarHeightForWindow: method was taken from Apple's documentation on [[NSToolbars]]: http://developer.apple.com/documentation/cocoa/Conceptual/Toolbars/index.html (click the link titled "Calculating a Toolbar's Height")

----

You need to release [plugin pluginPrefsView] after you've set it as the window's content view (to balance the earlier retain).

----

The retain in the above code is actually just a little wacky in general. <code>setContentView:</code> won't destroy the view, it'll destroy the ''last'' view that was there. The correct fix would be to have the plugin retain the view when necessary.

----

[[OOOps]]! I know it destroys the last view. Somehow, in my mind I was thinking I was retaining the last one. Don't ask.

Should I change the line to get the contentView and retain it instead of the new view, and should I release the current view after doing a setContentView?

Wait, setContentView releases the old one already. The earlier retain is already balanced. The original problem is that it wasn't balanced.

Here's my new line of code:

[[[self window] contentView] retain];

----

see also [[UFISpringyPanel]] in [[CocoaSampleCode]], which extends this idea