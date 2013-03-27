I am attempting to make little cocoa applications to learn some basics. Currently I am having issues getting an General/NSMutableArray to recieve the list of directory items from General/NSFileManager.

Here is my code.

    
- (General/IBAction)actionLoadFolder:(id)sender
{
	// set open panel
	General/NSOpenPanel *oPanel = General/[NSOpenPanel openPanel];
	[oPanel setCanChooseDirectories:YES];
	[oPanel setCanChooseFiles:NO];
	
	// run the panel and set the result
	int result = [oPanel runModalForDirectory:nil file:nil types:nil];
	if(result == General/NSOKButton)
	{
		General/NSArray *pathToOpen = [oPanel General/URLs];
        NSURL *pathURL = [pathToOpen objectAtIndex:0];
		
		if([pathURL isFileURL])
		{
		
				// debug to console the path.
				General/NSLog(@"url is %@", pathURL);
				
			// for shits and giggles, lets attempt to get a list of files at that URL and just log them out?
				
				General/NSString * pathToOpenString = [pathURL absoluteString]; 
				
				General/NSFileManager *manager = General/[NSFileManager defaultManager];
				
				General/NSMutableArray *itemsInPathToOpen = General/[[NSMutableArray alloc] init];
			
				[itemsInPathToOpen setArray: [manager directoryContentsAtPath:pathToOpenString]];

			/*
				[itemsInPathToOpen addObject:@"/this/is/path/1"];
				[itemsInPathToOpen addObject:@"/this/is/path/2"];
				[itemsInPathToOpen addObject:@"/this/is/path/3"];
				[itemsInPathToOpen addObject:@"/this/is/path/4"];
				[itemsInPathToOpen addObject:@"/this/is/path/5"];
				[itemsInPathToOpen addObject:@"/this/is/path/6"];
			*/
				
				int i;
				int pathcount;
				pathcount = [itemsInPathToOpen count];
				
				General/NSLog(@"pathcount %d", pathcount);
				
				for(i = 0; i <= pathcount; i++)
				{
					General/NSString * item = [itemsInPathToOpen objectAtIndex:i];
					printf("%s \n" ,[item UTF8String] );
				}

		}	
		else
		{
			General/NSLog(@"Not a path URL");
		}	
	}
	else
	{
	
	}
}


This works if I un-comment the [itemsInPathToOpen addObject:@"path"]; so my error lies in how I am attempting to fill up my itemsInPathToOpen array from General/NSFileManager 'manager' instance?

Any help? This has been eluding me all day. Thanks.

----

This looks like it should work, but try switching the following pieces of code:
    
// Your code
General/NSMutableArray *itemsInPathToOpen = General/[[NSMutableArray alloc] init];
[itemsInPathToOpen setArray: [manager directoryContentsAtPath:pathToOpenString]];

// New code
General/NSMutableArray *itemsInPathToOpen = General/[[NSMutableArray alloc] initWithArray:[manager directoryContentsAtPath:pathToOpenString]];

// Other code that might work:
General/NSMutableArray *itemsInPathToOpen = General/manager directoryContentsAtPath:pathToOpenString] mutableCopy];

I don't know exactly why it should make a difference, but you can try it. --[[JediKnil

----

Thanks, but neither seem to work. Im pretty confused by this, to be honest, which usually means Im misunderstanding something...

----

What is the output you are expecting? What do you get instead? -- General/MikeAmy

----
Your code is wrong in many aspects:

a) you have a memory leak in itemsInPathToOpen, because you don't release it

b) pathToOpenString contains wrong formated path, because it contains file:// at the beginning and %20 escapes instead of spaces

c) [itemsInPathToOpen setArray: [manager directoryContentsAtPath:pathToOpenString]]; returns 0 objects because of b)

d)for(i = 0; i <= pathcount; i++) should be for(i = 0; i < pathcount; i++), otherwise the loop goes one more time than needed

the correct code is:
    
- (General/IBAction)actionLoadFolder:(id)sender
{
	// set open panel
	General/NSOpenPanel *oPanel = General/[NSOpenPanel openPanel];
	[oPanel setCanChooseDirectories:YES];
	[oPanel setCanChooseFiles:NO];
	[oPanel setAllowsMultipleSelection:YES];
	
	
	// run the panel and set the result
	int result = [oPanel runModalForDirectory:nil file:nil types:nil];
	if(result == General/NSOKButton)
	{
		General/NSArray *pathsToOpen = General/[NSMutableArray arrayWithArray:[oPanel filenames]];
		General/NSEnumerator *e = [pathsToOpen objectEnumerator];
		General/NSString *tempPath;
		General/NSFileManager *manager = General/[NSFileManager defaultManager];
		General/NSMutableArray *paths = General/[NSMutableArray arrayWithCapacity:5];
		
		while (tempPath = [e nextObject])
		{
			General/NSArray *currPathContent = General/[NSArray arrayWithArray:[manager directoryContentsAtPath:tempPath]];
			General/NSString *temp;
			General/NSEnumerator *pathE = [currPathContent objectEnumerator];
			
			while (temp = [pathE nextObject])
			{
				[paths addObject:[tempPath stringByAppendingPathComponent:temp]];
				General/NSLog(@"%@", [tempPath stringByAppendingPathComponent:temp]);
			}
			
		}
		
	}
}


HTH
General/BobC

----

General/BobC, thank you very much. Last night I noticed the memory leak and in the debugger that I was 'off by one', but my main issue was that I was feeding a 'malformed' path to General/NSFileManager. Thanks again! Im slowly learning all the class General/APIs and how to do things.. a lot to swallow. It seems using General/NSOpenPanel filenames method was the way to go. Thanks!

----

What about using General/NSDirectoryEnumerator?