This is a General/NSCollectionView like class that works on Tiger. It derives directly from General/NSView. I tried to customize General/NSTableView but there were too many bugs with drag/drop and scrollbars for it too work. If you don't need those features then you might want to start there first (see  http://www.joar.com/code ). --General/SaileshAgrawal

This is written specifically with the requirements I had in mind. It has the following features and limitations hard coded into it:

* Like General/NSCollectionView allows you to create you row's view in Interface Builder and add it to the collection view.
* One column only
* Always has at least one selected item.
* Allows multiple selection.
* Allows reordering of items using drag/drop.
* Allows files to be dragged into it.
* Allows rows to be dragged out of it as shortcuts to files.
* Automatically changes text field colors to white when a row is selected.
* Your row view must derive from General/TigerCollectionViewItem to be added to the collection view.
* Allows menus on right click


Remember that this is mostly sample code. Feel free to use it any way you like but there will likely be some bugs in it.

----
**Interface**

    
#import <Cocoa/Cocoa.h>


@class General/TigerCollectionViewItem;


@protocol General/TigerCollectionViewTarget <General/NSObject>

- (General/NSDragOperation)dragOperationForFiles: (General/NSArray *)filePaths;
- (void)dragFiles: (General/NSArray *)filePaths toIndex: (int)index;
- (void)dragItemsAtIndexes: (General/NSArray *)indexes toIndex: (int)index;
- (BOOL)shouldRemoveItemsAtIndexes: (General/NSArray *)indexes;
- (void)performDoubleClickActionForIndex: (int)index;
- (void)onSelectionDidChange;
- (General/NSString *)filePathForIndex: (int)index;

@end


@interface General/TigerCollectionView : General/NSView
{
   General/IBOutlet id<General/TigerCollectionViewTarget> target;
   General/NSMutableArray *items;
   BOOL needsLayout;
}

- (void)addItem: (General/TigerCollectionViewItem *)item
        atIndex: (int)index;

- (void)removeItemAtIndex: (int)index;

- (void)removeAllItems;

- (int)numberOfItems;

- (General/NSArray *)selectedIndexes;

@end


@interface General/TigerCollectionViewItem : General/NSView
{
   BOOL isSelected;
   General/NSPoint mouseDownPos;
   int dragTargetType;
   General/NSMutableDictionary *cachedTextColors;
}
@end



----
**Implementation**

    
#import "General/TigerCollectionView.h"


static const float DRAG_START_DISTANCE = 10;
static const float DRAG_IMAGE_ALPHA = 0.5;
static General/NSString * const DRAG_ITEM_TYPE = @"General/TigerCollectionViewDragType";

typedef enum
{
   DragTargetType_None,
   DragTargetType_Top,
   DragTargetType_Bottom,
} General/DragTargetType;


@interface General/TigerCollectionView (Private)

// Override General/NSView
- (void)moveDown: (id)sender;
- (void)moveUp: (id)sender;
- (BOOL)isFlipped;
- (void)selectAll: (id)sender;
- (void)keyDown: (General/NSEvent *)event;
- (void)deleteBackward: (id)sender;
- (void)deleteForward: (id)sender;
- (General/NSDragOperation)draggingEntered: (id<General/NSDraggingInfo>)sender;
- (void)draggingExited: (id<General/NSDraggingInfo>)sender;
- (BOOL)prepareForDragOperation: (id<General/NSDraggingInfo>)sender;
- (BOOL)performDragOperation: (id<General/NSDraggingInfo>)sender;
- (General/NSDragOperation)draggingUpdated: (id<General/NSDraggingInfo>)sender;
- (BOOL)wantsPeriodicDraggingUpdates;
- (General/NSDragOperation)draggingSourceOperationMaskForLocal: (BOOL)isLocal;
- (void)resizeWithOldSuperviewSize: (General/NSSize)oldBoundsSize;

// Internal methods
- (void)setNeedsLayout: (BOOL)flag;
- (void)performLayout;
- (void)startDrag: (General/NSEvent *)event
         withItem: (General/TigerCollectionViewItem *)item;
- (General/NSImage *)dragImageForIndexes: (General/NSArray *)indexes
                     dragPoint: (General/NSPoint *)dragPoint;
- (void)itemClicked: (General/TigerCollectionViewItem *)item
              event: (General/NSEvent *)event;
