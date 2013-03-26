For some reason, my timer code doesn't seem to work; playBeat: never gets called.
<code>
timer = [[[[NSTimer]] timerWithTimeInterval:60/_bpm target:self selector:@selector(playBeat:) userInfo:nil repeats:YES] retain];
</code>

In case it matters, here is playBeat:
<code>
- (void)playBeat:([[NSTimer]] '')theTimer {
  [[NSLog]](@"playBeat: called");
}
</code>

I have searched through the [[APIs]] and Googled, but found nothing. Thanks.

----

From Apple's documentation

''In Objective-C, there are three ways to create a timer. The following two class methods automatically register the new timer with the current [[NSRunLoop]] object in the default mode ([[NSDefaultRunLoopMode]]).''

<code>
scheduledTimerWithTimeInterval:invocation:repeats:
scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:
</code>

''The following two class methods create timers that you may register at a later time by sending the message addTimer:forMode: to an [[NSRunLoop]] object.''

<code>
timerWithTimeInterval:invocation:repeats:
timerWithTimeInterval:target:selector:userInfo:repeats:
</code>

Try using <code>scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:</code>. --zootbobbalu