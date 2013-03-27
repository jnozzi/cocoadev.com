Here's a brief list of possible bugs:


*Forgetting to removeObserver from the General/NSNotificationCenter and then releasing that object that needs removed first. The only hint that you get from PB's debugger is the line "_CFNotificationCenterPostLocalNotification" on a SIG abort. 


*I think this would be better off filed on General/SignalsSentOnCrash, assuming you do mean this error message occurs on SIGABRT. If no objections come along, I or someone else will/should move it.*

That isn't a bad idea, but General/SignalsSentOnCrash is a clean list that only describes what the signals are and a very general description of the cause. I have also noticed that this particular bug source can cause a SIGBUS or a SIGABRT. I just thought that it might be nice to share possible bug sources that are hard to catch but easy to create. I also thought that it might be nice to point out the smoking gun in the debugging output that points toward the culprit. Maybe I could create a new page named General/PossibleSIGABRTCauses. Any votes?

*No, put it with General/SignalsSentOnCrash for now. There's not enough information to warrant a whole new page yet. Best keep it where people can find it - and looking up "SIGABRT" would lead one to General/SignalsSentOnCrash. We can always factor back out into a new page later, and create a decent organizational system then.*

----

Awhile back, General/BruceB added that using the wrong specifier for an integer variable (probably not just integers) in General/NSLog would generate a Signal 10 SIGBUS error:

General/NSLog( @"%@", i );   //  Signal 10 SIGBUS error

General/NSLog( @"%d", i );    //  correct

----

Doing tre above is the same thing as sending a message to a deallocated instance of a class, and not relly a case of "wrong specifer". When General/NSLog sees %@, it expects the variable to be a pointer to a calls, which it can send a -description message to. So in this case, it interprets i as a pointer address, and sending a message to an arbitrary memory location, is always a crash. --General/EnglaBenny

The original error stemmed from some overzealous copy and pasting.  The correction is obvious once identified, but buried
in the middle of a number of General/NSLog statements, it was difficult to see.  Using %@ as a descriptor will be new for many of us coming from the C/C++ world.

Does anyone have a list of the SIGXXX error numbers?  *look in /usr/include/sys/signal.h*