- (void)setAllItemsSelected: (BOOL)selected;
- (void)growSelectionToItem: (General/TigerCollectionViewItem *)item;
- (void)moveSelection: (BOOL)moveUp
          byExtending: (BOOL)byExtending;
- (void)scrollToItem: (General/TigerCollectionViewItem *)item;
- (void)maintainNonEmptySelection: (int)index;
- (void)removeItemsAtIndexes: (General/NSArray *)indexes;
- (int)indexFromDragTarget: (General/NSView *)targetView
              draggingInfo: (id<General/NSDraggingInfo>)draggingInfo;
- (void)setDragTarget: (General/NSView *)targetView
         draggingInfo: (id<General/NSDraggingInfo>)draggingInfo;
- (void)setIndex: (int)index
    isDragTarget: (BOOL)isDragTarget;
- (id<General/TigerCollectionViewTarget>)target;
- (int)dragTargetIndex;
- (void)maximizeViewWidth: (id)sender;
- (void)onKeyWindowChanged: (General/NSNotification *)notification;
- (void)testSelectionChanged: (General/NSArray *)oldSelection;
- (General/NSArray *)filePathsForIndexes: (General/NSArray *)indexes;

@end


@interface General/TigerCollectionViewItem (Private)

// Override General/NSView
- (General/NSMenu *)menuForEvent:(General/NSEvent *)event;
- (General/NSView *)hitTest: (General/NSPoint)point;
- (void)mouseDown: (General/NSEvent *)event;
- (void)mouseUp: (General/NSEvent *)event;
- (void)mouseDragged: (General/NSEvent *)event;
- (BOOL)acceptsFirstResponder;

// Internal methods
- (void)setIsSelected: (BOOL)flag;
- (BOOL)isSelected;
- (General/TigerCollectionView *)collectionView;
- (BOOL)isLeftClickEvent: (General/NSEvent *)event;
- (void)setDragTargetType: (General/DragTargetType)type;
- (General/DragTargetType)dragTargetType;
- (void)updateHighlightState;
- (void)setHighlight: (BOOL)isHighlighted
        forTextField: (General/NSTextField *)textField;
- (BOOL)shouldDrawSecondaryHighlight;

@end


static float
General/PointDistance(General/NSPoint start,
              General/NSPoint end)
{
   float deltaX = end.x - start.x;
   float deltaY = end.y - start.y;
   return sqrt(deltaX * deltaX + deltaY * deltaY);
}


@implementation General/TigerCollectionView


- (id)initWithFrame: (General/NSRect)frame
{
   if ((self = [super initWithFrame:frame])) {
      items = General/[[NSMutableArray alloc] init];
   }
   return self;
}


- (void)dealloc
{
   General/[[NSNotificationCenter defaultCenter] removeObserver:self];
   [items release];
   items = nil;
   [super dealloc];
}


