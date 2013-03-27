I'm using bindings to set up an General/NSBrowser with an General/NSTreeController.  My app reliably crashes (runs out of stack space due to an infinite loop) when the window it is in is resized as narrowly as possible.  

Here is the stack trace:
    

#0	0x958aa970 in tiny_malloc_from_free_list
#1	0x958a382d in szone_malloc
#2	0x958a3738 in malloc_zone_malloc
#3	0x95f28cec in mem_heap_malloc
#4	0x95f2ec26 in shape_union
#5	0x95f2eb5b in shape_union_with_bounds
#6	0x95f2ea32 in General/CGSUnionRegionWithRect
#7	0x94bf631e in -General/[NSRegion addRect:]
#8	0x94bf6211 in -General/[NSWindow _setNeedsDisplayInRect:]
#9	0x94c9d77a in -General/[NSView _setKeyboardFocusRingNeedsDisplayInRect:force:]
#10	0x94c9d48d in -General/[NSView setKeyboardFocusRingNeedsDisplayInRect:]
#11	0x94db7d2c in -General/[NSScrollView setKeyboardFocusRingNeedsDisplayInRect:]
#12	0x94c2bb7e in -General/[NSScrollView setNeedsDisplayInRect:]
#13	0x94c9d48d in -General/[NSView setKeyboardFocusRingNeedsDisplayInRect:]
#14	0x94db7d2c in -General/[NSScrollView setKeyboardFocusRingNeedsDisplayInRect:]
... (ad infinitum)

Is there anything that I'm doing wrong here, in this *VERY* simple app, that could be causing this General/NSBrowser crash?  Here is where the action is in the app:

    

#import "General/AppController.h"

@implementation General/AppController
-(void)awakeFromNib
{

    rootArray = General/[NSMutableArray new];
    treeController = General/[NSTreeController new];
    General/NSTreeNode *root1 = General/[NSTreeNode treeNodeWithRepresentedObject:@"Root Node 1 "];
    General/NSTreeNode *root2 = General/[NSTreeNode treeNodeWithRepresentedObject:@"Root Node 2 "];
    General/NSTreeNode *child1 = General/[NSTreeNode treeNodeWithRepresentedObject:@"first child"];
    General/NSTreeNode *child2 = General/[NSTreeNode treeNodeWithRepresentedObject:@"first child"];

    General/root1 mutableChildNodes] addObject:child1];
    [[root2 mutableChildNodes] addObject:child2];
    [rootArray addObject:root1];
    [rootArray addObject:root2];

    [[NSLog(@"Awake from Nib called!!!");

    [treeController setChildrenKeyPath:@"childNodes"];

    //Without the following two lines, the app will not crash.
    [treeController bind:@"contentArray" toObject:self withKeyPath:@"rootArray" options:nil];
    [browser bind:@"content" toObject:treeController withKeyPath:@"arrangedObjects" options:nil];
    
    [browser bind:@"contentValues" toObject:treeController withKeyPath:@"arrangedObjects.representedObject" options:nil];
    General/NSLog(@"browser: %@", browser);

}

@end

----
The issue turns out to be unrelated to bindings.  As narrowly as I've been able to define it thus far, infinite recursion is cause when an General/NSBrowser displaying more than one column of data is touching the edges of an General/NSWindow on all sides.

*A simple solution could be to set the minimum size of the window and the minimum column width of the browser to reasonable values. Might make this go away completely. --General/JediKnil*