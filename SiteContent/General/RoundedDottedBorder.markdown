Does anyone have any idea how to make a rounded dotted border like in the empty General/TextMate project drawer?

I really have no idea where to begin.

----
Review General/NSBezierPath for drawing any path including a rounded rectangle as well as -setLineDash:count:phase:. http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSBezierPath_Class/Reference/Reference.html

Review path drawing in general at 
http://developer.apple.com/documentation/Cocoa/Conceptual/General/CocoaDrawingGuide/Paths/chapter_6_section_3.html
In particular, look at the section and example for "Line Dash Style"

This sample code includes a category on General/NSBezierPath specifically for drawing rounded rectangles:
http://developer.apple.com/samplecode/Reducer/listing21.html

----

Also see General/HowToCreateWalkingAnts