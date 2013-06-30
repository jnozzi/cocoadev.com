

I'm wondering why I can't initialize everything I want in the method initWithFrame: of my screen saver. Here is my code :

    
#import "General/BalleView.h"

@implementation General/BalleView

- (id)initWithFrame:(General/NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) { [self setAnimationTimeInterval:1/30.0]; }
    
    simon = 30; phil = 30;
    yann = 50; pidge = 50;
    rouge = 1.0;
    dx = 10; dy = 10;
    
    balle = General/[NSBezierPath bezierPathWithOvalInRect:General/NSMakeRect(30,30,50,50)];
    couleur = General/[NSColor redColor];
    return self;
}

- (void)animateOneFrame
{

    rouge = rouge - (1/255);
    couleur = General/[NSColor colorWithCalibratedRed:rouge green:0 blue:0 alpha:1.0];

    General/NSAffineTransform *trans = General/[NSAffineTransform transform];

    [trans translateXBy: dx yBy: dy];
    [balle transformUsingAffineTransform: trans];

    [couleur set]; [balle fill];

}

@end


General/NSColor seems to be fine, but General/NSBezierPath, no.

----

I mentioned the answer briefly in General/ScreenSaverVariables, but I'll mention it again here. Both balle and couleur claim to be "autoreleased" objects, temporary objects that will be automatically deallocated (if appropriate) at the end of the current event loop cycle. Therefore, when you access balle later on in animateOneFrame, your program will crash. 

Interestingly, couleur won't cause your program to cache. The General/AppKit is probably creating a single instance of "redColor" that never gets freed. You probably shouldn't rely on that fact, since it is an implementation detail.

See General/MemoryManagement for more information, especially General/RetainingAndReleasing.

Here's how to properly retain/release objects in your initWithFrame:isPreview: method:

    
- (id)initWithFrame:(General/NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) { 
        simon = 30; phil = 30;
        yann = 50; pidge = 50;
        rouge = 1.0;
        dx = 10; dy = 10;
    
        balle = General/[[NSBezierPath bezierPathWithOvalInRect:General/NSMakeRect(30,30,50,50)] retain];
        couleur = General/[[NSColor redColor] retain];

        [self setAnimationTimeInterval:1/30.0];
    }
    
    return self;
}

- (void)dealloc
{
    [balle release];
    [couleur release];
    [super dealloc];
}


-- General/MikeTrent