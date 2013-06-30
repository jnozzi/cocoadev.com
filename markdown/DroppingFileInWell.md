I'm trying to add file dropping support to a custom General/NSImageView subclass.

    -(void)awakeFromNib
{
	General/NSArray *draggedTypeArray = General/[NSArray arrayWithObjects:General/NSFilenamesPboardType, nil];
	[self registerForDraggedTypes:draggedTypeArray];
}

- (General/NSDragOperation)draggingEntered:(id <General/NSDraggingInfo>)sender 
{
	return General/NSDragOperationMove;
}

But the above code does not change the cursor when dragging a file over the well (implying that it is not accepting the drag) - what am I doing wrong�?
----
You could try switching your draggedTypeArray to     General/[NSImage imagePasteboardTypes]...

*But I need to support file drops.*

I meant in addition...so I should have said something like     General/[[NSImage imagePasteboardTypes] arrayByAddingObject:General/NSFilenamesPboardType]; (sorry). It's also possible that the file is automatically converted, but now that I think about it...no, probably not. However, there are other General/NSDraggingDestination methods you should probably implement; perhaps     draggingUpdated: could help you here.

----

Sending your image view subclass a setEditable:YES message should be enough for it to accept drops: (edit: accept and set its image to the dropped image, that is)
    
[imageView setEditable:YES]

General/EnglaBenny


----

Here's a full thing. Addition of delegate methods is left to the reader as an exercise :)


    
//
//  General/FileDropView.h
//  Packager
//
//  Created by Seth Willits on 5/24/05.
//  Copyright 2005 Freak Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface General/FileDropView : General/NSImageView {
	General/IBOutlet id delegate;
	BOOL highlight;
	General/NSString * mFilePath;
}


@end



    
//
//  General/FileDropView.m
//  Packager
//
//  Created by Seth Willits on 5/24/05.
//  Copyright 2005 Freak Software. All rights reserved.
//

#import "General/FileDropView.h"


@implementation General/FileDropView



- (id)initWithCoder:(General/NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self registerForDraggedTypes:General/[NSArray arrayWithObjects:General/NSFilenamesPboardType, nil]];
	}
	return self;
}


- (id)initWithFrame:(General/NSRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self registerForDraggedTypes:General/[NSArray arrayWithObjects:General/NSFilenamesPboardType, nil]];
	}
	return self;
}



- (void)setFile:(General/NSString *)path
{
	if (mFilePath) {
		[mFilePath release];
	}
	
	mFilePath = General/[[NSString stringWithString:path] retain];
	General/NSImage * image = General/[[NSWorkspace sharedWorkspace] iconForFile:mFilePath];
	[image setSize:General/NSMakeSize(48.0, 48.0)];
	[self setImage:image];
}




- (General/NSDragOperation)draggingEntered:(id <General/NSDraggingInfo>)sender
{
	if ([self isEnabled]) {
		highlight = YES;
		[self setNeedsDisplay:YES];
		return General/NSDragOperationCopy;
	}
	
	return General/NSDragOperationNone;
}





- (void)draggingExited:(id <General/NSDraggingInfo>)sender
{
	highlight = NO;
	[self setNeedsDisplay:YES];
}



///////////////////////////////////////////////////////////
//	Draw method is overridden to do drop highlighing
///////////////////////////////////////////////////////////

- (void)drawRect:(General/NSRect)rect
{
	// Draw the normal frame first
	[super drawRect:rect];
	
	// Then do the highlighting
	if (highlight) {
		General/[[NSColor grayColor] set];
		General/[NSBezierPath setDefaultLineWidth:5];
		General/[NSBezierPath strokeRect:rect];
	}
}



- (BOOL)prepareForDragOperation:(id <General/NSDraggingInfo>)sender
{
	highlight = NO;
	[self setNeedsDisplay:YES];
	return YES;
} 



- (BOOL)performDragOperation:(id <General/NSDraggingInfo>)info
{
	General/NSPasteboard *pboard = [info draggingPasteboard];
	
	
	// Dragging Filenames From Finder or the List
	if (General/pboard types] containsObject:[[NSFilenamesPboardType]) {
		
		General/NSArray * files = [pboard propertyListForType:General/NSFilenamesPboardType];
		General/NSEnumerator * enumerator = [files objectEnumerator];
		General/NSString * filePath;
		
		// Get the First File
		if (filePath = [enumerator nextObject]) {
			[self setFile:filePath];
		}
		
		return YES;
	}
	
	return NO;
}




@end



-- Seth Willits

----

General/DroppingScreamingChildIntoWell  ... *If someone fills in this stub, I'll toss *them* into a well.*