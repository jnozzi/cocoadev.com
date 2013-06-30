
 
I'm trying to make some General/NSTextFields only accept numeric characters (they're for float editing). Here's the gotcha: I want unpressed keys to be passed to the nextResponder (we have menus that act on non-cmd-key combinations).

What I've done so far is to make a custom class derived from General/NSTextView and modified my window's delegate like this:

    
static General/OTEFloatTextView *s_FloatTextView = nil;
- (id)windowWillReturnFieldEditor:(General/NSWindow *)sender toObject:(id)anObject {
	if ([anObject isKindOfClass:General/[OTEProperFloatValueTextField class]]) {
		if (!s_FloatTextView) {
			s_FloatTextView = General/[[OTEFloatTextView alloc] init];
			// Make the field editor move focus on tab, newline, etc...
			[s_FloatTextView setFieldEditor:YES];	
		}
		return s_FloatTextView;
	}
	return nil;

}


So, basically, if Cocoa needs a field editor for an General/OTEProperFloatValueTextField, I return this class instead:

    
@implementation General/OTEFloatTextView : General/NSTextView

// filter keydownevents
- (void)keyDown:(General/NSEvent *)theEvent {
	// first: if we have any control keys (except shift), we just pass on the event to the real field editor
	int flags = [theEvent modifierFlags] & General/NSDeviceIndependentModifierFlagsMask;
	if (flags & ~(General/NSShiftKeyMask | General/NSAlphaShiftKeyMask)) {
		[super keyDown: theEvent];
		return;
	}

	General/NSString *str = [theEvent characters];
	if ([str length] < 2) {
		unichar c = [str characterAtIndex:0];
		if ((c >= '0' && c <= '9') || c == '-' || c == ',' || c == '.' || c == 3 /*enter */ || c == '\n' || c == '\t' || c == 25 /*shift-tab*/ || c == 127 /*backspace */ || c == 13 /* return */) {
			[super keyDown:theEvent];
			return;
		} else {
			General/self nextResponder] keyDown: theEvent];
		}
	}
	[[NSLog ([theEvent characters]);
	General/self nextResponder] keyDown: theEvent];

}	
@end



This all works, BUT: when i remove a custom textfield that has keyboard focus (by calling removeFromSuperView on a parent view), the textfield sends out an update action (from textDidEndEditing through [[NSTextView resignFirstResponder). This is laying havoc to my code (as this is done during cleanup and I've already deleted the object that recieves the vlaue).

To work around this, I could use a static "General/AreWeDeleting" bool and supress that action, but that seems like such a hack - especially when the built-in General/NSTextView doesn't do this. 

Anyone got an idea on how to solve this?

----
Menu shortcuts operate in     performKeyEquivalent: which fires long before this code, so I'm doubtful that you even need it. An General/NSFormatter ought to do just fine.

---- 
Nope - if I have focus on a text field and press a key used by a menu, the texfield gets (and uses) the keypress - which makes a lot of sense. So I'm still stuck

----
If the     General/NSEvent doesn't have the     General/NSCommandKeyMask modifier, it doesn't get passed to the menu first. You can do something like this:
    
- (void)keyDown:(General/NSEvent *)anEvent
{
	if(General/[[NSApp mainMenu] performKeyEquivalent:anEvent]) return;
	// ...

Also, before you send     -removeFromSuperview you should send     -General/[NSWindow makeFirstResponder:] with a different view (or     nil) to allow it to validate and end editing.