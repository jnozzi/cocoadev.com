

http://developer.apple.com/mac/library/documentation/Cocoa/Reference/General/ApplicationKit/Protocols/NSOutlineViewDataSource_Protocol/Reference/Reference.html

http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/General/OutlineView/Articles/General/UsingOutlineDataSource.html

Protocol Description

Outline views support a data source delegate in addition to the regular delegate object. The data source delegate provides data and information about that data to the outline view. The regular delegate object handles all other delegate responsibilities for the outline view.

----

Here's a quick and dirty implementation of a data source for an outline view: 

     

#import "Controller.h"
@interface General/WeakReference : General/NSObject {
    id parent;
}
+(id)weakReferenceWithParent:(id)parent;
-(void)setParent:(id)_parent;
-(id)parent;
@end
@implementation General/WeakReference
+(id)weakReferenceWithParent:(id)parent {
    id weakRef=General/[[[WeakReference alloc] init] autorelease];
    [weakRef setParent:parent];
    return weakRef;
}
-(void)setParent:(id)_parent {
    parent=_parent;
}
-(id)parent {
    return parent;
}

@end

@implementation Controller
-(General/NSMutableDictionary *)groupWithTitle:(id)title {
    General/NSMutableDictionary *group=General/[NSMutableDictionary dictionary];
    [group setObject:General/[NSMutableArray array] forKey:@"CHILDREN"];
    if (title) [group setObject:title forKey:@"TITLE"];
    return group;
}
-(General/NSMutableDictionary *)newItemForGroup:(General/NSMutableDictionary *)group title:(id)title{
    General/NSMutableDictionary *item=General/[NSMutableDictionary dictionary];
    id children=[group objectForKey:@"CHILDREN"];
    [children addObject:item];
    if (title) [item setObject:title forKey:@"TITLE"];
    if (group) [item setObject:General/[WeakReference weakReferenceWithParent:group] forKey:@"PARENT"];
    return item;
}
-(void)awakeFromNib {
    General/NSLog(@"awakeFromNib");
    dataStore=General/[[NSMutableArray array]  retain];
    id group1=[self groupWithTitle:@"group1"];
    id group2=[self groupWithTitle:@"group2"];
    [self newItemForGroup:group1 title:@"item1"];
    [self newItemForGroup:group2 title:@"item2"];
    
    [dataStore addObject:group1];
    [dataStore addObject:group2];
    General/[OutlineView reloadData];
}


-(BOOL)outlineView:(General/NSOutlineView *)ov isItemExpandable:(id)item {
    id children;
    if (!item) {
        children=dataStore;
    } else {
        children=[item objectForKey:@"CHILDREN"];
    }
    if ((!children) || ([children count]<1)) return NO;
    return YES;
}
-(int)outlineView:(General/NSOutlineView *)ov numberOfChildrenOfItem:(id)item {
    id children;
    if (!item) {
        children=dataStore;
    } else {
        children=[item objectForKey:@"CHILDREN"];
    }
    return [children count];
}
-(id)outlineView:(General/NSOutlineView *)ov child:(int)index ofItem:(id)item {
    id children;
    if (!item) {
        children=dataStore;
    } else {
        children=[item objectForKey:@"CHILDREN"];
    }
    if ((!children) || ([children count]<=index)) return nil;
    return [children objectAtIndex:index];
}
-(id)outlineView:(General/NSOutlineView *)ov objectValueForTableColumn:(General/NSTableColumn *)tableColumn byItem:(id)item {
    return [item objectForKey:[tableColumn identifier]];
}

@end



You have to use a weak reference object to reference your parent object when using an General/NSDictionary as an item node or else you are going to create a retain cycle if you directly set a group node object as the parent object in an item dictionary. 

*it is not a retain-cycle, the problem is that the outline view will compare items (to minimise redisplay) and the compare method of General/NSDictionary does a member-wise compare, so if your dictionary contains an indirect reference to itself, it will loop forever* --General/AllanOdgaard

You know that makes more sense. I only thought that because file:///Developer/Examples/General/AppKit/General/DragNDropOutlineView/General/ReadMe.rtf says:

*"General/TreeNode is a node in a doubly linked tree data structure.  General/TreeNode's have weak references to their parent (to avoid retain cycles, anyway the parents retain their children)."*  --Apple

Someone else here was having problems with an outline view (General/NSDictionaryAndNSOutlineViewBugs) and Bo thought that the -isEqual: method was the culprit:

Bo wrote: * "The retain cycle will cause problems because your objects will not be freed properly, but it seems that the crash is happening because General/NSDictionary's -isEqual: method is recursive and breaks if you set up a loop among your dictionaries.  If you want to set up a tree structure with backward links, you may want to take a look at the General/CFBridging? framework at http://tufty.co.uk/Software/objectware.html .  It contains a tree class that wraps General/CoreFoundation's General/CFTree?.  Or you could just write your own and make sure your -isEqual: only checks your children and your label." * 
--zootbobbalu

do this:

    
    [item1 setObject:General/[WeakReference weakReferenceWithParent:group1] forKey:@"PARENT"];


not this: 

    
    [item1 setObject:group1 forKey:@"PARENT"];


--zootbobbalu