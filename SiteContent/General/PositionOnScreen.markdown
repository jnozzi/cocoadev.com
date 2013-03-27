

Just trying to see if the mouse is within my tableview when a particular method is called, here's my code it is within an General/NSView subclass, 

    

General/NSPoint widgetOrigin = [self frame].origin;
General/NSPoint widgetOriginInWindowCords = [self convertPoint:widgetOrigin toView:nil];
General/NSPoint windowOrigin = General/self window] frame].origin;
[[NSPoint widgetOriginOnScreen = General/NSMakePoint(windowOrigin.x + widgetOriginInWindowCords.x,
                                           windowOrigin.y + widgetOriginInWindowCords.y);


General/NSRect rectForSelfOnScreen = General/NSMakeRect(widgetOriginOnScreen.x, widgetOriginOnScreen.y, [self frame].size.width, [self frame].size.height);

General/NSLog(@"The rect on screen is %f %f %f %f ", widgetOriginOnScreen.x, widgetOriginOnScreen.y, [self frame].size.width, [self frame].size.height);

if (General/NSMouseInRect(General/[NSEvent mouseLocation], rectForView, NO))
{
...do something...
}



I just need a second pair of eyes, this is about the 7th try i've had at this code, it started out just using convertRect: fromView:.

It just doesn't seem to tell me whether the pointer is indeed within the view (which is 'self' in the example above), but gives me strange results.

!

Thanks!
----
Try General/NSWindow's     convertBaseToScreen: method instead of all that     General/NSMakePoint(...) stuff. Also, while maybe your code *should* work, make sure you know if your view is flipped...if it is, your y-value would be completely off. --General/JediKnil