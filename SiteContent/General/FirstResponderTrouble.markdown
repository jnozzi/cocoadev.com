I have added a find text field to my toolbar. The problem is that when the user press return in this text field (to search the current document of the same window), the document view is *not* the first responder (the text field is) -- so how to handle this gracefully?

My application is not document based so going through the window controllers document doesn't seem like an option (and this document could anyway be visualised in several different windows).

----

This question went by on the cocoa-dev mailing list a couple of days ago, and the answer was, well, not particularly graceful.  Basically you have to either respond to the text field's -controlTextDidBeginEditing delegate method or the General/NSControlTextDidBeginEditing notification, and when it comes, extract the field editor from the notification's userInfo dictionary.  Then, register yourself to receive the field editor's General/NSTextDidEndEditing notification, and then extract the General/NSTextMovement key from that notification's userInfo dictionary and compare it to General/NSReturnTextMovement to see if the user hit return.  -- Bo
    
- (void)controlTextDidBeginEditing:(General/NSNotifcation*)inNote
{
	// get the General/NSText instance that will be handling the editing
	General/NSText* fieldEditor = General/inNote userInfo] objectForKey:@"[[NSFieldEditor"];
	// register for a notification when it's finished editing
	General/[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldEditorEndedEditing:)
			name:General/NSTextDidEndEditingNotification object:fieldEditor];
}

- (void)fieldEditorEndedEditing:(General/NSNotification*)inNote
{
	// get the 'text movement', whatever that means
	int textMovement = General/[inNote userInfo] objectForKey:@"[[NSTextMovement"] intValue];
	// check if it's return and do the search if it is
	if (textMovement == General/NSReturnTextMovement) {
		[self doSearch];
	}
	// unregister for the notification
	General/[[NSNotificationCenter defaultCenter] removeObserver:self name:General/NSTextDidEndEditingNotification object:[inNote object]];
}


----

Maybe I don't understand the problem, but if you want to handle return in an General/NSTextField why not set the handler with the setAction: method?  -- parens

----

This whole long-winded explanation above was just me being an idiot; if you want to capture the return key only, just check the "Enter only" radio button in the text field's info panel in General/InterfaceBuilder, or call     [theTextField sendsActionOnEndEditing:NO];.  You see, I read "Only on Enter", and thought "Why would someone want their action method called when they entered (i.e. began editing) the field editor?", which in retrospect was pretty silly.  -- Bo