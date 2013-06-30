http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSSlider_Class/index.html

----

General/NSSlider is a visual way to adjust some value.  You could use it for volume control, selecting colors, adjusting brightness, etc.. It has continous and discrete modes.

To create an General/NSSlider AND show its value (but see just below about how much **easier** this is with General/CocoaBindings):

Drag an General/NSSlider from the 'Cocoa-Buttons' palette onto a window.  Next, drag an General/NSTextField (any size is fine) from the 'Cocoa-Text' palette onto the window.  Control-click and drag from the General/NSSlider to the General/NSTextField.  This will open the 'Connections' inspector window.  Select takeFloatValueFrom: from the target submenu and hit 'Connect'.  Finally, drag the General/NSNumberFormatter from 'Cocoa-Text' palette onto the General/NSTextField.  The 'Formatter' inspector window will appear.  Select the percentage format from the menu (-100%, 100%).

You're done, run your program and play with the slider, it will automatically update the value inside General/NSTextField according to the value of the General/NSSlider!

----

You can also, with no actual coding, set up the slider so that it responds to the value that you type into a text field. Just control drag in the opposite direction, and select takeFloatValueFrom: from the target submenu and hit 'Connect'.  This is a cheap way to do it... it will end up not being very integrated with your document's instance variables.

----

**Example**

I have a slider and a blank text field in General/InterfaceBuilder, all hooked up. I created an outlet for the text field and an action for the slider. It has 10 different tick marks and it moves accordingly. I want to display which tick mark it is at in the text field. I can't figure how to implement this without errors.

----

Create an action in your class, and then hook up the slider to this action as if you were hooking up a button to an action. It works the same way. Then you can call     [slider doubleValue] to get its position,     [slider minValue] and     [slider maxValue] to get its minimum and maximum values.

----

With General/CocoaBindings this becomes even fantastically easier, if you set up a model variable that is KVC-compliant and  bind both the General/NSSlider instance and the General/NSTextField instance to the corresponding model key path. Talk about eliminating "glue code"! Yowza!


----

**Continuous Updates while dragging**

If you connect a General/NSSlider to another view, by binding both objects to the same key path, at first you won't get continuous updates as you drag the control knob. Updates will occur only when you release the mouse button.

If you want the value in the text box to change as you drag then you need to set the General/NSSlider to be "Continuous", either in Interface Builder or by calling -setContinuous:YES on the view directly.

(This may be obvious but I couldn't remember how to do it today)

----

Anyone know how to setup an General/NSSlider so it uses allowsTickMarkValuesOnly but doesn't draw the ticks (as if numberOfTickMarks == 0)?

I figured it out. Here is the code. I implemented a tickCount getter/setter which is virtually the same as numberOfTickMarks in terms of behavior, but the tick marks are not drawn. I just calculate manually the correct tick value after the slider value changes:

    - (void)stopTracking:(General/NSPoint)lastPoint at:(General/NSPoint)stopPoint inView:(General/NSView *)controlView mouseIsUp:(BOOL)flag
{
	[super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];

	if (flag)
	{
		[self setNumberOfTickMarks:[self tickCount]];
		float val = [self closestTickMarkValueToValue:[self floatValue]];
		[self setNumberOfTickMarks:0];
		[self setFloatValue:val];
	}
}