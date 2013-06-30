

We have seen examples of Core Animation based software that does nice animation with hundreds of General/NSViews.
It would seem like using General/NSViews is not considered that expensive anymore.

Should we start to abandon the use of General/NSCell subclasses or custom General/NSObject derived representation classes that we now use to do custom drawing in our custom views?  I'm talking about a case where the custom view draws arbitrary number of objects at arbitrary locations.

If so, we could just represent all things with General/NSView subclasses and get the possibility to do nice animations for "free".

----

The real answer to this is still under NDA, I'm afraid.

----

You're probably never going to be in a position where it makes sense to represent each cell in an General/NSTableView with an General/NSCell. You can have dozens of columns and hundreds of thousands of rows. The current architecture makes it fast, and "hundreds of General/NSViews" is not enough, not by several orders of magnitude.

In any case, this has nothing to do with General/CoreAnimation. Obviously the General/NSView machinery has become faster than it was in 1993 simply by virtue of hardware improvements, and we can handle a lot more of them than we did, but General/NSCell still makes sense in situations like General/NSTableView.

----

Ouch. It kinda sucks being a paying select ADC member and not being able to access all the latest information. Documentation for the latest pre-release build is quite lacking.

----

I think it has a lot to do with General/CoreAnimation.  If General/CoreAnimation only animates General/NSView objects, then it becomes tempting to consider switching from the other mechanisms to using General/NSViews. That is, at least for some cases - maybe General/NSTableView isn't one of them.

----
The question may be prompted by General/CoreAnimation, but the answer is unrelated. The simple answer to the question in the page's title is "no". Whether General/NSCell is obsolete or not, General/CoreAnimation is not what did it.

----

I don't know where the OP is seeing hundreds of General/NSView's in an animation... hundreds of layers perhaps?