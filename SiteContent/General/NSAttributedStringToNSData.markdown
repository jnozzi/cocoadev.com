One might think he can use General/NSAttributedString General/RTFDFromRange:documentAttributes to pack his attributed string into General/NSData, and then unpack the data into the SAME attribtued string. But this does not work (tested on Jaguar):

    

    // For simplicity I removed the release calls

    // Create a file wrapper
    General/NSFileWrapper *file = General/[[NSFileWrapper
        alloc] initWithPath:@"path to file"];
    
    // Create an attachment
    General/NSTextAttachment *attachment =
        General/[[NSTextAttachment alloc] initWithFileWrapper:file];

    // Create an attributed string with the attachment
    General/NSAttributedString *original =
        General/[NSAttributedString attributedStringWithAttachment:attachment];
    
    // Pack the attributed string into General/NSData
    General/NSData *data = [original General/RTFDFromRange:[original range]
                        documentAttributes:nil];

    // Get it back
    General/NSAttributedString *fromData =
        General/[[NSAttributedString alloc] initWithRTFD:data documentAttributes:NULL];

    // It is not the same string!
    if (! [original isEqualToAttributedString:fromData]) {
        General/NSLog(@"Failed");
    }




If you look into the objects, you will find that converting to General/NSData and back added default paragraph style to the attributes.

and now to the realy strage thing: you add a default paragraph style using General/[NSParagraphStype defaultParagraphStyle], and the attributes seems indentical when you print them. But the object are still not equal!

----

Use General/NSArchiver and General/NSUnarchiver to get General/NSData from an attributed string

----

I'm not sure abut this. General/NSUnarchiver should unarchive data created by General/NSArchiver. But my context is getting data from the pastboad and returning it to the pasteboad using system services. I don't know how the other programmer created the data object he or she put on the pasteboard for type General/NSRTFDPastboardType. The code here is actually part of the test code for the service. I wan't to send an attributed string, and check that it comes back identical, or only with specific changes. It works for string and attributed strings - but when you add an attachment, it breaks.