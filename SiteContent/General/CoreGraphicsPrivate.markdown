


The original header is available at http://svn.berlios.de/viewcvs/desktopmanager/General/DesktopManager/trunk/General/DesktopManager/General/CoreGraphics/General/CGSPrivate.h?view=markup and copied here for posterity. Another one may be found at the "Rotated windows" application (see http://homepage.cs.latrobe.edu.au/wjtregaskis/ and General/WildWindows)

The version here includes a description of General/CGSSetDebugOptions which can be used to tell the window server to do things like flash screen updates yellow (the same options the Quartz Debug application can set):  http://goo.gl/General/OeSCuhttp://code.google.com/p/satellitedisplays/source/browse/trunk/General/CGSPrivate.h

A comprehensive tutorial on using General/CoreGraphics for window transitions is found at http://lipidity.com/dev/tutorial/xcode-transitions-core-graphics-image-2 

    
/* General/CGSPrivate.h -- Header file for undocumented General/CoreGraphics stuff. */

/* General/DesktopManager -- A virtual desktop provider for OS X
 *
 * Copyright (C) 2003, 2004 Richard J Wareham <richwareham -at- users -d0t- sourceforge -dot- net>
 * This program is free software; you can redistribute it and/or modify it 
 * under the terms of the GNU General Public License as published by the Free 
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
 * for more details.
 *
 * You should have received a copy of the GNU General Public License along 
 * with this program; if not, write to the Free Software Foundation, Inc., 675 
 * Mass Ave, Cambridge, MA 02139, USA.
 */

#include <Carbon/Carbon.h>

/* These functions all return a status code. Typical General/CoreGraphics replies are:
    kCGErrorSuccess = 0,
    kCGErrorFirst = 1000,
    kCGErrorFailure = kCGErrorFirst,
    kCGErrorIllegalArgument = 1001,
    kCGErrorInvalidConnection = 1002,
*/

// Internal General/CoreGraphics typedefs
typedef int             General/CGSConnection;
typedef int             General/CGSWindow;
typedef int             General/CGSValue;

//// CONSTANTS ////

/* Window ordering mode. */
typedef enum _CGSWindowOrderingMode {
    kCGSOrderAbove                =  1, // Window is ordered above target.
    kCGSOrderBelow                = -1, // Window is ordered below target.
    kCGSOrderOut                  =  0  // Window is removed from the on-screen window list.
} General/CGSWindowOrderingMode;

// Internal General/CoreGraphics functions.

/* Retrieve the workspace number associated with the workspace currently
 * being shown.
 *
 * cid -- Current connection.
 * workspace -- Pointer to int value to be set to workspace number.
 */
extern General/OSStatus General/CGSGetWorkspace(const General/CGSConnection cid, int *workspace);

/* Retrieve workspace number associated with the workspace a particular window
 * resides on.
 *
 * cid -- Current connection.
 * wid -- Window number of window to examine.
 * workspace -- Pointer to int value to be set to workspace number.
 */
extern General/OSStatus General/CGSGetWindowWorkspace(const General/CGSConnection cid, const General/CGSWindow wid, int *workspace);

/* Show workspace associated with a workspace number.
 *
 * cid -- Current connection.
 * workspace -- Workspace number.
 */
extern General/OSStatus General/CGSSetWorkspace(const General/CGSConnection cid, int workspace);

typedef enum {
        General/CGSNone = 0,    // No transition effect.
        General/CGSFade,                // Cross-fade.
        General/CGSZoom,                // Zoom/fade towards us.
        General/CGSReveal,              // Reveal new desktop under old.
        General/CGSSlide,               // Slide old out and new in.
        General/CGSWarpFade,    // Warp old and fade out revealing new.
        General/CGSSwap,                // Swap desktops over graphically.
        General/CGSCube,                // The well-known cube effect.
        General/CGSWarpSwitch,   // Warp old, switch and un-warp.
	General/CGSFlip			// Flip over
} General/CGSTransitionType;

