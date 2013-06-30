Seems to be at least three ways to handle events in Cocoa games.

1.) Create your own run loop.
2.) Override sendEvent
3.) Use HID code

Can someone critique this example of #2 with multithreaded drawing thrown in. Would it be preferable to just create your own run loop? One of the main reasons I would say that this is preferable to #1 is that finding good examples of creating a run loop are few and far between and it is not recommended in the offical docs of General/NSApplication that you do so.

--Overridden General/NSApplication--
    
-(void)sendEvent:(General/NSEvent *)anEvent {
	switch ([anEvent type]) {
		case General/NSLeftMouseUp:
		case General/NSLeftMouseDown:
		case General/NSRightMouseUp:
		case General/NSRightMouseDown:
		case General/NSKeyUp:
		case General/NSKeyDown: {
			[input queueEvent:anEvent];
			break;
		}
		
		default: {
			[super sendEvent: anEvent];
		}
	}
}


--Input class--
    
-(id)init {
	self = [super init];
	
	if (self != nil) {
		eventQueue = General/[[NSMutableArray alloc] initWithCapacity:256];
		queueLock = General/[[NSConditionLock alloc] initWithCondition:NO_DATA];
	}
	
	return self;
}

-(void)dealloc {
	if (eventQueue != nil) {
		[queueLock lock];
		[eventQueue removeAllObjects];
		[eventQueue release];
		[queueLock unlock];
	}
	
	if (queueLock != nil) {
		[queueLock release];
	}
	
	[super dealloc];
}

-(void)queueEvent:(General/NSEvent *)anEvent {
	[queueLock lock];
	[eventQueue addObject:anEvent];
	[queueLock unlockWithCondition:HAS_DATA];
}

-(General/NSEvent *)dequeueEventNoWait {
	General/NSEvent *event = nil;
	
	if ([queueLock tryLockWhenCondition:HAS_DATA]) {
		event = [eventQueue objectAtIndex:0];
		[event retain];
		[eventQueue removeObjectAtIndex:0];
		
		if ([eventQueue count] == 0) {
			[queueLock unlockWithCondition:NO_DATA];
		} else {
			[queueLock unlockWithCondition:HAS_DATA];
		}
	}
	
	return event;
}

-(General/NSEvent *)dequeueEventWait {
	General/NSEvent *event = nil;
	
	[queueLock lockWhenCondition:HAS_DATA];
	
	event = [eventQueue objectAtIndex:0];
	[event retain];
	[eventQueue removeObjectAtIndex:0];
	
	if ([eventQueue count] == 0) {
		[queueLock unlockWithCondition:NO_DATA];
	} else {
		[queueLock unlockWithCondition:HAS_DATA];
	}
	
	return event;
}


--Game Loop--
    
-(void)playGame:(id)anObject {
    General/NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];
	General/NSDate *frameStart;
	General/NSDate *frameEnd;
	
	[self loadGame]; // Load resources for game

	while (gameRunning) {
		frameStart = General/[[NSDate alloc] init];
		frameEnd = General/[[NSDate alloc] initWithTimeInterval:0.016 sinceDate:frameStart];

		// Wait for events to be posted and act accordingly
		General/NSEvent *event = [input dequeueEventNoWait];
		
		if (event != nil) {
			switch ([event type]) {
				case General/NSLeftMouseDown: {
					[self openInGameMenu];
					break;
				}
			
				case General/NSKeyDown: {
					General/[NSApp terminate:nil];
					break;
				}
			
				default: {
				}
			}
		
			[event release];
			
			if (!gameRunning) {
				break;
			}
		}
		
		[self drawFrame]; // Draw single frame of animation

		General/[NSThread sleepUntilDate:frameEnd];
		[frameStart release];
		[frameEnd release];
	}

	if (frameStart != nil) {
		[frameStart release];
	}
	
	if (frameEnd != nil) {
		[frameEnd release];
	}
	
    [pool release];
	
	if (menuActive) {
		General/[NSThread detachNewThreadSelector:@selector(openMainMenu:) toTarget:self withObject:nil];
	} else {
		General/NSLog(@"Shouldn't be able to get here");
		General/[NSApp terminate:nil];
	}
}
