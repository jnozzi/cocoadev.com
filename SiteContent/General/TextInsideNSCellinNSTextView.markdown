
Hello folks,
I am trying to replicte the addressBook.app interface.
So far I have learned I am supposed to put [[NSCell]] objects inside the [[NSTextView]].
I have not been able to draw a string inside the [[NSCell]].
This is a snippet from my code; the string I get from this method is inserted at the end of the text view with [textInView appendAttributedString:attachedTextString];
<code>
- ([[NSAttributedString]] '')textAttachment
{
	[[NSTextAttachment]] ''attachment;
	attachment = [[[[[NSTextAttachment]] alloc] init] autorelease];
	[[NSCell]] ''cell = [attachment attachmentCell];
	
	[[NSMutableAttributedString]] ''attachedString;
	attachedString = [[[[NSMutableAttributedString]] alloc] initWithString:@"Questo invece � un text attachment"];
	[attachedString addAttribute:[[NSFontAttributeName]]
						   value:[[[NSFont]] userFontOfSize:22]
						   range:[[NSMakeRange]](0,34)];
	
		

	[cell setAttributedStringValue:attachedString];
	
	[[NSAttributedString]] ''stringWithAttachedText;
	stringWithAttachedText = [[[NSAttributedString]] attributedStringWithAttachment:attachment];
	return (stringWithAttachedText);
}
</code>
What is wrong? Is this the right way to implement this?
I was not able to find a solution on the web or in the documentation...
Thanks in advance,
Davide