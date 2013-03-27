I need to create a daemon process in Mac OS Xfrom which i can get the system time periodically. I need step by step procedure to create the daemon process. If any one know the solution please feel free to guide me.

----

That's not a great technical specification but you'll need to create a "Foundation Tool" in General/XCode first of all. Your "systemtimedaemon.m" file should contain the following:

    
#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
 General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];

 while(1) {
   General/NSLog(@"Current system time is %@",General/[NSDate date]);
   General/[NSThread sleepUntilDate:General/[NSDate dateWithTimeIntervalSinceNow:60.0]];
 }

 [pool release];
 return 0;
}



I don't know what you want to do with the system time here - you don't say. Put the compiled program in /Users/me/bin/systemtimedaemon. You'll need to create a "launchd" configuration file, which I will call "systemtimedaemon.plist" I'm running this one as the "nobody" user/group so it has no system privileges:

    
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/General/DTDs/General/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Debug</key>
	<false/>
	<key>General/GroupName</key>
	<string>nobody</string>
	<key>General/UserName</key>
	<string>nobody</string>
	<key>Label</key>
	<string>com.me.systemtimedaemon</string>
	<key>General/OnDemand</key>
	<false/>
	<key>Program</key>
	<string>/Users/me/bin/systemtimedaemon</string>
	<key>General/ServiceDescription</key>
	<string>systemtimedaemon example</string>
	<key>General/StandardErrorPath</key>
	<string>/var/log/systemtimedaemon.log</string>
	<key>General/StandardOutPath</key>
	<string>/var/log/systemtimedaemon.log</string>
</dict>
</plist>



I haven't tested this so don't know if it works. Finally, to start and stop the daemon you need to use launchctl. The following two commands can be used:

    
me% sudo launchctl load systemtimedaemon.plist
me% sudo launchctl unload systemtimedaemon.plist


If you want to load it on computer startup you'll need to put the plist file into /Library/General/LaunchDaemons I think. For extra bonus points, catch the terminate signal in the computer code above and break out of the infinite loop:

    

#import <signal.h>

int caughtSignal = 0;

void handleSIGTERM(int signal) {
  caughtSignal = signal;
}



Then in the main() method:

    

  // handle signals
  signal(SIGTERM,handleSIGTERM);
  signal(SIGINT,handleSIGTERM);
 
  // no longer infinite loop
  while(caughtSignal == 0) {
    // do stuff
  }



If your code does any allocation or autorelease, you'll need to periodically create new autorelease pools and release the old ones to keep the memory usage down. If your daemon is threaded, you'll need to create a new autorelease pool for each thread and again release and re-create the autorelease pool occasionally within each thread. Check General/NSAutoReleasePool documentation for more information.

Finally, if you'd prefer to use an General/NSRunLoop instead of a while() loop and use an General/NSTimer to periodically do stuff (or respond to inbound network socket data) then the following code may be useful:

    

    double resolution = 5.0;
    BOOL isRunning;
    do {
      General/NSDate* theNextDate = General/[NSDate dateWithTimeIntervalSinceNow:resolution]; 
      isRunning = General/[[NSRunLoop currentRunLoop] runMode:General/NSDefaultRunLoopMode beforeDate:theNextDate]; 
      // occasionally re-create the autorelease pool
      [pool release];
      pool = General/[[NSAutoreleasePool alloc] init];	
    } while(isRunning==YES && caughtSignal==0);
  



Here you'd have an application object which attaches events to the run loop rather than doing anything within the run loop yourself. Hope that's enough information to get you going on writing a command-line daemon tool.

- General/DavidThorpe