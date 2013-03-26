Is there any way to continue rendering a [[QCRenderer]] while clicking buttons or resizing your window?  I have a custom view rendering a Quartz composition with a [[QCRenderer]] and a video feed in the composition and the video feed refreshs with an [[NSTimer]], and when I click a button or anything like that it freezes the [[NSView]] that I'm rendering to.  Also if I do expose and then move the window I get a repeated flashing in the [[NSView]].  Is there anyway to fix this?

Heres the code:
<code>
      . . .
//I looked to the Quartz Composer Programming guide for some of this
[[NSOpenGLPixelFormatAttribute]]	attributes[] = {[[NSOpenGLPFAAccelerated]], [[NSOpenGLPFANoRecovery]],       [[NSOpenGLPFADoubleBuffer]],    [[NSOpenGLPFADepthSize]], 24, 0};
	long swapInterval = 1;
	[[NSString]] ''path;
	[[NSString]] ''videoPath;
	
	pixelFormat = [[[[NSOpenGLPixelFormat]] alloc] initWithAttributes:attributes];
	context = [[[[NSOpenGLContext]] alloc] initWithFormat:pixelFormat shareContext:nil];
	[context setValues:&swapInterval forParameter:[[NSOpenGLCPSwapInterval]]];

	//We need to know when the rendering view frame changes so that we can update the [[OpenGL]] contex
	
	[context setView: qcView];
	path = [[[[NSBundle]] mainBundle] pathForResource:@"Billboard" ofType:@"qtz"];
	videoPath = [[[[NSBundle]] mainBundle] pathForResource:@"Video" ofType:@"qtz"];
	
	videoRenderer = [[[[QCRenderer]] alloc] initWithOpenGLContext:context pixelFormat:pixelFormat file:videoPath];
	renderer = [[[[QCRenderer]] alloc] initWithOpenGLContext:context pixelFormat:pixelFormat file:path];

	//Render timer for rendering Quartz and feeding it the video.
	#define kRendererFPS 30.0
 
	renderTimer = [[[[NSTimer]] scheduledTimerWithTimeInterval:(1.0 /
                                ([[NSTimeInterval]])kRendererFPS)
                        target:self
                        selector:@selector(renderFrame:)
                        userInfo:nil
                        repeats:YES]
                        retain];
}
- (void)renderFrame:([[NSTimer]] '')timer
{
	[self renderWithEvent:nil];
}
- (void) renderWithEvent:([[NSEvent]]'')event
{
    [[NSTimeInterval]]  time = [[[NSDate]] timeIntervalSinceReferenceDate];
	
	if(startTime == 0)
    {
        startTime = time;
        time = 0;
    }
    else
        time -= startTime;
	[videoRenderer renderAtTime:time arguments:nil];
	[renderer setValue:[videoRenderer valueForOutputKey:@"Video"] forInputKey:@"Image"];
	[renderer renderAtTime:time arguments:nil];
	[context flushBuffer];
}
</code>

----

You need to add your timer to additional run-loop modes. The sheduledTimer... call only adds it to the default runloop mode which is interrupted by resizes, menu pulldowns and lots of other stuff. From the docs: "The [[NSTimer]] class method scheduledTimerWithTimeInterval:invocation:repeats:, for example, creates a new timer object and adds it to the [[NSDefaultRunLoopMode]] mode of the current run loop. If you instead create the timer with timerWithTimeInterval:invocation:repeats:, you must add it manually to the run loop with the [[NSRunLoop]] instance method addTimer:forMode:, which allows you to specify a different mode." The mode you need to add it to is [[NSEventTrackingRunLoopMode]]. This is basically the same problem as [[NSTimerDoesntRunWhenMenuClicked]] --[[GrahamCox]]

----
Thanks, really appreciate it.