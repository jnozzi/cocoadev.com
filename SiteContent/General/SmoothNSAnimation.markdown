Hey

I have read some of the previous articles on animation in cocoadev, but could not find a direct answer to my question. I am trying to use General/NSAnimation to simply move a General/NSWindow from off the screen to on the screen and vice versa. The window contains several views and General/NSImages. I found General/NSViewAnimation to be horrible for smoothness. I have subclassed the General/NSAnimation class an in the setCurrentProgress I move the window up based upon the progress. This is fairly smooth, but it still seems to be slightly bumpy. I have played around with the frame rate and can get it to smooth out a little more, but it is not nearly as smooth as say minimizing a window. I have also set General/NSAnimation to General/NSAnimationNonblocking (and have tried the other 2 modes). Does anyone know of a really good way to further smooth out an animation either using General/NSAnimation, or would I be better off doing something else, perhaps with a Timer. I am guessing that General/CoreAnimation would solve the issue by moving stuff to the GPU?

I am also running on a General/MacBook Pro, so I have the horsepower.

Thanks

----

General/CoreAnimation shouldn't be a big help for this.  You already don't have to redraw anything to move a window around, and the performance benefits of General/CoreAnimation come from avoiding redraw.  

Post your General/NSViewAnimation code, perhaps?  There's no good reason why this should be slow.

Also, if your case is so simple, you might be able to use -General/[NSWindow setFrame:display:animate:].  Pass NO for display.  This shouldn't be any more performant than General/NSViewAnimation, but it's a bit less code.


----

Thanks for the help. I actually found setting animate:NO did very good for the performance. This seems to have solved my issue for now and made things better. Thought I still need the display:YES for it to work correctly. Unfortunately, at this time I do not have access to the code (its at home), but it was bassically in the setCurrentProgress just altering the windows position by some amount * progress. Oh well, the animate:NO seems to work for now.

Sorry for troubling you.
Thanks