

A category that adds some functionality to General/NSWindow.

A particularly interesting method is 
    - (void)morphToFrame:(General/NSRect)newFrame overTimeInterval:(General/NSTimeInterval)morphInterval;
which allows you to smoothly animate a window resizing. 

----
I haven't used this - it looks like it might be a little slow. Does anyone have any experience with it?

----

I've not used any of the Omni frameworks myself, but I'd assume they use this in the preferences window in General/OmniWeb, which is quick enough. -- General/RobRix

Looking at General/OAPreferenceController, they use General/NSWindow's <code>setFrame:display: animate:</code>. In fact, they don't use morphToFrame anywhere in General/OmniAppKit. --General/MichaelMcCracken

Heh, curious. -- General/RobRix

----
It's used in General/OmniWeb: 

*Main Menu -> View -> Status Bar 
*Downloads window: Show details disclosure widget.


-- General/TomBunch