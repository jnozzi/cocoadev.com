I have a serious problem with General/NSTimer. I noticed when I have General/NSTimer running, and it's cranking through the selector method, if I click on a menu or some other similar object in the UI, the General/NSTimer won't do anything - loop, increment, whatever.... it just stops. Of course, once the menu is no longer active (if I click off or something), then the General/NSTimer continues on its merry way. I want that General/NSTimer to keep looping and everything as it is told, whether it's key, or a menu is clicked or whatever. Barring some act of God or computer death of some sort, I want that General/NSTimer instance to keep going. How do I do that? I'm surprised I didn't notice this before, and it's not the desired behavior in this instance. -- General/JasonTerhorst

... Also, I did some further research, and noticed that Aaron Hillegass' example on General/NSTimer ("TypingTutor") exhibits this same behavior, which isn't good in that case, either. Surely there is a workaround? Should I read on General/NSThread, or is that not useful? I'm using code from Apple's General/QuartzComposerTexture example, which uses an General/NSTimer to render the view.

----


Timers fire only in certain specified runloop modes - General/NSDefaultRunLoopMode is the only one used if you're using the scheduledTimer.. method.  When a menu is down, there's a pretty good chance that the runloop is running in General/NSEventTrackingRunLoopMode.  You'll probably find the same behavior for things like dragging a slider's knob.

Solution: don't use the scheduledTimer.. methods.  Create your timer with timerWithTimeInterval.. and then use -General/[NSRunLoop addTimer:forMode:] to add it to the run loop in whatever modes you're interested in (probably default, modal and event tracking, sounds like).

----

Yeah, actually, I just found info that fixed the problem at http://hayne.net/MacDev/TestButtonDown/. This little code snippet did it:
    
 General/NSRunLoop currentRunLoop] addTimer:_renderTimer
                              forMode:NSEventTrackingRunLoopMode];


I needed the scheduledTimer in this case, since it wasn't working with the other types of methods. But, no matter, since [[NSRunLoop will take it without complaint anyway.