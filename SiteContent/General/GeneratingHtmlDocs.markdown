**Note:** The name of this page is misleading, as General/AutoDoc can generate more than just HTML. Sorry, my bad. -- General/MichaelMcCracken
----
Answering the question: * Anybody know the best way to build generated documentation automatically from Objective-C source files? *  

* Check out General/AutoDoc which can be found at stepwise, or as part of the General/MiscKit - * http://softrak.stepwise.com/display?pkg=2163&os=20

Also, check out Apple's General/OpenSource General/HeaderDoc - http://developer.apple.com/darwin/projects/headerdoc/

----

**Automatic API Documentation Generation** 

It is really easy to set up a documentation build for a PB project with either General/AutoDoc or General/HeaderDoc: 


*1. set up a new target "Documentation" (or whatever) 

*2. Create a new shell script build phase (Edit target "Documentation", click on the files & build phases tab, go to the Project->New Build Phase menu) for:
 * General/HeaderDoc: each of the two perl scripts that comprise headerdoc (headerdoc2html.pl and gatherheaderdoc.pl), with appropriate options
* General/AutoDoc: the autodoc executable, with appropriate options


And now you can build API docs automatically from within PB.

----

Also check out the article at General/MacDevCenter (http://www.macdevcenter.com/pub/a/mac/2004/08/27/cocoa.html) about free documentation tools & Xcode.

--General/TheoHultberg/Iconara