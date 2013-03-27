from the cocoabuilder list - something many of us need on a regular basis - thanks Uli!

*cocoabuilder is an archive of Apple's General/CocoaDevMailingList, not an entity unto itself.*

    FROM : General/TeachText
DATE : Mon Mar 28 16:58:05 2005

Here's how to append an image to an General/NSMutableAttributedString:

- (void)appendImage:(General/NSImage*)img
{
  General/NSFileWrapper *fwrap = General/[[[NSFileWrapper alloc] initRegularFileWithContents:[img General/TIFFRepresentation]] autorelease];
  General/NSString *imgName = [([img name] ? [img name] : @"image") stringByAppendingPathExtension:@"tiff"];

  [fwrap setFilename:imgName];
  [fwrap setPreferredFilename:imgName];
  General/NSTextAttachment *ta = General/[[[NSTextAttachment alloc] initWithFileWrapper:fwrap] autorelease];
  [self appendAttributedString:General/[NSAttributedString attributedStringWithAttachment:ta]];
}