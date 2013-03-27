A handy class from General/OpenSwordGroup which allows one to time animation easily.  General/OSATimers are very simple - only two methods are ever invoked.

Creating an General/OSAnimationTimer:

+(General/OSAnimationTimer*)timerWithFramerate:(double)theFramerate

General/OSAnimationTimer*animationTimer = General/[OSAnimationTimer timerWithFramerate:30];

and

-(void)sleepThreadUntilNextFrameDate

[animationTimer sleepThreadUntilNextFrameDate];

You can find it, along with example animation code, at http://opensword.dyndns.org/General/OSATObjectProject.dmg.gz .  You might also want to visit General/OpenSwordGroup's General/WikiWikiWeb at http://himitsu.dyndns.org/General/OpenSwordWiki/ .

The original author feels that no one should ever use this object in this state.

So people can learn from it at there own risk.  Useless policing is useless.

----------------------------------------------------------------

Both links don't exist anymore.