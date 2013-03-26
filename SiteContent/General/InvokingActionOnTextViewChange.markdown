I was able to make a connection in Interface Builder from a [[TextField]] to my Controller that invokes a certain action whenever the text in the field is changed and it loses focus.  Is there a way to invoke this same action when the text in a [[TextView]] is changed?

Implement the [[NSTextView]] <code>- ([[NSRange]])textView:([[NSTextView]] '')aTextView willChangeSelectionFromCharacterRange:([[NSRange]])oldSelectedCharRange toCharacterRange:([[NSRange]])newSelectedCharRange</code> delegate method.

i actually found it more useful to use <code>(void)textDidEndEditing:([[NSNotification]] '')aNotification</code>