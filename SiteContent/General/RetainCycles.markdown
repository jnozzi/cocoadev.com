

General/RetainCycles can occur when you are attempting to make sure your code employs proper General/ThreadSafety. Basically, what happens is that the first object retains the second object, and the second object retains the first object. So, neither will ever be released, which causes General/MemoryLeaks.

In order to avoid General/RetainCycles, you can General/AutoRelease objects, or you can employ the concept of General/WeakReferences.

In case you're not sure just what exactly retaining is, we have information about General/RetainingAndReleasing and the General/RetainCount for you. If you're wondering exactly what a retain cycle is, see General/DirectedCycle.