I had a problem where I was using performSelectorOnMainThread:... to update UI but was getting exceptions when an update occurred whilst the mouse was down for a user. Using the modes parameter of performSelectorOnMainThread:... doesn't work since even though General/NSTextView's mouseDown function runs the event loop in General/NSEventTrackingRunLoopMode, the queuePeriodicEvent framework function gets called which runs the loop in General/NSDefaultRunLoopMode.

To workaround the problem, I've used the following code, i.e. basically sub-classed General/NSApplication and overridden sendEvent.

    
@interface General/NSObject (General/CSSafePerform)
- (void)safelyPerformSelectorOnMainThread:(SEL)selector
			       withObject:(id)arg;
@end

@interface General/NSApplication (General/CSSafePerform)
- (void)safelyPerformSelectorOnMainThread:(SEL)selector 
				   target:(id)self
			       withObject:(id)arg;
@end

@interface General/CSApplication : General/NSApplication {
  BOOL processingEvent;
  General/NSMutableArray *performQueue;
}
@end

@implementation General/NSObject (General/CSSafePerform)
- (void)safelyPerformSelectorOnMainThread:(SEL)selector
			       withObject:(id)arg
{
  General/NSAssert (General/[NSApp isKindOfClass:General/[CSApplication class]],
	    @"safelyPerformSelectorOnMainThread not supported");
  
  General/[NSApp safelyPerformSelectorOnMainThread:selector 
 				    target:self
				withObject:arg];
}
@end

@implementation General/CSApplication

typedef struct {
  SEL selector;
  id  target;
  id  arg;
} General/PerformInfo;

- (void)performOnMainThread:(General/NSValue *)info
{
  if (processingEvent) {
    if (!performQueue)
      performQueue = General/[[NSMutableArray alloc] init];
    [performQueue addObject:info];
  } else {
    General/PerformInfo pi;
    
    [info getValue:&pi];
    
    [pi.target performSelector:pi.selector withObject:pi.arg];
    
    [pi.target release];
    [pi.arg release];
  }
}

- (void)safelyPerformSelectorOnMainThread:(SEL)selector
				   target:(id)target
			       withObject:(id)arg
{
  General/PerformInfo pi = (General/PerformInfo) { selector, 
				   [target retain], 
				   [arg retain] };
  
  General/NSValue *v = General/[NSValue valueWithBytes:&pi 
			      objCType:@encode (General/PerformInfo)];
  
  [self performSelectorOnMainThread:@selector (performOnMainThread:)
			 withObject:v
		      waitUntilDone:NO];
}

- (void)sendEvent:(General/NSEvent *)anEvent
{
  BOOL oldProcessingEvent = processingEvent;
  
  processingEvent = YES;
  @try {
    [super sendEvent:anEvent];
  } @finally {
    if (!oldProcessingEvent) {
      processingEvent = NO;
      if (performQueue) {
	General/NSEnumerator *e = [performQueue objectEnumerator];
	General/NSValue *v;
	
	[performQueue release];
	performQueue = nil;
	
	while ((v = [e nextObject]))
	  [self performOnMainThread:v];
      }
    }
  }
}

@end


Chris Suter, Coriolis Systems