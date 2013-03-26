
* <code>[[NSNormalWindowLevel]]</code> - The default level for [[NSWindow]] objects.
* <code>[[NSFloatingWindowLevel]]</code> - Useful for floating palettes.
* <code>[[NSSubmenuWindowLevel]]</code> - Reserved for submenus. Synonymous with [[NSTornOffMenuWindowLevel]], which is preferred.
* <code>[[NSTornOffMenuWindowLevel]]</code> - The level for a torn-off menu. Synonymous with [[NSSubmenuWindowLevel]].
* <code>[[NSModalPanelWindowLevel]]</code> - The level for a modal panel.
* <code>[[NSMainMenuWindowLevel]]</code> - Reserved for the application�s main menu.
* <code>[[NSStatusWindowLevel]]</code> - The level for a status window.
* <code>[[NSPopUpMenuWindowLevel]]</code> - The level for a pop-up menu.
* <code>[[NSScreenSaverWindowLevel]]</code> - The level for a screen saver.
* <code>kCGDesktopWindowLevel</code> - Under the desktop. (Still accepts mousedown so desktop is useless where the window is located)


Another useful way to specify window level is with <code>-[[[NSWindow]] addChildWindow:ordered:]</code>.  This allows you to place a window always directly over or under a related window (and will also cause drags of the parent to drag the child as well).  Think of a sheet.

see also

*[[WindowAlwaysInFront]]
*[[SplashWindow]]
*[[GlobalFloatingWindow]]
*[[PopOutWindowFromTitleBar]]