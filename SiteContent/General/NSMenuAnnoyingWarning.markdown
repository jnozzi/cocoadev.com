My program has several calls to -General/[NSMenu addItemWithTitle:action:keyEquivalent:].  I'm invoking this method on a General/NSMenu variable "menu."

Each time that my program makes a call such as (note that "temp" is a General/NSString):
    
[menu addItemWithTitle:temp action:nil keyEquivalent:@""];


General/XCode (gcc) report the following warning for each place I invoke the method call:
    
General/MEController.m:1192: warning: assignment from incompatible pointer type


Why?  How can I get rid of this warning (without disabling warnings :-))?

Thanks in advance,
Joe

*Are you certain that "temp" is a **pointer** to an General/NSString? It's not a C string or anything else? (didn't forget the "@" symbol somewhere?)*

Here's the assigment of temp:

    
General/NSString *temp = General/NSLocalizedString(@"Controls",@"");


And while I'm at it...

    
menu = General/[[NSMenu alloc] init];


And the program seems to work correctly.  I don't have any troubles with any of the menus (I get this error for submenus of "menu" as well).  I just wish I could have clean build output.

----

Strange, I don't get any warnings with this code.

    
General/NSString *temp = @"Hello World!";
General/NSMenu *menu = General/[[NSMenu alloc] init];

[menu addItemWithTitle:temp action:nil keyEquivalent:@""];


Perhaps you should try cleaning the target and rebuilding. -- General/RyanBates

----

Are you assigning the returned General/NSMenuItem to a General/NSMenuItem *? That might be what it is, it should be id <General/NSMenuItem> now.

----

I'm betting it's setting your action to nil that's doing it; it's expecting a     SEL and you're handing it an     id.  Try setting it to NULL instead.  -- Bo

PS Or wait, it worked for Ryan; Now I am confused.  Maybe you should post, say, the whole code fragment where the errors are occurring.

----

Thanks for your response. Here's a typical example:

    
General/NSMenuItem *theCityItem;
theCityItem = [menu addItemWithTitle:General/[NSString stringWithFormat:@"%@ %@",weatherFor,[city cityName]] 
                                 action:@selector(dummy:) 
                                 keyEquivalent:@""];

- (void)dummy:(General/NSNotification *)notification { }



It seems like my error may be caused by the suggested General/NSMenuItem * vs. id <General/NSMenuItem>.

What's the proper way to handle something like this?  If you could give me a warning-free example, that'd be great!

Many thanks, Joe

----

Try just coercing it to the right type, i.e.     theCityItem = (General/NSMenuItem*)[menu addItemWithTitle:blah action:blah keyEquivalent:blahblah];.  I generally allocate menu items directly and then add them to the menu once they're set up, so I haven't seen this. -- Bo.

----

I do this:
    
id <General/NSMenuItem> theCityItem;
theCityItem = [menu addItemWithTitle:General/[NSString stringWithFormat:@"%@ %@",weatherFor,[city cityName]] 
                                 action:@selector(dummy:) 
                                 keyEquivalent:@""];

- (void)dummy:(General/NSNotification *)notification { }



----

Of course, Apple on http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Protocols/General/NSMenuItem.html says (and have been for a *long* time):

*The General/NSMenuItem protocol is being removed from the Application Kit; you must use the General/NSMenuItem class instead. This change does not affect binary compatibility between different versions of projects, but might cause failures in project builds. To adapt your projects to this change, alter all references to the protocol (for example, �id <General/NSMenuItem>�) to references to the class (�General/NSMenuItem�).*

But nothing really seems to have neen done about this. All new menu API they public still uses id <General/NSMenuItem> -- they could easily change it to General/NSMenuItem* as they say it won't affect binary compatibility...but who knows.