typedef enum {
        General/CGSDown,                                // Old desktop moves down.
        General/CGSLeft,                                // Old desktop moves left.
        General/CGSRight,                               // Old desktop moves right.
        General/CGSInRight,                             // General/CGSSwap: Old desktop moves into screen, 
                                                        //                      new comes from right.
        General/CGSBottomLeft = 5,              // General/CGSSwap: Old desktop moves to bl,
                                                        //                      new comes from tr.
        General/CGSBottomRight,                 // Old desktop to br, New from tl.
        General/CGSDownTopRight,                // General/CGSSwap: Old desktop moves down, new from tr.
        General/CGSUp,                                  // Old desktop moves up.
        General/CGSTopLeft,                             // Old desktop moves tl.
        
        General/CGSTopRight,                    // General/CGSSwap: old to tr. new from bl.
        General/CGSUpBottomRight,               // General/CGSSwap: old desktop up, new from br.
        General/CGSInBottom,                    // General/CGSSwap: old in, new from bottom.
        General/CGSLeftBottomRight,             // General/CGSSwap: old one moves left, new from br.
        General/CGSRightBottomLeft,             // General/CGSSwap: old one moves right, new from bl.
        General/CGSInBottomRight,               // General/CGSSwap: onl one in, new from br.
        General/CGSInOut                                // General/CGSSwap: old in, new out.
} General/CGSTransitionOption;

typedef enum {
        General/CGSTagExposeFade        = 0x0002,   // Fade out when Expose activates.
        General/CGSTagNoShadow          = 0x0008,   // No window shadow.
        General/CGSTagTransparent   = 0x0200,   // Transparent to mouse clicks.
        General/CGSTagSticky            = 0x0800,   // Appears on all workspaces.
} General/CGSWindowTag;

extern General/OSStatus General/CGSSetWorkspaceWithTransition(const General/CGSConnection cid,
        int workspaceNumber, General/CGSTransitionType transition, General/CGSTransitionOption subtype, 
        float time);
        
/* Get the default connection for the current process. */
extern General/CGSConnection _CGSDefaultConnection(void);

typedef struct {
        uint32_t unknown1;
        General/CGSTransitionType type;
        General/CGSTransitionOption option;
        General/CGSWindow wid; /* Can be 0 for full-screen */
        float *backColour; /* Null for black otherwise pointer to 3 float array with RGB value */
} General/CGSTransitionSpec;

/* Transition handling. */
extern General/OSStatus General/CGSNewTransition(const General/CGSConnection cid, const General/CGSTransitionSpec* spec, int *pTransitionHandle);
extern General/OSStatus General/CGSInvokeTransition(const General/CGSConnection cid, int transitionHandle, float duration);
extern General/OSStatus General/CGSReleaseTransition(const General/CGSConnection cid, int transitionHandle);

// thirtyTwo must = 32 for some reason. tags is pointer to 
//array ot ints (size 2?). First entry holds window tags.
// 0x0800 is sticky bit.
extern General/OSStatus General/CGSGetWindowTags(const General/CGSConnection cid, const General/CGSWindow wid, 
        General/CGSWindowTag *tags, int thirtyTwo);
extern General/OSStatus General/CGSSetWindowTags(const General/CGSConnection cid, const General/CGSWindow wid, 
        General/CGSWindowTag *tags, int thirtyTwo);
extern General/OSStatus General/CGSClearWindowTags(const General/CGSConnection cid, const General/CGSWindow wid, 
        General/CGSWindowTag *tags, int thirtyTwo);
extern General/OSStatus General/CGSGetWindowEventMask(const General/CGSConnection cid, const General/CGSWindow wid, uint32_t *mask);
extern General/OSStatus General/CGSSetWindowEventMask(const General/CGSConnection cid, const General/CGSWindow wid, uint32_t mask);

