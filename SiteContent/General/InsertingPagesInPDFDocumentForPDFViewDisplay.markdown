

I'm trying to find a better way to insert numerous pages into a General/PDFDocument for display in a General/PDFView.

I have an array containing General/PDFPages I'm calling "_pages".

I've tried the intuitive approach, but the General/PDFView is screwing it up...it won't display the thing, for some reason if I change the [_pages objectAtIndex:i] index value to a static number it will work (putting the same page in throughout the whole script), but otherwise there are always problems, either at the end of the document where the General/PDFView goes berserk (indexForPage:page not found). Sometimes it puts in a default small page. I've looked pretty extensively into my _pages array and counters and they appear to be alright, so I think it's a problem with my understanding of General/PDFView and/or General/PDFDocument rather than a pointer error. (Also, others have had this problem)

    

	int i;

	General/PDFDocument *masterScriptDocument = General/[[PDFDocument alloc] initWithData:[_pages objectAtIndex:0] dataRepresentation]];
	for (i=1;i<_numberOfPages; i++) {
		[masterScriptDocument insertPage:[_pages objectAtIndex:i] atIndex:i];
	}




I've looked around online and found this solution:

    

	int i;

	General/PDFDocument *masterScriptDocument = General/[[PDFDocument alloc] initWithData:General/_pages objectAtIndex:0] dataRepresentation;
	for (i=1;i<_numberOfPages; i++) {
		General/PDFDocument *aPage = General/[[PDFDocument alloc] initWithData:General/_pages objectAtIndex:0]  dataRepresentation;
		[masterScriptDocument insertPage:[aPage pageAtIndex:0] atIndex:i];
		masterScriptDocument = General/[[PDFDocument alloc] initWithData:[masterScriptDocument dataRepresentation]]; 

	}


This works, but freezes up my computer on anything over twenty pages.

Anybody have a fix for this?

Thanks - General/EricBadros
----

I've figured it out and though it is reasonably slow (it takes about 3-4 times as long as preparing the document for printing) it works consistently and correctly...I'm going to try out a few more things to speed it up (and make it more elegant) before posting my solution. - General/EricBadros

----
Sorry, almost forgot that I had promised to post this.


I have two General/NSTableViews subclass instances, one with the revision document and one with the source document. One can choose pages from the source document and then choose which pages to replace, or insert in the revision document...that's why you may see a lot of extraneous stuff that isn't vitally important but provides a more complete solution (I think). This is in my General/ScriptManagerController. Please forgive me, I made an assumption that both documents pages are 612x792...easily fixed but gets the point across.

    

- (void) insertPages {
	int j, insertionIndexOfDestination, indexOfRevision;
	//Make a copy of the revision that is being modified
	indexOfRevision = [_scriptRevisionPopUpButton indexOfSelectedItem];
	
	[self setNewRevision:General/_projectData revisions] objectForKey:[[_projectData revisionTitles] objectAtIndex:indexOfRevision];
	//	[self setNewRevision:General/_projectData revisions] objectAtIndex:indexOfRevision;

	// Find and store the selected source pages in General/NSMutableArray pagesToBeInserted
	int i;
	General/NSMutableArray *pagesToBeInserted = General/[[NSMutableArray alloc] init];
	for (i= 0; i<= [_scriptTableView numberOfRows]; i++) {
		if ([_scriptTableView isRowSelected:i] == YES) {
			General/NSMutableDictionary *pageInformation = General/[[NSMutableDictionary alloc] init];
			[pageInformation setObject:[_scriptPopUpButton titleOfSelectedItem] forKey:@"fromScriptNamed"];
			[pageInformation setObject:General/[NSNumber numberWithInt:i] forKey:@"fromScriptPage"];
			General/PDFDocument *theSourcePDF = General/[[PDFDocument alloc] initWithData:General/[_projectData scripts] objectForKey:[_scriptPopUpButton titleOfSelectedItem objectForKey:@"document"]];
			[pageInformation setObject:General/theSourcePDF pageAtIndex:i] dataRepresentation] forKey:@"page"];
			[pagesToBeInserted addObject:pageInformation];
			[pageInformation release];
		}
	}
	
	insertionIndexOfDestination = [[_scriptRevisionTableView selectedRowIndexes] firstIndex];
	
	[[NSMutableArray *newRevisionPages = General/[[NSMutableArray alloc] init];
	newRevisionPages = General/_newRevision pages] mutableCopy];
	for (j=0; j<[pagesToBeInserted count] ; j++) {
		[newRevisionPages insertObject:[pagesToBeInserted objectAtIndex:j] atIndex:insertionIndexOfDestination];
		[self insertComponentValuesForPage:insertionIndexOfDestination];
		[self insertAnnotationsForPage:insertionIndexOfDestination];
		insertionIndexOfDestination = insertionIndexOfDestination + 1;
	}
	[pagesToBeInserted release];
	[_newRevision setPages:newRevisionPages];
	[[NSString *revisionName = General/[NSString stringWithFormat:@"Revision #%i", (General/_projectData revisions] count])];
	//[self createScriptForRevision:_newRevision withName:revisionName];
	[_projectData addRevision:_newRevision withName:revisionName];
	[_newRevision release];
	[self prepareWindow];
	[self closeWaitWindow];

}


    

