I am wondering if anyone has an idea of how to pop a window/panel out from the menu bar (The same way as in the app: General/LaunchBar). I cannot find a way to get a window above title bar, anyone know of a way to do this?

----

You need to create the window with General/NSBorderlessWindowMask and General/NSFloatingWindowLevel and position it just below the menu bar when it's opened.

See General/BorderlessWindow General/WindowAlwaysInFront and General/NSWindowLevel