- (void)awakeFromNib
{
   ASSERT(General/self target] conformsToProtocol:
      @protocol([[TigerCollectionViewTarget)]);

   General/[[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(onKeyWindowChanged:)
             name:General/NSWindowDidBecomeKeyNotification
           object:[self window]];
   General/[[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(onKeyWindowChanged:)
             name:General/NSWindowDidResignKeyNotification
           object:[self window]];

   General/[self enclosingScrollView] contentView] setCopiesOnScroll:NO];

   [self registerForDraggedTypes:
      [[[NSArray arrayWithObjects:General/NSFilenamesPboardType, DRAG_ITEM_TYPE, nil]];

   [self maximizeViewWidth:nil];
}


- (void)drawRect: (General/NSRect)rect
{
   /*
    * XXX: This is a hack to work around autohide scrollbars not working
    * correctly. When removing an item causes the vertical scrollbar to
    * be hidden our items don't automatically resize to fit the new width.
    *
    * Until that bug is fixed this hack disables the "needsLayout" optimization
    * and forces a layout on every dray. The layout code is pretty fast so this
    * isn't very expensive.
    */
   needsLayout = YES;

   if (needsLayout) {
      [self performLayout];
      [self maintainNonEmptySelection:0];
   }
   [super drawRect:rect];

   General/[[NSColor colorWithCalibratedRed:214.0/255.0
                              green:221.0/255.0
                               blue:229.0/255.0
                              alpha:1.0] set];
   General/NSRectFill([self bounds]);
}


- (void)addItem: (General/TigerCollectionViewItem *)item
        atIndex: (int)index
{
   ASSERT(item);
   [items insertObject:item atIndex:index];
   [item setAutoresizingMask:General/NSViewWidthSizable | General/NSViewMinYMargin];
   [self addSubview:item];
   [self setNeedsLayout:YES];
}


- (void)removeItemAtIndex: (int)index
{
   [self removeItemsAtIndexes:
      General/[NSArray arrayWithObject:General/[NSNumber numberWithInt:index]]];
   [self maintainNonEmptySelection:index];
}

- (void)removeAllItems
{
   [items removeAllObjects];
   [self setNeedsLayout:YES];
   [self setNeedsDisplay:YES];
}


- (int)numberOfItems
{
   return [items count];
}


- (General/NSArray *)selectedIndexes
{
   General/NSMutableArray *selectedIndexes = General/[NSMutableArray array];
   int count = [items count];
   int i;
   for (i = 0; i < count; i++) {
      General/TigerCollectionViewItem *item = [items objectAtIndex:i];
      if ([item isSelected]) {
         [selectedIndexes addObject:General/[NSNumber numberWithInt:i]];
      }
   }
   return selectedIndexes;
}


@end // General/TigerCollectionView


@implementation General/TigerCollectionView (Private)


- (void)setNeedsLayout: (BOOL)flag
{
   needsLayout = flag;
}


- (void)performLayout
{
   // Calculate the total height.
   float myHeight = 0;
   General/NSEnumerator *e = [items objectEnumerator];
   General/TigerCollectionViewItem *item;
   while ((item = [e nextObject])) {
      myHeight += [item frame].size.height;
   }

   // Resize the collection view to fit.
   General/NSRect myFrame = [self frame];
   [self setFrameSize:General/NSMakeSize(myFrame.size.width, myHeight)];
   if (myFrame.size.height != myHeight) {
      [self setNeedsDisplay:YES];
   }

   // Layout all the items.
   float yPos = 0;
   e = [items objectEnumerator];
   while ((item = [e nextObject])) {
      General/NSRect oldItemFrame = [item frame];
      General/NSRect newItemFrame;
      newItemFrame.origin.y = yPos;
      newItemFrame.origin.x = 0;
      newItemFrame.size.width = myFrame.size.width;
      newItemFrame.size.height = oldItemFrame.size.height;
      [item setFrame:newItemFrame];

      yPos += newItemFrame.size.height;
      if (!General/NSEqualRects(newItemFrame, oldItemFrame)) {
         [item setNeedsDisplay:YES];
      }
   }

   [self setNeedsLayout:NO];
}


- (BOOL)isFlipped
{
   return YES;
}


- (void)startDrag: (General/NSEvent *)event
         withItem: (General/TigerCollectionViewItem *)item
{
   // If the dragged item is selected then drag all selected items too.
   General/NSArray *dragIndexes = nil;
   if ([item isSelected]) {
      dragIndexes = [self selectedIndexes];
   } else {
      dragIndexes = General/[NSArray arrayWithObject:
         General/[NSNumber numberWithInt:[items indexOfObject:item]]];
   }

   // Write data to the paste board.
   General/NSPasteboard *pboard = General/[NSPasteboard pasteboardWithName:General/NSDragPboard];
   [pboard declareTypes:General/[NSArray arrayWithObjects:DRAG_ITEM_TYPE,
                                                  General/NSFilenamesPboardType,
                                                  nil]
                  owner:self];
   [pboard setPropertyList:dragIndexes
                   forType:DRAG_ITEM_TYPE];
   [pboard setPropertyList:[self filePathsForIndexes:dragIndexes]
                   forType:General/NSFilenamesPboardType];

   // Generate the drag image from the dragged items.
   General/NSPoint dragPos;
   General/NSImage *dragImage = [self dragImageForIndexes:dragIndexes dragPoint:&dragPos];

   // Start the drag.
   [self dragImage:dragImage
                at:dragPos
            offset:General/NSZeroSize
             event:event
        pasteboard:pboard
            source:self
         slideBack:YES];
}


- (General/NSImage *)dragImageForIndexes: (General/NSArray *)indexes
                     dragPoint: (General/NSPoint *)dragPoint
{
   // Make an image as big as the visible rect.
   General/NSRect dragRect = [self convertRect:[self visibleRect]
                              fromView:[self superview]];
   General/NSImage *dragImage =
      General/[[[NSImage alloc] initWithSize:dragRect.size] autorelease];

   General/NSEnumerator *e = [indexes objectEnumerator];
   General/NSNumber *indexNumber;
   while ((indexNumber = [e nextObject])) {
      General/TigerCollectionViewItem *item =
         [items objectAtIndex:[indexNumber intValue]];

      General/NSRect itemRect = [item visibleRect];
      if (General/NSEqualRects(itemRect, General/NSZeroRect)) {
         continue;
      }

      // Get an image of the dragged view without the selection.
      BOOL oldSelectedValue = [item isSelected];
      [item setIsSelected:NO];
      General/NSData *itemAsPDF = [item dataWithPDFInsideRect:itemRect];
      [item setIsSelected:oldSelectedValue];
      General/NSImage *itemImage = General/[[NSImage alloc] initWithData:itemAsPDF];

      // Convert from our flipped axis into the image's non-flipped axis.
      General/NSPoint pos = [item frame].origin;
      pos.y = dragRect.origin.y + dragRect.size.height - pos.y;
      pos.y -= itemRect.size.height;

      // Drag the view's image into the drag image.
      [dragImage lockFocus];
      [itemImage drawAtPoint:pos
                    fromRect:General/NSZeroRect
                   operation:General/NSCompositeSourceOver
                    fraction:DRAG_IMAGE_ALPHA];
      [dragImage unlockFocus];

      [itemImage release];
   }

   ASSERT(dragPoint);
   *dragPoint = General/NSMakePoint(dragRect.origin.x,
                            dragRect.origin.y + dragRect.size.height);

   return dragImage;
}


- (void)itemClicked: (General/TigerCollectionViewItem *)item
              event: (General/NSEvent *)event
{
   General/NSArray *oldSelection = [self selectedIndexes];

   if (([event modifierFlags] & General/NSCommandKeyMask) != 0) {
      [item setIsSelected:![item isSelected]];
   } else if (([event modifierFlags] & General/NSShiftKeyMask) != 0) {
      [self growSelectionToItem:item];
   } else {
      [self setAllItemsSelected:NO];
      [item setIsSelected:YES];
      if ([event clickCount] == 2) {
         General/self target]
            performDoubleClickActionForIndex:[items indexOfObject:item;
      }
   }
   [self scrollToItem:item];

   [self testSelectionChanged:oldSelection];
}


- (void)setAllItemsSelected: (BOOL)selected
{
   General/NSEnumerator *e = [items objectEnumerator];
   General/TigerCollectionViewItem *item;
   while ((item = [e nextObject])) {
      [item setIsSelected:selected];
   }
}


- (void)growSelectionToItem: (General/TigerCollectionViewItem *)item
{
   General/NSArray *oldSelection = [self selectedIndexes];

   int itemIndex = [items indexOfObject:item];
   int startIndex = General/oldSelection objectAtIndex:0] intValue];
   int endIndex = [[oldSelection lastObject] intValue];

   if (itemIndex < startIndex) {
      startIndex = itemIndex;
   } else if (itemIndex > endIndex) {
      endIndex = itemIndex;
   }

   int i;
   for (i = startIndex; i <= endIndex; i++) {
      [[items objectAtIndex:i] setIsSelected:YES];
   }

   [self testSelectionChanged:oldSelection];
}


