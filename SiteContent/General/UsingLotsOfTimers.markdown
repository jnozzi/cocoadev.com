Is this going to get me into trouble?

<code>
 - (void)textDidChange:(NSNotification *)aNotification
 {
   [super textDidChange:aNotification];
   if ([completeTimer isValid])
   {
     [completeTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:.5]];
   }
   else
   {
     [completeTimer release];
     completeTimer = [[NSTimer scheduledTimerWithTimeInterval:.5
                                                       target:self
                                                     selector:@selector(complete:)
                                                     userInfo:nil
                                                      repeats:NO] retain];
   }
 }
</code>

What I'm worried about is all the timers that get inserted into the run loop.  They get invalidated, but I don't really know what that means.  Are they really gone?  Are they polluting my run loop in some way?

Thanks,
[[KenFerry]]

----

I'd still like to know about the timers, but the proper solution to my problem seems to be [[DelayedMessaging]]: http://www.mactech.com/articles/mactech/Vol.14/14.12/DelayedMessaging/.

----

Invalidating a timer is supposed to remove it from the run-loop.

----

Is it? That's what I'm not sure about.

From http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSTimer_Class/Reference/NSTimer.html :

"There is no method that removes the association of a timer from an [[NSRunLoop]], send the timer the invalidate message instead. invalidate disables the timer, so it no longer affects the [[NSRunLoop]]."

on the other hand..

<code>- (void)invalidate</code>
 
Stops the receiver from ever firing again and removes it from any run loops. This is the only way to remove a timer from an [[NSRunLoop]]."

The first sounds like it's still there, it just can't affect anything.  The second explicitly says it's gone.  Well, I guess you're probably right.

----

Yes, a better thing to do is

<code>
 [self performSelector:@selector(complete:) withObject:nil afterDelay:0.5];
</code>

so you don't have to mess around with a timer. You can get into trouble with this though if you call this too frequently -- say more frequently than 0.5 seconds. You'll end up calling your selector once for every call to performSelector:withObject:afterDelay: even if you'd rather they coalesce. So I usually do something like this:

<code>
 [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(complete:) object:nil];
 [self performSelector:@selector(complete:) withObject:nil afterDelay:0.5];
</code>

You can do the same thing with a timer:

<code>
 NSTimer *mDelayTimer;
 
 - (void)destroyDelayTimer
 {
   [mDelayTimer invalidate];
   [mDelayTimer release];
   mDelayTimer = nil;
 }
 
 - (void)textDidChange:(NSNotification *)aNotification
 {
   [super textDidChange:aNotification];
   
   [self destroyDelayTimer];
   mDelayTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5
                                                   target:self
                                                 selector:@selector(complete:)
                                                 userInfo:nil
                                                  repeats:NO] retain];
 }
 
 - (void)complete:(NSTimer *)timer
 {
   [self destroyDelayTimer];
   
   // ...
 }
 
 - (void)dealloc
 {
   [self destroyDelayTimer];
   
   [super dealloc];
 }
</code>

See? performSelector:withObject:afterDelay: is easier.

-- [[MikeTrent]]
----

But I don't get all the fuss. It's very probable that performSelector: withObject: afterDelay: itself uses a timer. And if you look at the first code snipped on this page, then if the timer hasn't fired, its reused, and delayed a little. Which IMHO is the best and most efficient solution to this problem. [[SubEthaEdit]] uses this mechanism in the delayed mode of the Live-Web-Preview and it caused no problems.

-- [[DominikWagner]]