- (void) replacePages {
	int  j, insertionIndexOfDestination, indexOfRevision;
	
	//Make a copy of the revision that is being modified
	indexOfRevision = [_scriptRevisionPopUpButton indexOfSelectedItem];
	
	[self setNewRevision:[[_projectData revisions] objectForKey:[[_projectData revisionTitles] objectAtIndex:indexOfRevision];

	//[self setNewRevision:General/_projectData revisions] objectAtIndex:indexOfRevision;
	
	// Find and store the selected source pages in General/NSMutableArray replacementPages
	int i;
	General/NSMutableArray *replacementPages = General/[[NSMutableArray alloc] init];
	General/PDFDocument *theSourcePDF = General/[[PDFDocument alloc] initWithData:General/[_projectData scripts] objectForKey:[_scriptPopUpButton titleOfSelectedItem objectForKey:@"document"]];
	General/NSString *theSourceScriptName = [_scriptPopUpButton titleOfSelectedItem];
	for (i= 0; i< [_scriptTableView numberOfRows]; i++) {
		if ([_scriptTableView isRowSelected:i] == YES) {
			General/NSMutableDictionary *pageInformation = General/[[NSMutableDictionary alloc] init];
			[pageInformation setObject:theSourceScriptName forKey:@"fromScriptNamed"];
			[pageInformation setObject:General/[NSNumber numberWithInt:i] forKey:@"fromScriptPage"];
			[pageInformation setObject:General/[theSourcePDF pageAtIndex:i] dataRepresentation] mutableCopy] forKey:@"page"];
			[replacementPages addObject:pageInformation];
			[pageInformation release];
		}
	}
	
	
	// Copy the current revision and replace the pages into the copy, also change the name and number of pages dictionary objects
	insertionIndexOfDestination = [[_scriptRevisionTableView selectedRowIndexes] firstIndex];
	int lastIndexOfDestination = [[_scriptRevisionTableView selectedRowIndexes] lastIndex];
	
	[[NSMutableArray *newRevisionPages = General/[[NSMutableArray alloc] init];
	newRevisionPages = General/_newRevision pages] mutableCopy];
	j = 0;
	for (j=insertionIndexOfDestination; j<= lastIndexOfDestination; j++) {
		[newRevisionPages removeObjectAtIndex:insertionIndexOfDestination];
		[self removeComponentValuesForPage:insertionIndexOfDestination];
		[self removeAnnotationsForPage:insertionIndexOfDestination];

	}
	
	int k;
	for (k = 0; k<[replacementPages count]; k++) {
		[newRevisionPages insertObject:[replacementPages objectAtIndex:k] atIndex:insertionIndexOfDestination];
		[self insertComponentValuesForPage:insertionIndexOfDestination];
		[self insertAnnotationsForPage:insertionIndexOfDestination];
		insertionIndexOfDestination = insertionIndexOfDestination + 1;
	}
	
	[replacementPages release];
	[_newRevision setPages:[newRevisionPages mutableCopy;
	[newRevisionPages release];
	General/NSString *revisionName = General/[NSString stringWithFormat:@"Revision #%i", (General/_projectData revisions] count])];
	[[PDFDocument *theScript = [self createScriptForRevision:_newRevision withName:revisionName];
	[_newRevision setScript:[theScript dataRepresentation]];
	[_projectData addRevision:_newRevision withName:revisionName];
	[_newRevision release];
	[self prepareWindow];
	[self closeWaitWindow];
}


    
- (General/NSData *) createScriptForRevision:(Revision *) aRevision withName:(General/NSString *) aName{
	[_scriptCreatorView drawPdfWithPages:[aRevision pages]];
	[_scriptCreatorView setNeedsDisplay:YES];
	General/NSPrintInfo *printInfo;
	General/NSPrintInfo *sharedInfo;
	General/NSPrintOperation *printOp;
	General/NSMutableDictionary *printInfoDict;
	General/NSMutableDictionary *sharedDict;
	
	sharedInfo = General/[NSPrintInfo sharedPrintInfo];
	sharedDict = [sharedInfo dictionary];
	printInfoDict = General/[NSMutableDictionary dictionaryWithDictionary:sharedDict];
	
	[printInfoDict setObject:General/NSPrintSaveJob forKey:General/NSPrintJobDisposition];
	General/NSString *revisionScriptFilePath = General/[NSString stringWithFormat:@"/%@.pdf", aName];

	[printInfoDict setObject:revisionScriptFilePath forKey:General/NSPrintSavePath];
	printInfo = General/[[NSPrintInfo alloc] initWithDictionary: printInfoDict];
	printOp = General/[NSPrintOperation printOperationWithView:[self scriptCreatorView] printInfo:printInfo];
	[printOp setShowPanels:NO];
	[printOp runOperation];
	NSURL *aPath;
	aPath = [NSURL fileURLWithPath:revisionScriptFilePath];
	General/PDFDocument *newMasterScript = General/[[[PDFDocument alloc] initWithURL:aPath] autorelease];
	return newMasterScript;

}



Then, the I have subclassed General/NSView for the General/ScriptCreatorView and here is the relevant code:

    

- (void) drawPdfWithPages:(General/NSMutableArray *) somePages {
	int i;
	_numberOfPages = [somePages count];
	_pdfPageImageArray = General/[[NSMutableArray alloc] init];
	for (i=0; i<_numberOfPages; i++) {
		General/NSImage *masterPdfImage = General/[[NSImage alloc] initWithSize:General/NSMakeSize(612, 792)];
		[masterPdfImage setDataRetained:YES];
		General/NSPDFImageRep *aPdfRep = General/[NSPDFImageRep imageRepWithData:General/somePages objectAtIndex:i] objectForKey:@"page";
		General/NSRect onePageBounds = [aPdfRep bounds];
		[masterPdfImage addRepresentation:aPdfRep];
		[masterPdfImage lockFocus];
		General/[[NSColor whiteColor] set];
		General/[NSBezierPath fillRect:onePageBounds];
		[aPdfRep drawInRect:onePageBounds];
		[masterPdfImage unlockFocus];
		[_pdfPageImageArray addObject:masterPdfImage];
		[masterPdfImage release];
	}
	General/NSRect frameRect;
	frameRect = General/NSMakeRect(0,0,612, 792);
	frameRect.size.height *= _numberOfPages;
	[super setFrame:frameRect];
}

    

- (void) drawRect: (General/NSRect) rect {
	int i;
	General/NSRect onePageBounds = General/NSMakeRect(0,0,612,792);
	General/NSAffineTransform* xform = General/[NSAffineTransform transform];
	General/NSRect frameRect = [self frame];
	[xform translateXBy:0.0 yBy:frameRect.size.height];
	[xform scaleXBy:1.0 yBy:-1.0];
	[xform concat];
	
	for (i=0; i< _numberOfPages; i++) {
		{
			onePageBounds.origin.y = frameRect.size.height - ((i+1) * onePageBounds.size.height);
			General/_pdfPageImageArray objectAtIndex:i] drawAtPoint:onePageBounds.origin fromRect:[[NSZeroRect operation:General/NSCompositeSourceOver fraction:1.0];
		}
	}
}


    

- (BOOL) isFlipped {
	return YES;
}


- (BOOL) knowsPageRange: (General/NSRangePointer) range
{
    range->location = 0;        // page numbers are one-based
    range->length = _numberOfPages + 1;  
	
    return YES;
}

- (General/NSRect) rectForPage: (int) pageNumber {
	General/NSRect pageRect = General/NSMakeRect(0,0,612, 792);
	pageRect.origin.y = (pageNumber - 1) * pageRect.size.height;
	return pageRect;
}



Hope that helps...I know a lot of people have been trying to make this work and I've found this is pretty fast...for 120 pages on a Powerbook G4 1.6 with 1GB I just get the pinwheel before the new General/PDFDocument is created. General/EricBadros


----
Maybe I'm misunderstanding the problem but why not do it like so?...

    
- (General/PDFDocument *)pdfDocumentFromArray:(id)array
{
	General/PDFDocument *masterDocument;
       General/NSEnumerator *enumerator = [array objectEnumerator];
		id anObject;
	
			while (anObject = [enumerator nextObject]) {
                             if (!masterDocument)
                                   masterDocument = General/[[PDFDocument alloc] initWithData:[anObject dataRepresentation]];
                             else
	                     	[masterDocument insertPage:anObject atIndex:[masterDocument pageCount]];
                    }

return [masterDocument autorelease];
}


That's basically the way I do it. As long as everything in the array is a General/PDFPage it should work ok. If I really need to insert pages in specific places (instead of just adding to the end) then I modify/re-order the array before making the document.

*I went ahead and turned that into General/PDFDocumentCategory so..yeah.*