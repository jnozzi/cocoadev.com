Having declared lightTimer in my header:

<code>
- (void)awakeFromNib
{
[[NSNOtificationCenter]] ''nc = [[[NSNotificationCenter]] defaultCenter];
[nc addObserver:self selector:@selector(timerStart) name:@"[[TimerFire]]" object:nil];
}

- (void)timerStart
{
double p = 1;
lightTimer = [[[[NSTimer]] scheduledTimerWithTimeInterval:(p) target:self selector:@selector(lightTimer) userInfo:nil repeats:YES] retain];
[lightTimer fire];
}
</code>

Now, I know I get the notification as [[NSLog]] previously indicated it, and I know my timer is getting set up and the [lightTimer fire]; is firing it, but it is not repeating. When I put a [self timerStart]; in the awakeFromNib the timer runs properly. Is there something I am doing wrong or is there a bug where this code will not run when called from a notification? (Yes lightTimer exists).

----

Hmmm... The first [[NSTimer]] implementation I made worked correctly and looked like this :

<code>

temps = [[[NSTimer]] scheduledTimerWithTimeInterval:1.000000
                             target:self
                             selector:@selector(avTemps:)
                             userInfo:nil
                             repeats:YES ];

</code>

Then, there's the avTemps method which contains whatever I want and invalidate the [[NSTimer]] after a condition is reached.
In Apple's reference docs, it says the selector should be the variable that represents the timer itself, in your case, lightTimer.
However, my piece of code works perfectly and I didn't follow that rule...