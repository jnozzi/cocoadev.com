**General/NSTextFieldCell**

General/NSTextFieldCell adds to General/NSCell�s text display capabilities by allowing you to set the color of both the text and its background. You can also specify whether the cell draws its background at all. All of the methods declared by this class are also declared by General/NSTextField, which uses General/NSTextFieldCell<nowiki/>s to draw and edit text.

See: http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSTextFieldCell_Class/index.html

----
After some investigation, I've settled upon how to override text drawing within an General/NSTextFieldCell so that it appears indistinguishable from the same text drawn while the cell is being edited (through the field editor). The sample code below draws the cell's attributed string contents including hyperlinks (normally, General/NSTextFieldCell does not draw styled hyperlinks):

    
- (void)drawInteriorWithFrame:(General/NSRect)rect inView:(General/NSView*)controlView {
	static General/NSTextContainer *tc = nil;
	General/NSLayoutManager *lm = nil;
	General/NSTextStorage *ts = nil;
	
	if (tc == nil) {
		ts = General/[[NSTextStorage alloc] init];
		lm = General/[[NSLayoutManager alloc] init];
		tc = General/[[NSTextContainer alloc] initWithContainerSize:General/NSMakeSize(1e7, 1e7)];
		
		// we configure the layout manager in the way it is configured for editing.
		// these settings were established by looking at the field editor and it's associated
		// objects after installing it using the cell's editWithFrame... method.
		[tc setLineFragmentPadding:2];

		[lm setTypesetterBehavior:NSTypesetterBehavior_10_2_WithCompatibility];
		[lm setUsesFontLeading:NO];
		
		[ts addLayoutManager:lm];
		[lm addTextContainer:tc];
		
		// these are retained by our text storage...
		[lm release];
		[tc release];		
	}
	
	lm = [tc layoutManager];
	ts = [lm textStorage];
	
	// to position our text correctly and ensure that lines wrap as they do in the
	// field editor, we expand our layout rectangle width by 0 (0 inset for no border, 1 for line border, experiment for others)
	General/NSRect textRect = General/NSInsetRect(rect, 0, 0);
	
	[ts setAttributedString:self.attributedStringValue];
	[tc setContainerSize:General/NSMakeSize(textRect.size.width, 1e7)];
	
	// fix hyperiinks
	unsigned int length;
	General/NSRange effectiveRange;
	
	length = [ts length];
	effectiveRange = General/NSMakeRange(0, 0);
	while (General/NSMaxRange(effectiveRange) < length) {
		NSURL *link = [ts attribute:General/NSLinkAttributeName atIndex:General/NSMaxRange(effectiveRange) effectiveRange:&effectiveRange];
		if (link != nil) {
			General/NSDictionary *linkAttributes = General/[NSDictionary dictionaryWithObjectsAndKeys:
											General/[NSColor blueColor], General/NSForegroundColorAttributeName,
											General/[NSNumber numberWithInt:General/NSUnderlineStyleSingle], General/NSUnderlineStyleAttributeName,
											nil];
			
			[lm setTemporaryAttributes:linkAttributes forCharacterRange:effectiveRange];
		}
	}
	
	General/NSRange range, glyphRange;
	range = General/NSMakeRange(0, ts.length);
	glyphRange = [lm glyphRangeForCharacterRange:range actualCharacterRange:NULL];
	
	if (glyphRange.length > 0) {
		[lm drawBackgroundForGlyphRange:glyphRange atPoint:textRect.origin];
		[lm drawGlyphsForGlyphRange:glyphRange atPoint:textRect.origin];
	}
}


Important in the above code is the configuration of the layout manager. Typesetter behavior is set to 10.2 with compatibility and usesFontLeading is set to NO. The textContainer's line fragment padding is set to 2 - these settings cause lines of text to be rendered exactly as they are using the field editor. The expanded text frame should be established through experimentation. It will vary with the style of border you have set on your text field - in the case of a borderless text field, the inset is 0.

General/MrO