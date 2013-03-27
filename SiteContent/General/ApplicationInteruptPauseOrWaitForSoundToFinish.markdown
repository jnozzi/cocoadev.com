Hello, this is my first page I've made on this site (beside my name page General/SamM). I have run into an issue with my most recent (and only main) application. The application simply incements or decrements a count instance variable when the user presses the corisponding button. I have also added other features: apple remote support, counting down from a specified amount and counting up styles, preferences for defaults of all values and the feature I need help with an interval at which to play a selected sound (system sounds right now). 

My problem is that the sound that plays will play but if you hve the sound set to play at every count and hold the button or repeatedly press it fast some of the sounds are skipped while updating the count depending on how long the sound is.

     Here is the place where i want the sound to play and where i want the program to wait:

    
- (void)setCount:(int)newCount{
	
	if(count == newCount || newCount < 0 || ([style isEqualToString:@"Down From:"] && newCount > countDown)){
	}else{
		
		if(remainder(newCount, beepOn) == 0 && newCount != 0 && noBeep != YES){
			
[beepSound play]; //this is the sound i want the program to wait for Its just a system sound you can can see where its assigned below

		}else if(countDownSelected && newCount == 0 && noBeep != YES)
		{
			[finishedSound play];
		}else
		{
			noBeep = NO;	
		}
		count = newCount;
	}
}



Counter Files:

    
#import <Cocoa/Cocoa.h>


@interface Counter : General/NSObject {
	int count, maxCount, beepOn;
	int countDown;
	BOOL countDownSelected, countAtTop, noBeep;
	General/NSSound *finishedSound;
	General/NSSound *beepSound;
	General/NSString *style;
}
@property int count, maxCount, beepOn;
@property (copy) General/NSString *style;
@property BOOL countDownSelected;
@property (readonly) BOOL countAtTop, isResetable;
@property int countDown;
@property (copy) General/NSSound *beepSound;

-(void)resetCount;
-(void)runCount;
-(void)syncWithUserDefaults;

@end

----
    
#import "Counter.h"


@implementation Counter

@synthesize count, maxCount, beepOn, style, countDownSelected, countDown, countAtTop, beepSound;

+ (General/NSSet *)keyPathsForValuesAffectingCountAtTop {
    return General/[NSSet setWithObjects:@"count", @"countDown",@"style",
			nil];
}

+ (General/NSSet *)keyPathsForValuesAffectingIsResetable {
	return General/[NSSet setWithObjects:@"countAtTop", @"count", @"countDownSelected", nil];
}

/*+ (General/NSSet *)keyPathsForValuesAffectingCountFromSelect{
		
	return General/[NSSet setWithObjects:@"style", @"countDown", nil];
}*/


- init
{
	if (self = [super init])
	{
		General/NSUserDefaults *userDefaults = General/[NSUserDefaults standardUserDefaults];
		beepOn = [userDefaults doubleForKey:@"beepOn"];
		countDown = [userDefaults doubleForKey:@"countDown"];
		if(General/userDefaults stringForKey:@"style"] isEqualToString:@"Count Down"]){
			style = @"Down From:";
			countDownSelected = YES;
			count = countDown;
		}else{
			style = @"Up";
			countDownSelected = NO;
			count = 0;
		}
		noBeep = NO;
		//filepath is the location of the sound in the bundle
		//[[NSString *filePath = General/[[NSBundle mainBundle] pathForResource:@"Reward" ofType:@"mp3"];
		finishedSound = General/[NSSound soundNamed:@"Reward.mp3"];
		//[filePath release];
		
		[self addObserver:self 
			   forKeyPath:@"style" 
				  options:General/NSKeyValueObservingOptionNew 
				  context:NULL];
		[self addObserver:self 
			   forKeyPath:@"countDown" 
				  options:General/NSKeyValueObservingOptionNew 
				  context:NULL];
	}
	return self;	
}

- (void)setCount:(int)newCount{
	
	if(count == newCount || newCount < 0 || ([style isEqualToString:@"Down From:"] && newCount > countDown)){
	}else{
		
		if(remainder(newCount, beepOn) == 0 && newCount != 0 && noBeep != YES){
			[beepSound play];
		}else if(countDownSelected && newCount == 0 && noBeep != YES)
		{
			[finishedSound play];
		}else
		{
			noBeep = NO;	
		}
		count = newCount;
	}
}


- (void)resetCount{
	noBeep = YES;
	if(countDownSelected && self.isResetable){
		self.count = countDown;
	}else {
		self.count = 0;
	}
}

- (void)observeValueForKeyPath:(General/NSString *)keyPath
					  ofObject:(id)object
                        change:(General/NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"style"]) {
		if(General/change objectForKey:[[NSKeyValueChangeNewKey] isEqualToString:@"Down From:"]){
			noBeep = YES;
			self.count = countDown; 
			self.countDownSelected = YES;
		}else{
			noBeep = YES;
			self.count = 0;
			self.countDownSelected = NO;
		}
    }else if([keyPath isEqualToString:@"countDown"]){
		self.count = countDown;
	}else{
		
		[super observeValueForKeyPath:keyPath
							 ofObject:object
							   change:change
							  context:context];
	}
}

