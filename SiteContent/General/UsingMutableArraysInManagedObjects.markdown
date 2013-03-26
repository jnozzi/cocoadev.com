

Upon execution of the following code (which produces no warnings):
<code>
// Create initial security group
[[NSManagedObject]] '' group = [[[NSEntityDescription]] insertNewObjectForEntityForName:@"[[SecurityGroup]]" 
                                                    inManagedObjectContext:mainContext];
[group setValue:@"Private Assets" forKey:@"groupName"];
[[NSMutableArray]] '' userArray = [group mutableArrayValueForKeyPath:@"users"];
 [userArray addObject:user];
</code>
... I get:
<code>
2005-05-04 13:45:17.122 [[MyApp]][3670] [[NSManagedObjects]] of entity '[[SecurityGroup]]' 
do not support -mutableArrayValueForKey: for the property 'users'
</code>

Why doesn't -mutableArrayValueForKey: work in this case?

----

To-many relationships are represented by [[NSMutableSet]] in Core Data. Try -mutableSetValueForKey:. --[[ScottStevenson]]

''Thanks! Works like a charm. I was completely reading that wrong, for what it's worth. I was reading it as 'set value for key, mutably'. :-} ''

'''Congrats! Retired.'''

''Actually, can we keep this page linked to the [[CoreData]] topic? This is pretty useful information not everybody may grasp, with such a new technology.''

sounds good to me. people are way too quick to 'retire' pages  or otherwise orphan them. this site isn't a mailing list or a forum - it's a reference.

'''To be fair, "retiring" a discussion merely means removing it from [[CocoaDiscussions]], nothing more. Since that page is a list of open discussions, doesn't that make sense?'''

----

Actuallty, this doesn't solve the problem at hand. It may have for the original poster, but there is a difference between a set and an array. Arrays maintain the order of their members, and sets do not. How can one use ARRAYS, or ordered sets in [[CoreData]] entities? [[CoreData]] doesn't currently provide this functionality out of the box.

I have skated by using an orderHint variable in the member object of unordered to-many relationships in [[CoreData]], but this is hackish (though the preferred method according to an apple employee). I would prefer a cleaner solution. Any ideas?

-- [[EliotSimcoe]]

----
I think the idea behind using sets in [[CoreData]] is that most data ''is'' unordered, or is ordered by a primary key that is stored within the data itself. For example, a list of purchases is "naturally" ordered by date, but it could just as easily be ordered by price, or by store name, or whatever. The point is that a set can be sorted by any of these at any time, whereas an array has an intrinistic order. Also, sets do not support duplicates.

So, to get back to your question, an <code>orderHint</code> variable probably ''is'' the best way to do this (and not really hackish at all), as long as the order does not depend on anything else. An example of ''this'' might be a playlist in iTunes, which can be sorted by many different fields, but can also be dragged into a specific order. --[[JediKnil]] 

----

Why would'nt you order the data with a [[NSFetchRequest]], ordered with a relevant [[NSSortDescriptor]] ?

''Because this wouldn't preserve manual ordering as defined by the user - it'd sort by a descriptor, which may not be what the user (or developer) wants. [[JediKnil]] is correct - an orderHint (or whatever) variable is pretty much the only way to guarantee an order. You'd use the [[NSSortDescriptor]] to sort by that key. This allows your user to drag-n-drop the items in whatever order they want (which would trigger a re-enumeration of each item's orderHint keys) and still have that order preserved on subsequent fetches from your store. This is directly due to the fact that [[NSSets]] do not support orders. This has been discussed several times on the cocoa-dev mailing list (you might want to search www.cocoabuilder.com for the threads) and is the only currently-known approach to a solution for this problem.''