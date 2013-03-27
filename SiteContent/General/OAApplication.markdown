Part of the General/OmniAppKit.

General/OAApplication is a subclass of General/NSApplication that provides some useful functionality for applications using the General/OmniAppKit.

Mainly it is useful for the fact that it triggers <code> General/[OBPostLoader processClasses]</code>, which you need to use General/OmniAppKitPreferences.

Also, though, it defines some methods to access the preferences dialog, the software update checking framework that General/OmniAppKit provides, and the General/OAInspector.

Use it by setting your main application class to General/OAApplication instead of General/NSApplication in your target settings window.