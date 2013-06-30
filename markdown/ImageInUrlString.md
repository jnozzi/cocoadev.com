Describe General/ImageInUrlString here.


In my roll-your-own Cocoa browser, I am trying to get the webView:didReceiveIcon:forFrame: method for the General/WebFrameLoadDelegate delegate to work.   Here is the code I am using which is showing the 'abc' string in the url address bar but no image attachment.  Am I mistaken in thinking that a favicon can be included in a text field in this manner or I am missing something here?

    
- (void)webView:(General/WebView *)sender didReceiveIcon:(General/NSImage *)image forFrame:(General/WebFrame *)frame {
	General/NSString *urlValue = @"abc ";
	if (frame == [sender mainFrame]) {
		General/NSTextAttachment *attachment = General/[[[NSTextAttachment alloc] init] autorelease];
		if ([(General/NSCell *)[attachment attachmentCell] respondsToSelector:@selector(setImage:)]) {
			General/NSLog(@"icon : %@",image);
			[(General/NSCell *)[attachment attachmentCell] setImage:image];
			General/NSDictionary *theAttributes = General/[NSDictionary dictionaryWithObjectsAndKeys: 
				attachment, General/NSAttachmentAttributeName,
				NULL];
			General/NSAttributedString *attrname = General/[[[NSAttributedString alloc] initWithString: urlValue attributes:theAttributes] autorelease];
			General/NSMutableAttributedString *imageString = (id)General/[NSMutableAttributedString attributedStringWithAttachment: attachment];
			[imageString appendAttributedString: attrname];
			General/NSLog(@" stringer: %@",imageString);
                     //sends imageString to browser
			[urlString setStringValue:imageString];
		}
	}
}

Here is the output from General/NSLog when I go to a page like apple.com.  Here the log shows the string 'abc' (which is showing up in the url address bar) but not the apple favicon that apparently accompanies it.


2007-02-01 13:25:05.677 Z Test[10997] urlString: http://apple.com

2007-02-01 13:25:06.405 Z Test[10997] icon : General/NSImage 0x373340 Size={16, 16} Reps=(
    General/NSBitmapImageRep 0x353b10 Size={16, 16} General/ColorSpace=General/NSCalibratedWhiteColorSpace BPS=8 BPP=16 Pixels=16x16 Alpha=YES Planar=NO Format=2
)

2007-02-01 13:25:06.428 Z Test[10997]  stringer: abc {General/NSAttachment = <General/NSTextAttachment: 0x3e9830>; }


If anyone could give me a pointer on this, it would be most appreciated.

Thanks, Vince