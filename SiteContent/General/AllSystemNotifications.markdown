

I know this can be cleaner, but I have to go to sleep.
If anyone feels like putting this all into an General/NSMutableDictionary you would be worshipped (but only slightly).

    

- (void)logNote:(id)sysNote
{
General/NSEnumerator *noteKeys = General/sysNote userInfo] keyEnumerator];

int x = 0;
id keyVal;

[[NSMutableArray *infoArray = General/[NSMutableArray arrayWithCapacity:General/sysNote userInfo] count]+2]; 

[infoArray insertObject:[@"\n noteMessage:" stringByAppendingString:[sysNote name 
atIndex:0
];


if (General/sysNote object] className])
	{
	[infoArray insertObject:[@"\n objectClass:" stringByAppendingString:[[sysNote object] className 
	atIndex:1
	];
	}
	  else [infoArray insertObject:@"\n objectClass:nil"  atIndex:1];
		

while (keyVal = [noteKeys nextObject])
{
	[infoArray insertObject:[@"\n userInfo:" stringByAppendingString:keyVal] 
	atIndex:x+2
	];
	x++;
}


General/NSMutableString *noteAll = General/[NSMutableString stringWithCapacity:256];
General/NSEnumerator *allEnum = [infoArray objectEnumerator];
id allVal;


while (allVal = [allEnum nextObject])
        {
	[noteAll appendString:allVal];
        }

General/NSLog(noteAll);
}



-(void)awakeFromNib
{
General/[[NSDistributedNotificationCenter defaultCenter] 
   addObserver:self
   selector:@selector(logNote:)
   name:nil
   object:nil];
}



One problem is that I havent found a good place to remove the observer....
Also oblectClass always returns nil

General/ChrisW

----

You would remove the observer in dealloc, same as usual. Also why do you have a General/NSDistributedNotificationCenter called allSystem, then assign void (the results of addObserver) to it? You probably mean something like

    

General/NSDistributedNotificationCenter *allSystem = General/[NSDistributedNotificationCenter defaultCenter];
   [allSystem addObserver:self
   selector:@selector(logNote:)
   name:nil
   object:nil];



But you could also just remove allSystem entirely.

The code for General/NotificationWatcher [http://www.tildesoft.com/Programs.html] would probably be of help to you. 

----

Thanks
I cut it down to

    
General/[[NSDistributedNotificationCenter defaultCenter] 
   addObserver:self
   selector:@selector(logNote:)
   name:nil
   object:nil];


Now all I need to do is get the values for the userInfo keys