// Get on-screen window counts and lists.
extern General/OSStatus General/CGSGetWindowCount(const General/CGSConnection cid, General/CGSConnection targetCID, int* outCount); 
extern General/OSStatus General/CGSGetWindowList(const General/CGSConnection cid, General/CGSConnection targetCID, 
  int count, int* list, int* outCount);

// Get on-screen window counts and lists.
extern General/OSStatus General/CGSGetOnScreenWindowCount(const General/CGSConnection cid, General/CGSConnection targetCID, int* outCount); 
extern General/OSStatus General/CGSGetOnScreenWindowList(const General/CGSConnection cid, General/CGSConnection targetCID, 
  int count, int* list, int* outCount);

// Per-workspace window counts and lists.
extern General/OSStatus General/CGSGetWorkspaceWindowCount(const General/CGSConnection cid, int workspaceNumber, int *outCount);
extern General/OSStatus General/CGSGetWorkspaceWindowList(const General/CGSConnection cid, int workspaceNumber, int count, 
    int* list, int* outCount);

// Gets the level of a window
extern General/OSStatus General/CGSGetWindowLevel(const General/CGSConnection cid, General/CGSWindow wid, 
        int *level);
        
// Window ordering
extern General/OSStatus General/CGSOrderWindow(const General/CGSConnection cid, const General/CGSWindow wid, 
        General/CGSWindowOrderingMode place, General/CGSWindow relativeToWindowID /* can be NULL */);   

// Gets the screen rect for a window.
extern General/OSStatus General/CGSGetScreenRectForWindow(const General/CGSConnection cid, General/CGSWindow wid, 
        General/CGRect *outRect);

// Window appearance/position
extern General/OSStatus General/CGSSetWindowAlpha(const General/CGSConnection cid, const General/CGSWindow wid, float alpha);
extern General/OSStatus General/CGSSetWindowListAlpha(const General/CGSConnection cid, General/CGSWindow *wids, int count, float alpha);
extern General/OSStatus General/CGSGetWindowAlpha(const General/CGSConnection cid, const General/CGSWindow wid, float* alpha);
extern General/OSStatus General/CGSMoveWindow(const General/CGSConnection cid, const General/CGSWindow wid, General/CGPoint *point);
extern General/OSStatus General/CGSSetWindowTransform(const General/CGSConnection cid, const General/CGSWindow wid, General/CGAffineTransform transform); 
extern General/OSStatus General/CGSGetWindowTransform(const General/CGSConnection cid, const General/CGSWindow wid, General/CGAffineTransform * outTransform); 
extern General/OSStatus General/CGSSetWindowTransforms(const General/CGSConnection cid, General/CGSWindow *wids, General/CGAffineTransform *transform, int n); 

extern General/OSStatus General/CGSMoveWorkspaceWindows(const General/CGSConnection connection, int toWorkspace, int fromWorkspace);
extern General/OSStatus General/CGSMoveWorkspaceWindowList(const General/CGSConnection connection, General/CGSWindow *wids, int count, 
        int toWorkspace);

// extern General/OSStatus General/CGSConnectionGetPID(const General/CGSConnection cid, pid_t *pid, General/CGSConnection b);

extern General/OSStatus General/CGSGetWindowProperty(const General/CGSConnection cid, General/CGSWindow wid, General/CGSValue key,
        General/CGSValue *outValue);

//extern General/OSStatus General/CGSWindowAddRectToDirtyShape(const General/CGSConnection cid, const General/CGSWindow wid, General/CGRect *rect);
extern General/OSStatus General/CGSUncoverWindow(const General/CGSConnection cid, const General/CGSWindow wid);
extern General/OSStatus General/CGSFlushWindow(const General/CGSConnection cid, const General/CGSWindow wid, int unknown /* 0 works */ );

extern General/OSStatus General/CGSGetWindowOwner(const General/CGSConnection cid, const General/CGSWindow wid, General/CGSConnection *ownerCid);
extern General/OSStatus General/CGSConnectionGetPID(const General/CGSConnection cid, pid_t *pid, const General/CGSConnection ownerCid);

