

General/NSWindow+General/CCDWindowTinting.h

    
#import <Cocoa/Cocoa.h>

@interface General/NSWindow (General/CCDWindowTinting)
- (General/NSColor *)baseWindowBackgroundColor;
- (void)removeTint;
- (void)tintWithColor:(General/NSColor *)color;
@end



General/NSWindow+General/CCDWindowTinting.m

    
#import "General/NSWindow+General/CCDWindowTinting.h"

General/NSColor *baseWindowBackgroundColor;

@implementation General/NSWindow (General/CCDWindowTinting)

- (General/NSColor *)baseWindowBackgroundColor
{
	if (!baseWindowBackgroundColor) baseWindowBackgroundColor = General/self backgroundColor] retain];
	
	return baseWindowBackgroundColor;
}

- (void)removeTint
{
   [self setBackgroundColor:nil];
   [self performSelector:@selector(display) withObject:nil afterDelay:0];
}

- (void)tintWithColor:([[NSColor *)color
{
	General/NSRect winRect = [self frame];
	General/NSImage *img = General/[[NSImage alloc] initWithSize:winRect.size];

              winRect.origin = General/NSZeroPoint;

		[img lockFocus];		
		[color set];
		General/NSRectFillUsingOperation(winRect, General/NSCompositeSourceOver);

		General/self baseWindowBackgroundColor] set];
		[[NSRectFillUsingOperation(winRect, General/NSCompositePlusDarker);
		[img unlockFocus];

	[self setBackgroundColor:General/[NSColor colorWithPatternImage:img]];
	[self performSelector:@selector(display) withObject:nil afterDelay:0];

	[img release];
}

@end


----
A quick addition for window tinting. The backgroundColor will tile if the window size changes but you can overcome that if you need to. Enjoy.

-- General/RyanStevens