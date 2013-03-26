

From http://ellkro.jot.com/[[WikiHome]]/iPhoneDevDocs/[[UIPushButton]]

<code>
//Button images - in application bundle.  These are from the clock app
[[UIImage]]'' btnImage = [[[UIImage]] imageNamed:@"button_green.png"];
[[UIImage]]'' btnImagePressed = [[[UIImage]] imageNamed:@"button_green_pressed.png"];

[[UIPushButton]]'' pushButton = [[[[UIPushButton]] alloc] initWithTitle:@"My Button!" autosizesToFit:NO];
[pushButton setFrame: [[CGRectMake]](100.0, 130.0, 100.0, 50.0)];
[pushButton setDrawsShadow: YES];
[pushButton setEnabled:YES];  //may not be needed
[pushButton setStretchBackground:YES];

[pushButton setBackground:btnImage forState:0];  //up state
[pushButton setBackground:btnImagePressed forState:1]; //down state
</code>