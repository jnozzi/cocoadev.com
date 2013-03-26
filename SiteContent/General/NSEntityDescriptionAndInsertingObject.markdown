

I know I can insert [[NSManagedObject]] into a context with the following code

<code>
[[NSManagedObjectContext]] ''context = [self managedObjectContext];

[[NSManagedObject]] ''object = [[[NSEntityDescription]] insertNewObjectForEntityForName:@"Object" inManagedObjectContext:context];

[object setValue:@"george" forKey:@"name"];
</code>

But there is something I do not understand : if that context is bound to a [[NSArrayController]], it seems that calling ''insertNewObjectForEntityForName:inManagedObjectContext'' sometimes inserts the object into the array and sometimes not... 

Could anyone tell why ?

----

Please provide more details on how you have your array controller configured. One thing I will say is that, unless you're calling the array controller's <code>-add:</code> method directly, you (often) need to tell the array controller to <code>-fetch:</code> to refresh its result set.