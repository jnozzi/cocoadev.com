

Hello!

I�ve linked 2 to 3 instances of General/NSViewAnimation, firing them as in the official doc, I even followed the sample code in iSpend and it works for unique animations but as soon as I try to link animations, my app crashes (sigbus), but not always, even if the animation process is exactly the same and nothing else is happening in the program. Very strange! And there�s no code sample illustrating linking, except the lines in http://developer.apple.com/documentation/Cocoa/Conceptual/General/DrawViews/Tasks/General/TimingAnimations.html .

I tried to set different blocking modes etc. but with no success.

Did anyone succeeded in making this work? I�m looking for advices!

Thank you.

--Flofl.

----

I haven't used linked animations yet, but my first guess would be that an animation in your chain is being used after it's deallocated. I would assume that linking an animation does not retain it, as that could quickly lead to circular retains.

----

I don�t think so as I use an alloc-init for each animation and use all of them just after they�re created. If someone could post some tested code that would be great.

--Flofl.

If you could post *your* code, maybe we'd have a better idea of what's breaking.

----

Yes, *maybe*. Here you are.
    -(void)animateViews {

    // These are pointers declared in .h.
    // Animations are released in the delegate End method,
    // I set the pointers to nil before starting over, just in case.
    firstTwoObjectsAnimation = nil;
    thirdObjectAnim = nil;

    
    // 1st animation
    General/NSMutableDictionary * firstObjectDict = General/[NSMutableDictionary dictionaryWithObjectsAndKeys:
	firstObject,General/NSViewAnimationTargetKey,
	General/[NSValue valueWithRect:General/NSMakeRect(167,188,138,138)],General/NSViewAnimationStartFrameKey,
	General/[NSValue valueWithRect:General/NSMakeRect(167,387,138,138)],General/NSViewAnimationEndFrameKey,
	General/NSViewAnimationFadeOutEffect,General/NSViewAnimationEffectKey,nil];
  
    General/NSMutableDictionary * secondObjectDict = General/[NSMutableDictionary dictionaryWithObjectsAndKeys:
	secondObject,General/NSViewAnimationTargetKey,
	General/[NSValue valueWithRect:General/NSMakeRect(317,188,138,138)],General/NSViewAnimationStartFrameKey,
	General/[NSValue valueWithRect:General/NSMakeRect(471,387,138,138)],General/NSViewAnimationEndFrameKey,
	General/NSViewAnimationFadeOutEffect,General/NSViewAnimationEffectKey,nil];

   firstTwoObjectsAnimation = General/[[NSViewAnimation alloc] initWithViewAnimations:General/[NSArray
        arrayWithObjects:firstObjectDict, secondObjectDict, nil]];
    [firstTwoObjectsAnimation addProgressMark:0.5];
    [firstTwoObjectsAnimation setDelegate:self];
    

    // 2nd animation
    General/NSMutableDictionary * thirdObjectDict = General/[NSMutableDictionary dictionaryWithObjectsAndKeys:
	thirdObject,General/NSViewAnimationTargetKey,
	General/[NSValue valueWithRect:General/NSMakeRect(149,132,175,226)],General/NSViewAnimationStartFrameKey,
	General/NSViewAnimationFadeInEffect,General/NSViewAnimationEffectKey,nil];
    
    thirdObjectAnim = General/[[NSViewAnimation alloc] initWithViewAnimations:General/[NSArray
        arrayWithObjects:thirdObjectDict, nil]];

    [thirdObjectAnim setDelegate:self];
    
    
    // Start animations
    [thirdObjectAnim startWhenAnimation:firstTwoObjectsAnimation reachesProgress:0.5];
    
    [firstTwoObjectsAnimation startAnimation];
    
    }

- (void)animationDidStop:(General/NSAnimation*)animation {    
    [self animationDidEnd:animation];
}

- (void)animationDidEnd:(General/NSAnimation*)animation {
    [animation release];
}


