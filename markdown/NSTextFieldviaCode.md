I am trying to create a General/NSTextField in a blank General/NSView but am having trouble.  I do not want to use IB to do this.  So, this means I need to figure out the code to creating and displaying the General/NSTextField.  I have tried the following:

General/NSTextField *thetestfield;   //in header file

int x;
x = 6478;
thetextfield = General/[[NSTextField alloc] initWithFrame:General/NSMakeRect(10,10,20,80)];
[thetextfield setIntValue:x];
[theWindow display];

this does not work.  Does anyone have any suggestions?  Thanks

----

You need to add it to the window's view hierarchy in order to see it. something on the lines of     [[theWindow contentView] addSubview:thetextfield]; should be enough to get you started.