- (void)moveDown: (id)sender
{
   BOOL shift = ([[[[NSApp currentEvent] modifierFlags] & General/NSShiftKeyMask) != 0;
   [self moveSelection:NO byExtending:shift];
}


- (void)moveUp: (id)sender
{
   BOOL shift = (General/[[NSApp currentEvent] modifierFlags] & General/NSShiftKeyMask) != 0;
   [self moveSelection:YES byExtending:shift];
}


- (void)moveSelection: (BOOL)moveUp
          byExtending: (BOOL)byExtending
{
   if ([items count] == 0) {
      return;
   }
   General/NSArray *oldSelection = [self selectedIndexes];

   int index = General/NSNotFound;
   if (moveUp) {
      int firstIndex = General/oldSelection objectAtIndex:0] intValue];
      firstIndex--;
      if (firstIndex >= 0) {
         index = firstIndex;
      }
   } else {
      int lastIndex = [[oldSelection lastObject] intValue];
      lastIndex++;
      if (lastIndex < [items count]) {
         index = lastIndex;
      }
   }

   if (index != [[NSNotFound) {
      if (!byExtending) {
         [self setAllItemsSelected:NO];
      }
      General/TigerCollectionViewItem *item = [items objectAtIndex:index];
      [item setIsSelected:YES];
      [self scrollToItem:item];
   }

   [self testSelectionChanged:oldSelection];
}


- (void)scrollToItem: (General/TigerCollectionViewItem *)item
{
   General/NSRect itemFrame = [item frame];
   General/NSPoint top, bottom;
   bottom.y = General/NSMaxY(itemFrame);
   top.y = General/NSMinY(itemFrame);
   top.x = 0;
   bottom.x = 0;

   General/NSRect visibleRect = [self visibleRect];
   BOOL bottomVisible = General/NSPointInRect(bottom, visibleRect);
   BOOL topVisible = General/NSPointInRect(top, visibleRect);
   if (!topVisible || !bottomVisible) {
      General/NSPoint scrollPos;
      if (!bottomVisible) {
         scrollPos.y = bottom.y - visibleRect.size.height;
      } else {
         scrollPos.y = top.y;
      }
      scrollPos.x = 0;

      General/NSClipView *clipView = General/self enclosingScrollView] contentView];
      [clipView scrollToPoint:[clipView constrainScrollPoint:scrollPos;
      General/self enclosingScrollView] reflectScrolledClipView:clipView];
   }
}


