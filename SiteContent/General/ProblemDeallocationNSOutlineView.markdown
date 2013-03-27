I've got some problem with programmatically creating a window showing a General/NSOutlineView object.

For some reason I do not want to use Interface Builder to create that window and view.
Somehow I manage to bring the window including the outline view on screen. For that I need
to use alloc-method several times. Going on in the program I want to hide only the General/NSOutlineView object (with General/NSScrollView and General/NSClipView) and freeing the memory. The window should stay alive.
I tried to use release at appropriate times. But, PROBLEM: when I release one of the views after its retainCount is down to 1, so it should be deallocated now, my application is crashing.
Error message: myApplication has exited due to signal 11 (SIGSEGV)

Can anyone please explain to me, how I can create the needed General/NSOutlineView and deallocate it the right way?

Strange observation: the crashing occours only when I use setDocumentView- or setContentView-method.

here is my test code that does not work:

----
General/MyOutlineView.h:
    
#import <Cocoa/Cocoa.h>
@interface General/MyOutlineView : General/NSObject
{
  General/NSWindow	 	*window;
  General/NSScrollView 		*scrollView;
}
- (General/IBAction)clear:(id)sender;
@end

----
General/MyOutlineView.m:
    
#import "General/MyOutlineView.h"
@implementation General/MyOutlineView
- (void)applicationDidFinishLaunching:(General/NSNotification *)aNotification
{
  /* preparing some frame for window's contentView and all other views (unimportant now) */
  General/NSRect contentRect;
  contentRect.size.width = 270.;
  contentRect.size.height = 180.;
  contentRect.origin.x = 0.;
  contentRect.origin.y = 0.;
  /* any style for window (unimportant now) */
  unsigned int styleMask = General/NSTitledWindowMask | General/NSClosableWindowMask;
  /* allocating and initializing General/NSOutlineView, General/NSClipView and General/NSScrollView */
  General/NSOutlineView *outlineView = General/[[NSOutlineView alloc] initWithFrame:contentRect];
  General/NSClipView *clipView = General/[[NSClipView alloc] initWithFrame:contentRect];
  scrollView = General/[[NSScrollView alloc] initWithFrame:contentRect];
  /* setting outlineView as documentView of clipView and clipView as contentView of scrollView */
  [clipView setDocumentView:outlineView];
  [scrollView setContentView:clipView];
  /* allocating and initializing General/NSWindow */
  window = General/[[NSWindow alloc] initWithContentRect:contentRect styleMask:styleMask backing:General/NSBackingStoreBuffered defer:NO];
  /* setting scrollView as window's contentView */
  General/window contentView] addSubview:scrollView];
  /* showing window */
  [window makeKeyAndOrderFront:self];
}  

- ([[IBAction)clear:(id)sender
{
  /* cut connection between scrollView and window */
  [scrollView removeFromSuperview];
  General/NSLog(@"[scrollView retainCount] %d", [scrollView retainCount]);
  [scrollView release]; //scrollView got second retain from General/NSView's addSubview-method
  /* if you close the window before pressing command-o scrollView will be released by that ones. So at this point only one release would be enought. */
  General/NSLog(@"[scrollView retainCount] %d", [scrollView retainCount]);
  [scrollView release];//scrollView got first retain from alloc
  scrollView = nil;
  General/NSLog(@"[scrollView retainCount] %d", [scrollView retainCount]);
}
@end
