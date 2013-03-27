General/AspectCocoaDocumentation - Documentation for General/AspectCocoa

Creating an Apsect consists of three pieces: an General/AdviceObject, a General/PointCut, and the Aspect(General/ACAspect) itself

From the viewpoint of an Aspect, a running program is simply a sequence of method calls on classes.  An Aspect combines a General/PointCut (which defines some subset of all method calls on all classes) with an General/AdviceObject (which defines some functionality to be performed before, after, or in place of an intercepted method call).

General/AspectCocoa classes: [Topic]

That's it!  Everything you need to know about General/AspectCocoa... now go make something cool

----

for an example of hands on code for creating General/AspectAdvice, General/PointCuts, and loading an General/ACAspect see General/InvarianceCheckingWithAspectCocoa