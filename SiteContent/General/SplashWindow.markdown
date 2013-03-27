Is this the best way to create a splash window?

*
**General/SplashWindow.h**
    
#import <Cocoa/Cocoa.h>

@interface General/SplashWindow : General/NSWindow
{

}

@end

*
**General/SplashWindow.m**
    

#import "General/SplashWindow.h"
#import <General/AppKit/General/AppKit.h>

@implementation General/SplashWindow

- (id)initWithContentRect:(General/NSRect)contentRect
                styleMask:(unsigned int)aStyle
                  backing:(General/NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
	self = [super initWithContentRect:contentRect
                                styleMask:General/NSBorderlessWindowMask
                                  backing:General/NSBackingStoreBuffered
                                    defer:NO];
    [self setBackgroundColor: General/[NSColor clearColor]];
    [self setLevel: General/NSStatusWindowLevel];
    [self setAlphaValue:1.0];
    [self setOpaque:NO];
    [self setHasShadow: YES];
    return self;
}

@end



----

I don't know if I would use General/NSStatusWindowLevel, that makes a floating window that stays above all other windows.  What if a user wanted to switch to another application while your program was launching?

----

General/NSStatusWindowLevel wouldn't be objectionable if the window was set to hide on deactivate. Although I find splash windows in general objectionable unless they show some sort of useful information about the app's startup progress.

----

I'd use something more like this...

    
@implementation General/SplashWindow

- (id)initWithImage:(General/NSImage *)splashImage
{
     General/NSRect contentRect = General/NSMakeRect(0,0, [splashImage size].width, [splashImage size].height);

	self = [super initWithContentRect:contentRect
                                styleMask:General/NSBorderlessWindowMask
                                  backing:General/NSBackingStoreBuffered
                                    defer:NO];

         { // create the contentView and set the image...
           General/NSImageView *contentView = General/[[NSImageView alloc] initWithFrame:contentRect];
                [contentView setImageFrameStyle:General/NSImageFrameNone];
                [contentView setImage:splashImage];
                [self setContentView:contentView];
                [contentView release];
         }

    [self setBackgroundColor: General/[NSColor clearColor]];
    [self setLevel: General/NSStatusWindowLevel];
    [self setAlphaValue:1.0];
    [self setOpaque:NO];
    [self setHasShadow: YES];
    [self center]; // might as well

    return self;
}

@end


Of course, it could borrow from the lower General/ToolTip example to return an autoreleased General/SplashWindow that displays for a set amount of time. Then using it would be real simple... General/[SplashWindow splashWithImage:yourImage display:YES];