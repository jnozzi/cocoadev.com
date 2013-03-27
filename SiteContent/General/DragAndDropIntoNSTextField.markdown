

Hey!

I'm writing a GUI wrapper for a tool I wrote to download code to an EZ-USB development board. Its nearly finished, but I have hit a stumbling block.

I want to be able to drag a file from the Finder into an General/NSTextField. After dragging, the filepath is written into the General/NSTextField. This all works fine, but when the General/NSTextField in question has the focus, only the focus ring acts as the dragging area, ie. I can't drag the file onto the General/NSTextField itself, only the focus ring.

When the General/NSTextField doesn't have the focus, it all works fine. It may be really simple, but I can't work out whats going on here.

I subclassed General/NSTextField to add the dragging stuff, and I've included the code below.

Can anyone give me an idea of how to fix this?

Many thanks in advance,

Lyndon.


    
@implementation General/EZTextView

- (void)awakeFromNib
{
	[self registerForDraggedTypes:General/[NSArray arrayWithObjects:General/NSFilenamesPboardType, nil]];
}

- (General/NSDragOperation)draggingEntered:(id <General/NSDraggingInfo>)sender 
{
    General/NSPasteboard *pboard;
	General/NSDragOperation sourceDragMask;

	sourceDragMask = [sender draggingSourceOperationMask];
	pboard = [sender draggingPasteboard];

	if (General/pboard types] containsObject:[[NSFilenamesPboardType]) 
	{
		if (sourceDragMask & General/NSDragOperationLink) 
		{
			return General/NSDragOperationLink;
		} 
	}

    return General/NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <General/NSDraggingInfo>)sender 
{
    General/NSPasteboard *pboard;
    General/NSDragOperation sourceDragMask;
	General/NSArray *fileArray;

    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];

	if (General/pboard types] containsObject:[[NSFilenamesPboardType])
	{
        fileArray = [pboard propertyListForType:General/NSFilenamesPboardType];
		[self setStringValue:[fileArray objectAtIndex:0]];
		return YES;
    }

    return NO;
}

@end

----
The fact that the General/FieldEditor exists makes this task much harder than it should be. Because you're actually dropping onto the General/FieldEditor when the text field has focus, you need to write some code in your window's delegate to return a custom General/FieldEditor which has code similar to what you have above.