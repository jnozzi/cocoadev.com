

Hello,

I am using the
    
General/[NSString drawAtPoint:withAttributes:] 

method to draw some text to a custom General/NSView. I want to make the font size smaller, say maybe 9 pt, rather than the default 12.0 pt.

I cannot find any good documentation on this method that shows how to do it. I think I might have to use
    
General/[NSFont fontWithName:size:]
,
 but really I'm not sure how to relate this to a dictionary - can't find any info on how dictionaries come in to play with this method.

----
In Xcode, File->Open Quickly, type     General/AppKit/General/NSAttributedString.h and read up.
----
I took a look at that file,thank you for the pointer. I did not find it too helpful, however. I will keep looking.

----

How hard did you look for doco?

http://developer.apple.com/documentation/Cocoa/Conceptual/General/AttributedStrings/Tasks/General/CreatingAttributedStrings.html

ADC Website -> Guides -> Cocoa -> Text and Fonts -> Attributed Strings Programming Guide