I have created a very simple test project to try and get this to work.

In the main.nib I created a borderless [[NSImageView]], which I then connected to an outlet in an [[AppController]] I created.  The implementation for my [[AppController]] looks like this

<code>
@implementation [[AppController]]

- (void) awakeFromNib
{
[theImageView setImage:[[[NSImage]] imageNamed:@"ipcLogoWhite"]];
[[NSImage]] ''theImage = [theImageView image];
[[NSRect]] theImageFrame = [theImageView bounds];
[[NSSize]] imgSize = [theImage size];
[[NSRect]] srcRect = [[NSMakeRect]]( 0.0, 0.0, imgSize.width, imgSize.height );
[theImage drawInRect:theImageFrame fromRect:srcRect operation:[[NSCompositeSourceIn]] fraction:1.0];
}
@end
</code>

What i was hoping was that the image I set to appear inside the [[NSImageView]] would become transparent and I would see the image looking through to the background of the window.  If you look at any apple installer you will see what I am talking about.  A screenshot of what I am aiming for is included below

 http://www.kirkconsulting.co.uk/public/[[TransparentBackground]].jpg.
 
----
 
'''You might try subclassing [[NSImageView]] to return <code>NO</code> for <code>-isOpaque</code>. Don't know if this will work, but it's a shot.'''

----

I tried subclassing and overriding the return value on this method but to no avail.  It seems that the drawInRect:fromRect:operation:fraction: method doesn't have any effect at all.  To prove this I tried changing the fromRect to something arbitarilly smaller than it should be and it doesn't redraw the image any smaller.  What gives?

----

OK - So I nailed it in the end.  I had already opened up the NIB from Apple's Installer to see how it was done but I found the contents confusing.  There was an object somewhere behind everything set to a custom class which was doing the work, but I couldn't see it.  I assumed wrongly that this was not a custom view.  Actually, I discovered that it is possible to have a custom view that does not show in Interface Builder, if you resize it to fill the whole window and then double click it!

Anyway, now I new that the object was a subclass of [[NSImageView]] and I set to work trying to make my own that would do the same job.  I came up with this:

<code>
/'' [[JKBackgroundImage]] ''/

#import <Cocoa/Cocoa.h>

@interface [[JKBackgroundImage]] : [[NSImageView]]
{
	[[NSImage]] ''image;
	float opacity;
}
- (void) setImage:([[NSImage]] '') newImage;
- (void) setOpacity:(float)x;
@end

#import "[[JKBackgroundImage]].h"

@implementation [[JKBackgroundImage]]

- (void) setImage:([[NSImage]] '') newImage
{
	[newImage retain];
	[image release];
	image = newImage;
}

- (void) setOpacity: (float) x
{
	opacity = x;
	[self setNeedsDisplay:YES];
}

- (void) drawRect: ([[NSRect]])rect
{ 
	[self setImageScaling:[[NSScaleToFit]]];
	if (image) {
		[[NSRect]] theFrame = [self bounds];
		[[NSSize]] imgSize = [image size];
		[[NSRect]] srcRect = [[NSMakeRect]]( 0.0, 0.0, imgSize.width, imgSize.height );
		[image drawInRect:theFrame
				 fromRect:srcRect
				operation:[[NSCompositeSourceOver]]
				   fraction:opacity];
	}
}
@end
</code>

then in my [[AppController]] I just set the opacity and the image and voila!  I have acheived exactly the effect shown in the picture I posted.

----

It's kind of wasteful to have this inherit from [[NSImageView]]. You get a bunch of extra clutter from [[NSImageView]] and [[NSControl]] that doesn't affect the drawing of your view at all (and thus actually makes your view's interface deceptive). You'd be better off with just an [[NSView]] subclass.