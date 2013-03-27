Hi,

maybe I am using General/NSBeginAlertSheet improperly, but it strikes me as very irritating to use in certain situations.

For example, I am using it to as a question of the user on General/ApplicationShouldTerminate... the outcome of which will determine whether that method returns NO (don't terminate) or YES (terminate).

In most languages you can do something like this:

    
- (int)applicationShouldTerminate...
{
return (Alert("Do you want to terminate the app"));
}


Whereas with General/NSBeginAlertSheet, I have to specify a selector for the outcome to be evaluated in... so instead I have another method just to evaluate the outcome of the General/NSAlertSheet, and it gets really confusing especially in this situation because you can have an infinite loop very easily...

1 General/ApplicationShouldTerminate called

2 Sheet Asks 'Are you sure'

3 User clicks yes

4 Sheet method reads the outcome of the sheet

5 User clicked yes so General/[NSApp terminate];

6 GOTO 1;

There must be a more efficient way to do this... am I using General/NSBeginAlertSheet where I am not supposed to perhaps, is there a different class to use?

----

I take some of this back after discovering General/NSTerminateLater and replyToApplicationShouldTerminate... but it still makes for a lot more code than in other languages (I've heard Obj-C and Cocoa were a little verbose, but this just seems irritating).

----

In most other languages/environments, this type of thing is application modal. Sheets aren't. You could always use modal panels. I personally perfer the flexibility using sheets provides.