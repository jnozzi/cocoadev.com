

I have an General/NSOpenGLView that reshapes fine when it is the content view of a window, but when I place this view in an General/NSSplitView the General/NSOpenGLView does not autoresize very well. When the divider of the split view is changing the size of the General/NSOpenGLView the visible space for the glView does not get flushed properly. Artifacts are left from the trailing edge of the divider and even the content of a neighboring view that is being decreased in size will be left as artifacts in the space reserved for the glView. Anyone else have this problem?

----

I've never had the problem; but then, I've never put an General/NSOpenGLView into a split-pane. If I were you, I'd write a throwaway app with a simple General/NSOpenGLView that just draws a rectangle or something. You can put in General/NSLog traces to resize events and calls to draw and so on an figure out what's getting foobarred.

--General/ShamylZakariya

----

I'm guessing that General/NSOpenGLView is using a child window to do its drawing. A child window that gets cropped by a subview placed in a splitview acts the same way. --zootbobbalu

----

Here's a solution to this problem I ran across today. 

http://developer.apple.com/samplecode/General/GLChildWindowDemo/General/GLChildWindowDemo.html

The basic idea is to use a Carbon hack to get the view to sync with the live resizing coordinated by a split view. You have to subclass the view's window and add these two methods.     needsEnableUpdate is an instance variable of type     BOOL. 

    

- (void)disableUpdatesUntilFlush {
	if (!needsEnableUpdate) General/DisableScreenUpdates();
	needsEnableUpdate = YES;
}

- (void)flushWindow {
	[super flushWindow];
	if (needsEnableUpdate) {
		needsEnableUpdate = NO;
		General/EnableScreenUpdates();
	}
}



Then you have to modify the General/NSOpenGLView subclass to disable window updates temporarily while the split view is resizing.

    

- (void)viewWillMoveToWindow:(General/NSWindow *)win {
	if ([win respondsToSelector:@selector(disableUpdatesUntilFlush)]) {
		General/[[NSNotificationCenter defaultCenter] addObserver:self
			selector:@selector(splitViewWillResizeSubviewsNotification:)
			name:General/NSSplitViewWillResizeSubviewsNotification
			object:enclosingSplitView];
	}
}

- (void)splitViewWillResizeSubviewsNotification:(General/NSNotification *)note {
	General/self window] performSelector:@selector(disableUpdatesUntilFlush)];
}

- (void)dealloc {
	[[[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}



--zootbobbalu