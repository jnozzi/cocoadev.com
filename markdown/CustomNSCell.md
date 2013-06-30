Hi,

I am trying to design a custom General/NSCell that has two fields on top of each other. How do I do this

Thanks

----

Your best bet is to use an General/NSMatrix and go from there. --zootbobbalu

If you mean two subclasses of General/NSCell (such as General/NSTextFieldCell or General/NSButtonCell), try setting your custom class to retain two General/NSCell<nowiki/>s as instance variables, then make sure you draw them both each time a draw function is called. -- General/JediKnil

----

I like these examples http://www.stepwise.com/Articles/Technical/General/NSCell.html

There are lots of examples of custom cells available via a google search. http://www.google.com/search?hl=en&as_qdr=all&q=custom+General/NSCell&spell=1 **This google link is less than useless**
Apples documentation: http://developer.apple.com/documentation/Cocoa/Conceptual/General/ControlCell/Tasks/General/SubclassingNSCell.html

Apple includes some custom cells in various examples already on your hard disk.

Apple provides samples: http://developer.apple.com/samplecode/Clock_Control/Clock_Control.html


There are lots of discussions of custom cells in http://www.cocoabuilder.com/archive/