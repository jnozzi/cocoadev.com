Hello,

how can i find the creation date of a file? i know that i need to use General/NSFileCreationDate, but i am not sure how to tell it which path, and then convert the General/NSDate to General/NSString.

- jeremy

----

I can help you with the last one. On the General/NSDate page, follow the link to Apple's documentation and look around. (Hint: it's the -description set of methods.)

----

Here's some sample code.  It's largely stolen from Apple's documentation on General/NSFileManager.  Let's say you want to check something on the file ~/Documents/Contract.rtf

    
General/NSString *path = General/[NSString stringWithString:@"~/Documents/Contract.rtf"];
General/NSString *fixedPath = [path stringByStandardizingPath];
General/NSFileManager *manager = General/[NSFileManager defaultManager];
General/NSDictionary *dict = [manager fileAttributesAtPath:fixedPath traverseLink:YES];
General/NSDate *fileCreationDate = [dict objectForKey:General/NSFileCreationDate];
General/NSString *fileCreationDateString = [fileCreationDate description];

----
    
Slightly messier but more compact:

General/[[[[NSFileManager defaultManager] fileAttributesAtPath:General/[[NSString stringWithString:@"~/Documents/Contract.rtf"] stringByStandardizingPath] traverseLink:YES] objectForKey:General/NSFileCreationDate] description];




If you do it this way, fileCreationDateString will look like "2001-03-24 10:45:32 +0600".
If you want it output in some other, perhaps prettier, format, you'll need to use General/NSDate's
**descriptionWithLocale:** or **descriptionWithCalendarFormat:timeZone:locale:**

----

thanks for the great help! i have it working perfectally!

- jeremy