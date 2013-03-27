General/CocoaDiscussions - Sample code for an idle timer? 
Sample code for an idle timer? Please?

Here's what I've ot right now:
    

#include <Carbon/Carbon.h>

void General/DisplayAlert(General/CFStringRef Message)
{
	General/DialogItemIndex General/LMyDialogItemIndex;
	General/DialogItemIndex *General/LMyDialogItemIndexPointer;
	General/DialogRef General/LAlertDialogRef;
	General/DialogRef *General/LAlertDialogRefPointer;
	General/LMyDialogItemIndexPointer = &General/LMyDialogItemIndex;
	General/LAlertDialogRefPointer = &General/LAlertDialogRef;
	
	General/OSStatus		er;
		
er = General/CreateStandardAlert (1,Message,CFSTR("great!"),nil,General/LAlertDialogRefPointer);
er = General/RunStandardAlert (General/LAlertDialogRef,nil,General/LMyDialogItemIndexPointer);
}



void General/DoIdle(General/EventLoopTimerRef inTimer,  void * inUserData, General/EventLoopIdleTimerMessage inState)
{
General/DisplayAlert(CFSTR("Idling"));
}


int main(int argc, char* argv[])
{
    General/IBNibRef 		nibRef;
    General/WindowRef 		window;
    
    General/OSStatus		err;
	
	double General/PreDelay=0;
	double Interval=1;
	General/EventLoopTimerRef	General/MyIdleTimer;
	General/EventLoopIdleTimerProcPtr General/DoIdlePointer;
	General/EventLoopTimerUPP General/DoIdleUPP;
	General/EventLoopTimerRef *General/MyIdleTimerPointer;
	//
	General/DialogItemIndex General/MyDialogItemIndex;
	General/DialogItemIndex *General/MyDialogItemIndexPointer;
	//
	General/DialogRef General/AlertDialogRef;
	General/DialogRef *General/AlertDialogRefPointer;
	//
	//
	General/MyIdleTimerPointer = &General/MyIdleTimer;
	General/MyDialogItemIndexPointer = &General/MyDialogItemIndex;
	General/AlertDialogRefPointer = &General/AlertDialogRef;
	
	Interval = Interval*kEventDurationSecond;
	General/PreDelay = General/PreDelay*kEventDurationSecond;
	

    err = General/CreateNibReference(CFSTR("main"), &nibRef);
    require_noerr( err, General/CantGetNibRef );
    err = General/SetMenuBarFromNib(nibRef, CFSTR("General/MenuBar"));
    require_noerr( err, General/CantSetMenuBar );
    General/DisposeNibReference(nibRef);


General/DisplayAlert(CFSTR("Hey"));

err = General/InstallEventLoopIdleTimer (
   General/GetMainEventLoop (),
   General/PreDelay,
   Interval,
   General/NewEventLoopIdleTimerUPP( &General/DoIdle ),
   0,
   General/MyIdleTimerPointer
);

// Call the event loop
General/RunApplicationEventLoop();

General/CantCreateWindow:
General/CantSetMenuBar:
General/CantGetNibRef:
	return err;
}



But General/XCode doesn't seem to like the pointer to my Do Idle routine.

I'm realatively new to calling Tool box stuff and to C so I'm sure I'm doing something dumb, but a working example would be great.

The aim here is (of course) to detect when the user has done nothing for a certain amount of time (as in the trigger for a screen saver).

Thanks!

----

You want to use General/NewEventLoopTimerUPP. There is no General/NewEventLoopIdleTimerUPP function.

----

Well, I thought so too...BUT:

passing    <code> General/NewEventLoopTimerUPP( &General/DoIdle ), </code>  I  get: passing arg 4 of  'General/InstallEventLoopIdleTimer' from incompatible ponter type

AND Also: passing arg 1 of 'General/NewEventLoopTimerUPP' from incompatible pointer type  (a result of the &General/DoIdle somehow)

WHILE passing <code> General/NewEventLoopIdleTimerUPP( &General/DoIdle ), </code> I ONLY get: passing arg 1 of 'General/NewEventLoopIdleTimerUPP' from incompatible pointer type

In other words the compiler (General/XCode) seems to recognize it and give no warning (however it still doesn't like my pointer to the function - which I suspect is somehow the main issue here?)

I admit that too many pointers and pointers to pointers have my head swimming I can barely remember enough Pascal to deal, let alone C!

That's why it would be great to see a chunk of code that actually works! So I can see how I've screwed up.

Anyone have anything? Or know where I can find some?

----

Strange, my documentation conflicts with the header files. That's why I recommended that you use General/NewEventLoopTimerUPP(), but the header actually does have (and want) General/NewEventLoopIdleTimerUPP().

Looking at the header, your declaration for General/DoIdle() doesn't match the prototype. You need to reverse the second and third parameters.

----

Thanks! OK! Now I'm not getting any warnings! Progress! BUT:

Wouldn't one expect to see the "Idling" alert every second (provided the user isn't moving the mouse or typing)? - Well it's not happening!

I'm not sure how to even begin to figure out why.

One thing I HAVE noticed, it now doesn't care if I have the & in front of General/DoIdle or just the name General/DoIdle. It doesn't warn or crash either way.

(And I've actually seen documentation with both versions [I think] which is kind of bizarre)

So how do I figure out what this thing is actually DOING? Is the Event Loop Timer ever firing? Is General/DoIdle getting called? 

UPDATE:

I tried substituting in a normal (not idle) loop timer in place of the General/IdleTimer:

    
err = General/InstallEventLoopTimer (
   General/GetMainEventLoop (),
   General/PreDelay,
   Interval,
   General/NewEventLoopTimerUPP( &General/DoIdol ),
   0,
   General/MyIdleTimerPointer
);


(General/DoIdol is the same routine as General/DoIdle above without the General/InState parameter)

And it works! (it Alerts every second) Now WHY won't the General/EventLoopIdleTimer version work!?!?

----
PROBLEM SOLVED.
For anyone who cares, it looks like you have to pass a non-zero value to inFireDelay (2nd parameter of  General/InstallEventLoopIdleTimer) to successfully start the whole process (although the documentation claims otherwise).

It's working pretty well now.