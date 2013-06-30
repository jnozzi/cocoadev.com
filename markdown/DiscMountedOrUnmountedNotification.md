Is there a way to receive a notification when a disk (specifically an ipod) is mounted or unmounted?

----

How about General/NSWorkspaceDidMountNotification

or

General/NSWorkspaceDidUnmountNotification?

There's also a willUnmount notification. Don't know if these work with iPods. They are described in the documentation for General/NSWorkspace.

----

Is there a way of detecting mounting of an Audio CD and playing it automatically?

I have a general idea of how to do it with an interface, but I'd like to make it a background app with no dock icon or window. Basically like System 7 thru OS 9 handled Audio General/CDs - once inserted, they played without any extra apps open.

----

Someone else may have a better idea, but you could try listening to the General/NSWorkspace General/NSWorkspaceDidMountNotification. I don't know how you'd determine whether the mounted device is an audio CD.

----

There is a setting in the CD/DVD system settings concerning the action to be taken when an Audio CD is inserted. The finder may send your app (once specified) an event to indicate you should play it. Perhaps a simple open AE with the volume path? I have not looked into it, so I may be way off. I would look at this first before writing code that assumes that your app is the designated player though.

*I did some tests -- no General/AppleEvents and no Finder. It seems likely that the CD/DVD settings thingy simply opens the application, which is then responsible to find out why it's been called (i.e. scan for Audio General/CDs and video General/DVDs).* -- General/EmanueleVulcano aka l0ne

----

**Check your notification center if things seem not to be working**

I am trying to use the General/NSWorkspaceDidMountNotification

and

General/NSWorkspaceDidUnmountNotification notifications to detect if a a drive has mounted so I can see if it's an iPod (the actual iPod detection code does work). Unfortunately the selector method is never called and I've tried mounting my iPod and a CD. The code I have atm is:

    
[nc addObserver:self
	selector:@selector(detectediPodNotification:)
	name:General/NSWorkspaceDidMountNotification
	object:nil];


I also have another notification that does work. Any help would be much appreciated :)

----

what is     nc? you need to get General/NSWorkspace's notification center, not the default center. From the docs:

*
All General/NSWorkspace notifications are posted to General/NSWorkspace�s own notification center, not the application�s default notification center. Access this center using General/NSWorkspace�s notificationCenter method.
*

Do you have detectediPodNotification: proprely defined? Is this properly defined in your class?

    
- (void)detectediPodNotification:(General/NSNotification *)note {

}


----

You may also wish to read General/MountedNotificationSentOnAwakeFromSleep

----

The following code will work for getting notifications about mounts.

    
- (void)awakeFromNib
	General/[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector( didMount: )
		name:General/NSWorkspaceDidMountNotification object:nil];
	General/[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector( didUnmount: )
		name:General/NSWorkspaceDidUnmountNotification object:nil];
}

- (void)didMount:(General/NSNotification *)notif
{
	General/NSLog( @"Hey someone mounted something at %@", General/notif userInfo] objectForKey:@"[[NSDevicePath"] );
}

- (void)didUnmount:(General/NSNotification *)notif
{
	General/NSLog( @"Hey someone unmounted something at %@", General/notif userInfo] objectForKey:@"[[NSDevicePath"] );
}


Unfortunately the behavior will differ due to iTunes. If iTunes isn't running and you insert a CD that (hasn't recently or ever?) been inserted you will get a notification of a mount on "/Volumes/Audio CD". But of course the default General/CDs & General/DVDs System Preference will cause iTunes to launch. iTunes will lookup the CD info, unmount the CD and remount it as the name of the album. Thereafter if you mount that CD you will still get the album name. There does appear to be a way to find out the file system ID and determine if it is an audio cd.

A more interesting question to me at the moment is if there is a programmatic way to change that system preference that launches iTunes on audio cd insertion?

----
Don't. The user has iTunes set to open **on purpose**. The quickest way to send your app to the Trash is to mess with the user's personal settings. -General/JonathanGrynspan
----
----
I think it is likely more accurate to say the user hasn't changed the default. I certainly wouldn't change it arbitrarily but I think a user might be equally annoyed with you telling them to go change a system preference so that your application can perform it's advertised functionality without being scooped by iTunes.
----
----
com.apple.digihub has a key called com.apple.digihub.cd.music.appeared but the value is numeric, and I'm not sure what it means

