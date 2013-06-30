Ok, in my current program I had an array that is saved into the user defaults.  That works all fine and dandy while the application is running.  But when I quit and reload the application, the array defaults back to it's set values.  Here's the code that runs at start: (NOTE:  I know this isn't the best way to do it, that's why I'm asking you all.  I can't figure out the 'right' way.)

----
<code>
    
+ (void)initialize {
    int i;
    General/NSMutableDictionary *defaultValues = General/[NSMutableDictionary dictionary];
    General/NSMutableArray *theArray = General/[NSMutableArray array];
        [theArray addObject:@"This"];
        [theArray addObject:@"Is"];
        [theArray addObject:@"A Test"];
    [defaultValues setObject:General/[NSNumber numberWithBool:NO] forKey:General/ShowMainDrawer];
    [defaultValues setObject:General/[NSNumber numberWithBool:NO] forKey:General/ShowInfoDrawer];
    General/[[NSUserDefaults standardUserDefaults] setObject:General/[NSArchiver archivedDataWithRootObject:theArray] forKey:General/MyTestList];
    General/[[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
}

</code>
----

Like I said, the array works perfectly fine (saving to the defaults and calling it) while the program is running, which leads me to believe that the above is faultered.  My understanding of the above is that it should only run the first time the application is run, but by placing a General/NSLog("I'm running!"); in there, it's obvious that it runs everytime the program starts.  How can I run a check to make sure the defaults have been set and if so, add the saved arrays to the default array list (There is more code, I just posted the initialize code, which is my problem).

Any help would be great!

[EDIT:  I'm such a moron...  I don't know why I didn't think about checking to see if the file existed in the first place.  I figured it all out.  :)  Please excuse this note.]

----
Good because I do not feel like writting up the huge thing I wrote before my DNS decided it forgot how to resolve and I restarted in frustration! But I will still say that the initialize function sets up the "factory defaults" which are loaded everytime, user defaults are then loaded after them in say the awakFromNib method for example.

--General/GormanChristian