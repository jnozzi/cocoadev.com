see also General/SetADateForAnAppToExpire for application of this idea

----

My app is using preferences properly and neatly, and I want to detect the first time my app is run by checking for the existence of these preferences. I understand this is a pretty normal thing to do. I can't find a place to put the code that would detect blank preferences though... and to tell the truth, I'm not sure if I have things all sorted out at all.

In my main Controller I have the following...
    
+ (void)initialize //this overides the initialize method for this class
{
   //Create a dictionary...
      General/NSMutableDictionary *defaultValues = General/[NSMutableDictionary dictionary];
   //archive the objects to be stored as General/NSData...
      General/NSData *lastOpenedPathAsData = General/[NSArchiver archivedDataWithRootObject:General/[NSString stringWithString:@""]];
   //put the defaults in the dictionary...
      [defaultValues setObject:lastOpenedPathAsData forKey:General/PALLastOpenedPath];
   //Register the dictionary of defaults...
      General/[[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
}

And I am trying to check on the awakeFromNib (in the same controller) for existing preferences like so:
    
if ([defaults objectForKey:General/PALClientList] == nil) 
   [introWindow makeKeyAndOrderFront:self];

But my introWindow is never shown :(

I am assuming that the detection is coming too late - and that if the defaults aren't there, then they are set up as blank, and so General/PALClientList is never going to be nil.

What order are these things done in:     +(void)initialize,     -(void)init ?

Thanks for any help you can offer!

----

Yes,     initialize is always sent to the class object before the first method. It is documented in the GCC manual.

file:///Developer/Documentation/General/DeveloperTools/gcc-3.3/gcc/Executing-code-before-main.html

P.S. Please format your code and surround it with BEGIN/ENDCODE markers.

----

Perhaps an easier way would be to add this line to +initialize:

    
[defaultValues setBool: YES forKey: @"General/IsFirstRun"];


Then, when you want to show your first run window do this:

    
if( [defaults boolForKey: @"General/IsFirstRun"] == YES ) {
  [defaults setBool: NO forKey: @"General/IsFirstRun"];
  // Show window here.
}


This just checks to see if the "General/IsFirstRun" bool is YES (by default it is, so when your app is run for the first time this test will succeed). Then the "General/IsFirstRun" bool is set to NO, so that the next time your app is run, the test fails, and the window is not shown.

This way you don't have to try to run code before main or anything, which is overkill for such a simple problem.

-- General/QuentinHill


----
I generally add the following to the awakeFromNib of my application controller, this handles first run and version changes nicely...
    
General/NSUserDefaults *userDefaults = General/[NSUserDefaults standardUserDefaults];
General/NSString *version = [userDefaults stringForKey:@"version"]; //will return 'nil' if no defaults
General/NSString *appVersion = General/[[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"General/CFBundleVersion"];
if(!version) {
	General/NSLog(@"First run - configuring preferences");
}
if(!version || ![version isEqual:appVersion]) {
	General/NSLog(@"Version changed %@ -> %@", version, appVersion);
	[userDefaults setObject:appVersion forKey:@"version"];
}

-- General/RbrtPntn