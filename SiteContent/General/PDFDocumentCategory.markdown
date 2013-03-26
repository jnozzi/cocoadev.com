

This lets you easily make a [[PDFDocument]] from an array containing [[PDFPage]] objects.

'''[[PDFDocument]]+[[CCDAdditions]].h'''
<code>
#import <Cocoa/Cocoa.h>
#import <[[PDFKit]]/[[PDFDocument]].h>
#import <[[PDFKit]]/[[PDFPage]].h>

@interface [[PDFDocument]] ([[CCDAdditions]])
+ ([[PDFDocument]] '')pdfDocumentFromArray:([[NSArray]] '')array;

// This pair will raise an exception if index is out of bounds.
- ([[NSSize]])sizeOfPageAtIndex:(unsigned int)index;
- ([[NSSize]])sizeInInchesOfPageAtIndex:(unsigned int)index;
@end
</code>

'''[[PDFDocument]]+[[CCDAdditions]].m'''
<code>
#import "[[PDFDocument]]+[[CCDAdditions]].h"

@implementation [[PDFDocument]] ([[CCDAdditions]])
+ ([[PDFDocument]] '')pdfDocumentFromArray:([[NSArray]] '')array
{
  if (!array) return nil;
  if ([array count] == 0) return nil;

	[[PDFDocument]] ''masterDocument = nil;
       [[NSEnumerator]] ''enumerator = [array objectEnumerator];
		id anObject;
	
			while (anObject = [enumerator nextObject])
                          if ([anObject isKindOfClass:[[[PDFPage]] class]]) {
                             if (!masterDocument)
                                   masterDocument = [[[[PDFDocument]] alloc] initWithData:[anObject dataRepresentation]];
                             else
	                     	[masterDocument insertPage:anObject atIndex:[masterDocument pageCount]];
                          }

return [masterDocument autorelease];
}


- ([[NSSize]])sizeOfPageAtIndex:(unsigned int)index
{
	[[PDFPage]] ''pdfPage = [self pageAtIndex:index];

	if (!pdfPage) return [[NSZeroSize]];

   return [pdfPage boundsForBox:kPDFDisplayBoxMediaBox].size;
}

- ([[NSSize]])sizeInInchesOfPageAtIndex:(unsigned int)index
{
	[[NSSize]] size = [self sizeOfPageAtIndex:index];
       float width=0, height=0;

        // no fair dividing zeros so we check for that...
        if ([[NSEqualSizes]](size, [[NSZeroSize]])) return [[NSZeroSize]];

       // check each component too.
       if (size.width != 0) width = size.width / 72;
       if (size.height != 0) height = size.height / 72;

return [[NSMakeSize]](width, height);
}

@end
</code>

The next-obvious addition would be <code>- ([[NSArray]] '')pages;</code>. <code>-addPagesFromArray:</code> or similar would probably be good too.

----
Borrowed the idea (and some implementation) for the <code>-size...</code> methods from [[ReadingPDFPageDimensions]].

...which will probably break in Leopard due to resolution independence. If this can be fixed now (legally) then please do. Otherwise, I guess we wait.