This may be an easy question and I'm just missing the concept. What would be the best way to create a custom view ala iTunes Videos where you have your objects grouped in a matrix-esque style, almost like pagination, where they fill according to width of the pane? Delicious Library is famous for this with its cover view.

I can't seem to find a good way to implement it. I've looked into subclassing General/NSView and drawing everything myself. If I do that, I'd have to set up selection, dragging, and everything to fit the paradigm, almost like re-implementing General/NSTableView completely, but for a different design.

Is there a better way anyone else has worked out to do this? Thanks, --General/LoganCollins

----

Just a hunch, maybe a bad one, but does General/FlowLayoutView do anything like what you're interested in?

----

You want to use General/NSMatrix with your own custom General/NSImageCell that probably draws its own selection border and stuff. General/NSMatrix will handle all the dragging, selection, etc. associated with the view. For example, the thumbnail view in the media browser for iLife/iWork is an General/NSMatrix with a custom General/NSImageCell that displays an image and below it a filename.

--General/ZacWhite

----

Thanks! I'll get to looking through General/NSMatrix right away. I guess when I said a "matrix-esque style", I should have looked into General/NSMatrix a little more. --General/LoganCollins

----

Okay, I've been playing around with this all day, and I have hit a snag. I am trying to bind the General/NSMatrix to an General/NSArrayController to give it content. I have the matrix bound to the controller's content fine, but I can't seem to get selection to work right. I can't bind any of the selection bindings found in IB programmatically without the debugger throwing an exception. It almost seems like none of the selection bindings actually exist, because that's what the run log is saying. Anybody know how to bind an General/NSMatrix to an General/NSArrayController correctly? --General/LoganCollins

----

I think you can find a part of the answer here General/BindNSMatrixWithNSArrayController but I have difficulties to bind pictures.