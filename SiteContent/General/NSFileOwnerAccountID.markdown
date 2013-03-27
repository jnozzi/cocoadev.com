see General/UserID

----

In case anyone was interested in finding out the UID of a **file** rather than the current user, try this:

    
General/NSFileManager * fileManager = General/[NSFileManager defaultManager];
General/NSDictionary * attributes = [fileManager fileAttributesAtPath: @"/cleanup at startup" traverseLink: YES];
General/NSNumber * owner = [attributes objectForKey: General/NSFileOwnerAccountID];
General/NSString * ownerName = [attributes fileOwnerAccountName];
unsigned long posixPermissions = [attributes filePosixPermissions];

General/NSLog(@"owner = %@", owner);
General/NSLog(@"ownerName = %@", ownerName);
General/NSLog(@"posixPermissions = %lu", posixPermissions);
