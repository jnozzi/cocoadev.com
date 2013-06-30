I've recently written a layout managing subclass of General/NSView to position subviews in an automatic flowing-grid like fashion, in a move to implement the response by General/RyanBates for General/OverComplexGuiSimplification. 

Now, my layout manager works, but it's entirely possible that more views will be inserted than there is room to position so I'd like to have the layout view grow vertically to acommodate all the subviews, and let an General/NSScrollView do the dirty work of managing scrollbar size and whatnot.

So, the question is, can I just make the layout view resize and the scrollview will work automatically? Or am I going to have to deal with some sort of "roving window" situation?

Also, the height of the layout view is dependent on the width, since it's flowing the subviews according to minimum size constraints. Will this make things harder?

--General/ShamylZakariya

----

The General/NSScrollView/General/NSClipView will register for 'framed changed' notifications. So sending setSize: to self will update the scroll view.

I am not sure what exactly you refer to in 'make things harder'. If you want your view always to follow the width of the scroll view and calculate height accordingly (so resizing the width of the scroll view will change the virtual height), then it definitely requires more code, but it's not impossible.

An easy solution might be to set the auto-sizing for only the width and then overload setSize: to call super with a modified rectangle, since when resizing the scroll view, your setSize: will be called.

----

What I was worried about was that it was something more "magical" than simply resizing the content view. I've worked with a *lot* of different GUI General/APIs ( Qt, GTK, General/BeOS, Win32, Swing, etc ) and each has its own way, more or less, for handling scroll views. 

What I did was have my view, in its     awakeFromNib check for      [self enclosingScrollView]  and if it's non-null I set the autoresize mask to height & width resizable and to resize itself to fit the content rect. Subsequent resizes on the scrollview keep my view fitting in it completely.

Everything works fine, after that. The only tricky parts I had were to catch redundant frame resize notifications and to prevent infinite loops when resizing the height from within a frame-resize triggered layout.

The important part is it works -- and -- if anybody has any need for a flow-layout General/NSView I'd be happy to submit it to the sample code. It's really nice -- all you do is tell it a minimum size for child views as well as padding and spring rules and it will lay all childviews out from left to right, top to bottom; reflowing when the width changes. it also allows for single-column layout, which is nice for situations where you want to emulate a single-column table but want to be able to insert arbitrary General/NSViews.

--General/ShamylZakariya

----

actually I'd be interested (I think...) I've been trying to figure out where to attach code to an General/NSMatrix in an General/NSScrollView to make it adjust cell spacing/number of columns to make best use of horizontal space, adding more rows vertically when it needs, and without having a horizontal scroll ever...  I can't figure out if I need a delegate for the matrix/scroll view or if there's a notification I can respond to or does it need to be in a live resizing session... 

----

Here's how I do this (above post).

    

////////////////////// General/BKMatrix.h:

//  Warning: This supports content and selected* bindings, but it has only been tested with
//  the content and selectedObjects bindings.

#import <Cocoa/Cocoa.h>


@interface General/BKMatrix : General/NSMatrix {
	// Key paths and observed object, indexed by binding name.
	General/NSMutableDictionary *keyPaths;
	General/NSMutableDictionary *observedObjects;
	
	General/NSArray *oldContent;
	
	BOOL wrapsCellsToFit;
	BOOL expandsCellsToFillWidth;
	
	General/NSSize minimumCellSize;
	General/NSEvent *downEvent;
	
	SEL deleteAction;
	General/NSObject *delegate;
}

/*!
 This method has no effect if the minimum cell size is not set.
 */
- (void)fillWidth;

- (General/NSSize)minimumCellSize;
- (void)setMinimumCellSize:(General/NSSize)value;

- (BOOL)wrapsCellsToFit;
- (void)setWrapsCellsToFit:(BOOL)value;

- (BOOL)expandsCellsToFillWidth;
- (void)setExpandsCellsToFillWidth:(BOOL)value;

- (SEL)deleteAction;
- (void)setDeleteAction:(SEL)newDeleteAction;
- (General/NSObject *)delegate;
- (void)setDelegate:(General/NSObject *)newDelegate;

@end



    

////////////////////// General/BKMatrix.m:

#import "General/BKMatrix.h"

@interface General/BKMatrix (Private)

