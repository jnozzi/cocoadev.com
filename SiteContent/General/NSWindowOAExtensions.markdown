

A category that adds some functionality to [[NSWindow]].

A particularly interesting method is 
<code>- (void)morphToFrame:([[NSRect]])newFrame overTimeInterval:([[NSTimeInterval]])morphInterval;</code>
which allows you to smoothly animate a window resizing. 

----
I haven't used this - it looks like it might be a little slow. Does anyone have any experience with it?

----

I've not used any of the Omni frameworks myself, but I'd assume they use this in the preferences window in [[OmniWeb]], which is quick enough. -- [[RobRix]]

Looking at [[OAPreferenceController]], they use [[NSWindow]]'s %%BEGINCODESTYLE%%setFrame:display: animate:%%ENDCODESTYLE%%. In fact, they don't use morphToFrame anywhere in [[OmniAppKit]]. --[[MichaelMcCracken]]

Heh, curious. -- [[RobRix]]

----
It's used in [[OmniWeb]]: 

*Main Menu -> View -> Status Bar 
*Downloads window: Show details disclosure widget.


-- [[TomBunch]]