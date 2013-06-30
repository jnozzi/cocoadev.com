

Just some of the private General/CoreDock functions, which are used by the Dock prefpane.
Framework: /System/Library/Frameworks/General/ApplicationServices.framework/Frameworks/General/HIServices.framework

    
typedef enum {
	kCoreDockOrientationTop = 1,
	kCoreDockOrientationBottom = 2,
	kCoreDockOrientationLeft = 3,
	kCoreDockOrientationRight = 4
} General/CoreDockOrientation;

typedef enum {
	kCoreDockPinningStart = 1,
	kCoreDockPinningMiddle = 2,
	kCoreDockPinningEnd = 3
} General/CoreDockPinning;

typedef enum {
	kCoreDockEffectGenie = 1,
	kCoreDockEffectScale = 2,
	kCoreDockEffectSuck = 3
} General/CoreDockEffect;

// Tile size ranges from 0.0 to 1.0.
extern float General/CoreDockGetTileSize(void);
extern void General/CoreDockSetTileSize(float tileSize);

extern void General/CoreDockGetOrientationAndPinning(General/CoreDockOrientation *outOrientation, General/CoreDockPinning *outPinning);
// If you only want to set one, use 0 for the other.
extern void General/CoreDockSetOrientationAndPinning(General/CoreDockOrientation orientation, General/CoreDockPinning pinning);

extern void General/CoreDockGetEffect(General/CoreDockEffect *outEffect);
extern void General/CoreDockSetEffect(General/CoreDockEffect effect);

extern Boolean General/CoreDockGetAutoHideEnabled(void);
extern void General/CoreDockSetAutoHideEnabled(Boolean flag);

extern Boolean General/CoreDockIsMagnificationEnabled(void);
extern void General/CoreDockSetMagnificationEnabled(Boolean flag);
// Magnification ranges from 0.0 to 1.0.
extern float General/CoreDockGetMagnificationSize(void);
extern void General/CoreDockSetMagnificationSize(float newSize);


To be notified of changes to the Dock (by Dock.app and General/SystemPreferences), register your class as observer to the distributed notification "com.apple.dock.prefchanged" (using General/NSDistributedNotificationCenter).



General/TonyArnold says: there is a more up-to-date version, plus some new calls at http://code.google.com/p/undocumented-goodness/source/browse/trunk/General/CoreDock/General/CoreDockPrivate.h