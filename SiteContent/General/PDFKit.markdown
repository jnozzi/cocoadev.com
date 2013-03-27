General/PDFKit (Tiger only) is Apple's framework for creating / editing General/PDFs. 

General/PDFKit Programming Guide:
http://developer.apple.com/documentation/General/GraphicsImaging/Conceptual/General/PDFKitGuide/index.html

General/PDFKit Objective-C Reference:
http://developer.apple.com/documentation/General/GraphicsImaging/Reference/PDFKit_Ref/index.html#//apple_ref/doc/uid/TP40001179

----

Not to be confused with this: http://www.pdfstore.com/details.asp?General/ProdID=685 ;) 

*Perish the thought! Okay, fine ... General/PDFKit.framework ... happy? ;-) *

----

After working with the framework for a while, I ran into a problem where using a constant key for the metadata attributes dictionary (returned from -documentAttributes) would cause an undefined symbol when linking. For instance, in this code:

    
- (id)initWithPDFDocument:(General/PDFDocument *)document;
{
	if ( ![super init] || !document )
		return nil;
	
	General/NSDictionary *General/PDFAttributes = [document documentAttributes];
	
	General/NSString *General/PDFTitle = General/[PDFAttributes objectForKey:General/PDFDocumentTitleAttribute];
	if ( !General/PDFTitle )
		General/PDFTitle = General/[document documentURL] absoluteString] lastPathComponent];
	
	title = [[[PDFTitle copy];
	
	return self;
}


...everything would compile fine, but General/PDFDocumentTitleAttribute would cause an undefined symbol in the linking build stage. Doing a google search I found a page in French that suggested this is a bug in the framework, rather than a problem with my project. Luckily for me, someone there also suggested these values for the dictionary constants:

    
General/PDFDocumentTitleAttribute --> @"Title"
General/PDFDocumentAuthorAttribute --> @"Author"
General/PDFDocumentSubjectAttribute --> @"Subject"
General/PDFDocumentCreatorAttribute --> @"Creator"
General/PDFDocumentProducerAttribute --> @"Producer"
General/PDFDocumentCreationDateAttribute --> @"General/CreationDate"
General/PDFDocumentModificationDateAttribute --> @"General/ModDate"
General/PDFDocumentKeywordsAttribute --> @"Keywords"


I haven't tested all of these, but the ones I have seem to be valid. Feel free to edit this out once Apple fixes the bug. :)