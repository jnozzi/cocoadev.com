Hello,

I'm new in cocoa programming and despite General/AAron Hillegass's book, Apple's documentation and cocoadev's post I can't solve my problem. Here it is : 

I'm building a core data application. I want it to calculate some statistics thanks to an entity content. In my case the calculation consist in getting the max - the min value and dividing by the General/NSArray count property. My app is a General/NSTableView bound to a General/NSArrayController bound to a core data structure. There are an add and a remove buttons bound to the General/NSArrayController.
Thanks to IB and bindings my app is already able to add, remove, edit and store datas. I know how to build an Entity. I know how to customize it (General/NSManagedObject inheritance) and I know how to fetch it (predicates). The problem is I want the calculation to be real time refreshed. I mean I want it to be recalculated when I add, edit or remove a row from the General/NSTableView as the calculation is based on the values of the rows. To do that I've learnt I should add and observer. 

Here is what I did :

/////////////General/EntityRelev.h
#import <Cocoa/Cocoa.h>

//I will use a custom managed object as entity so that I can control default values...
@interface General/EntityRelev : General/NSManagedObject {
}

@end

////////////General/EntityRelev.m
#import "General/EntityRelev.h"

@implementation General/EntityRelev

//Adds an observer on each object so that I can trigger my calculations when one is added, editied or removed
- (void) awakeFromEverything
{
  [self addObserver:self forKeyPath:@"kmReleve" options:(General/NSKeyValueObservingOptionNew | General/NSKeyValueObservingOptionOld) context:NULL];
}

- (void) awakeFromInsert
{
  //some initializations
  //adds an observer on new objects
  [self awakeFromEverything];
}

- (void) awakeFromFetch
{
   //adds an observer on already stored datas and on fetched datas
   [self awakeFromEverything];
}

- (void) didTurnIntoFault
{
  //should remove the observer from the close to be removed object
}

- (void) observeValueForKeyPath:(General/NSString *)keyPath ofObject:(id)object change:(General/NSDictionnary *)change context:(void *)context
{
  //perform my calculations
  General/NSLog(@"you should do it now");
}

@end


When editing pre stored objects -> the "event" is triggered -> ok
When adding a new object and editing them -> the "event" is triggered -> ok
When removing a previously created object -> the "event" is triggered -> ok
When removing a pre stored object -> the "event" ISN'T triggered -> Problem :-(

According to what I read there is a thing about the managedcontext and faults but I can't understand how to solve that. Is there something I should add to my class ? Is there something I missunderstood ?
Please could someone help me ?

Kind Regards
Xavier