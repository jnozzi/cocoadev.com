General/NSMultipleTextSelectionPboardType is a standard pasteboard type that's a little different from the norm.  The documentation about it is a little hard to find; the only documentation I've seen are in the Leopard (10.5) General/AppKit release notes, which says the following:

----
Finally, there is a new pasteboard type used by General/NSTextView when copying and pasting multiple selections.

    General/NSString *General/NSMultipleTextSelectionPboardType;

This type is used only when the pasteboard is representing a multiple selection. The contents for this type should be an array of General/NSNumbers, one for each subrange of the selection, indicating the number of paragraphs contained in each subrange. The plain or rich text contents of the pasteboard will be a string representing the contents of each subrange concatenated with paragraph breaks in between them (where they do not already end in paragraph breaks); that combined with the paragraph counts in the General/NSMultipleTextSelectionPboardType is sufficient to determine which portions of the contents are associated with which subrange. This mechanism has been chosen because it is consistent across plain and rich text, and across different representations of rich text. The counts may be checked for consistency by comparing the total number of paragraphs in the plain or rich text contents of the pasteboard with the total of the numbers in the General/NSMultipleTextSelectionPboardType array; if the two do not match, then the General/NSMultipleTextSelectionPboardType contents should be ignored.
----

(Thanks to Douglas Davidson for a pointer to the documentation.)

One more unusual thing that the documentation doesn't mention is that data on the General/NSPasteboard for the array of General/NSNumbers is an (XML!) property list, not an General/NSArchived array as is usual for most pasteboard data.  

Since the pasteboard data's in a rather unusual format and is pretty annoying to deal with, here's some code to extract the text selections off the pasteboard for the General/NSMultipleTextSelectionPboardType.  BSD-licensed, etc etc.  It currently extracts the text in plaintext format, but it should be fairly easy to support rich text.

    
/// Returns an General/NSArray, where each item in the array is a single plain-text General/NSString representing a single selection from the pasteboard.  Returns nil if the pasteboard doesn't currently hold an General/NSMultipleTextSelectionPboardType, or if the total number of paragraphs in the pasteboard text do not match the total of the nubmes in the General/NSMultipleTextSelectionPboardType array (as per the documentation).
/** See http://developer.apple.com/releasenotes/Cocoa/General/AppKit.html (search for General/NSMultipleTextSelectionPboardType) for information on the pasteboard data format. */
General/NSArray* General/NSPasteboardPlainTextArrayForMultipleTextSelection(General/NSPasteboard* pboard)
{
	General/NSString* firstAvailablePasteBoardType = [pboard availableTypeFromArray:General/[NSArray arrayWithObject:General/NSMultipleTextSelectionPboardType]];
	if(![firstAvailablePasteBoardType isEqual:General/NSMultipleTextSelectionPboardType]) return nil;
	
	id propertyList = [pboard propertyListForType:General/NSMultipleTextSelectionPboardType];
	General/NSArray* numberOfParagraphsPerSelection = [propertyList isKindOfClass:General/[NSArray class]] ? (General/NSArray*)propertyList : nil;
	if(numberOfParagraphsPerSelection == nil) return nil;
	
	General/NSString* allPlainTextSelections = [pboard stringForType:General/NSStringPboardType];
	
	static General/NSCharacterSet* paragraphSeparatorCharacterSet = nil;
	if(paragraphSeparatorCharacterSet == nil)
	{
		// We can't use General/[NSCharacterSet newlineCharacterSet] here, since that covers U+000A-U+000D and U+0085; we only want U+000A
		paragraphSeparatorCharacterSet = General/[[NSCharacterSet characterSetWithRange:General/NSMakeRange('\n', 1)] retain];
	}
	
	General/NSMutableArray* textSelections = General/[NSMutableArray array];
	
	General/NSUInteger numberOfParagraphsScanned = 0;
	General/NSScanner* paragraphScanner = General/[NSScanner scannerWithString:allPlainTextSelections];
	for(General/NSNumber* paragraphsToScanNumber in numberOfParagraphsPerSelection)
	{
		const General/NSUInteger numberOfParagraphsToScan = [paragraphsToScanNumber unsignedIntegerValue];
		
		General/NSMutableString* nextTextSelection = General/[NSMutableString string];
		for(General/NSUInteger i = 0; i < numberOfParagraphsToScan; i++)
		{
			General/NSString* nextParagraph = nil;
			
			const BOOL didScanOK = [paragraphScanner scanUpToCharactersFromSet:paragraphSeparatorCharacterSet intoString:&nextParagraph];
			if(didScanOK) numberOfParagraphsScanned++;
			else break;
			
			[nextTextSelection appendString:nextParagraph];
			
			if(i+1 != numberOfParagraphsToScan) [nextTextSelection appendString:@"\n"];
		}
		
		[textSelections addObject:nextTextSelection];
	}

	General/NSUInteger totalNumberOfParagraphs = 0;
	for(General/NSNumber* numberOfParagraphsInSingleSelectionNumber in numberOfParagraphsPerSelection)
	{
		totalNumberOfParagraphs += [numberOfParagraphsInSingleSelectionNumber unsignedIntegerValue];
	}

	if(numberOfParagraphsScanned == totalNumberOfParagraphs) return textSelections;
	else return nil;
}


