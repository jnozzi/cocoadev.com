[[ScreenSaverEngine]] is the Cocoa application that displays screen saver modules at the appropriate times (after so many minutes, when the cursor is in a hot-corner, etc.). It is part of the [[ScreenSaver]] system.

If necessary you can run the [[ScreenSaverEngine]] from Terminal:

<code>/System/Library/Frameworks/S<nowiki/>creenSaver.framework/Resources/S<nowiki/>creenSaverEngine.app/Contents/M<nowiki/>acOS/S<nowiki/>creenSaverEngine</code>

This is useful for running the engine under GDB for easy debugging.

The [[ScreenSaverEngine]] supports some special command line flags to aid in debugging:


* <code>-background</code> -- All screen saver windows appear behind all other windows (behind Finder icons but in front of the desktop image). The password and gamma fade features are disabled. It will not exit on mouse or keyboard activity.
* <code>-debug</code> -- Like <code>-background</code>, except mouse movement over the desktop causes it to exit. Very handy when running the [[ScreenSaverEngine]] in GDB. (Trying to get around my computer in this mode without causing it to exit reminds me of playing Don't Touch The Floor as a kid)
* <code>-module <module name></code> -- Loads the specified module rather than the module specified by the user defaults.

* <code><module name></code> accepts the same values as the <code>moduleName</code> node in <code>~/Library/Preferences/B<nowiki/>yHost/com.apple.screensaver.''.plist</code>
* For example, <code>Flurry</code>, <code>Abstract</code>, or <code>Spectrum</code>.
* It doesn't appear to accept full paths or [[URLs]] to <code>.saver</code>, <code>.slideSaver</code>, or <code>.qtz</code> files, however, so it's necessary to place the desired module in one of the typical [[ScreenSaver]] folders and reference it without the filename extension.