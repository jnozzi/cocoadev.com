My Situation is this:

I custom draw my tableview row background and manually return white text for the selected row.  However, if I go to drag this row (which is highlighted in white), it drags the white text.  Is there a way to make the dragged text still appear black?  Thanks!

----

Make an image of the text string in black and return it from     - (General/NSImage *)dragImageForRows:(General/NSArray *)dragRows event:(General/NSEvent *)dragEvent dragImageOffset:(General/NSPointPointer)dragImageOffset