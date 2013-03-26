

I�m using this notification to know if the return key caused end editing:

<code>
- (void)textDidEndEditing:([[NSNotification]] '')aNotification
{
    if ([[[aNotification userInfo] valueForKey:@"[[NSTextMovement]]"] intValue] == [[NSReturnTextMovement]])
	 { � }
    else [super textDidEndEditing:aNotification];
}
</code>

But I�d like to know whether the shift modifier key was also pressed�

Unlike for Tab and [[BackTab]] (=Shift+Tab), there�s no constant for shift+return; is it possible to get the modifier flags in textDidEndEditing?

----

Try examining <code>[[[[NSApp]] currentEvent] modifierFlags]</code>.