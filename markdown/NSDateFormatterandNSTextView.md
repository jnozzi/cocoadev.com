I have an General/NSTextView that I want to add an General/NSDateFormatter to, but as far as I can see, in IB, you can only add date formatter to an General/NSTextField. Is there a way to add a date formatter to a text view in Interace Builder, and if there isn't, what would be the best way to do it programmatically?

Thanks in advance.

----

Only an General/NSCell can take a formatter, only an General/NSControl has cells, and General/NSTextView is not a control.  So you cannot add a formatter to an General/NSTextView.

----

OK, thanks.