- (void)selectAll: (id)sender
{
   [[NSArray *oldSelection = [self selectedIndexes];
   [self setAllItemsSelected:YES];
   [self testSelectionChanged:oldSelection];
}


- (void)maintainNonEmptySelection: (int)index
{
   General/NSArray *oldSelection = [self selectedIndexes];
   if ([items count] > 0 && [oldSelection count] == 0) {
      int selectionIndex = index;
      if (selectionIndex < 0) {
         selectionIndex = 0;
      } else if (selectionIndex >= [items count]) {
         selectionIndex = [items count] - 1;
      }
      General/items objectAtIndex:selectionIndex] setIsSelected:YES];

      [self testSelectionChanged:oldSelection];
   }
}


- (void)keyDown: ([[NSEvent *)event
{
   unichar u = General/event charactersIgnoringModifiers] characterAtIndex: 0];

   if (u == [[NSDeleteCharacter ||
       u == General/NSDeleteFunctionKey) {
      // Forward or backward delete.
      [self interpretKeyEvents:General/[NSArray arrayWithObject:event]];
   } else if (u == General/NSEnterCharacter ||
              u == General/NSCarriageReturnCharacter) {
      General/NSArray *indexes = [self selectedIndexes];
      if ([indexes count] > 0) {
         General/self target] performDoubleClickActionForIndex:
            [[indexes objectAtIndex:0] intValue;
      }
   } else {
      [super keyDown:event];
   }
}


- (void)deleteBackward: (id)sender
{
   General/NSArray *indexes = [self selectedIndexes];
   if ([indexes count] > 0 &&
       General/self target] shouldRemoveItemsAtIndexes:indexes]) {
      [self removeItemsAtIndexes:indexes];
      [self maintainNonEmptySelection:[[indexes objectAtIndex:0] intValue] - 1];
      [[self window] makeFirstResponder:self];
   }
}


- (void)deleteForward: (id)sender
{
   [[NSArray *indexes = [self selectedIndexes];
   if ([indexes count] > 0 &&
       General/self target] shouldRemoveItemsAtIndexes:indexes]) {
      [self removeItemsAtIndexes:indexes];
      [self maintainNonEmptySelection:[[indexes objectAtIndex:0] intValue;
      General/self window] makeFirstResponder:self];
   }
}


