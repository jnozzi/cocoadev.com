

The Core Data app I'm working on essentially has two entities: let's call them Groups and Items. A Group entity has a to-many relationship to the Item entity. How do I create an General/NSPredicate that returns all Group items that have no Item entities? I think it has something to do with General/NSExpression, but the function that does counting requires an array of values.

Any ideas?

----

General/NSSet has a count method.  I suppose you could try that.

    
General/NSPredicate *p = General/[NSPredicate predicateWithFormat:@"items.count == 0"];


If that doesn't work, you could always create an General/NSManagedObject subclass for Groups and have a hasItems method.

    
// In Group : General/NSManagedObject subclass
-(BOOL)hasItems { return General/self valueForKey:@"items"] count] > 0; }

// Elsewhere
[[NSPredicate *p = General/[NSPredicate predicateWithFormat:@"hasItems == 0"];