And if you class dump General/SystemUIServer you'll find classes dedicated to "General/DigiHub" (here's the dump)

**EDIT**: I've figured out how to change the prefs, check the General/DigiHub page for instructions (just don't change this preference without asking your user, if you do there's nothing wrong with changing it)

-General/FjolnirAsgeirsson
----

I'm sure there's a way through General/IOKit to find all the mounted General/CDs...

----

Not sure how old this is since these pages are not dated, but to help anyone else who might be looking at this page. You can do so using the General/DiskArbitration Framework. What follows is pretty much a boilerplate setup. You'll notice that the class is set up as a Singleton class, as that works better with the static callback functions. All initialization is still done in the -init function, and this singleton class will also function as expected if put in a NIB file.


Interface file:
    

#import <Cocoa/Cocoa.h>
#import <General/DiskArbitration/General/DiskArbitration.h>

@interface General/IKMediaController : General/NSObject {
	General/DASessionRef		_session;
	General/DADiskRef		_diskRef;
}

+(General/IKMediaController*)sharedInstance;

@end



Implementation File:
    

#import "General/IKMediaController.h"
#import <General/DiskArbitration/General/DiskArbitration.h>

@interface General/IKMediaController (Private)
-(void)mountVolume:(General/NSString*)deviceName;
-(void)unmountVolume:(General/NSString*)deviceName;
@end

#pragma mark General/DiskArbitration callback functions

static void diskAppearedCallback(General/DADiskRef disk, void * context);
static void diskDisppearedCallback(General/DADiskRef disk, void * context);
static void unmountCallback(General/DADiskRef disk, General/DADissenterRef dissenter, void * context);
static void ejectCallback(General/DADiskRef disk, General/DADissenterRef dissenter, void * context);

static void diskAppearedCallback(General/DADiskRef disk, void * context)
{
	General/[[IKMediaController sharedInstance] mountVolume:General/[NSString stringWithCString:General/DADiskGetBSDName(disk) encoding:General/NSASCIIStringEncoding]];
}

static void diskDisappearedCallback(General/DADiskRef disk, void * context)
{
	General/[[IKMediaController sharedInstance] unmountVolume:General/[NSString stringWithCString:General/DADiskGetBSDName(disk) encoding:General/NSASCIIStringEncoding]];
}

static void unmountCallback(General/DADiskRef disk, General/DADissenterRef dissenter, void * context)
{
	@try {
		if(NULL != dissenter) {
			General/DAReturn status = General/DADissenterGetStatus(dissenter);
			if(unix_err(status)) {
				int code = err_get_code(status);
				@throw General/[NSException exceptionWithName:@"General/IOException"
											   reason:@"Unable to unmount the disc." 
											 userInfo:General/[NSDictionary dictionaryWithObjects:General/[NSArray arrayWithObjects:General/[NSNumber numberWithInt:code], General/[NSString stringWithCString:strerror(code) encoding:General/NSASCIIStringEncoding], nil] forKeys:General/[NSArray arrayWithObjects:@"errorCode", @"errorString", nil]]];
			}
			else {
				@throw General/[NSException exceptionWithName:@"General/IOException"
											   reason:@"Unable to unmount the disc." 
											 userInfo:General/[NSDictionary dictionaryWithObject:General/[NSNumber numberWithInt:status] forKey:@"errorCode"]];
			}
		}
		
		// Only try to eject the disc if it was already successfully unmounted
		General/DADiskEject(disk, kDADiskEjectOptionDefault, ejectCallback, context);
	}
	
	@catch(General/NSException *exception) {
		General/NSAlert *alert = General/[[[NSAlert alloc] init] autorelease];
		[alert addButtonWithTitle:(@"OK", @"General", @"")];
		[alert setMessageText:General/[NSString stringWithFormat:@"An error occurred on device %s.", General/DADiskGetBSDName(disk)]];
		[alert setInformativeText:[exception reason]];
		[alert setAlertStyle:General/NSWarningAlertStyle];		
		[alert runModal];
	}
}