- (void)removeItemsAtIndexes: ([[NSArray *)indexes
{
   if ([indexes count] == 0) {
      return;
   }

   General/NSMutableIndexSet *indexSet = General/[NSMutableIndexSet indexSet];

   General/NSEnumerator *e = [indexes objectEnumerator];
   General/NSNumber *indexNumber;
   while ((indexNumber = [e nextObject])) {
      int index = [indexNumber intValue];
      General/TigerCollectionViewItem *item = [items objectAtIndex:index];
      [item removeFromSuperview];
      [indexSet addIndex:index];
   }

   [items removeObjectsAtIndexes:indexSet];

   /*
    * Need to force the layout to change right away so that scrolling and
    * selection code will work.
    */
   [self performLayout];
}


- (General/NSDragOperation)draggingEntered: (id<General/NSDraggingInfo>)sender
{
   return [self draggingUpdated:sender];
}


- (void)draggingExited: (id<General/NSDraggingInfo>)sender
{
   [self setDragTarget:nil draggingInfo:sender];
}


- (BOOL)prepareForDragOperation: (id<General/NSDraggingInfo>)sender
{
   BOOL acceptDrop = NO;
   General/NSArray *dragTypes = General/sender draggingPasteboard] types];

   if ([dragTypes containsObject:DRAG_ITEM_TYPE]) {
      acceptDrop = YES;
   } else if ([dragTypes containsObject:[[NSFilenamesPboardType]) {
      General/NSArray *filePaths = General/sender draggingPasteboard]
         propertyListForType:[[NSFilenamesPboardType];
      acceptDrop = General/self target] dragOperationForFiles:filePaths] !=
                   [[NSDragOperationNone;
   }

   if (!acceptDrop) {
      [self setDragTarget:nil draggingInfo:sender];
   }
   return acceptDrop;
}


- (BOOL)performDragOperation: (id<General/NSDraggingInfo>)sender
{
   int destIndex = [self dragTargetIndex];
   ASSERT(destIndex != General/NSNotFound);
   [self setDragTarget:nil draggingInfo:sender];

   General/NSArray *dragTypes = General/sender draggingPasteboard] types];
   if ([dragTypes containsObject:DRAG_ITEM_TYPE]) {
      [[NSArray *indexes = General/sender draggingPasteboard]
         propertyListForType:DRAG_ITEM_TYPE];
      [[self target] dragItemsAtIndexes:indexes toIndex:destIndex];         
   } else if ([dragTypes containsObject:[[NSFilenamesPboardType]) {
      General/NSArray *filePaths = General/sender draggingPasteboard]
         propertyListForType:[[NSFilenamesPboardType];
      General/self target] dragFiles:filePaths toIndex:destIndex];
   }
   return YES;
}


- ([[NSDragOperation)draggingUpdated: (id<General/NSDraggingInfo>)sender
{
   General/NSPoint dragPos = General/self superview] convertPoint:[sender draggingLocation]
                                           fromView:nil];
   [[NSView *targetView = [self hitTest:dragPos];

   General/NSDragOperation dragOperation = General/NSDragOperationNone;
   General/NSArray *dragTypes = General/sender draggingPasteboard] types];
   if ([dragTypes containsObject:DRAG_ITEM_TYPE]) {
      dragOperation = [[NSDragOperationMove;
   } else if ([dragTypes containsObject:General/NSFilenamesPboardType]) {
      General/NSArray *filePaths = General/sender draggingPasteboard]
         propertyListForType:[[NSFilenamesPboardType];
      dragOperation = General/self target] dragOperationForFiles:filePaths];
   }

   if (dragOperation == [[NSDragOperationNone) {
      [self setDragTarget:nil draggingInfo:sender];
   } else {
      [self setDragTarget:targetView draggingInfo:sender];
   }
   return dragOperation;
}


- (BOOL)wantsPeriodicDraggingUpdates
{
   return NO;
}


- (General/NSDragOperation)draggingSourceOperationMaskForLocal: (BOOL)isLocal
{
   if (isLocal) {
      return General/NSDragOperationMove;
   } else {
      return General/NSDragOperationLink;
   }
}


- (int)indexFromDragTarget: (General/NSView *)targetView
              draggingInfo: (id<General/NSDraggingInfo>)draggingInfo
{
   int index = General/NSNotFound;
   if (targetView &&
       [targetView isKindOfClass:General/[TigerCollectionViewItem class]]) {
      index = [items indexOfObject:targetView];
   }

   if (index != General/NSNotFound) {
      General/TigerCollectionViewItem *item =
         [items objectAtIndex:index];
      General/NSPoint viewPos = [item convertPoint:[draggingInfo draggingLocation]
                                  fromView:nil];
      General/NSRect bounds = [item bounds];
      if (viewPos.y < bounds.size.height / 2.0) {
         index = fmin(index + 1, [items count]);
      }
   }

   return index;
}


- (void)setDragTarget: (General/NSView *)targetView
         draggingInfo: (id<General/NSDraggingInfo>)draggingInfo
{
   int newDragTargetIndex = [self indexFromDragTarget:targetView
                                         draggingInfo:draggingInfo];
   int curDragTargetIndex = [self dragTargetIndex];
   if (newDragTargetIndex != curDragTargetIndex) {
      [self setIndex:curDragTargetIndex isDragTarget:NO];
      [self setIndex:newDragTargetIndex isDragTarget:YES];
   }
}


- (void)setIndex: (int)index
    isDragTarget: (BOOL)isDragTarget
{
   if (index != General/NSNotFound) {
      General/DragTargetType dragTargetType = isDragTarget ? DragTargetType_Top :
                                                     DragTargetType_None;
      int actualIndex = index;
      if (actualIndex == [items count]) {
         actualIndex = [items count] - 1;
         if (isDragTarget) {
            dragTargetType = DragTargetType_Bottom;
         }
      }
      General/items objectAtIndex:actualIndex] setDragTargetType:dragTargetType];
   }
}