And, here's some code to write data to the pasteboard.  You probably want to use the     General/NSPasteboardSetDataForPlainTextSelections() function below, which writes directly to the pasteboard for you.

    
/// Given an General/NSArray of General/NSString items, this creates General/NSData and General/NSString objects that is intended to be written to an General/NSPasteboard for General/NSMultipleTextSelectionPboardTypeData.  Returns YES on success; NO otherwise.
/** See http://developer.apple.com/releasenotes/Cocoa/General/AppKit.html (search for General/NSMultipleTextSelectionPboardType) for information on the pasteboard data format. */
BOOL General/NSPasteboardDataForPlainTextArray(General/NSArray* textSelections, General/NSData** outNSMultipleTextSelectionPboardTypeData, General/NSString** outNSStringPboardTypeString)
{
	if(outNSMultipleTextSelectionPboardTypeData == nil) return NO;
	if(outNSStringPboardTypeString == nil) return NO;
	
	static General/NSCharacterSet* paragraphSeparatorCharacterSet = nil;
	if(paragraphSeparatorCharacterSet == nil)
	{
		// We can't use General/[NSCharacterSet newlineCharacterSet] here, since that covers U+000A-U+000D and U+0085; we only want U+000A
		paragraphSeparatorCharacterSet = General/[[NSCharacterSet characterSetWithRange:General/NSMakeRange('\n', 1)] retain];
	}
	
	General/NSMutableArray* numberOfParagraphs = General/[NSMutableArray array];
	for(General/NSString* textSelection in textSelections)
	{
		General/NSArray* paragraphs = [textSelection componentsSeparatedByCharactersInSet:paragraphSeparatorCharacterSet];
		
		[numberOfParagraphs addObject:General/[NSNumber numberWithUnsignedInteger:[paragraphs count]]];
	}
	
	General/NSString* errorString = nil;
	General/NSData* General/NSMultipleTextSelectionPboardTypeData = General/[NSPropertyListSerialization dataFromPropertyList:numberOfParagraphs format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
	if(General/NSMultipleTextSelectionPboardTypeData)
	{
		*outNSMultipleTextSelectionPboardTypeData = General/NSMultipleTextSelectionPboardTypeData;
	}
	else
	{
		General/NSLog(@"Couldn't construct General/NSMultipleTextSelectionPboardType property list from array: %@", errorString);
		
		return NO;
	}

	*outNSStringPboardTypeString = [textSelections componentsJoinedByString:@"\n"];
	
	return YES;
}

/// Writes the given General/NSArray of General/NSString items to the given pasteboard. Note that you must declare that General/NSMultipleTextSelectionPboardType is to be written to the pasteboard by yourself, using [pboard declareTypes:General/[NSArray arrayWithObject:General/NSMultipleTextSelectionPboardType] owner:yourClass]: this function cannot do it because it doesn't know who the know is.  Returns YES if successful; NO otherwise.
/** See http://developer.apple.com/releasenotes/Cocoa/General/AppKit.html (search for General/NSMultipleTextSelectionPboardType) for information on the pasteboard data format. */
BOOL General/NSPasteboardSetDataForPlainTextSelections(General/NSArray* textSelections, General/NSPasteboard* pboard)
{
	General/NSData* General/NSMultipleTextSelectionPboardTypeData = nil;
	General/NSString* General/NSStringPboardTypeString = nil;
	
	const BOOL didCreateDataForPasteboardOK = General/NSPasteboardDataForPlainTextArray(textSelections, &General/NSMultipleTextSelectionPboardTypeData, &General/NSStringPboardTypeString);
	if(!didCreateDataForPasteboardOK) return NO;
	
	const BOOL setMultipleTextSelectionOK = [pboard setData:General/NSMultipleTextSelectionPboardTypeData forType:General/NSMultipleTextSelectionPboardType];
	if(!setMultipleTextSelectionOK) return NO;
	
	const BOOL setStringOK = [pboard setString:General/NSStringPboardTypeString forType:General/NSStringPboardType];
	if(!setStringOK) return NO;
	
	return YES;
}


All the code above is tested, and works OK for me.  Hopefully this will save people some trouble.  -General/AndrePang