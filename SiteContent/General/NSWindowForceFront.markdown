How do you force a window to stay in the foreground (i.e. Force Quit Window). I tried   [myWindow orderFrontRegardless] and this doesn't work.

----

Use a Panel instead of a Window and select the Utility Window checkbox in its info panel in General/InterfaceBuilder. -- Bo

Or just call [window setLevel:General/NSFloatingWindowLevel]; if you don't want the full range of General/NSPanel behaviors.

----

see also General/WindowAlwaysInFront