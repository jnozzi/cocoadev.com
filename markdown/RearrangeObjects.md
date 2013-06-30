

Hi all,

I am trying to keep my General/NSArrayController ordering my General/CoreData entities in my desired order after adding, inserting, removing entries etc.

In my Controller I have:

    
- (void)awakeFromNib
{
General/NSSortDescriptor *groupSortDescriptor = General/[[NSSortDescriptor alloc] initWithKey:@"orderPriority" ascending:YES];
[groupsArrayController setSortDescriptors:General/[NSArray arrayWithObject:groupSortDescriptor]];
[groupSortDescriptor release];

[groupsArrayController addObserver:self forKeyPath:@"arrangedObjects" options:General/NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(General/NSString*)keyPath ofObject:(id)object change:(General/NSDictionary*)change context:(void*)context
{
if (object == groupsArrayController)
[groupsArrayController rearrangeObjects];
}


The idea here is that when the arranged objects changes through an insertion, deletion or what-have-you, we get to call rearrangeObjects, and they're sorted according to the sortDescriptor again. The observeValueForKeyPath: method does get called, and at the right time... but when I put the 'rearrangeObjects' call in there I am getting a crash at startup "Signal 11 (SIGSEGV)" - I'm confused as I can't see how I can cock things up (a memory problem it looks like too) with a call to rearrangeObjects...

... any hints?

----
Maybe try General/NSZombieEnabled.

----
Strangely, I only get the crash if the General/NSArrayController is set to automaticallyPrepareContent. I can also call 'rearrangeObjects' however I like from a button-push for example... it's only sensitive in the observeValueForKeyPath method. :(

----
Ok, I think I know what is going on... it's just an infinite loop... arrangedObjects changes -> rearrangeObjects called -> rearranges and changes arrangedObjects --- ad infinitum.

Um... anyone have any advice on how to do what I want here? I.e. as soon as an insert/add/remove is done on an General/NSArrayController, I want to call rearrangeObjects (so they rearrange themselves according to my sort descriptor again). I don't /really/ want to subclass General/NSArrayController just for this... it seems simple. I don't think I can just call 'rearrangeObjects' after any General/IBAction which causes an insert/add/remove for two reasons: 1. It seems clumsy to me, and 2. My IB Buttons for insert and delete are connected straight through to the General/NSArrayController's convenient add: and insert: methods... giving me no space to run my own code to call rearrangeObjects... unless I subclass General/NSArrayController.

Surely there's a seasoned Cocoa pro reading who can swoop in and save the day?!
----
If you use the General/NSArrayController to add objects I'm pretty sure it'll automatically fit your sort descriptors, and if the     arrangedObjects key is being changed, I think it knows it's supposed to sort. (Did you try just letting it go without the key-value observing and call to     rearrangeObjects?) If it isn't sorting, though, maybe you should try observing your General/CoreData array directly and calling     rearrangeObjects from there. --General/JediKnil

----

Yeah it doesn't seem to rearrange automatically :(
When you say '...try observing your General/CoreData array directly...' do you mean the General/ManagedObjectContext?
----
Hmm...in retrospect that wasn't a great way to put it. Looking at the way General/CoreData handles things...it may not be easy to pick out just a certain array to observe. Looking on Apple's site...they recommend (somewhere) subclassing General/NSArrayController. One other solution *I've* found seems to be, yes, observing the General/CoreData object context for changes in any object of your entity type. Something like this:
    
- (void)awakeFromNib
{
General/NSSortDescriptor *groupSortDescriptor = General/[[NSSortDescriptor alloc] initWithKey:@"orderPriority" ascending:YES];
[groupsArrayController setSortDescriptors:General/[NSArray arrayWithObject:groupSortDescriptor]];
[groupSortDescriptor release];

General/[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(objectsDidChange:) name:General/NSManagedObjectContextObjectsDidChangeNotification object:[self managedObjectContext]];
}

- (void)objectsDidChange:(General/NSNotification *)note
{
    General/NSArray *insertedEntities = General/[note userInfo] valueForKey:[[NSInsertedObjectsKey] valueForKeyPath:@"entity.name"];
    General/NSArray *updatedEntities  = General/[note userInfo] valueForKey:[[NSUpdatedObjectsKey] valueForKeyPath:@"entity.name"];
    General/NSArray *deletedEntities  = General/[note userInfo] valueForKey:[[NSDeletedObjectsKey] valueForKeyPath:@"entity.name"];

     // Use whatever entity name, or use an General/NSEntityDescription and key path @"entity" above
    if ([insertedEntities containsObject:@"Post"] ||
        [updatedEntities containsObject:@"Post"] ||
        [deletedEntities containsObject:@"Post"])
    {
        [postController rearrangeObjects];
    }
}

I realized that in most cases updated objects had to be included too, since most sort keys are user-modifiable. The drawback of this method, of course, is that any modification to the General/CoreData store triggers this method. It may be easier and/or more efficient to simply subclass General/NSArrayController and override     -add:,     -insert:, and     -remove:. Hmm...sorry I can't be of more help...maybe someone else on the site has a better solution? (And why don't General/NSArrayController's sort descriptors automatically go into the General/CoreData fetch request?) --General/JediKnil

----

Thanks a lot for your help.

It does seem strange that the General/SortDescriptor is not used to re-order the objects after an insert/add/remove automatically. At least this should be an option, but unless I'm being very, very, stupid (not uncommon), it doesn't rearrange its objects automatically. I've even rebuilt a test app that just does this, and yep, the array doesn't auto-sort after things in it are changed or added. Weird.

I will give your very kind suggestion a go and report back... thanks again.

... 1 hour later ...

General/JediKnil, thanks so much for your help, this works perfectly, and although like you I am concerned by the efficiency and cleanliness of this implementation, this is the only way I can see to keep an General/NSArrayController sorted 100% of the time. Thanks and thanks again if you have a mailing address I'll send you a postcard, and if you're going to WWDC I'll buy you a beer :) . Now I'm a General/CoreData and Cocoa Bindings newbie so I don't want to be critical out of place, but isn't this kind of thing /exactly/ what the General/NSArrayController /should/ be capable of doing out of the box?
----

I had this same problem and I just wanted to say thanks to General/JediKnil as his solution works great! � patr1ck
----
I'll just bump this. Could anyone please confirm that there still isn't a clean solution to the above mentioned problem?
----
I just ran into this problem, and wrote the following code:
    
static void *General/ContentChangedContext = @"General/ContentChangedContext";

[arrayController addObserver:self forKeyPath:@"arrangedObjects.keyByWhichObjectsAreArranged" options:0 context:General/ContentChangedContext];

- (void)observeValueForKeyPath:(General/NSString *)keyPath ofObject:(id)object change:(General/NSDictionary *)change context:(void *)context
{
	if (context == General/ContentChangedContext)
	{
		General/NSArray *existing = [object arrangedObjects];
		General/NSArray *wouldbe = [object arrangeObjects:existing];
		if (![existing isEqualToArray:wouldbe])
			// rearrange at the end of the run loop, otherwise detail interface gets out of sync
			[object performSelector:@selector(rearrangeObjects) withObject:nil afterDelay:0];
		[self reloadData];
	}
}

It's still not pretty, and may well be less efficient than General/JediKnil's solution -- I'll be using Shark to compare the two later (no premature optimisation for me). --Hamish

----
I also ran into this problem.  I am NOT using General/CoreData, and my solution is much simpler.  (Note I am under 10.5.4 and am a Cocoa newbie, so this may not be relevant to others).

I solved the problem by checking "Auto Rearrange Content" on the array controller in Interface Builder.  Then in in my controller object I did this:

    
- (void)awakeFromNib
{
	General/NSSortDescriptor *d = General/[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[myArrayController setSortDescriptors:General/[NSArray arrayWithObject:d]];
	[d release];
}


This seems to work perfectly.

--Taylor
----
Taylor, I'm doing the same thing for an array controller of mutable dictionary objects stored in the shared user defaults, and it does indeed keep the items sorted, but the issue I'm having now is removing objects.  I can remove one without trouble but the second one will always give me an exception:

    
-General/[NSCFArray removeObjectAtIndex:]: index (2147483647( or possibly larger)) beyond bounds (2)


I've tried making sure the table and array controller have the same sort descriptor.  I've tried subclassing the array controller and doing a re-index upon add and remove of objects.

Any ideas anyone?
-- Steve

----
One thing to double check is that modifications to the controller aren't being done in a modal context, since in many cases the operation is deferred. But there still seem to be cases when remove: inexplicably fails in a non-modal context. Try calling rearrangeObjects before remove:, that seems to work for me.