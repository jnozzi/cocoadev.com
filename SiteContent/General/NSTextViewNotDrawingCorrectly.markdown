

I've got a custom view drawing a background color (white) and two�borders (gray). Inside this custom view i've got two�labels and one General/NSTextField. like this:

http://anais.3motions.net/Screen.jpg

The problem is that the�General/NSTextField always seams to draw the whole custom view as its background. (the two lines above and below the General/NSTextField)
Here is the code i used for the custom view

    
- (void)drawRect:(General/NSRect)rect {
	General/[[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] setFill];
	General/[[NSColor colorWithCalibratedWhite:0.0 alpha:1.0] setStroke];
	
	General/NSBezierPath * path = General/[NSBezierPath bezierPathWithRect:General/NSInsetRect(rect,-4.0,0.0)];
	[path fill];
	[path stroke];
}


How can i solve this problem. Should I make a custom General/NSTextField?

-- General/SimonAndreasMenke

----

The rect in your code is that of the redraw region as opposed to that of the whole view. I would suggest that you fill rect, but stroke [self bounds].

*Easier just to both fill and stroke [self bounds]. The fill will be clipped anyway so there won't be any performance loss.*�

----

Thanks a lot :-)
�-- General/SimonAndreasMenke