static void ejectCallback(General/DADiskRef disk, General/DADissenterRef dissenter, void * context)
{
	@try {
		if(NULL != dissenter) {
			General/DAReturn status = General/DADissenterGetStatus(dissenter);
			if(unix_err(status)) {
				int code = err_get_code(status);
				@throw General/[NSException exceptionWithName:@"General/IOException"
											   reason:@"Unable to eject the disc." 
											 userInfo:General/[NSDictionary dictionaryWithObjects:General/[NSArray arrayWithObjects:General/[NSNumber numberWithInt:code], General/[NSString stringWithCString:strerror(code) encoding:General/NSASCIIStringEncoding], nil] forKeys:General/[NSArray arrayWithObjects:@"errorCode", @"errorString", nil]]];
			}
			else {
				@throw General/[NSException exceptionWithName:@"General/IOException"
											   reason:@"Unable to eject the disc." 
											 userInfo:General/[NSDictionary dictionaryWithObject:General/[NSNumber numberWithInt:status] forKey:@"errorCode"]];
			}
		}
	}
	
	@catch(General/NSException *exception) {
		General/NSAlert *alert = General/[[[NSAlert alloc] init] autorelease];
		[alert addButtonWithTitle:@"OK"];
		[alert setMessageText:General/[NSString stringWithFormat:@"An error occurred on device %s.", General/DADiskGetBSDName(disk)]];
		[alert setInformativeText:[exception reason]];
		[alert setAlertStyle:General/NSWarningAlertStyle];		
		[alert runModal];
	}
}



@implementation General/IKMediaController

/*****************************************************\
 Singleton init methods ****************************|
\*****************************************************/

static General/IKMediaController *_sharedInstance = nil;

+(General/IKMediaController*)sharedInstance 
{
	@synchronized(self) {
		if(_sharedInstance == nil) {
			General/self alloc] init];
		}
	}
	return _sharedInstance;
}

-(id)init 
{
	Class thisClass = [self class];
	@synchronized(thisClass) {
		if(_sharedInstance == nil) {
			if(self = [super init]) {
				_sharedInstance = self;
				
				[[NSDictionary *match = General/[NSDictionary dictionaryWithObjects:General/[NSArray arrayWithObjects:@"General/IOCDMedia", General/[NSNumber numberWithBool:YES], nil] 
																  forKeys:General/[NSArray arrayWithObjects:(General/NSString *)kDADiskDescriptionMediaKindKey, kDADiskDescriptionMediaWholeKey, nil]];
				
				_session = General/DASessionCreate(kCFAllocatorDefault);
				General/DASessionScheduleWithRunLoop(_session, General/CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
				General/DARegisterDiskAppearedCallback(_session, (General/CFDictionaryRef)match, diskAppearedCallback, NULL);
				General/DARegisterDiskDisappearedCallback(_session, (General/CFDictionaryRef)match, diskDisappearedCallback, NULL);	
			}
		}
	}
	return _sharedInstance;
}

+(id)allocWithZone:(General/NSZone*)zone 
{
	@synchronized(self) {
		if(_sharedInstance == nil) {
			return [super allocWithZone:zone];
		}
	}
	return _sharedInstance;
}

- (id)copyWithZone:(General/NSZone *)zone { return self; }

- (id)retain { return self; }

- (unsigned)retainCount { return UINT_MAX; }

- (void)release {}

- (id)autorelease { return self; }

-(void)dealloc
{
	General/DAUnregisterCallback(_session, diskAppearedCallback, NULL);
	General/DAUnregisterCallback(_session, diskDisappearedCallback, NULL);
	General/DASessionUnscheduleFromRunLoop(_session, General/CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	General/CFRelease(_session);
	
	[super dealloc];
}



-(void)mountVolume:(General/NSString*)deviceName
{
	General/[NSThread detachNewThreadSelector:@selector(initMountedDisc) toTarget:self withObject:nil];
}

-(void)initMountedDisc
{
	General/NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];

       /* Right here goes the code for when your disc is mounted */

	[pool drain];
}

-(void)unmountVolume:(General/NSString*)deviceName
{
       /* Here goes the code to perform any cleanup when the disc is ejected */
}




-bryscomat

----
Is there a way to use the code posted above to get callbacks for USB mass storage devices, and things like iPhones?