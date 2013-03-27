I have a General/NSTextView that is editable and i want to restrain the amount of letters or numbers the end user types into the box. 

Any pointers to how I would create this behavior would be great. I am newbe and have waded through ducuments for 4 days now to no avail.



----

How about implementing     - (BOOL)textView:(General/NSTextView *)textView shouldChangeTextInRange:(General/NSRange)affectedCharRange replacementString:(General/NSString *)replacementString;?