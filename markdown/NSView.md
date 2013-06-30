General/NSView inherits from: General/NSResponder : General/NSObject

Base class representing an area within a window that can draw its own contents and (due to abilities inherited from General/NSResponder) can handle events such as keys and clicks.

You can subclass General/NSView to create your own views and even make an General/IBPalette of them for use in General/InterfaceBuilder.

See if you can reproduce (or even explain) some of the General/OddViewBehavior that has been observed by unfortunate developers.

----

Redrawing a view. I spent a whole day invoking various redrawing methods on my General/NSTextField only to realize that the window has to be set to buffered in IB otherwise setNeedsDisplay doesn't work... It says Description Forthcoming

----

Documentation:

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSView_Class/index.html#//apple_ref/doc/uid/TP40004149

----

A collection of questions and answers about General/NSView can be found at General/NSViewQuestions

----

Guidelines for setting up the key view loop can be found at General/KeyViewLoopGuidelines