Now, look at the log, if I had made a mistake, would the animations start and end 5 times but the 6th time start then cause a sigbus??

    
2005-08-12 11:22:51.646 General/NewApp[443] animateViews
2005-08-12 11:22:51.649 General/NewApp[443] animation <General/NSViewAnimation: 0x36cad0> General/ShouldStart
2005-08-12 11:22:51.925 General/NewApp[443] animation <General/NSViewAnimation: 0x36c890> General/ShouldStart
2005-08-12 11:22:52.210 General/NewApp[443] animation <General/NSViewAnimation: 0x36cad0> General/DidEnd
2005-08-12 11:22:52.455 General/NewApp[443] animation <General/NSViewAnimation: 0x36c890> General/DidEnd
2005-08-12 11:22:53.678 General/NewApp[443] animateViews
2005-08-12 11:22:53.678 General/NewApp[443] animation <General/NSViewAnimation: 0x36be60> General/ShouldStart
2005-08-12 11:22:53.948 General/NewApp[443] animation <General/NSViewAnimation: 0x3630de0> General/ShouldStart
2005-08-12 11:22:54.201 General/NewApp[443] animation <General/NSViewAnimation: 0x36be60> General/DidEnd
2005-08-12 11:22:54.467 General/NewApp[443] animation <General/NSViewAnimation: 0x3630de0> General/DidEnd
2005-08-12 11:22:55.622 General/NewApp[443] animateViews
2005-08-12 11:22:55.623 General/NewApp[443] animation <General/NSViewAnimation: 0x36be60> General/ShouldStart
2005-08-12 11:22:55.874 General/NewApp[443] animation <General/NSViewAnimation: 0x3630de0> General/ShouldStart
2005-08-12 11:22:56.138 General/NewApp[443] animation <General/NSViewAnimation: 0x36be60> General/DidEnd
2005-08-12 11:22:56.385 General/NewApp[443] animation <General/NSViewAnimation: 0x3630de0> General/DidEnd
2005-08-12 11:22:58.038 General/NewApp[443] animateViews
2005-08-12 11:22:58.038 General/NewApp[443] animation <General/NSViewAnimation: 0x3630de0> General/ShouldStart
2005-08-12 11:22:58.289 General/NewApp[443] animation <General/NSViewAnimation: 0x36be60> General/ShouldStart
2005-08-12 11:22:58.599 General/NewApp[443] animation <General/NSViewAnimation: 0x3630de0> General/DidEnd
2005-08-12 11:22:58.822 General/NewApp[443] animation <General/NSViewAnimation: 0x36be60> General/DidEnd
2005-08-12 11:22:59.814 General/NewApp[443] animateViews
2005-08-12 11:22:59.814 General/NewApp[443] animation <General/NSViewAnimation: 0x3703d0> General/ShouldStart
2005-08-12 11:23:00.066 General/NewApp[443] animation <General/NSViewAnimation: 0x36be60> General/ShouldStart
2005-08-12 11:23:00.325 General/NewApp[443] animation <General/NSViewAnimation: 0x3703d0> General/DidEnd
2005-08-12 11:23:00.569 General/NewApp[443] animation <General/NSViewAnimation: 0x36be60> General/DidEnd
2005-08-12 11:23:05.246 General/NewApp[443] animateViews
2005-08-12 11:23:05.247 General/NewApp[443] animation <General/NSViewAnimation: 0x36cad0> General/ShouldStart
2005-08-12 11:23:05.505 General/NewApp[443] animation <General/NSViewAnimation: 0x36be60> General/ShouldStart

General/NewApp has exited due to signal 10 (SIGBUS).


--Flofl

----

Are you doing any custom drawing or any custom *anything* with the views (or their subviews) that are being animated?

----

First, everything takes place in a general view that�s made the content view of the window. Then, the two views I�m trying to animate contain three text fields involving Chinese characters� But I don�t modify the objects or their content during the animation. --Flofl

----

I�m testing a new approach: at the beginning of the anim method, I test every animation, if it�s non-nil, I release and set it to nil. Maybe releasing the first animation when it reaches the didEnd state while the second one is still running causes a problem in the linked animations (but in such a case, it **should** be documented). 

But I�ve got a question: why should we always recreate the animations in the first place? I�m continuously switching from a state and another with two opposite animations, why couldn�t I init them in awakeFromNib and keep them till the app terminates?? --Flofl

*Have you tried it?*

I did it at the beginning but it crashed and will try again (only when it will work without it). It works in a sample project; in my big project I�m testing the use of performSelector:�withDelay: which  seems to solve some problems.
I can�t believe I�m the first one using it and having problems with it! Nobody here to share it�s experience, explain it�s way of implementing it??--Flofl

----

This method looks kind of risky.

    
- (void)animationDidEnd:(General/NSAnimation*)animation {
    [animation release];
}


You are releasing something based on the assumption that this method is called only once. You should do something more like this:

    
- (void)animationDidEnd:(General/NSAnimation*)animation {
    if (animation == firstTwoObjectsAnimation) {
        [firstTwoObjectsAnimation release];
        firstTwoObjectsAnimation = nil;
    } else if (animation == thirdObjectAnim) {
        [thirdObjectAnim release];
        thirdObjectAnim = nil;
    }
}


--zootbobbalu

----

Yes, you�re right, this code was from a non-linked animation code sample� Finally, I managed to make the animations once in awakeFromNib. --Flofl

----

I�ve just rewritten all my code without the animations! It was getting like in X-files: I put an General/NSLog in every single method of my code and the method that was supposed to start animation X happened to sometimes start animation X and animation Y. The General/NSLog stated no call to any method supposed to start animation Y� If anyone can explain� I�ve checked my code hundreds of times� If anybody hears about a known bug or finds similar cases of weirdness in its own app, let us know.

--Flofl.

----

Well, I think what your trouble might have been is that animations automatically retain and then release themselves upon completion.  They are oneshot, you don't reuse them, ever.

->Ben