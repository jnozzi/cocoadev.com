http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Protocols/NSDraggingInfo_Protocol/

Constants that are returned by <code>draggingSourceOperationMask</code>

*General/NSDragOperationCopy - The data represented by the image can be copied.
*General/NSDragOperationLink - The data can be shared.
*General/NSDragOperationGeneric - The operation can be defined by the destination.
*General/NSDragOperationPrivate - The operation is negotiated privately between the source and the destination.
*General/NSDragOperationMove - The data can be moved.
*General/NSDragOperationDelete - The data can be deleted.
*General/NSDragOperationEvery - All of the above.
*General/NSDragOperationNone - No drag operations are allowed.


(The following lines are from <code>General/NSDragging.h</code>)

    
/* protocol for the sender argument of the messages sent to a   
drag destination.  The view or window that registered dragging types sends these messages as dragging is
 happening to find out details about that session of dragging.
 */
@protocol General/NSDraggingInfo
- (General/NSWindow *)draggingDestinationWindow;
- (General/NSDragOperation)draggingSourceOperationMask;
- (General/NSPoint)draggingLocation;
- (General/NSPoint)draggedImageLocation;
- (General/NSImage *)draggedImage;
- (General/NSPasteboard *)draggingPasteboard;
- (id)draggingSource;
- (int)draggingSequenceNumber;
- (void)slideDraggedImageTo:(General/NSPoint)screenPoint;
@end
