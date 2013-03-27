Hi!

I am currently learning Cocoa as I am porting my Win32 App across to Mac. Although most of the concept have been fairly simple to port across, from time to time I come across something which confuses me no end!

Drag and drop with General/NSOutlineView is one such problem...

I have found and looked at the example that comes with General/XCode, but I believe that the tutorial is too complex to answer the simple question of exactly how, step by step, to allow drag and drop. So, I am writing my own SIMPLE tutorial. However, I need some help...

The tutorial consists of 2 outlineviews on a window, each of which is controlled by it's own controller. I have created a custom class (General/OlvNode) and I want to be able to drag General/OlvNode objects from the left General/OutlineView to the right out lineView. Simple. Right? Well, I've hit some snags.

In the controller for the source outlineview, I have the following code:

    
- (BOOL) outlineView : (General/NSOutlineView *) outlineView 
		  writeItems : (General/NSArray*) items 
		toPasteboard : (General/NSPasteboard*) pboard 
{
	// 'items' is an array that contains all the nodes we're dragging.
	// For this example, lets just drag one node:
	draggedNode =  [items objectAtIndex : 0];
	
    // We need to tell the Paste Board what types of data we might send to it.
	// Here we'll declare:
	//		General/DragDropSimplePboardType - The custom type we declared 
	//		General/NSStringPboardType       - Simple General/NSString type
    [pboard declareTypes:General/[NSArray arrayWithObjects: General/DragDropSimplePboardType, General/NSStringPboardType,  nil] owner:self];
	
    // the actual data doesn't matter since General/DragDropSimplePboardType drags aren't recognized by anyone but us!.
    [pboard setData : General/[NSData data] 
			forType : General/DragDropSimplePboardType]; 
    
    // Put string data on the pboard... notice you candrag into General/TextEdit!
    [pboard setString : [draggedNode nodeCaption] 
			  forType : General/NSStringPboardType];
    return YES;
}


Then for the receiving outlineview, I call the following code:

    
- (unsigned int) outlineView : (General/NSOutlineView*) outlineView 
				validateDrop : (id <General/NSDraggingInfo>) info 
				proposedItem : (id) item 
		  proposedChildIndex : (int) childIndex 
{
	@try
	{
		// item is the node, so lets give it a useful name to work with
		General/OlvNode *targetNode = item;

		// This method validates whether or not the proposal is a valid one. Returns NO if the drop should not be allowed.
		//    General/SimpleTreeNode *targetNode = item;
		BOOL targetNodeIsValid = YES;
		
		if (nil == targetNode)
		{
			General/NSLog(@"Invalid target Node");
			targetNodeIsValid = NO;
		}

		// Get the dragged node from the dragged node's data source
		General/OlvNode *_draggedNode = General/[info draggingSource] dataSource] draggedNode];
		
		[[NSLog(@"Dragged Node is: '%@'", [_draggedNode nodeCaption]);

		// Set the item and child index in case we computed a retargeted one.
		[olv setDropItem : targetNode dropChildIndex : 0];//childIndex];

		return targetNodeIsValid ? General/NSDragOperationGeneric : General/NSDragOperationNone;
		
	}
	@catch (General/NSException *e) 
	{
		General/NSLog(@"EXCEPTION: '%@'", e);
	}
	return General/NSDragOperationNone;
}



- (BOOL)outlineView : (General/NSOutlineView*) outlineView 
		 acceptDrop : (id <General/NSDraggingInfo>) info 
			   item : (id) targetItem 
		 childIndex : (int) childIndex 
{
	General/OlvNode *thisNode = targetItem;
	
	General/OlvNode *newNode = General/[[OlvNode alloc] init];
	[newNode setNodeCaption: [thisNode nodeCaption]];
	[arrNodes addObject: newNode];
	
	General/NSLog(@"Created new Node with caption '%@'", [newNode nodeCaption]);
	
	[olv reloadData];

    return NO;
}


The problem I'm having is that when I'm dragging the node over, the app crashes, and I don't know why. I'd REALLY appreciate any help in this!!!

I'll happily email the source to anyone who wants to see for themselves - email me at temp@jacobs.co.za to let me know you want it.

Thanks in advance!!!!!!!!!!!!!

----

Posting your code and stating your application crashes doesn't really help; you're missing a vital piece of information. **Where** does it crash? :-) Run your application in the debugger and tell us what line kills it. To learn how to do this, see General/DebuggingTechniques, specifically the "Breaking on Exceptions" section. This technique more often than not will show you exactly what's wrong.