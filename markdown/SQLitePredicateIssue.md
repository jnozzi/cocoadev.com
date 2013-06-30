

I have a functioning app that I've created using Core Data. I've been using XML as by data store and it's all been peachy, save for its performance issues (fetching a couple thousand entries to delete when quitting takes ages). So I figured I'd switch over to General/SQLite, only I've run into an odd bug.

    
General/NSFetchRequest *request = General/[[[NSFetchRequest alloc] init] autorelease];
General/NSEntityDescription *entity = General/[NSEntityDescription entityForName:@"Edit" inManagedObjectContext:[self managedObjectContext]];
[request setEntity:entity];
General/NSPredicate *predicate = General/[NSPredicate predicateWithFormat:@"article.name == %@ AND mostRecent == TRUE", [self valueForKeyPath:@"article.name"]];
[request setPredicate:predicate];

General/NSLog(@"article.name is <%@>", [self valueForKeyPath:@"article.name"]);

General/NSError *error = nil;
General/NSArray *array = General/self managedObjectContext] executeFetchRequest:request error:&error];


The [[NSLog prints out the article's name, but the executeFetchRequest results in...

    
An uncaught exception was raised
2006-10-29 23:31:49.302 General/WikiGuard[6576] unresolved keypath: article.name
2006-10-29 23:31:49.303 General/WikiGuard[6576] *** Uncaught exception: <General/NSInternalInconsistencyException> unresolved keypath: article.name


If I remove article.name from the predicate and just search for mostRecent == TRUE, the error pumps out an issue with mostRecent. As I said, this works in an XML data store, but not General/SQLite. Crazy. Ideas?

-- bradbeattie@gmail.com

----
Kay, fixed my own problem. You can't search on transient attributes, which all the attributes of edits were.