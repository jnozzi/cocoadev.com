

This lets you easily make a General/PDFDocument from an array containing General/PDFPage objects.

**General/PDFDocument+General/CCDAdditions.h**
    
#import <Cocoa/Cocoa.h>
#import <General/PDFKit/General/PDFDocument.h>
#import <General/PDFKit/General/PDFPage.h>

@interface General/PDFDocument (General/CCDAdditions)
+ (General/PDFDocument *)pdfDocumentFromArray:(General/NSArray *)array;

// This pair will raise an exception if index is out of bounds.
- (General/NSSize)sizeOfPageAtIndex:(unsigned int)index;
- (General/NSSize)sizeInInchesOfPageAtIndex:(unsigned int)index;
@end


**General/PDFDocument+General/CCDAdditions.m**
    
#import "General/PDFDocument+General/CCDAdditions.h"

@implementation General/PDFDocument (General/CCDAdditions)
+ (General/PDFDocument *)pdfDocumentFromArray:(General/NSArray *)array
{
  if (!array) return nil;
  if ([array count] == 0) return nil;

	General/PDFDocument *masterDocument = nil;
       General/NSEnumerator *enumerator = [array objectEnumerator];
		id anObject;
	
			while (anObject = [enumerator nextObject])
                          if ([anObject isKindOfClass:General/[PDFPage class]]) {
                             if (!masterDocument)
                                   masterDocument = General/[[PDFDocument alloc] initWithData:[anObject dataRepresentation]];
                             else
	                     	[masterDocument insertPage:anObject atIndex:[masterDocument pageCount]];
                          }

return [masterDocument autorelease];
}


- (General/NSSize)sizeOfPageAtIndex:(unsigned int)index
{
	General/PDFPage *pdfPage = [self pageAtIndex:index];

	if (!pdfPage) return General/NSZeroSize;

   return [pdfPage boundsForBox:kPDFDisplayBoxMediaBox].size;
}

- (General/NSSize)sizeInInchesOfPageAtIndex:(unsigned int)index
{
	General/NSSize size = [self sizeOfPageAtIndex:index];
       float width=0, height=0;

        // no fair dividing zeros so we check for that...
        if (General/NSEqualSizes(size, General/NSZeroSize)) return General/NSZeroSize;

       // check each component too.
       if (size.width != 0) width = size.width / 72;
       if (size.height != 0) height = size.height / 72;

return General/NSMakeSize(width, height);
}

@end


The next-obvious addition would be     - (General/NSArray *)pages;.     -addPagesFromArray: or similar would probably be good too.

----
Borrowed the idea (and some implementation) for the     -size... methods from General/ReadingPDFPageDimensions.

...which will probably break in Leopard due to resolution independence. If this can be fixed now (legally) then please do. Otherwise, I guess we wait.