// Values
extern General/CGSValue General/CGSCreateCStringNoCopy(const char *str);
extern char* General/CGSCStringValue(General/CGSValue string);
extern int General/CGSIntegerValue(General/CGSValue intVal);


    


Another private General/CoreGraphics function for grabbing all windows in General/WindowServer here : http://www.objective-cocoa.org/forum/index.php?topic=1556.msg15898#msg15898
(in cocoa and in french, but easyly understandable).  Reproduced below for posterity.

    
static General/NSImage* General/GrabWindow(int wid)
{
    General/NSImage *img;
    int cid;
    General/CGRect cgrect;
    General/NSRect nsrect;
    void *grafport;

    // grab a context ID
    cid=General/[NSApp contextID];

    // get the rect of the window
    General/CGSGetWindowBounds(cid, wid, &cgrect);

    // turn the General/CGRect into an General/NSRect
    nsrect.origin.x=cgrect.origin.x;
    nsrect.origin.y=cgrect.origin.y;
    nsrect.size.width=cgrect.size.width;
    nsrect.size.height=cgrect.size.height;

    // create an General/NSImage
    img=General/[[NSImage alloc] initWithSize:nsrect.size];

    // lock focus on the image for drawing
    [img lockFocus];

    // get the graphics port for the image
    grafport=General/[[NSGraphicsContext currentContext] graphicsPort];

    // copy the contents of the window to the graphic context
    cgrect.origin=General/CGPointZero;

    // release the graphic context
    cgrect.origin=General/CGPointZero;
    General/CGContextCopyWindowCaptureContentsToRect(grafport, cgrect, cid, wid, 0);

    // retrait du contexte graphique de l'image mis en avant
    [img unlockFocus];

    // return the image
    return [img autorelease];
}


The window id type is an int you can get through a few channels.

*Undocumented _realWindowNumber method in the General/NSWindow class.
*documented windowNumber method in the General/NSWindow class.
*The General/NSWindowList function (documented).
*The General/CGSGetWindowList and General/CGSGetOnScreenWindowList from the (above) Core Graphics API.


*Thanks to Andrew Farmer for the following commentary for the above code, which I found through Google on cocoabuilder*


*Note : I am the coder of  the function General/GrabWindow() above. When I retro-engineered some Apple's applications (Grab and General/ScreenCapture) to discover the magic function to get window content (for developing a screen saver named Fenetres-Volantes), undocumented _realWindowNumber was used to obtain window id. Now, we can use the official method windowNumber from General/NSWindow class (I updated the "few channels" list). *

Note that [the above function] invokes a couple of private functions:

    General/OSStatus General/CGSGetWindowBounds(int cid, int wid, General/CGRect *ret);

    void General/CGContextCopyWindowCaptureContentsToRect(void *grafport, General/CGRect rect, int cid, int wid, int zero);

No, I don't know what the last parameter is for. The only program I know of that uses CGCWCCTR - screencapture - always passes a constant zero for the last argument.

There's also another useful function that gets invoked in the screencapture tool:

    
General/OSStatus General/CGSFindWindowByGeometry(int cid, int zero, int one, int zero_again,
                General/CGPoint *screen_point, General/CGPoint *window_coords_out,
                int *wid_out, int *cid_out);


This'll take a point in screen coordinates, specified by screen_point, and return the window ID of the frontmost window at that point (in wid_out), the General/WindowServer connection ID of that application (in cid_out), and the transformed coordinates of that point within the window (in window_coords_out).  There's actually no public *or* private API for the "click to select a window" interface that you get in screencapture; the tool just creates translucent overlay windows itself.
----
So, I've tried writing a little utility that would change the alpha value of any window, but it only works for windows in my application... What can I do to make it work with any cocoa window?
----
You can't.  A "special" connection to the General/WindowServer is required to mess with other application's windows, and this connection is maintained exclusively by the Dock.  If you quit the Dock you can take control of other windows... but good luck getting your users to ditch the dock :)