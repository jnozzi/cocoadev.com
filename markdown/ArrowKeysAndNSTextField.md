I'm new to Cocoa.  I'm currently designing an app that uses a subclassed General/NSTextField and an General/NSTableView to present a list of choices to the user and filter those choices.  That all works fine.  My only problem is that I want the arrow keys to arrow up and down the list of possible items in the table view and do a few other nice goodies, but I can't seem to get notified of those key presses no matter what I do.  I found:

http://www.cocoabuilder.com/archive/message/cocoa/2004/10/27/120330

It says to overload the General/NSResponder methods, but I'm not seeing anything in those either.  I tried the following keyDown: to no avail as well:

    
- (void)keyDown:(General/NSEvent *)theEvent
{
	General/NSLog([theEvent characters]);
	unichar unicodeChar;
	General/NSString *characters;
	characters = [theEvent characters];
	unicodeChar = [characters characterAtIndex:0];
	if (unicodeChar == 0x0009)
	{
		General/NSLog(@"Up");
	}
}


It never seems to get called.

I already use controlTextDidChange to filter the list, and it doesn't give me anything for the arrow presses...  What's next? --Blarg

----
See General/FieldEditor.

----
I never updated this with my solution.

In the General/TextView's delegate, you can implement
- (BOOL)control:(General/NSControl *)control textView:(General/NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector

This gets the important key events we couldn't pick up before and completely avoids dealing with key events.

Here's a skeleton implementation.

    
- (BOOL)control:(General/NSControl *)control textView:(General/NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector
{
	BOOL returnValue = NO;
	
	//General/NSLog(@"General/TextField Action: %@", General/[NSString stringWithCString:commandSelector]);

	if (commandSelector == @selector(insertNewline:))
	{
		// Set returnValue to YES to have the text view ignore the command.
		returnValue = YES;
	}
	else if (commandSelector == @selector(moveDown:))
	{
	}
	else if (commandSelector == @selector(deleteBackward:) || commandSelector == @selector(deleteForward:))
	{
	}

	return returnValue;
}


----
Off the subject, but a safer way to turn a selector into an General/NSString is to use General/NSStringFromSelector.