- (BOOL)countAtTop{
	if(countDownSelected && count==countDown){
		return YES;
	}else{
		return NO;
	}
}

- (void)runCount{
	(countDownSelected) ? self.count-- : self.count++;
}

- (BOOL)isResetable{
	return (self.countAtTop || (!countDownSelected && count ==0))? NO:YES;
}

- (void)syncWithUserDefaults{
	General/NSUserDefaults *userDefaults = General/[NSUserDefaults standardUserDefaults];
	self.beepOn = [userDefaults doubleForKey:@"beepOn"];
	self.countDown = [userDefaults doubleForKey:@"countDown"];
	if(General/userDefaults stringForKey:@"style"] isEqualToString:@"Count Down"]){
		self.style = @"Down From:";
	}else{
		self.style = @"Up";
	}
}

@end



----


Counter Controller Files:

    
#import <Cocoa/Cocoa.h>
#import "Counter.h"
#import "[[AppleRemote.h"
#import "General/RemoteControl.h"
#import "General/MaxCountTransformer.h"
#import "General/ZeroTransformer.h"



@interface General/CounterController : General/NSObject {
	General/IBOutlet General/NSButton *addButton;
	General/IBOutlet General/NSButton *subtractButton;
	Counter *counter;
	General/RemoteControl *remoteControl;
	General/NSArray *systemSoundNames;
	General/NSString *_selectedBeepSound;
	General/NSWindowController *_preferencesPanelController;
}

@property(copy) General/NSArray *systemSoundNames;
@property(copy) General/NSString *selectedBeepSound;

- (General/IBAction)addToCounter:(id)sender;
- (General/IBAction)subtractFromCounter:(id)sender;
- (General/IBAction)showPreferencesPanel:(id)sender;

@end

----
    
#import "General/CounterController.h"

static General/NSString *General/CounterAppBeepOnPreferenceKey = @"beepOn";
static General/NSString *General/CounterAppStylePreferenceKey = @"style";
static General/NSString *General/CounterAppCountDownPreferenceKey = @"countDown";
static General/NSString *General/CounterAppBeepSoundPreferenceKey = @"beepSound";

@implementation General/CounterController

@synthesize systemSoundNames, selectedBeepSound = _selectedBeepSound;



-(void)findSystemSoundNames:(id)inObject {
	General/NSFileManager *fileManager = General/[NSFileManager defaultManager];
	General/NSMutableArray *sounds = General/[NSMutableArray array];
	General/NSArray *foundItems = [fileManager contentsOfDirectoryAtPath:@"/System/Library/Sounds" error:NULL];
	foundItems = [foundItems pathsMatchingExtensions:General/[NSArray arrayWithObjects:@"aiff", @"aif",@"mp3",nil]];
	General/NSEnumerator *soundsEnum = [foundItems objectEnumerator];
	General/NSString *currSound = nil;
	while (currSound = [soundsEnum nextObject]) {
		[sounds addObject:[currSound stringByDeletingPathExtension]];
	}
	self.systemSoundNames = General/[NSArray arrayWithArray:sounds];
}

-(void)setSelectedBeepSound:(General/NSString *)selectedSound {
	General/NSSound *newSound = General/[NSSound soundNamed:selectedSound];
	[newSound play];
	counter.beepSound = [newSound copy];
	_selectedBeepSound = [selectedSound copy];
	[newSound release];
	General/NSLog(@"selectedSound: %@   newSound: %@  counter.beepSound: %@  _selectedBeepSound: %@", selectedSound, newSound, counter.beepSound, _selectedBeepSound);
}

@end



----

This is an exceedingly bad idea. Why not use General/QTKit and a basic queue? You get full control over play stop/start, you can be notified when the "movie" (sound) stops, and there's no need whatsoever to block the whole UI to wait for a series of sounds to play.

----

I believe that simply using General/NSSound and a couple of boolean setting made it work although if you click the button multiple times (not holding it down) you only get one increment up which isn't to much of a problem for me. Im not sure about using General/QTKit im not sure i need that kind of functionality the sounds that play are the system alerts and i dont think it would be worth going through the trouble right now but when i get more time i will look more into it i does seem quite appealing to have a queue and a notification of a stop. 

Also I was wondering if there is an easy way to share (preferably on this site) an application so that i could possibly let you guys see the whole application and use it to see exactly what i am talking about? I have another app that has a small problem that would be hard to put correctly into words. Thank You once again for your help. 

----

It's clear what you're talking about, but General/NSSound was not meant to work the way you want it to. "Simply using General/NSSound and a couple of boolean setting" won't work, period. The minimum required to do what you need is General/QTKit. Simply playing a sound is EXTREMELY lightweight. It's your only choice.