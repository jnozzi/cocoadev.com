Hello,

Having played around using bindings with General/NSOutlineView and General/NSTreeController in Tiger a fair bit recently, I have come to love General/NSTreeController. However, it has one ludicrous (IMHO) shortcoming that causes frustrations with so many things: all of the objects it returns are opaque. For instance, if you want to use any of its delegate or datasource methods that provide an (id)item parameter, such as -outlineView:heightOfRowByItem:, the item object you are passed will be of private class _NSControllerTreeNode (or some such). This is completely unusable.

Fortunately, there is a workaround. Scott Stevenson on the Cocoa-dev lists pointed out that the private class has an undocumented (ie. private and therefore not guaranteed to work forever) method -observedObject, which will return the object you would have expected to have been passed in the first place. This solves the problem for the most part, but is of no use when you are expected to pass back an item, which is the case with -outlineView:itemForPersistentObject:. This will expect you to return an item of class _NSControllerTreeNode - and there is simply no way to do that.

In short, I am saying (and please prove me wrong somebody :) ) that there is no way to use the traditional datasource state-saving methods (-setAutosaveExpandedItems:, -outlineView:persistentObjectForItem: and -outlineView:itemForPersistentObject:) with an General/NSOutlineView when using an General/NSTreeController and bindings. This is *very* annoying, and seems a rather large oversight on Apple's part, but hey. So if you want state-saving in your General/NSOutlineView but want to use General/NSTreeController (and why wouldn't you?), you have to implement it yourself. Just in case this is of any use to anybody else, I therefore thought I would post my own solution to this problem here. What follows is the code to an General/NSOutlineView subclass (though it could just as easily have been a category) that provides methods for state-saving.

Interface:

    

// General/KBOutlineView.h

#import <Cocoa/Cocoa.h>

@interface General/KBOutlineView : General/NSOutlineView
{
}
- (id)observedObjectForItem:(id)item;
- (General/NSArray *)expandedState;
- (BOOL)restoreExpandedStateWithArray:(General/NSArray *)stateArray;
@end

@interface General/NSObject (General/KBOutlineViewDataSource)
- (id)outlineView:(General/NSOutlineView *)outlineView uniqueValueForObservedObject:(id)observedObject;
@end




Implementation:

    

// General/KBOutlineView.m

#import "General/KBOutlineView.h"


// Avoid compiler errors by declaring the required _NSControllerTreeNode private method here
@interface General/NSObject (General/PrivateTreeNodeMethods)
- (id)observedObject;
@end


@implementation General/KBOutlineView

- (id)observedObjectForItem:(id)item
{
	if ([item respondsToSelector:@selector(observedObject)])
		return [item observedObject];
	return item;
}

- (General/NSArray *)expandedState
{
	// This depends on the datasource implementing uniqueValueForObservedObject
	if (!General/self dataSource] respondsToSelector:@selector(outlineView:uniqueValueForObservedObject:)])
		return nil;
	
	[[NSMutableArray *state = General/[NSMutableArray array];
	int i;
	for (i=0; i<[self numberOfRows]; i++)
	{
		if ([self isItemExpanded:[self itemAtRow:i]])
			[state addObject:General/self dataSource] outlineView:self
							   uniqueValueForObservedObject:[self observedObjectForItem:[self itemAtRow:i]];
	}
	return state;
}

- (BOOL)restoreExpandedStateWithArray:(General/NSArray *)state
{
	if (!General/self dataSource] respondsToSelector:@selector(outlineView:uniqueValueForObservedObject:)])
		return NO;
	
	int i;
	int numberOfRows = [self numberOfRows];
	for (i=0; i<[state count]; i++)
	{
		int d;
		for (d=0; d<numberOfRows; d++)
		{
			if ([[[self dataSource] outlineView:self 
				   uniqueValueForObservedObject:[self observedObjectForItem:[self itemAtRow:d]
				isEqual:[state objectAtIndex:i]])
			{
				[self expandItem:[self itemAtRow:d]];
				numberOfRows = [self numberOfRows];
			}
		}
	}
	return YES;
}

@end




To get state-saving to work:

1) Make sure your outline view's custom class is set to General/KBOutlineView in IB and that your instance variable in your controller is of type General/KBOutlineView rather than General/NSOutlineView (duh).

2) Make sure you set a datasource for the outline view. As Scott Stevenson has pointed out on his site (http://theocacao.com/document.page/130), this means you will need to implement dummy datasource methods (because General/NSTreeController is taking care of everything), as follows:

    

- (int)outlineView:(General/NSOutlineView *)ov numberOfChildrenOfItem:(id)item
{
	return 0;
}

- (BOOL)outlineView:(General/NSOutlineView *)ov isItemExpandable:(id)item
{
	return NO;
}

- (id)outlineView:(General/NSOutlineView *)ov child:(int)index ofItem:(id)item
{
	return nil;
}

- (id)outlineView:(General/NSOutlineView *)ov objectValueForTableColumn:(General/NSTableColumn *)tableColumn byItem:(id)item
{
	return nil;
}



3) Implement -outlineView:uniqueValueForObservedObject: in your datasource:

    

- (id)outlineView:(General/NSOutlineView *)ov uniqueValueForObservedObject:(id)object
{
	return [object someUniqueIdentifier];
}



This method must just return a unique object that can be used to identify the object passed in at a later time - in just the same way that -outlineView:persistentObjectForItem: works, in fact.

(Note: There is no reason this custom datasource method couldn't have been made a delegate method, thus negating the need for all the dummy datasource methods. However, it makes more sense to have it in the datasource, and you're probably going to want to implement drag and drop or other datasource methods anyway.)

4) Now, whenever you save your project, just call [myOutlineView expandedState] and save the returned array somewhere (most likely in with all the other save data). Whenever you open the project, call [myOutlineView restoreExpandedStateWithArray:savedArray] on the array that you previously saved, and ta-da - the outline view's state will be magically restored (obviously you will need to call this after the NIB files have been loaded, eg. in -awakeFromNib or -windowControllerDidLoadNib:).

I hope this helps someone else out there.
KB


There's another approach here http://blog.pioneeringsoftware.co.uk/2008/09/10/outline-view-tree-controller-and-itemforpersistentobject. It doesn't involve sub-classing and accessing private methods.