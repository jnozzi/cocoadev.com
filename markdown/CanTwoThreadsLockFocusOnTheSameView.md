Can two threads lock focus on the same view? Or does one thread block while the other thread completes its drawing?

The answer is: lockFocus makes no attempt to synchronize drawing between threads. Both threads will issue their drawing commands at the same time. This can have disastrous effects when drawing into General/NSOpenGLViews. The limitations on doing this kind of thing on normal views is less defined -- but it's probably not a good idea.

Here's a sample view that updates itself on two threads. Simply:


* Create a Cocoa app project
* Create a window w/ a custom view in it
* Create an General/NSView subclass object called "General/CustomView" and change your custom view's class from "General/NSView" to "General/CustomView"
* Copy the code below into your project, compile, and run. 


Best of luck!

-- General/MikeTrent

    

#import <Cocoa/Cocoa.h>

@interface General/CustomView : General/NSView
{
    BOOL _forkedThread;
    General/NSTimer *_fgTimer;
    General/NSTimer *_bgTimer;
    BOOL _drawGreen;
    
    int _privateData;
    General/NSLock *_drawLock;
}
@end

@implementation General/CustomView

- (void)drawRect:(General/NSRect)rect
{
    BOOL resetFlag = YES;
    General/NSColor *color;

    // do some drawing work, lock if necessary (see below)
    [_drawLock lock];
    
        if (_privateData == 1) {
            General/NSLog(@"looks like someone else locked focus?");
            resetFlag = NO;
        } else {
            _privateData = 1;
        }
    
        color = _drawGreen ? General/[NSColor greenColor] : General/[NSColor blueColor];
        [color set];
        General/NSRectFill(rect); 
        _drawGreen = !_drawGreen;   
            
        if (resetFlag) {
            _privateData = 0;
        }
    
    [_drawLock unlock];
    
    // manually setup a foreground refresh
    if (!_fgTimer) {
        _fgTimer = General/[[NSTimer
                scheduledTimerWithTimeInterval:(1.0/30.0)
                                        target:self
                                        selector:@selector(fgDraw:)
                                        userInfo:nil
                                        repeats:YES] retain];
    }

    // manually setup a background refresh
    if (!_forkedThread) {
        _forkedThread = YES;
        General/[NSApplication detachDrawingThread:@selector(startBGThread:)
                                  toTarget:self 
                                withObject:nil];
        
        // uncomment below to run w/ manual locking.
        // comment below to see if lockFocus implies locking when drawing.
        //_drawLock = General/[[NSLock alloc] init];
    }
}

// prep work for running a selector on another thread 
- (void)startBGThread:(id)sender
{
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];
    General/NSRunLoop *runLoop = General/[NSRunLoop currentRunLoop];

    _bgTimer = General/[[NSTimer
              scheduledTimerWithTimeInterval:(1.0/30.0)
                                      target:self
                                    selector:@selector(bgDraw:)
                                    userInfo:nil
                                     repeats:YES] retain];

    [pool release];
    
    while (_bgTimer) {
        General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];
        [runLoop runUntilDate:General/[NSDate dateWithTimeIntervalSinceNow:(1.0/30.0)]];
        [pool release];
    }
}

// manually draw on foreground (normally one would use setNeedsDisplay: for this)
- (void)fgDraw:(General/NSTimer*)timer
{
    [self lockFocus];
    [self drawRect:[self bounds]];
    [self unlockFocus];
    General/self window] flushWindow];
}

// manually draw on background
- (void)bgDraw:([[NSTimer*)timer
{
    [self lockFocus];
    [self drawRect:[self bounds]];
    [self unlockFocus];
    [[self window] flushWindow];
}

@end

