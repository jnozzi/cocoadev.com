Here is a category for General/NSTextView that allows you to easily size a text view to fit its contents:

    
@interface General/NSTextView (General/SizeToFit)

- (General/NSSize)minSizeForContent;

@end

@implementation General/NSTextView (General/SizeToFit)

- (General/NSSize)minSizeForContent
{
	General/NSLayoutManager *layoutManager = [self layoutManager];
	General/NSTextContainer *textContainer = [self textContainer];
	
	[layoutManager boundingRectForGlyphRange:General/NSMakeRange(0, [layoutManager numberOfGlyphs]) inTextContainer:textContainer]; // dummy call to force layout
	General/NSRect usedRect = [layoutManager usedRectForTextContainer:textContainer];
	General/NSSize inset = [self textContainerInset];
	
	return General/NSInsetRect(usedRect, -inset.width * 2, -inset.height * 2).size;
}

@end
