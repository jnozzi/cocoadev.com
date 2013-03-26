

Hi,
I have created an [[NSButton]] subclass along with an [[NSButtonCell]] subclass. I am using this in an [[NSToolbar]], however there is 2 problems.

1. When I run the toolbar customization palette I get the following:

''
2005-03-27 02:18:48.853 [[TestApp]][16011] Exception raised during posting of notification.  Ignored.  exception: Window: discardTrackingRect called before adding rect

2005-03-27 02:18:48.854 [[TestApp]][16011] ''''' Assertion failure in -[[[NSToolbarConfigPanel]] _discardTrackingRect:], [[AppKit]].subproj/[[NSWindow]].m:2796
''

I have heard that I need to removed my tracking rects here:
<code>
- (void)viewWillMoveToWindow:([[NSWindow]]'')newWindow {

[super viewWillMoveToWindow:newWindow];
}
</code>
However I have not created any, the button created them from mousEntered: and mouseExited:.

2. When the toolbar customization palette resigns the button is drawn blank. This may be because of point 1.

Any help would be most appreciated.

-Julian

----

Just pass the message up to super from your subclass implementation

----
Resolved with use of custom tracking rects.