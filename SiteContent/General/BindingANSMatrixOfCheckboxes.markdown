
My script is working good if i use radiobuttons :
It's a very simple thing : a controller with an array, a General/NSObjectController in my nib with a General/NSArrayController binded to it.
Then the General/NSMatrix is set to mode radio, prototype to General/NSButtonCell of type radio. Finally, the General/NSMatrix General/SelectedIndex is binded to the General/NSArrayController's and everything is working good.

Now : 
I want check boxes to have multiple selection. I changed the mode of the General/NSMatrix to Highlight and the prototype type to Check Box.
But there is no way to Value Selection of type General/SelectedIndexes for the General/NSMatrix. How can i bind this General/NSMatrix of Check Boxes then?

UPDATE: does really nobody tried that before? Maybe i should use a General/NSTableView?