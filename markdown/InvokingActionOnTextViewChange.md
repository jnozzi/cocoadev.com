I was able to make a connection in Interface Builder from a General/TextField to my Controller that invokes a certain action whenever the text in the field is changed and it loses focus.  Is there a way to invoke this same action when the text in a General/TextView is changed?

Implement the General/NSTextView     - (General/NSRange)textView:(General/NSTextView *)aTextView willChangeSelectionFromCharacterRange:(General/NSRange)oldSelectedCharRange toCharacterRange:(General/NSRange)newSelectedCharRange delegate method.

i actually found it more useful to use     (void)textDidEndEditing:(General/NSNotification *)aNotification