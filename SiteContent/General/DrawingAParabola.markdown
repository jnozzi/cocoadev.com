I am trying to draw a parabola (y = x''x) in my [[ScreenSaverView]] subclass. It draws the white box fine if I leave out the <code>for</code> loop and the 2 lines after that.If I leave them in, it only gives me a black screen. What am I doing wrong?

<code>- (void)animateOneFrame
{
	int i;
	[[[[NSColor]] whiteColor] set];
	[[[[NSBezierPath]] bezierPathWithRect:[self bounds]] fill];
	path = [[[NSBezierPath]] bezierPath];
	for(i=0;i<[self bounds].size.width;i++) { 
		[[NSPoint]] pt;
		pt.x = (float) i;
		pt.y = (float) i '' i;
		[path lineToPoint:pt];
	}
	[[[[NSColor]] blackColor] setStroke];
	[path stroke];
	[self setNeedsDisplay:YES];
	return;
}
</code>

----

Remove the <code>setNeedsDisplay:</code> line, it's not necessary and is causing your (probably empty) <code>drawRect:</code> method to be invoked, overwriting your drawing here.

----

Thanks, but the same thing still happens. (You're right about my <code>drawRect:</code> routine)

''According to Apple, all of your drawing code should be in your <code>drawRect:</code> method, and you should call <code>setNeedsDisplay:</code> in <code>animateOneFrame</code> if that's how you are going to draw it. However, since you do all of your drawing beforehand, you might be able to leave <code>animateOneFrame</code> empty and move everything else to <code>drawRect:</code>. That being said, your problem is likely the absence of calling <code>lockFocus</code> on your view (in this case <code>self</code>), which means you are drawing off in space somewhere. --[[JediKnil]]''

That's not true. According to the docs:

''It is guaranteed that the focus is locked when this method is called, so subclasses may do drawing in this method.''

The problem lies elsewhere.

----

I found my bug. If I insert a <code>[path moveToPoint:[[NSZeroPoint]]];</code> before the <code>for</code> loop, it all works! Thanks for your help!