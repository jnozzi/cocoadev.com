The enumerator that is used to mask General/NSEvent types. These correspond to user actions, like clicking, dragging hitting a key, using a scroll wheel, and even custom events that your application "makes up" (General/NSApplicationDefined).

    
General/NSEventType type = General/[NSEvent type];


See Apple's docs at http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSEvent.html .

Values (taken from Apple's General/AppKit Types and Constants page):
    
typedef enum _NSEventType {
   General/NSLeftMouseDown = 1,
   General/NSLeftMouseUp = 2,
   General/NSRightMouseDown = 3,
   General/NSRightMouseUp = 4,
   General/NSMouseMoved = 5,
   General/NSLeftMouseDragged = 6,
   General/NSRightMouseDragged = 7,
   General/NSMouseEntered = 8,
   General/NSMouseExited = 9,
   General/NSKeyDown = 10,
   General/NSKeyUp = 11,
   General/NSFlagsChanged = 12,
   General/NSAppKitDefined = 13,
   General/NSSystemDefined = 14,
   General/NSApplicationDefined = 15,
   General/NSPeriodic = 16,
   General/NSCursorUpdate = 17, 
   General/NSScrollWheel = 22,
   General/NSOtherMouseDown = 25,
   General/NSOtherMouseUp = 26,
   General/NSOtherMouseDragged = 27
} General/NSEventType;
