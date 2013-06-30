
I was working on a program like Pixen, but just to find the mouse's X and Y. I wrote this code to detect mouse motion:
    

#import <Cocoa/Cocoa.h>


@interface General/MouseMovement : General/NSObject {
	General/NSPoint oldPos;
	General/NSThread *sensorThread;
	SEL targetCallSelector;
	id target;
}

- (id)initWithTarget: (id)tgtObj selector: (SEL)tgtSel;
- (id)target;
- (void)setTarget: (id)newTgt;
- (void)beginScanning;
- (void)stopScanning;
@end

@interface General/MouseMovement()
- (void)mouseSensing: (id)param;
@end


@implementation General/MouseMovement

- (id)init
{
	[self initWithTarget: nil selector: General/NSSelectorFromString(@"")];
	return self;
}

- (id)initWithTarget: (id)tgtObj selector: (SEL)tgtSel
{
	[super init];
	target = tgtObj;
	targetCallSelector = tgtSel;
	sensorThread = General/[[NSThread alloc] initWithTarget: self selector: @selector(mouseSensing:) object: nil];
	return self;
}

- (void)dealloc
{
	[sensorThread cancel];
	[sensorThread release];
	[super dealloc];
}

#pragma mark System Methods

- (id)target
{
	return target;
}

- (void)setTarget: (id)newTgt
{
	target = newTgt;
}

- (void)beginScanning
{
	[sensorThread start];
}

- (void)stopScanning;
{
	[sensorThread cancel];
	[sensorThread release];
	sensorThread = General/[[NSThread alloc] initWithTarget: self selector: @selector(mouseSensing:) object: nil];
}

- (void)mouseSensing: (id)param
{
	General/NSAutoreleasePool *threadPool = General/[[NSAutoreleasePool alloc] init];
	oldPos = General/[NSEvent mouseLocation];
	while(![sensorThread isCancelled]) {
		General/NSPoint mousePos = General/[NSEvent mouseLocation];
		if((mousePos.x != oldPos.x) || (mousePos.y != oldPos.y)) { // If mouse moved
			// Post selector
			[target performSelector: targetCallSelector];
			// Finalize
			oldPos = mousePos;
		}
		[threadPool drain]; // Drain autorelease pool
	}
	[threadPool release];
}

@end
