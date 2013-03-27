**General/AspectCocoaExamples** - part of General/AspectCocoa

A place for examples of what we intend for Aspects to be able to accomplish, and examples of what we'd like to be able to have Aspects accomplish.

----
**Exploring General/NSTextView**

Suppose we have an General/NSTextView and we want it to update some other control every time someone clicks into it.  Well, we could look at http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSTextView.html  But, what if we could just write a couple of lines of code that meant that whenever any method gets called on General/NSTextView or its superclasses, we General/NSLog some information about that method call.  Now we can run an application, click in the box and see which methods got called.  So now we can subclass General/NSTextView and we know just what method to override.

----
you may also be interested in General/ACLoggingAdvice, General/InvarianceCheckingWithAspectCocoa, or General/AspectCocoaDocumentation