

I know I can insert General/NSManagedObject into a context with the following code

    
General/NSManagedObjectContext *context = [self managedObjectContext];

General/NSManagedObject *object = General/[NSEntityDescription insertNewObjectForEntityForName:@"Object" inManagedObjectContext:context];

[object setValue:@"george" forKey:@"name"];


But there is something I do not understand : if that context is bound to a General/NSArrayController, it seems that calling *insertNewObjectForEntityForName:inManagedObjectContext* sometimes inserts the object into the array and sometimes not... 

Could anyone tell why ?

----

Please provide more details on how you have your array controller configured. One thing I will say is that, unless you're calling the array controller's     -add: method directly, you (often) need to tell the array controller to     -fetch: to refresh its result set.