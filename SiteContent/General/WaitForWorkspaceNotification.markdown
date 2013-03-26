Hi. I am trying to create a foundation tool that records workspace notifications (using [[NSLog]]()).

I am registering for notifications using:

[[NSNotificationCenter]] ''center = [[[[NSWorkspace]] sharedWorkspace] notificationCenter]; 
[center addObserver:self selector: @selector(update:) name:nil object:nil];

This all works fine when the application stays alive (i.e. if I had a full blown [[NSApplication]] etc...). However, I am currently usure how to keep my "foundation tool" alive. I have looked into threads, run loops etc... but no topics seem to directly or indirectly apply. 

Any help would be gratefully appreciated.

----

<code>
#import <Foundation/Foundation.h>

@interface [[MainObject]] : [[NSObject]] {

}
@end

@implementation [[MainObject]]
- (void)globalNotification:([[NSNotification]] '')note {

	id object = [note object];	
	[[NSString]] ''date = [[[[NSCalendarDate]] date] descriptionWithCalendarFormat:@"%A %B %d, %Y %i:%M:%S.%F %p"];
	[[NSString]] ''log = [[[NSString]] stringWithFormat:@"\
<<<<<<<<<<  %@  >>>>>>>>>>\n\
Time: %f\n\
Notification: %@\n\
Object Class: %@\n\
Object: %@\n\
User Info: %@\n",
			date, 
			[[CFAbsoluteTimeGetCurrent]](),
			[note name],
			[[NSStringFromClass]]([object class]),
			object,
			[note userInfo]];
			
	printf([log UTF8String]);
}

- (void)start:([[NSPort]] '')port {
	static BOOL didRegister = NO;
	if (!didRegister) {
		[[[[NSDistributedNotificationCenter]] defaultCenter] addObserver:self
															selector:@selector(globalNotification:)
																name:nil
															  object:nil];
		didRegister = YES;
	}
	[[NSLog]](@"<%p>%s: port: %@", self, __PRETTY_FUNCTION__, [port description]);
}
@end

int main(int argc, char ''argv[]) {
	[[NSAutoreleasePool]] ''pool = [[[[NSAutoreleasePool]] alloc] init];
	[[NSRunLoop]] ''loop = [[[NSRunLoop]] currentRunLoop];
	[[MainObject]] ''mainObject = [[[[MainObject]] alloc] init];
	[[NSPort]] ''port = [[[NSPort]] port];
	[loop addPort:port forMode:[[NSDefaultRunLoopMode]]];
	[loop configureAsServer];
	[loop performSelector:@selector(start:) 
				   target:mainObject 
				 argument:port 
					order:nil 
					modes:[[[NSArray]] arrayWithObject:[[NSDefaultRunLoopMode]]]];
	[loop run];
	[pool release];
	[mainObject release];
	return 0;
}
</code>

--zootbobbalu

----

Thank you very much. My understanding of such matters is currently "very low" so please bare with me! 

I am particularly interested in application opening and closing notices from the [[NSWorkspace]] notification center. However, when I replace [[[[NSDistributedNotificationCenter]] defaultCenter] addObserver... code with: <code>[[[[[NSWorkspace]] sharedWorkspace] notificationCenter] addObserver:self selector:@selector(globalNotification:) name:nil object:nil];</code>I receive no notifications. If I leave the code alone, I receive notifications but not the ones I am interested in.

Thanks for any further help!

----

The code above was just a starting point. If [[NSWorkspace]]'s notification center provides you with the info you need then use that instead of DNC.

--zootbobbalu

----

Yes. The problem is that I cannot recieve notifications from the [[NSWorkspace]] notification center. I have included the [[AppKit]] framework and called [[NSApplicationLoad]](), so [[[NSWorkspace]] sharedWorkspace] is available (I can see a list of running apps using one of its methods), however no notifications are being received. I am truly at a loss why this is the case. Could it be because I am not calling [[NSApplicationMain]]()? If so, I cannot see a way round the problem. Thanks again.

----

Try using <code>[[[NSApp]] run]</code> rather than <code>[loop run]</code>.

----

Thanks! I shall go and learn something about run loops I think.

----

It's not clear to me why you invoked "configureAsServer". According to the [[NSRunLoop]] docs, "On Mac OS X, this method does nothing."