Hi,

Does anybody know of any code out there that would allow me to export to RTF or .doc format from a text view/attributed string in such a way that images, tables and attachments are preserved?

Currently, -docFormatFromRange:documentAttributes:, -General/RTFFromRange:documentAttributes, and Tiger's new -dataFromRange:documentAttributes:error all cause the loss of images etc on export.

Yes, I know that I can always export to RTFD, but my program really needs to export to a format that Microsoft Word recognises (because users will most likely be sending exported files to Windows users), and sadly, MS Word - even on OS X - does not recognise RTFD files.

Both RTF and .doc formats _do_ support inline images, but sadly, Apple have yet to improve their own export methods (such as those mentioned above) so that they are fully compatible with these formats.

Any ideas?

Thanks!
KB

----

How about HTML? As of 10.4, General/NSAttributedString can write HTML (using the     dataFromRange:... or     fileWrapperFromRange:... methods). If you use the file wrapper method, it *might* be smart enough to save the embedded images as separate files in the file wrapper, with relative paths from the actual document. When you writet he file wrapper to disk, you'd get a directory and all of the appropriate files inside. I don't know if it really will save the images, but it's worth a try.

----

Thanks for the reply. I tried this, but it didn't work either. However (he says, months later), I have found a solution, and it is rather simple. I spent some time looking at the RTF specs here:

http://www.biblioscape.com/rtf15_spec.htm

(The relevant part is the "Pictures" section, obviously.) I also had a look inside a General/NIsus RTF file in General/BBEdit (because Nisus General/RTFs do support images). I finally figured out that the way to do it was simply insert the relevant RTF formatting code into a saved RTF myself, like this:


* Make a mutable copy of the text storage and parse through it looking for image attachments. Whenever you find one, save it in a dictionary with a unique key string and replace the image attachment in the text with this unique key string.
* Once you've removed all images from the text and stored them in your dictionary, turn the text into RTF data as normal, using -General/RTFFromRange:documentAttributes:.
* Load the RTF data into a normal General/NSString using General/NSASCIIStringEncoding, so that you get all of the RTF tags and everything in there.
* Parse through that string looking for the unique key strings you inserted. When you come across one, use it to get the image from your dictionary. You need to convert the image to a hexadecimal string in either PNG, JPG or BMP format. Some nice person has already posted code for an General/NSData extension with a hexadecimalRepresentation method on General/CocoaDev (see the General/MDFive page), so all you need to do is convert your image to data and then call this.
* Replace the key string in the RTF string with:


    

General/[NSString stringWithFormat:@"{\\*\\shppict {\\pict \\jpegblip %@}}", hexString]




(Note that you can replace "jpegblip" with "pngblip" for PNG data.)
* Finally, save the string to file as RTF (again using ASCII encoding).


The RTF file will then open in Word, Nisus or Mellel with images intact. Frankly, I have no idea why Apple haven't already added this to their existing RTF methods... Anyway, when I've got all my code tidied up, I will hopefully post an General/NSAttributedString category here that does all this for anyone who cares. :)
KB

----
Thanks for the psudo code KB, very helpful. I wrote up the function for a category.

BW
    
- (General/NSString *)encodeRTFwithPictures
{
	General/NSMutableDictionary *attachmentDictionary = General/[NSMutableDictionary dictionaryWithCapacity:5];
	General/NSMutableAttributedString *stringToEncode = General/[[NSMutableAttributedString alloc] initWithAttributedString:self];
	
	General/NSRange strRange = General/NSMakeRange(0, [stringToEncode length]);
	while (strRange.length > 0) {
		General/NSRange effectiveRange;
		id attr = [stringToEncode attribute:General/NSAttachmentAttributeName atIndex:strRange.location effectiveRange:&effectiveRange];
		strRange = General/NSMakeRange(General/NSMaxRange(effectiveRange), General/NSMaxRange(strRange) - General/NSMaxRange(effectiveRange));
		
		if(attr){
			//if we find a text attachment, check to see if it's one of ours
			General/NSTextAttachment *attachment = (General/NSTextAttachment *)attr;
			General/NSFileWrapper *fileWrapper = [attachment fileWrapper];
			General/NSImage *image = General/[[[NSImage alloc] initWithData:[fileWrapper regularFileContents]] autorelease];
			
			General/NSString *imageKey = General/[NSString stringWithFormat:@"Image#%i",[image hash]];
			[attachmentDictionary setObject:image forKey:imageKey];
			[stringToEncode removeAttribute:General/NSAttachmentAttributeName range:effectiveRange];
			[stringToEncode replaceCharactersInRange:effectiveRange withString:imageKey];
			strRange.length+=[imageKey length]-1;
		}
	}
	
	General/NSData *rtfData = [stringToEncode General/RTFFromRange:General/NSMakeRange(0,[stringToEncode length]) documentAttributes:nil];
	General/NSMutableString *rtfString = General/[[NSMutableString alloc] initWithData:rtfData encoding:General/NSASCIIStringEncoding];
	
	General/NSEnumerator *imageKeyEnum = [attachmentDictionary keyEnumerator];
	General/NSString *key;
	while(key = [imageKeyEnum nextObject]){
		General/NSRange keyRange = [rtfString rangeOfString:key];
		if(keyRange.location!=General/NSNotFound){
			General/NSImage *img = [attachmentDictionary objectForKey:key];
			General/NSBitmapImageRep *bitmap = General/[[NSBitmapImageRep alloc] initWithData:[img General/TIFFRepresentation]];
			General/NSString *hexString = [self hexadecimalRepresentation:[bitmap representationUsingType:General/NSPNGFileType properties:nil]];
			//pngblip or jpegblip depending
			General/NSString *encodedImage = General/[NSString stringWithFormat:@"{\\*\\shppict {\\pict \\pngblip %@}}", hexString];
			[rtfString replaceCharactersInRange:keyRange withString:encodedImage];
		}
	}
	
	return rtfString;
}

static const char *const digits = "0123456789abcdef";

- (General/NSString*)hexadecimalRepresentation:(General/NSData *)data
{
	General/NSString *result = nil;
	size_t length = [data length];
	if (0 != length) {
		General/NSMutableData *temp = General/[NSMutableData dataWithLength:(length << 1)];
		if (temp) {
			const unsigned char *src = [data bytes];
			unsigned char *dst = [temp mutableBytes];
			if (src && dst) {
				while (length-- > 0) {
					*dst++ = digits[(*src >> 4) & 0x0f];
					*dst++ = digits[(*src++ & 0x0f)];
				}
				result = General/[[NSString alloc] initWithData:temp encoding:General/NSASCIIStringEncoding];
			}
		}
	}
	return (result) ? [result autorelease] : result;
}