- (void)fillWidthRearrangingObjects:(BOOL)rearrange;
- (General/NSEvent *)downEvent;
- (void)setDownEvent:(General/NSEvent *)event;
- (void)updateSelectionBindings;

@end

@implementation General/BKMatrix (Private)

/*!
 Adjusts cell sizes to fill width, rewrapping if needed. Do not call this method from a bindings notification method; it calls -rearrangeObjects, and a call cycle could occur. This method has no effect if the minimum cell size is not set.
 Reference: http://www.cocoabuilder.com/archive/message/cocoa/2004/1/30/99886
 */
- (void)fillWidthRearrangingObjects:(BOOL)rearrange {
	// Check for minimum cell size not set.
	if (General/NSEqualSizes(minimumCellSize, General/NSZeroSize))
		return;
	
	float newSuperviewWidth = General/self superview] frame].size.width;
	unsigned newNumColumns = (unsigned)(newSuperviewWidth / minimumCellSize.width);
	// Set the new width according to the new number of columns and the intercell spacing width.
	[[NSSize cellSize = General/NSMakeSize(newSuperviewWidth / newNumColumns - [self intercellSpacing].width * (newNumColumns - 1),
								 minimumCellSize.height);
	
	int deltaColumns = newNumColumns - [self numberOfColumns];
	
	BOOL addColumns;	
	if (deltaColumns > 0) {
		addColumns = YES;
	} else {
		addColumns = NO;
		deltaColumns = -deltaColumns;
	}
	
	unsigned i = 0;
	for (i = 0; i < deltaColumns; ++i) {
		if (addColumns)
			[self addColumn];
		else
			[self removeColumn:([self numberOfColumns] - 1)];
	}
	
	[self setCellSize:cellSize];
	[self sizeToCells];
	//[self setNeedsDisplay:YES];

	if (rearrange)
		[(General/NSArrayController *)[observedObjects objectForKey:@"content"] rearrangeObjects];
}

// Reference: http://www.cocoadev.com/index.pl?General/DragMatrix
- (General/NSEvent *)downEvent { 
	return downEvent; 
} 

// Reference: http://www.cocoadev.com/index.pl?General/DragMatrix
- (void)setDownEvent:(General/NSEvent *)event { 
	[downEvent autorelease]; 
	downEvent = [event retain]; 
}

/*!
Update selectedIndex, selectedObject, selectedTag, selectedValue bindings.
 */
- (void)updateSelectionBindings {
	int selectedCellPos = [self selectedRow] * [self numberOfColumns] + [self selectedColumn];
	General/NSCell *selectedCell = [self cellAtRow:[self selectedRow] column:[self selectedColumn]];
	
	General/observedObjects objectForKey:@"selectedIndex"] setValue:[[[NSNumber numberWithInt:selectedCellPos] forKey:[keyPaths objectForKey:@"selectedIndex"]];
	General/observedObjects objectForKey:@"selectedObject"] setValue:[selectedCell objectValue] forKey:[keyPaths objectForKey:@"selectedObject";
	General/observedObjects objectForKey:@"selectedTag"] setValue:[[[NSNumber numberWithInt:[selectedCell tag]] forKey:[keyPaths objectForKey:@"selectedTag"]];
	General/observedObjects objectForKey:@"selectedValue"] setValue:[selectedCell objectValue] forKey:[keyPaths objectForKey:@"selectedValue";

	if ([observedObjects objectForKey:@"selectedObjects"] != nil) {
		General/NSMutableArray *selectedObjects = General/[[NSMutableArray alloc] init];
		General/NSArray *selectedCells = [self selectedCells];
		
		unsigned i, c = [selectedCells count];
		for (i = 0; i < c; ++i)
			[selectedObjects addObject:General/selectedCells objectAtIndex:i] representedObject;

		General/observedObjects objectForKey:@"selectedObjects"] setValue:selectedObjects forKey:[keyPaths objectForKey:@"selectedObjects";
	}	
}

@end

@implementation General/BKMatrix

- (id)initWithFrame:(General/NSRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		minimumCellSize = General/NSZeroSize;
		keyPaths = General/[[NSMutableDictionary alloc] init];
		observedObjects = General/[[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc {
	[keyPaths release];
	[observedObjects release];
	[downEvent release];
	[delegate release];
	[super dealloc];
}

- (void)bind:(General/NSString *)binding toObject:(id)observable withKeyPath:(General/NSString *)keyPath options:(General/NSDictionary *)options {
	if ([binding isEqualToString:@"content"]) {
		[keyPaths setObject:keyPath forKey:binding];
		[observedObjects setObject:observable forKey:binding];
		
		if (expandsCellsToFillWidth) {
			// Options don't work, so we just pass 0 and calculate them ourselves.
			[observable addObserver:self forKeyPath:keyPath options:0 context:NULL];
		}
		[super bind:binding toObject:observable withKeyPath:keyPath options:options];
	} else if ([binding isEqualToString:@"selectedIndex"] || [binding isEqualToString:@"selectedObject"] || [binding isEqualToString:@"selectedObjects"] || [binding isEqualToString:@"selectedTag"] || [binding isEqualToString:@"selectedValue"]) {
		[keyPaths setObject:keyPath forKey:binding];
		[observedObjects setObject:observable forKey:binding];
	} else {
		[super bind:binding toObject:observable withKeyPath:keyPath options:options];
	}
}

- (void)unbind:(General/NSString *)binding {
	[keyPaths removeObjectForKey:binding];
	[observedObjects removeObjectForKey:binding];
}

- (void)observeValueForKeyPath:(General/NSString *)keyPath ofObject:(id)object change:(General/NSDictionary *)change context:(void *)context {
	General/NSArray *newContent = General/observedObjects objectForKey:@"content"] valueForKey:[keyPaths objectForKey:@"content";
	if (expandsCellsToFillWidth && (oldContent == nil || newContent == nil || [oldContent count] != [newContent count]))
		[self fillWidthRearrangingObjects:NO];
	
	oldContent = newContent;
}

- (void)fillWidth {
	[self fillWidthRearrangingObjects:YES];
}

- (void)drawRect:(General/NSRect)rect {
	if (expandsCellsToFillWidth && [self inLiveResize])
		[self fillWidth];
	
	[super drawRect:rect];
}

// Reference: http://www.cocoadev.com/index.pl?General/DragMatrix
- (void)mouseDown:(General/NSEvent *)theEvent {
	General/self window] makeFirstResponder:self];
	int clickedRow, clickedColumn;
	// If the clicked area isn't in the view, let the superclass handle it.
	if (![self getRow:&clickedRow column:&clickedColumn forPoint:[self convertPoint:[theEvent locationInWindow] fromView:nil) {
		[super mouseUp:theEvent];
		return;
	}
	
	// If the cell is already selected, don't do anything unless the user drags.
	if (General/self selectedCells] containsObject:[self cellAtRow:clickedRow column:clickedColumn) {
		[self setDownEvent:theEvent];
		return;
	}
	
	// Process the event.
	if ([theEvent modifierFlags] & General/NSCommandKeyMask) {
		int position = clickedRow * [self numberOfColumns] + clickedColumn;
		if (General/[self cells] objectAtIndex:position] representedObject] != nil) {
			[self setSelectionFrom:position to:position anchor:position highlight:YES];
		}
	} else if ([theEvent modifierFlags] & [[NSShiftKeyMask && [self selectedRow] != -1 && [self selectedColumn] != -1) {
		int lastSelectedPosition = [self selectedRow] * [self numberOfColumns] + [self selectedColumn];
		int clickedPosition = clickedRow * [self numberOfColumns] + clickedColumn;
		
		// Loop forwards or backwards depending on where clickedPosition is in relation to lastSelectedPosition.
		int delta = (lastSelectedPosition > clickedPosition ? 1 : -1);
		
		// Select everything in between lastSelectedPosition and clickedPosition.
		int position;
		for (position = clickedPosition; (delta > 0 && position < lastSelectedPosition) || (delta < 0 && position > lastSelectedPosition); position += delta) {
			if (General/[self cells] objectAtIndex:position] representedObject] != nil) {
				[self setSelectionFrom:position to:position anchor:position highlight:YES];
			}
		}
	} else {
		// Deselect all if they clicked without modifiers in an empty area.
		if ([[self cellAtRow:clickedRow column:clickedColumn] representedObject] == nil) {
			[self deselectSelectedCell];
		} else {
			[self selectCellAtRow:clickedRow column:clickedColumn];
		}
	}
	[self updateSelectionBindings];
}

- (void)mouseUp:([[NSEvent *)theEvent {
	if ([theEvent clickCount] == 2)
		[self sendDoubleAction];
}

- (void)mouseDragged:(General/NSEvent *)theEvent {
	int row, col;
	// Don't do anything if the clicked area isn't in the view.
	if ([self getRow:&row column:&col forPoint:[self convertPoint:[theEvent locationInWindow] fromView:nil]]) { 
		//General/NSLog(@"Mouse dragged in icon view at row %d, %d", row, col);
    } 
    [self setDownEvent:nil]; 
}

- (void)keyDown:(General/NSEvent *)theEvent {
	unichar key = General/theEvent charactersIgnoringModifiers] characterAtIndex:0];
    
	// Get flags and strip the upper 16 (device-dependent) bits.
	unsigned int keyFlags = [theEvent modifierFlags] & 0x00FF;
    
	if ([self deleteAction] != nil && (key == [[NSDeleteCharacter || key == General/NSDeleteFunctionKey) && keyFlags == 0) { 
		if ([self selectedRow] == -1)
			General/NSBeep();
		else
			General/self target] performSelector:[self deleteAction] withObject:self];
		return;
	}
	
	// Process selection movement keys.
	int row = [self selectedRow], col = [self selectedColumn];
	int newRow = row, newCol = col;
	switch (key) {
		case [[NSUpArrowFunctionKey:
			if (row >= 1)
				newRow = row - 1;
			break;
		case General/NSDownArrowFunctionKey:
			General/NSLog(@"row = %d, num rows = %d", row, [self numberOfRows]);
			if (row < [self numberOfRows] - 1)
				newRow = row + 1;
			break;

		case General/NSLeftArrowFunctionKey:
			if (col >= 1)
				newCol = col - 1;
			break;

		case General/NSRightArrowFunctionKey:
			if (col < [self numberOfColumns] - 1)
				newCol = col + 1;
			break;

		default:
			// Let somebody else handle the event.
			[super keyDown:theEvent];
	}
	[self interpretKeyEvents:General/[NSArray arrayWithObject:theEvent]];

	if ((row != newRow || col != newCol) && General/self cellAtRow:newRow column:newCol] representedObject] != nil) {
		[self selectCellAtRow:newRow column:newCol];
		[self updateSelectionBindings];
	}
}

#pragma mark -
#pragma mark Accessors

- ([[NSSize)minimumCellSize {
	return minimumCellSize;
}

- (void)setMinimumCellSize:(General/NSSize)value {
	minimumCellSize = value;
}

- (BOOL)wrapsCellsToFit {
	return wrapsCellsToFit;
}

- (void)setWrapsCellsToFit:(BOOL)value {
	wrapsCellsToFit = value;
}

- (BOOL)expandsCellsToFillWidth {
	return expandsCellsToFillWidth;
}

- (void)setExpandsCellsToFillWidth:(BOOL)value {
	expandsCellsToFillWidth = value;
}

- (SEL)deleteAction {
    return deleteAction;
}

- (void)setDeleteAction:(SEL)newDeleteAction {
	deleteAction = newDeleteAction;
}

- (General/NSObject *)delegate {
    return General/delegate retain] autorelease];
}

- (void)setDelegate:([[NSObject *)newDelegate {
    if (delegate != newDelegate) {
        [delegate release];
        delegate = newDelegate;
    }
}

@end



----


I have a view inside a General/NSScrollView, implemented in General/InterfaceBuilder.

When I move the scrollbar, the view gets very messy, things overlapping each other and that kind of stuff.

What do I have to do?

----

I would recommend reading the documentation on drawing and views. Specifically: http://developer.apple.com/documentation/Cocoa/Conceptual/General/DrawViews/Tasks/General/DisplayingViews.html  (see Marking a View as Needing Display)

----

I solved it but it is kinda stupid. see example code

    
- (void) scrollWheel:(General/NSEvent *)theEvent
{
	[super scrollWheel:theEvent];
	[self setNeedsDisplay:YES];
}

- (void) drawRect:(General/NSRect)rect
{
       General/NSRect r;
       //r = General/NSMakeRect(rect.origin.x+50, rect.origin.y+200, 100, 200);
       //did not work because rect.origin is the same even when the scrollbar moves
       r = General/NSMakeRect(50, 200, 100, 200); //worked
       General/[NSBezierPath fillRect:r];
}


----
PLEASE read the documentation as prescribed above. What are you trying to accomplish with the code above?
----