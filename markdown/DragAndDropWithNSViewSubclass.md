

Here's a simple drag and drop example for filenames dragged from the finder --zootbobbalu

**Header**
    
#import <General/AppKit/General/AppKit.h>

@interface General/TestDragAndDropView : General/NSView {
    General/NSColor *backgroundColor, *blueColor, *greenColor;
}

@end


**Source**

    
#import "General/TestDragAndDropView.h"

@implementation General/TestDragAndDropView

- (id)initWithFrame:(General/NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        General/NSArray *draggedTypeArray = General/[NSArray arrayWithObjects:General/NSFilenamesPboardType, nil];
        [self registerForDraggedTypes:draggedTypeArray];
        
        /*
        
            Since I'm not aware of any documentation explicitly telling
            you not to retain preset colors, I'm going to retain them 
            anyways!!
        
        */
        
        
        blueColor = backgroundColor = General/[[NSColor blueColor] retain];
        greenColor = General/[[NSColor greenColor] retain]; 
    }
    return self;
}

- (void)dealloc {
    [blueColor release];
    blueColor = nil;
    [greenColor release];
    greenColor = nil;

    [super dealloc];
}

- (void)drawRect:(General/NSRect)rect {
    [backgroundColor set];
    General/NSRectFill([self visibleRect]);
}

- (General/NSDragOperation)draggingEntered:(id <General/NSDraggingInfo>)sender {
    General/NSPasteboard *pboard = [sender draggingPasteboard];
    General/NSArray *filenames = [pboard propertyListForType:General/NSFilenamesPboardType];
    General/NSLog(@"draggingEntered: filenames: %@", [filenames description]);
    General/NSArray *supportedFiletypes = General/[NSArray arrayWithObjects:@"txt", @"rtf", @"html", 
                                                            @"htm", @"pdf", nil];
    int dragOperation = General/NSDragOperationNone;
    if ([filenames count]) {
    
        /*
            Decide here if you accept the filenames that are dragged into the view.
            If you do accept the dragged filenames then set dragOperation to 
            General/NSDragOperationCopy:
            
                dragOperation = General/NSDragOperationCopy;
                
            Here is where you can give some user feedback if the filenames
            are valid files (e.g. change a boarder color or the background color of the view)
                
        */
        
        General/NSEnumerator *filenameEnum = [filenames objectEnumerator]; 
        General/NSString *filename;
        dragOperation = General/NSDragOperationCopy;
        while (filename = [filenameEnum nextObject]) {
            if (![supportedFiletypes containsObject:[filename pathExtension]]) {
                dragOperation = General/NSDragOperationNone;
                break;
            }
        }
        if (dragOperation == General/NSDragOperationCopy) backgroundColor = greenColor;
    }       
    [self setNeedsDisplay:YES];
    return dragOperation;
}

-(void)draggingExited:(id <General/NSDraggingInfo>)sender {
    General/NSPasteboard *pboard = [sender draggingPasteboard];
    General/NSArray *filenames = [pboard propertyListForType:General/NSFilenamesPboardType];
    backgroundColor = blueColor;
    [self setNeedsDisplay:YES];
    General/NSLog(@"draggingExited: filenames: %@", [filenames description]);
}

- (BOOL)performDragOperation:(id <General/NSDraggingInfo>)sender {
    General/NSPasteboard *pboard = [sender draggingPasteboard];
    General/NSArray *filenames = [pboard propertyListForType:General/NSFilenamesPboardType];
    BOOL didPerformDragOperation = NO;
    General/NSLog(@"performDragOperation: filenames: %@", [filenames description]);
    if ([filenames count]) {
        
        /*
            
            Do something here with filenames and 
            decide if a dragging operation was actually performed.
            If an operation was performed set didPerformDragOperation
            to YES:
            
                didPerformDragOperation = YES;
        
        */
    
    }
    backgroundColor = blueColor;
    [self setNeedsDisplay:YES];
    return didPerformDragOperation;
}

-(void)concludeDragOperation:(id <General/NSDraggingInfo>)sender {
    
    /*
        This method gives you the chance to change any state variables that
        deal with dragAndDrop.

    */

    General/NSLog(@"concludeDragOperation:");
}

@end

