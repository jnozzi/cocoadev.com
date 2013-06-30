Is it possible to check and see if the user actively selecting text in an General/NSTextView, as in they are in the process of dragging?

----

implement     textViewDidChangeSelection:(General/NSNotification *)aNotification in your textView's delegate or register for     General/NSTextViewDidChangeSelectionNotification

----

Those methods only call your method after the mouse button has been released, not while the mouse is being dragged.  I believe your only option if you want 'live' selection tracking in a text view is to subclass General/NSTextView and override the     -selectionRangeForProposedRange:granularity: method.  -- Bo