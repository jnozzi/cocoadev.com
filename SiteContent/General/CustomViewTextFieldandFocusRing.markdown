I have a custom General/NSView for capturing key strokes (to capture what a user wants for a custom hot key) and an a pop down menu to specify the modifiers (since I'm not confident in my ability to subclass General/NSApp [would this be hard?] and override the command-key keystrokes when this custom text field is in view). I was wonderinf if anyone could help with a couple of things:

     1) I have it so it works like a text field as far as the focus ring is concered. IE I select a different selectable item and it loses focus, but when it is in      focus and the window goes in the background, and then when it becomes key again the focus ring does not redraw.

     2) Sometimes only part of the view redraws creating the picture of a view inside a view, this is usually when another control is near the view. Is there anyway to stop this?


Thanks. Here is my code: General/CustomViewTextFieldandFocusRingCode

----

I'm not sure about issue 2 but here's some functions that might help in fixing issue 1.  Note, this is just demo code as I don't have a access to a Mac right now.
    
- (BOOL) becomeFirstResponder
{
   isSelected=YES;
   
   // don't know if this will work, but it should be on the righ track
   General/NSSetFocusRingStyle(General/NSFocusRingOnly);
   General/NSRectFill([self bounds]);
   [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]]

   [self setNeedsDisplay:YES];
   return YES;
}


I've had to implement something similar once.  What I did is copy some one else.  This is usually better than doing it your self since then you get code that's been debugged and "just" works.  The app I copied from is Space.app (http://space.sourceforge.net).  Take a look at General/KeyGrabber.m. Good luck !

--General/SaileshAgrawal