


The General/ScreenSaver framework is a set of classes for working with Mac OS X's built-in screen saver. The framework first appeared in Mac OS X Public Beta, and public headers and documentation followed in Mac OS X 10.0.

See also: General/BuildingScreenSavers.

The General/ScreenSaver framework exports these classes:


* General/ScreenSaverView - A class that extends General/NSView by adding animation timer API. It also serves as the main controller for screen saver modules.

* General/ScreenSaverDefaults - Since screen saver modules can be re-used by many apps (General/ScreenSaverEngine, the screen saver pref pane, and most recently General/SaverLab, by Dozing Cat Software) Foundation's General/NSUserDefaults class cannot be conveniently used to get user defaults for screen saver modules. General/ScreenSaverDefaults provides a convenient way to do this.


The General/ScreenSaver framework also includes some handy utility in-line functions for generating random numbers and doing some common geometric shortcuts. These functions are buried inside General/ScreenSaverView.h.

General/ScreenSaver documentation is included in Mac OS X's Developer CD. Once the Developer packages are installed, the documentation can be found here:

**[Mac OS X 10.0]** /Developer/Documentation/General/ReleaseNotes/General/ScreenSaver

**[Mac OS X 10.1]** /Developer/Documentation/General/AdditionalTechnologies/General/ScreenSaver

**[Mac OS X 10.3]** /Developer/Documentation/General/UserExperience/Reference/General/ScreenSaver

----

General/MacEdition has an intro to screen savers article at http://macedition.com/bolts/bolts_20020514.php

----

Here is the order of operations performed by General/ScreenSaverEngine when it runs a General/ScreenSaverView (in normal mode).


* calls     +performGammaFade
* if it returned true, fades the screen to black
* instantiates your module and initializes it:     -initWithFrame:isPreview:
* creates the screen-filling window
* adds the module to the window, causing     -drawRect: to be called
* fades the screen back to full brightness if necessary
* calls     -startAnimation
* repeatedly calls     -animateOneFrame
* calls     -stopAnimation
* fades screen back to black
* closes the window
* fades back up and exits


All drawing should be done in     -drawRect: and/or     -animateOneFrame.

----

**Miscellaneous Questions**

**Q:** When running a screen saver with multiple monitors, is     +General/[ScreenSaverView performGammaFade] called just once or once for each screen?

**A:** No, it's called once before the screen saver module is alloc/init'ed. -- General/MikeTrent

**Q:** Has anyone had experience placing a General/ScreenSaverView in a subview?  I'd like to create a screensaver that is similar in design to General/ElectricSheep, where a status bar of General/NSTextField<nowiki/>s is at the bottom and the top view is any other screensaver.  Getting the bottom status bar isn't a problem (load my custom view in as a subview of the current view), but when I instantiate a new General/ScreenSaverView, make it a subview of my current view, and ask it to start animating, it doesn't display. --General/MatthewSwann

**A:** You need to make sure the subordinate screen saver is initialized properly. That includes both reading it in from its bundle, and installing it in your main screen saver's view. It may help to explicitly set the size of the module before installing (even though you specified the frame size in initWithFrame:isPreview:). -- General/MikeTrent

**Q:** How can you disable the screen saver for multimedia apps?

**A:** See General/DisableScreenSaver

**Q:** Is there a programmatic way to lock and unlock the user's session, a la xscreensaver-command -lock and -deactivate for General/XScreenSaver under Linux?

**A:** The best I've found to to use a General/NSTask to launch and terminate General/ScreenSaverEngine. When terminated, without -background, General/ScreenSaverEngine will stop to prompt for a password if the user has configured their system to do so.