- (id<[[TigerCollectionViewTarget>)target
{
   return target;
}


- (int)dragTargetIndex
{
   int count = [items count];
   int i;
   for (i = 0; i < count; i++) {
      General/TigerCollectionViewItem *item = [items objectAtIndex:i];
      if ([item dragTargetType] == DragTargetType_Top) {
         return i;
      } else if ([item dragTargetType] == DragTargetType_Bottom) {
         return i + 1;
      }
   }
   return General/NSNotFound;
}


- (void)resizeWithOldSuperviewSize: (General/NSSize)oldBoundsSize
{
   [super resizeWithOldSuperviewSize:oldBoundsSize];
   [self performSelector:@selector(maximizeViewWidth:) withObject:nil afterDelay:0.10];
   //[self maximizeViewWidth:nil];
}


- (void)maximizeViewWidth: (id)sender
{
   float width = General/[self enclosingScrollView] contentView] frame].size.width;
   [[NSRect myOldFrame = [self frame];
   if (myOldFrame.size.width != width) {
      [self setFrameSize:General/NSMakeSize(width, myOldFrame.size.height)];
      [self setNeedsDisplay:YES];
   }
}


- (void)onKeyWindowChanged: (General/NSNotification *)notification
{
   [self setNeedsDisplay:YES];

   General/NSEnumerator *e = [items objectEnumerator];
   General/TigerCollectionViewItem *item;
   while ((item = [e nextObject])) {
      [item updateHighlightState];
   }
}


- (void)testSelectionChanged: (General/NSArray *)oldSelection
{
   BOOL didChange = NO;
   if (!oldSelection) {
      didChange = YES;
   } else {
      General/NSArray *newSelection = [self selectedIndexes];
      didChange = ![oldSelection isEqualToArray:newSelection];
   }

   if (didChange) {
      General/self target] onSelectionDidChange];
   }
}


- ([[NSArray *)filePathsForIndexes: (General/NSArray *)indexes
{
   General/NSMutableArray *filePaths = General/[NSMutableArray array];

   General/NSEnumerator *e = [indexes objectEnumerator];
   General/NSNumber *indexNumber;
   while ((indexNumber = [e nextObject])) {
      General/NSString *filePath = General/self target] filePathForIndex:[indexNumber intValue;
      if (filePath) {
         [filePaths addObject:filePath];
      }
   }
   return filePaths;
}


@end // General/TigerCollectionView (Private)


@implementation General/TigerCollectionViewItem


- (void)dealloc
{
   [cachedTextColors release];
   cachedTextColors = nil;
   [super dealloc];
}

- (void)awakeFromNib
{
   [self setNextResponder:[self superview]];
}


- (void)drawRect: (General/NSRect)rect
{
   [super drawRect:rect];

   if ([self isSelected]) {
      if ([self shouldDrawSecondaryHighlight]) {
         General/[[NSColor grayColor] set];
      } else {
         General/[[NSColor blueColor] set];
      }
      General/NSRectFill(rect);
   }

   if (dragTargetType != DragTargetType_None) {
      General/NSRect dRect = [self bounds];
      if (dragTargetType == DragTargetType_Top) {
         dRect.origin.y = dRect.size.height - 2.0;
      }
      dRect.size.height = 2;
      General/[[NSColor blackColor] set];
      General/NSRectFill(dRect);
   }
}


@end // General/TigerCollectionViewItem


@implementation General/TigerCollectionViewItem (Private)


- (General/NSMenu *)menuForEvent:(General/NSEvent *)event
{
   if (![self isSelected]) {
      General/self collectionView] itemClicked:self event:event];
   }
   return [[self superview] menuForEvent:event];
}


