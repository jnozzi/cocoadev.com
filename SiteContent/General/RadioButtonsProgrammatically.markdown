I am having a difficult time creating Radio Buttons programmatically.  I have created an General/NSMatrix and set its mode to General/NSRadioModeMatrix.  The cellClass is General/NSButtonCell.  Here is the code:

    
thepushbuttons = General/[[NSMatrix alloc]initWithFrame:General/NSMakeRect(25,169,269,34)
	mode:General/NSRadioModeMatrix
	cellClass:General/[NSButtonCell class]
	numberOfRows:2
	numberOfColumns:1];


This code alone will add two regular rectangle buttons.  I guess what I am looking for are examples of radio buttons created without IB.  Can anyone post an example or point me in the right direction.

Thanks

Cable

----

Not sure if I can suggest too much for you, but you might try setting something up in a new .nib in IB and then loading it manually at runtime and calling whatever methods are needed on the General/NSMatrix instance therein. Personally, if I've got to do General/AppKit stuff like this programmatically, I always try to build whatever I can in IB just so as to give myself a bit of a head start... -- General/RobRix




----

I figured it out.  Here is the code that works.  I hope this can help someone else out in the future. 

    
	General/NSButtonCell *thepushbutton; 
	thepushbutton = General/[[[NSButtonCell alloc] init] autorelease]; 
	[thepushbutton setButtonType:General/NSRadioButton]; 
	[thepushbutton setTitle:@"title"]; 

	thepushbuttons = General/[[NSMatrix alloc]initWithFrame:General/NSMakeRect(25,169,269,34)
		mode:General/NSRadioModeMatrix
		prototype:thepushbutton
		numberOfRows:2
		numberOfColumns:1]; 

	[thepushbuttons selectCellAtRow:0 column:0]; //which cell to work with
	General/thepushbuttons selectedCell] setTag:0]; //set tag if needed
	[[thepushbuttons selectedCell] setTitle:@"titleOne"]; //set title 
	[thepushbuttons selectCellAtRow:1 column:0]; //work with a different cell now
	[[thepushbuttons selectedCell] setTag:1]; // set tag if needed
	[[thepushbuttons selectedCell] setTitle:@"titleTwo"]; //set title

	[thepushbuttons sizeToFit]; //sizes the Radio Buttons such that the title's can be included 
	[self addSubview:thepushbuttons]; // add to the [[NSView provided that 'self' is an General/NSView object
 

     --Cable