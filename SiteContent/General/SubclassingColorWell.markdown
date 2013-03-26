

Here's the code:

<code>
#import "[[MyColorWell]].h"

@implementation [[MyColorWell]]

- ([[IBAction]])mouseDown:(id)sender
{
	int t = [[sender cell] tag];
	
	[[NSLog]](@"[[MyColorWell]] -> mouseDown:");
	[[NSLog]](@"tag = %i", t);
	[super mouseDown: sender];
}

@end
</code>

This fails at runtime with the error ''  ''''' -[[[NSEvent]] tag]: selector not recognized [self = 0x35de30]''
The code runs fine with the omission of <code>[[sender cell] tag]</code> code.
I'm trying to capture the "tag" field of one of three different colorWells in my interface so that I might handle the chosen colors diffenetly.

Thanks.

----

The parameter to a <code>mouseDown:</code> message is not "sender", it's the [[NSEvent]] that generated the mouse down.
----
Ah... right.
I forgot.  How, then, might I determine which control, as layed out in IB, generated the event?

----

Uh, that would be <code>self</code> in this case....

''Not only that, but [[NSColorWell]]<nowiki/>s don't have cells. You'll have to just call <code>tag</code> on <code>self</code>. However, this is still the wrong way to do this. Just connect the action of a normal [[NSColorWell]], make sure the cell's action is set to be continuous, and go from there. The action will be fired whenever the color well's color changes, with the [[NSColorWell]] as the sender. This way you can implement just one method that handles all three color wells, or implement three separate action methods and skip tag testing altogether. --[[JediKnil]]''
----
[[JediKnil]],

That's the first thing I tried.  The method I set up as for the action wasn't getting called which is why I began investigating this other approach.  Now I'm starting to think that I forgot something simple - a connection maybe - so I'll give it another go.

Thanks.

''When the proper technique fails, the answer is to debug it until it works, not change to something totally different and weird.''
----
Understood, and point well taken.  However for those of us who are much less experienced it isn't often simple to tell whether or not the first approach undertaken is the ''proper technique''.  That is why this discussion board is so helpful and valuable.

''Right. So for reference, the target/action technique is usually the right one for this sort of stuff, although it remains to be seen exactly what you're doing....''

When I set my colorWell to an action - ([[IBAction]])colorWellClicked:(id)sender , it doesn't seem to get called until a click is registered in the resulting shared color panel.  Any click in that color panel then perfoms the code in my action method.  Can I get the method to be called at the first click on the [[NSColorWell]]?

''Why do you need this? If the user hasn't clicked in the color panel, then he hasn't set any color yet, and you shouldn't need to change anything. What should happen in this case?''
----
Fair question.
You are correct.  That is the behavior I need.