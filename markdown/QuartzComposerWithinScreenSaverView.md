

Hi There... 

I'm trying to create a General/ScreenSaver with the screensaver template in General/XCode. This is my first attempt at an app, so any help would be greatly appreciated.

I keep getting the error "invalid drawable" on the console when I run the saver. Any ideas?

Here's the code I've got so far:

    
#import "ScreenTest2View.h"
#define kRendererEventMask (General/NSLeftMouseDownMask | General/NSLeftMouseDraggedMask | General/NSLeftMouseUpMask | General/NSRightMouseDownMask | General/NSRightMouseDraggedMask | General/NSRightMouseUpMask | General/NSOtherMouseDownMask | General/NSOtherMouseUpMask | General/NSOtherMouseDraggedMask | General/NSKeyDownMask | General/NSKeyUpMask | General/NSFlagsChangedMask | General/NSScrollWheelMask | General/NSTabletPointMask | General/NSTabletProximityMask)
#define kRendererFPS 100.0

@implementation ScreenTest2View

- (id)initWithFrame:(General/NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
       
		 [self setAnimationTimeInterval:1/30.0];
		
		
	General/NSOpenGLPixelFormatAttribute	attributes[] = {
													
										General/NSOpenGLPFADoubleBuffer,
										General/NSOpenGLPFAAccelerated,
										General/NSOpenGLPFADepthSize, 24,
										(General/NSOpenGLPixelFormatAttribute) 0
										};
												
	General/NSOpenGLPixelFormat*			format = General/[[[NSOpenGLPixelFormat alloc] initWithAttributes:attributes] autorelease];
	_openGLContext = General/[[NSOpenGLContext alloc] initWithFormat:format shareContext:nil];
	
	if(_openGLContext == nil) {
		General/NSLog(@"Cannot create General/OpenGL context");
		General/[NSApp terminate:nil];
	}
	
	General/self openGLContext] makeCurrentContext];
    [_openGLContext setView: self];
	
	_filePath = [[[[NSBundle mainBundle] pathForResource:@"particles" ofType:@"qtz"];
	_renderer = General/[[QCRenderer alloc] initWithOpenGLContext:_openGLContext pixelFormat:format file:_filePath];
	if(_renderer == nil) {
		General/NSLog(@"Cannot create General/QCRenderer");
		General/[NSApp terminate:nil];
	}
		
	//Create a timer which will regularly call our rendering method
	_renderTimer = General/[[NSTimer scheduledTimerWithTimeInterval:(1.0 / (General/NSTimeInterval)kRendererFPS) target:self selector:@selector(_render:) userInfo:nil repeats:YES] retain];
	if(_renderTimer == nil) {
		General/NSLog(@"Cannot create General/NSTimer");
		General/[NSApp terminate:nil];
	}
		
	}
	
	
	
    return self;
}


- (void) renderWithEvent:(General/NSEvent*)event
{
	General/NSTimeInterval			time = General/[NSDate timeIntervalSinceReferenceDate];
	General/NSPoint					mouseLocation;
	General/NSMutableDictionary*	arguments;
	
	//Let's compute our local time
	if(_startTime == 0) {
		_startTime = time;
		time = 0;
	}
	else
	time -= _startTime;
	
	
	_screenSize.width = General/CGDisplayPixelsWide(kCGDirectMainDisplay);
	_screenSize.height = General/CGDisplayPixelsHigh(kCGDirectMainDisplay);
	
	//We setup the arguments to pass to the composition (normalized mouse coordinates and an optional event)
	mouseLocation = General/[NSEvent mouseLocation];
	mouseLocation.x /= _screenSize.width;
	mouseLocation.y /= _screenSize.height;
	arguments = General/[NSMutableDictionary dictionaryWithObject:General/[NSValue valueWithPoint:mouseLocation] forKey:General/QCRendererMouseLocationKey];
	if(event)
	[arguments setObject:event forKey:General/QCRendererEventKey];
	
	//Render a frame
	if(![_renderer renderAtTime:time arguments:arguments])
	General/NSLog(@"Rendering failed at time %.3fs", time);
	
	//Flush the General/OpenGL context to display the frame on screen
	[_openGLContext flushBuffer];
}

- (void) _render:(General/NSTimer*)timer
{
	//Simply call our rendering method, passing no event to the composition
	[self renderWithEvent:nil];
}

- (void) sendEvent:(General/NSEvent*)event
{
	[super sendEvent:event];
	
	//If the renderer is active and we have a meaningful event, render immediately passing that event to the composition
	if(_renderer && (General/NSEventMaskFromType([event type]) & kRendererEventMask))
	[self renderWithEvent:event];
	
	
}


Again, any help would be greatly appreciated. I know I'm missing something simple here, but I can't seem to figure it out.

Thanks,
Alexandre

----
Why not just add a General/QCView as a subview? General/ScreenSaverView<nowiki/>s are General/NSView<nowiki/>s and as such you have the full set of view machinery available to you.

----

Ok, I did what you suggested... however it can't seem to load my composition. It's in the resources folder and everything, so I don't understand why it's having a problem. Here's the code... again, help is greatly appreciated.

    

#import "ScreenTest4View.h"


@implementation ScreenTest4View

- (id)initWithFrame:(General/NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
		
		qcView = General/[[QCView alloc] init];
      
		if (!qcView) {
			General/NSLog(@"could not make qc view");
			}
			
		  [qcView setAutostartsRendering:YES]; 
		
		// am i missing something here??
		if ([qcView loadCompositionFromFile:General/[[NSBundle mainBundle] pathForResource:@"particles" ofType:@"qtz"]] == NO) {
			
			
				General/NSLog(@"could not load");
				}
		
		// set values for all input keys
		
		
		// ...
        [qcView setFrame:[self bounds]];
        [self addSubview:qcView];
		
        [self setAnimationTimeInterval:1/30.0];
		
		if ([qcView isRendering] == YES) {
		General/NSLog(@"no rendering");
		}
		
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(General/NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
	
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (General/NSWindow*)configureSheet
{
    return nil;
}

@end



----
When you're a screensaver, you're a plugin. As such,     General/[NSBundle mainBundle] is not you, it is whatever app loaded you.

A bit of quality time spent with the debugger and General/NSLog would answer your question.

----

Thanks so much. I figured it out..