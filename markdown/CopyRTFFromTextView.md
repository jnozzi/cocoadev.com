Here is a simple example of how you can copy formatted text in an General/NSTextView to the clipboard/pasteboard. The default copy: method only copies plain text. --General/KevinWojniak

    
- (General/IBAction)copy:(id)sender
{
	General/NSPasteboard *pb = General/[NSPasteboard generalPasteboard];
	General/NSTextStorage *textStorage = [self textStorage];
	General/NSData *rtf = [textStorage General/RTFFromRange:[self selectedRange]
		documentAttributes:nil];
	
	if (rtf)
	{
		[pb declareTypes:General/[NSArray arrayWithObject:General/NSRTFPboardType] owner:self];
		[pb setData:rtf forType:General/NSRTFPboardType];
	}
}


----
It's a good idea to put as much data as possible on the pasteboard; for example, when putting RTF data there, why not put plain text? The more types of data you can generate, the easier is it to integrate with other applications. General/EnglaBenny