- ([[NSView *)hitTest: (General/NSPoint)point
{
   General/NSView *result = [super hitTest:point];
   if (result && ![result isKindOfClass:General/[NSButton class]]) {
      return self;
   } else {
      return result;
   }
}


- (void)mouseDown: (General/NSEvent *)event
{
   if ([self isLeftClickEvent:event]) {
      mouseDownPos = [event locationInWindow];
   }
}


- (void)mouseUp: (General/NSEvent *)event
{
   if ([self isLeftClickEvent:event]) {
      General/self collectionView] itemClicked:self event:event];
   }
}


- (void)mouseDragged: ([[NSEvent *)event
{
   if ([self isLeftClickEvent:event]) {
      General/NSPoint mouseDragPos = [event locationInWindow];
      float distance = General/PointDistance(mouseDragPos, mouseDownPos);
      if (distance > DRAG_START_DISTANCE) {
         General/self collectionView] startDrag:event withItem:self];
      }
   }
}


- (BOOL)acceptsFirstResponder
{
   return NO;
}


- (void)setIsSelected: (BOOL)flag
{
   if (isSelected != flag) {
      isSelected = flag;
      [self updateHighlightState];
      [self setNeedsDisplay:YES];
   }
}


- (BOOL)isSelected
{
   return isSelected;
}


- ([[TigerCollectionView *)collectionView
{
   ASSERT(General/self superview] isKindOfClass:[[[TigerCollectionView class]]);
   return (General/TigerCollectionView *)[self superview];
}


- (BOOL)isLeftClickEvent: (General/NSEvent *)event
{
   return [event buttonNumber] == 0 &&
          ([event modifierFlags] & General/NSControlKeyMask) == 0;
}


- (void)setDragTargetType: (General/DragTargetType)type
{
   if (dragTargetType != type) {
      dragTargetType = type;
      [self setNeedsDisplay:YES];
   }
}


- (General/DragTargetType)dragTargetType
{
   return dragTargetType;
}


- (void)updateHighlightState
{
   BOOL isHighlighted = [self isSelected] &&
                        ![self shouldDrawSecondaryHighlight];

   General/NSEnumerator *e = General/self subviews] objectEnumerator];
   id subview;
   while ((subview = [e nextObject])) {
      if ([subview isKindOfClass:[[[NSTextField class]]) {
         [self setHighlight:isHighlighted
               forTextField:(General/NSTextField *)subview];                  
      } else if ([subview respondsToSelector:@selector(setIsSelected:)]) {
         [subview setIsSelected:isHighlighted];
      }
   }
}


- (void)setHighlight: (BOOL)isHighlighted
        forTextField: (General/NSTextField *)textField
{
   General/NSNumber *key = General/[NSNumber numberWithInt:[textField hash]];

   if (!cachedTextColors) {
      cachedTextColors = General/[[NSMutableDictionary alloc] init];
   }

   if (isHighlighted) {
      if (![cachedTextColors objectForKey:key]) {
         [cachedTextColors setObject:[textField textColor] forKey:key];
         [textField setTextColor:General/[NSColor whiteColor]];
      }
   } else {
      if ([cachedTextColors objectForKey:key]) {
         [textField setTextColor:[cachedTextColors objectForKey:key]];
         [cachedTextColors removeObjectForKey:key];
      }
   }
}


- (BOOL)shouldDrawSecondaryHighlight
{
   if (General/self window] isKeyWindow]) {
      return NO;
   } else {
      return YES;
   }
}


@end // [[TigerCollectionViewItem (Private)
