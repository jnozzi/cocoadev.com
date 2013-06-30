

Does anyone have any insight has to why the following code... 


    
	General/NSConnection* c1 = General/[NSConnection connectionWithRegisteredName:@"General/DoesNotExist" host:nil];
	General/NSLog(@"c1 = %@", c1);
	
	General/NSConnection* c2 = General/[NSConnection defaultConnection];
	[c2 registerName:@"General/DoesExist"];
	General/NSLog(@"c2 = %@", c2);
	
	[c2 registerName:@"General/NewName"];
	[c2 invalidate];
	[c2 release];

	General/NSConnection* c3 = General/[NSConnection connectionWithRegisteredName:@"General/DoesExist" host:nil];
	General/NSLog(@"c3 = %@", c3);


should produce the following output....

<code>
2007-10-04 01:12:32.530 General/TestTool[7642] c1 = (null)


2007-10-04 01:12:32.536 General/TestTool[7642] c2 = (** General/NSConnection 0x304c40 receivePort <General/CFMachPort 0x305040 [0xa07bb150]>{locked = No, valid = Yes, port = 0xc0b, source = 0x0, callout = 0x92bd9810, context = <General/CFMachPort context 0x304f00>} sendPort <General/CFMachPort 0x305040 [0xa07bb150]>{locked = No, valid = Yes, port = 0xc0b, source = 0x0, callout = 0x92bd9810, context = <General/CFMachPort context 0x304f00>} refCount 2 **)


2007-10-04 01:12:32.537 General/TestTool[7642] c3 = (** General/NSConnection 0x306b70 receivePort <General/CFMachPort 0x3053b0 [0xa07bb150]>{locked = No, valid = Yes, port = 0x1203, source = 0x0, callout = 0x92bd9810, context = <General/CFMachPort context 0x305b30>} sendPort <General/CFMachPort 0x305040 [0xa07bb150]>{locked = No, valid = Yes, port = 0xc0b, source = 0x0, callout = 0x92bd9810, context = <General/CFMachPort context 0x304f00>} refCount 2 **)
</code>

c1 is obviously what you would expect, but one would think that after at any one of, changing the registered name, invalidating, and releasing, c2 ought to actually be gone, but the fact that c3 exists suggests otherwise.

I managed to work around the problem that something similar to the above was causing, but I'm still curious as to why this is, and if there's any good way around it.

----
My guess would be that it doesn't really get invalidated until you return to the runloop.