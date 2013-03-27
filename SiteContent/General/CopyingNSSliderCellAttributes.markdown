I want to create my own General/NSSlider and General/NSSliderCell. But when I add my own General/NSSliderCell to my General/NSSlider, the slider looks quite ugly (compared to the standard slider from General/InterfaceBuilder). OK, I could start to read out all layout attributes (like knob size, number of ticks, ...) from the original General/NSSliderCell but that is somehow inconvenient. Is there an easy way to copy attributes from a General/NSSliderCell (or a class in general)?

--General/ThomasSempf

----

General/NSCell conforms to General/NSCopying, have you tried just copying it directly? If that doesn't work, General/NSCell also conforms to General/NSCoding, so you could shove it through an archiver to get a copy.