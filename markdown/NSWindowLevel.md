
*     General/NSNormalWindowLevel - The default level for General/NSWindow objects.
*     General/NSFloatingWindowLevel - Useful for floating palettes.
*     General/NSSubmenuWindowLevel - Reserved for submenus. Synonymous with General/NSTornOffMenuWindowLevel, which is preferred.
*     General/NSTornOffMenuWindowLevel - The level for a torn-off menu. Synonymous with General/NSSubmenuWindowLevel.
*     General/NSModalPanelWindowLevel - The level for a modal panel.
*     General/NSMainMenuWindowLevel - Reserved for the application�s main menu.
*     General/NSStatusWindowLevel - The level for a status window.
*     General/NSPopUpMenuWindowLevel - The level for a pop-up menu.
*     General/NSScreenSaverWindowLevel - The level for a screen saver.
*     kCGDesktopWindowLevel - Under the desktop. (Still accepts mousedown so desktop is useless where the window is located)


Another useful way to specify window level is with     -General/[NSWindow addChildWindow:ordered:].  This allows you to place a window always directly over or under a related window (and will also cause drags of the parent to drag the child as well).  Think of a sheet.

see also

*General/WindowAlwaysInFront
*General/SplashWindow
*General/GlobalFloatingWindow
*General/PopOutWindowFromTitleBar