Adding an image to a textview programatically:

This code is all you need. Simply make sure that the textview has "Graphics Allowed" checked.
    
General/NSOpenPanel *open = General/[NSOpenPanel openPanel];
[open setAllowsMultipleSelection:NO];
[open setCanChooseDirectories:NO];
if ([open runModalForTypes:General/[NSArray arrayWithObjects:@"jpg",@"jpeg",@"gif",@"png",nil]] ==  General/NSOKButton)
{
  General/NSString *thePath = General/open filenames] objectAtIndex:0];

  [[NSFileWrapper *filew = General/[[[NSFileWrapper alloc] initRegularFileWithContents:General/[NSData dataWithContentsOfFile:thePath]] autorelease];
		
  [filew setFilename:thePath];
  [filew setPreferredFilename:[thePath lastPathComponent]];

  General/NSTextAttachment *fileAttachment = General/[[[NSTextAttachment alloc] initWithFileWrapper:filew] autorelease];
  General/NSImage *image = General/[[[NSImage alloc] initWithContentsOfFile:thePath] autorelease]; 
  General/NSTextAttachmentCell *attachmentCell = General/[[[NSTextAttachmentCell alloc] initImageCell: image] autorelease];
  [fileAttachment setAttachmentCell:attachmentCell];
  General/NSAttributedString *fileAttString = General/[NSAttributedString attributedStringWithAttachment:fileAttachment];

  [textview insertText:fileAttString];

}


----

Hi, I am trying this code. The attachment can be dragged to General/TextEdit or Mail.app but when dragged to Desktop no (+) sign is shown on mouse pointer and when dropped it creates an empty Untitled clipping. Anything else should be added to make Finder accept this as file? --General/AndreyBabak