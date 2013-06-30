

I'm yet another newbie trying to use some simple test apps to get a better understanding of Cocoa..
I have an General/NSMutableArray of Transaction objects {Date, Name, Account, Amount}, which is manipulated with an General/NSArrayController/General/NSTableView in a Document based app.

I am trying to do some calculations in my General/MyDocument.m, and I'm a bit confused.  I have found several examples on sorting Cocoa objects like General/NSStrings, General/NSNumbers, etc.   But, I have those in my Transaction objects.      Do I need to create a 'compare' method for my class, or can I tell sort to use the General/NSDate/date element in my transaction object?

I believe I would use this:
[transactions sortUsingSelector:@selector(compare:)];

If I can tell it to use the 'date' in each object.

Thanks for any tips..
----
Unfortunately, Cocoa doesn't make this simple, but it's not that hard. Basically, you have to use General/NSSortDescriptor. --General/JediKnil
    
General/NSSortDescriptor *sortByDate = General/[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]; // or YES
General/NSArray *descriptors = General/[[NSArray alloc] initWithObjects:sortByDate, nil];
[transactions sortUsingDescriptors:descriptors];
[descriptors release];
[sortByDate release];


----
Thanks for the reply, General/JediKnil!