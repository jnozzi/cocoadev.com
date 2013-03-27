How do you have that little image by the icon, like in Mail?

----

I don't know how the question was aimed at, but I'm pretty sure its an General/NSBezierPath as a circle in red with a 2 in it. Well, at least thats what I do. -- General/MatPeterson

Actually, I believe it's an image from within the bundle, with the text applied to it. As for how you apply it to the dock icon, I really don't recall; you might begin looking in General/NSApplication's documentation. -- General/RobRix

----

**Executive summary of the example code below:**

* Create an General/NSImage of your icon and overlay that number image on top of it
* Use General/NSApplication's setApplicationIconImage: to put that icon into the dock
* PROFIT!

----

Also see General/BezierPathForDockIconCountBadge

----

**Controller Header**

    
#import <Cocoa/Cocoa.h>

@interface General/IconImageCounterController : General/NSObject
{
    General/NSImage *iconImageBuffer;
    General/NSImage *originalIcon;
    General/NSTimer *timer;
    General/NSDictionary *attributes;
    int count;
}
- (void)drawCountdownIcon:(int)number;
- (void)timerAction:(General/NSTimer *)_timer;
@end


**Controller Source**

    
#import "General/IconImageCounterController.h"

@implementation General/IconImageCounterController

- (void)awakeFromNib {
    if (timer) return;
    originalIcon = General/[[NSApp applicationIconImage] copy];
    iconImageBuffer = [originalIcon copy];
    timer = General/[[NSTimer scheduledTimerWithTimeInterval:1
                                                target:self
                                                selector:@selector(timerAction:)
                                                userInfo:nil
                                                repeats:YES] retain];
    attributes = General/[[NSDictionary alloc] initWithObjectsAndKeys:
                        General/[NSFont fontWithName:@"Helvetica-Bold" size:26], General/NSFontAttributeName,
                        General/[NSColor whiteColor], General/NSForegroundColorAttributeName, nil];
        
    count = 20;
}

- (void)dealloc {
    [originalIcon release];
    [iconImageBuffer release];
    [attributes release];
    [super dealloc];
}

- (void)timerAction:(General/NSTimer *)_timer {
    if (count < 0 && timer == _timer) {[timer invalidate]; [timer release]; timer = nil; return;}
    [self drawCountdownIcon:count--];
    
}

- (void)drawCountdownIcon:(int)number {
    
    General/NSString *countdown = General/[NSString stringWithFormat:@"%i", number];
    General/NSSize numSize = [countdown sizeWithAttributes:attributes];
    General/NSSize iconSize = [originalIcon size];
    if (number) {
        [iconImageBuffer lockFocus];
        [originalIcon drawAtPoint:General/NSMakePoint(0, 0)
            fromRect:General/NSMakeRect(0, 0, iconSize.width, iconSize.height) 
            operation:General/NSCompositeSourceOver 
            fraction:1.0f];
        float max = (numSize.width > numSize.height) ? numSize.width : numSize.height;
        max += 16;
        General/NSRect circleRect = General/NSMakeRect(iconSize.width - max, iconSize.height - max, max, max);
        General/NSBezierPath *bp = General/[NSBezierPath bezierPathWithOvalInRect:circleRect];
        General/[[NSColor colorWithCalibratedRed:0.8f green:0.0f blue:0.0f alpha:1.0f] set];
        [bp fill];
        [countdown drawAtPoint:General/NSMakePoint(General/NSMidX(circleRect) - numSize.width / 2.0f, 
                                            General/NSMidY(circleRect) - numSize.height / 2.0f + 2.0f) 
                    withAttributes:attributes];
        
        [iconImageBuffer unlockFocus];
        General/[NSApp setApplicationIconImage:iconImageBuffer];
    }
    else General/[NSApp setApplicationIconImage:originalIcon];
    
}




-- zootbobbalu


You Rock!  -General/EcumeDesJours

----

I found a very nice implementation available free here: http://blog.oofn.net/2006/01/08/badging-for-everyone/ --General/GrahamCox

----

Here's my implementation of a dock badge (like Acquisition's): http://johndevor.wordpress.com/2007/01/17/dock-badging-is-fun/ --General/JohnDevor

----

If you're using Leopard you can do the following: 

General/[[NSApp dockTile] setBadgeLabel:@"1000"];

Check out the source of  Transmission -- http://www.transmissionbt.com/ , the files Badger and General/BadgerView, if you need to do custom badge work or support pre-leopard machines.

General/MatthieuCormier