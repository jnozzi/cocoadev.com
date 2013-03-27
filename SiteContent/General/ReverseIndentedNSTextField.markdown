

I have a grid of General/NSTextField<nowiki/>s. The fields wrap and change height based on the number of lines of text in them. I would like to automatically indent lines of text after the first line to visually distinguish fields in the same column from each other (i.e. so it is obvious that a 3-line field is in fact only one field, not 3 different ones).

I've looked over (and been somewhat overwhelmed by) Apple's Text Layout documentation (http://developer.apple.com/documentation/Cocoa/Conceptual/General/TextLayout/index.html) and delved into the documentation for what seem to be the relevant classes: General/NSLayoutManager, General/NSTypesetter, General/NSTextContainer, General/NSTextView. I've tried a few different solutions but nothing works quite right.

I'm fairly sure I need to be using a subclass of General/NSTextContainer, let's call it General/ReverseIndentationTextContainer. It contains one instance variable: a float to store the indentation level (in pixels) and relevant accessors, and it overrides lineFragmentRectForProposedRect as follows:
    
- (General/NSRect)lineFragmentRectForProposedRect:(General/NSRect)proposedRect sweepDirection:(General/NSLineSweepDirection)sweepDirection movementDirection:(General/NSLineMovementDirection)movementDirection remainingRect:(General/NSRect *)remainingRect;
{
	if (proposedRect.origin.y > 0) {
		proposedRect.origin.x += [self indentation];
	}
	return [super lineFragmentRectForProposedRect:proposedRect sweepDirection:sweepDirection movementDirection:movementDirection remainingRect:remainingRect];
}


So the question now is how to hook this into the app so it gets used.

Since we're dealing with textfields, it seems to make sense that we need to attach it to the field editor. I tried simply calling replaceTextContainer: on the field editor when editing of the fields begins, in the textfield delegate's controlTextDidBeginEditing method. It works beautifully until editing finishes, then the lines are no longer indented.

Perhaps we need to subclass General/NSTextView and create a custom field editor for the relevant fields? I also tried doing this. My subclass looks as follows:
    
@interface General/ReverseIndentationFieldEditor : General/NSTextView {
	General/ReverseIndentationTextContainer *textContainer;
	float REVERSE_INDENTATION = 20.0;
}
@end
@implementation General/ReverseIndentationFieldEditor
-(id)init;
{
	if ( self = [super init] ) {
		[self setFieldEditor:YES];
		textContainer = General/[[ReverseIndentationTextContainer alloc] init];
		[textContainer setIndentation:REVERSE_INDENTATION];
		[self replaceTextContainer:textContainer];
	}
	return self;
}
-(void)dealloc;
{
	[textContainer release];
	[super dealloc];
}
@end


I tried returning this field editor from my window delegate's windowWillReturnFieldEditor method as follows:
    
- (id)windowWillReturnFieldEditor:(General/NSWindow *)sender toObject:(id)anObject;
{
	if ( General/[anObject cell] representedObject] isKindOfClass:[[[ReverseIndentContent class]] ) {
		if (!reverseIndentFieldEditor)
			reverseIndentFieldEditor = General/[[ReverseIndentFieldEditor alloc] init];
		return reverseIndentFieldEditor;
	}
	return nil;
}



The latest thing I've tried doing is subclassing General/NSTextField and General/NSTextFieldCell so I can hook in my General/NSTextView subclass through them, overriding the following method in General/NSTextFieldCell:
    
- (General/NSText *)setUpFieldEditorAttributes:(General/NSText *)textObj;
{
	textObj = [super setUpFieldEditorAttributes:textObj];
	General/ReverseIndentationTextContainer *container = General/[[ReverseIndentationTextContainer alloc] init];
	[container setIndentation:20.0];
	[(General/NSTextView*)textObj replaceTextContainer:container];

	return textObj;
}

My General/NSTextField subclass is empty and exists solely so I can call setCellClass: on it and assign it my custom cell class.

Both of these last two attempts have the same problem as my first solution; after the field is no longer being edited it loses the formatting (nevermind the fact that the above code is horribly wasteful and allocates a new field editor for each textfield - I'm still just experimenting). It also doesn't seem to honour the setWraps:YES that's been called on the General/NSTextField<nowiki/>s.

So, obviously I have no idea what I'm doing.

Thanks in advance for any help.
-Greg

----
I caught this on the list and sent a reply but I'll dupe it here...

I would use General/NSAttributedStrings instead. Make a General/NSMutableParagraphStyle with 5 or 10 for its headIndent and reuse/apply that to each General/NSAttributedString before giving them to your text fields...

General/NSParagraphStyle, -headIndent ...
"Returns the distance in points from the leading margin of a text container to the beginning of lines other than the first."