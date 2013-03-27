    
/*
    Call 			no# args	arg 			type
	
    General/CGSEndContext		1 argument	?			int				-- possibly unneeded by General/CGContextFlush
    General/CGSFlushContext		1 argument 	?			int				-- use General/CGContextFlush instead
    General/CGSImage			2 arguments	?, ?			int , int
    General/CGContextSetAlpha		1 argument 	?			int
    General/CGSScaleCTM			2 arguments	?, ?			float, float
    General/CGSTranslateCTM		2 arguments 	?, ?			float, float
    General/CGSSetGStateAttribute	3 arguments	?, ?, ?			int,int,int
    General/CGSUniqueCString		1 argument	?			int 		(constant 0x1fa8)
    General/CGSReadObjectFromCString	1 argument	?			int		(constant 0x2140)
    General/CGSClearContext		1 argument	?			int
    General/CGSGetWindowAlpha		3 argument	?,?,?			int,int,int
    General/CGSPutBooleanForCStringKey	3 arguments	?,?,?			int,int,int
    General/CGSPutIntegerForCStringKey	3 arguments	?,?,?			int,int,int
    General/CGSCreateDictionary		1 argument	?			int
    General/CGSReleaseWindow		2 arguments	?,?			int,int    -- deprecated? use General/CGContextRelease?
    General/CGSSetWindowWarp		5 arguments	?,?,?,?,?		int,int,int,int,int
    General/CGSSetBackgroundEventMaskAndShape 3 args	?,?,?			int,int,int
    General/CGSInputModifierKeyState	2 arguments	?,?			int,int 	(const arg1=0,arg2=variable)
    General/CGSGetScreenRectForWindow	1(2?) arguments ?,(?)			int,(int)
    General/CGSSetFillPattern		2 args		?,?			int,int
    General/CGSCurrentInputPointerPosition 1 args	?			int
    General/CGSSetWindowClipShape	3 arguments	?,?,?			int,int,int
    General/CGSGetScreenRectForWindow	2 arguments	?,?			int,int
    General/CGSGetWindowFlushSeed	3 arguments	?,?,?			int,int,int
    General/CGSGetCurrentCursorLocation 1 argument	?			int
*/

#ifndef _CGS_HACK_H
#define _CGS_HACK_H

#include <Carbon/Carbon.h> /* for General/ProcessSerialNumber */

typedef void *General/CGSConnectionID;
typedef void *General/CGSValueObj;
typedef void *General/CGSRegionObj;
typedef void *General/CGSBoundingShapeObj;

typedef enum _CGSWindowOrderingMode {
    kCGSOrderAbove                =  1,
    kCGSOrderBelow                = -1,
    kCGSOrderOut                  =  0
} General/CGSWindowOrderingMode;

#define kCGSNullConnectionID ((General/CGSConnectionID)0)

extern General/CGSConnectionID _CGSDefaultConnection(void);

extern void General/CGSReenableUpdate(General/CGSConnectionID cid);
extern void General/CGSDisableUpdate(General/CGSConnectionID cid);

extern General/OSStatus General/CGSSetWindowTransforms(const General/CGSConnectionID cid, General/CGWindowID *wid, General/CGAffineTransform *transform, int n);
extern General/OSStatus General/CGSSetWindowTransform(const General/CGSConnectionID cid, General/CGWindowID wid, General/CGAffineTransform transform);

extern General/OSStatus General/CGSGetWindowTransform(const General/CGSConnectionID, General/CGWindowID wid, General/CGAffineTransform *outTransform);
    
// questionable, partly guessed IIRC.
extern General/OSStatus General/CGSSetSharedWindowState(const General/CGSConnectionID cid, General/CGWindowID wid, General/CGSValueObj boolean);
extern General/OSStatus General/CGSSetWindowAlpha(const General/CGSConnectionID cid, General/CGWindowID wid, float alpha);
    
extern General/OSStatus General/CGSSetWindowProperty(const General/CGSConnectionID cid, General/CGWindowID wid, General/CGSValueObj key, General/CGSValueObj value);

extern General/CGSValueObj General/CGSCreateCString(char *string);
extern General/CGSValueObj General/CGSCreateBoolean(Boolean bool);
extern void General/CGSReleaseGenericObj(General/CGSValueObj obj);

extern General/OSStatus General/CGSOrderWindow(General/CGSConnectionID cid, General/CGWindowID wid, General/CGSWindowOrderingMode place, General/CGWindowID relativeToWindowID /* can be NULL */);

extern void General/CGSNewRegionWithRect(const General/CGRect *aRectangle, General/CGSRegionObj *outRegionObj);
extern General/OSStatus General/CGSReleaseRegion(General/CGSRegionObj);
extern void General/CGSGetRegionBounds(const General/CGSRegionObj aRegion, General/CGRect *outRect);

extern void General/CGSSetWindowOpacity(General/CGSConnectionID cid, General/CGWindowID wid, void* opacity /* kCGSFalse, is that a General/CGSValueObj or standard char? */);

extern General/OSStatus General/CGSNewConnection(void *something /* can be NULL, parent connection? */, General/CGSConnectionID *outID);
extern General/OSStatus General/CGSReleaseConnection(General/CGSConnectionID cid);
extern void General/CGSInitialize();

extern General/OSStatus General/CGSGetConnectionIDForPSN(const General/CGSConnectionID cid, General/ProcessSerialNumber *psn, General/CGSConnectionID *out);

// random hack constants for General/CGSSetDebugOptions
#define kCGSDebugOptionNormal 0
#define kCGSDebugOptionNoShadows 16384
#define kCGSHDumpWindowInfoToFile (0x8000<<16)|1

extern General/OSStatus General/CGSSetDebugOptions(unsigned long);

// only works if you kill the dock, then stops dock from relaunching
extern General/OSStatus General/CGSSetUniversalOwner(const General/CGSConnectionID cid, int);
// apparently a nop
extern General/OSStatus General/CGSSetOtherUniversalConnection(const General/CGSConnectionID cid);

extern General/OSStatus General/CGSGetScreenRectForWindow(General/CGSConnectionID cid, General/CGWindowID wid, General/CGRect *outRect);
extern General/OSStatus General/CGSMoveWindow(General/CGSConnectionID cid, General/CGWindowID wid, General/CGPoint *aPoint);

extern General/OSStatus General/CGSGetWindowLevel(General/CGSConnectionID cid, General/CGWindowID wid, General/CGWindowLevel *level);
extern General/OSStatus General/CGSGetWindowBounds(General/CGSConnectionID cid, General/CGWindowID wid, General/CGRect *bounds);

extern General/CGWindowID General/CGSDesktopWindow(void);

extern General/OSStatus General/CGSSetWindowLevel(General/CGSConnectionID cid, General/CGWindowID wid, General/CGWindowLevel level);

#endif /* _CGS_HACK_H */


----

I removed the General/CGSWindowID type, as it's actually the same as the General/CGWindowID type that's publicly defined. -General/JonathanGrynspan