
Can somebody explain me why this code :
    
- (void)mouseDown:(General/NSEvent *)event
{
	General/NSView *sub = [subviews objectAtIndex: n];
	[sub removeFromSuperview];	
}

Is working fine when n is 0 or 1, but crash when n>1???
([subviews count] is returning 4). - General/StephaneDassieu.

----

If you want help, you'll need to produce the actual code. At what point is [subviews count] returning 4? Also, define 'crash' - what message do you receive? Please include the complete code - our crystal balls are unavailable.

----

I presume subviews is an ivar,and you don't mean     [self subviews]? Yes, post code.

----

Don't forget to tell us *where* it crashes, too. Telling us that it crashes is not really enough, we can't read your mind. *Or your monitor for that matter ...*

----

*Ok sorry, will update my post asap!* -> done :

    
- (void)mouseDown:(General/NSEvent *)event
{
	int idx = 2; //[self clickedBox: [event locationInWindow]];
	if (idx != -1) {
		//General/NSView *subViewToBeRemoved = [subviews objectAtIndex: idx];
		General/NSLog(@"removing box index %i/%i",index,[subviews count]);
		General/NSView *sub = [subviews objectAtIndex: idx];
		[sub removeFromSuperview];
	}
}

- (void)drawRect:(General/NSRect)rect
{	
	General/NSRect r = rect;
	General/[[NSColor whiteColor] set];
	General/[NSBezierPath fillRect: r];
	General/NSRect bounds = [self bounds];
	subviews = [self subviews];
}


As i said, it works for idx=0 and idx=1. When idx= 2 it crash with this message : "2005-04-07 09:32:16.098 General/TestView[495] removing box index 2/4
Executable �General/TestView� has exited due to signal 11 (SIGSEGV)." It crash even if there is more subviews (�removing box index 2/7
Executable �General/TestView� has exited�)

And When idx>2 (i can add superviews so it can be higher than 4) it works too now!! I'm lost.
It only crash with '2', really weird. - General/StephaneDassieu

----

It's very dangerous to do     subviews = [self subviews] and then use this value later. If you want an object to stick around, you must retain it, otherwise it could be deallocated.

Really, though, you don't need this value at all. Just replace all uses of     subviews with     [self subviews].


----

You'd be better off keeping track of when your view's bounds changes with General/NSViewBoundsDidChangeNotification instead of resetting it every time through drawRect.

----

The verdict: This is all-around bad design - one you should re-think from the ground up. How about moving the 'remove self on mouse down' code to the subview itself? Have it call [self removeFromSuperview] on mouse down? That's another approach to consider, though not necessarily the right approach for *your project*.

----
*remove self on mouse down* -> I first did this.. but as i wanted my superview to know what was happening, i tried this way..
but whatever, i found what mades the app crash : i had a dealloc full of [var release]; i shouldn't had.. in other words, i was destroying objects prematurely. - General/StephaneDassieu.

*If the superview is a custom class you could override     willRemoveSubview:.* --> *very good idea, will try it*