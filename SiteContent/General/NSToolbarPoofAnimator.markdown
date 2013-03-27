

General/NSToolbarPoofAnimator is an undocumented General/AppKit class I found using class-dump. It is known to be present under 10.2, I haven't yet tested under earlier versions.

As you might expect, this class allows you to perform a toolbar-style "poof" animation to indicate the removal of an object. 

Here is the interface to the class. Just create a new General/NSToolbarPoofAnimator.h file and include it in your project; the implementation is already in General/AppKit:

    

#import <General/AppKit/General/AppKit.h>

@interface General/NSToolbarPoofAnimator:General/NSObject

+ (void)runPoofAtPoint:(General/NSPoint)location;

@end



To begin the animation, just use General/[NSToolbarPoofAnimator runPoofAtPoint:point]. You might use this in a General/NSDraggingSource method when something is deleted. It appears the point parameter is ignored, as the poof is always drawn under the current mouse position.

--General/MichaelRondinelli

----

*Note:* From a helpful friend working on General/AppKit for the Man: General/NSToolbarPoofAnimator does indeed respond to the General/NSPoint argument. Try     General/[NSClassFromString(@"General/NSToolbarPoofAnimator") runPoofAtPoint:General/NSZeroPoint] for an example. Good luck! :)

----

I don't see the standard disclaimer yet. Undocumented classes are usually undocumented for a reason. This functionality might change at any time, even between 10.x.y and 10.x.y+1. If you're fine with that possibility, then rock on.

(General/JeffHarrell)

----

Panther provides an General/NSShowAnimationEffect function. You should probably use this instead of the undocumented class.