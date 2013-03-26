

Part of the iPhone [[UIKit]] framework. Subclass of [[UIView]].

This is that handy navigation header that goes on the top of views that can be.. navigated.

Button Styles: 0 = Normal, 1 = Red, 2 = Back Arrow, 3 = Blue

<code>
- (void)navigationBar:([[UINavigationBar]]'')navbar buttonClicked:(int)button 
{
	switch (button) 
	{
		case 0: [[NSLog]](@"left"); break;
		case 1:	[[NSLog]](@"right"); break;
	}
}

- (void)applicationDidFinishLaunching:(id)unused
{
	window = [[[[UIWindow]] alloc] initWithContentRect:[[[UIHardware]] fullScreenApplicationContentRect]];

	//Setup main view
	struct [[CGRect]] rect = [[[UIHardware]] fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	mainView = [[[[UIView]] alloc] initWithFrame:rect];
	[window setContentView:mainView];

	//Setup navigation var
	navBar = [[[[UINavigationBar]] alloc] initWithFrame:[[CGRectMake]](0.0f, 0.0f, 320.0f, 40.0f)];
	[navBar showButtonsWithLeftTitle:@"Left" rightTitle:@"Right" leftBack:NO];
	//you can also do something like [navBar showLeftButton:@"Left" withStyle:1 rightButton:@"right" withStyle:0]; <-- this will let you change the button color!
	[navBar setBarStyle:5]; // This sets the color and look of the navigation bar.
	[navBar setDelegate:self];

	[mainView addSubview:navBar];

	[window orderFront:self];
	[window makeKey:self];
	[window _setHidden:NO];
}
</code>

----

'''Methods'''

%%BEGINCODESTYLE%%- (id)initWithFrame:([[CGRect]])frame;%%ENDCODESTYLE%%

Designated initializer!

%%BEGINCODESTYLE%%- (void)showButtonsWithLeftTitle:([[NSString]]'')left rightTitle:([[NSString]]'')right leftBack:(BOOL)flag;%%ENDCODESTYLE%%

Sets the title of the left and right buttons, and specifies whether the left button has the "back" styling. If a title is nil, its corresponding button is not shown.

%%BEGINCODESTYLE%%- (void)setDelegate:(id)delegate;%%ENDCODESTYLE%%

Delegate receives clicks.

%%BEGINCODESTYLE%%- (void)setBarStyle:(int)style;%%ENDCODESTYLE%%

0 - Normal Style 

1 - Dark Style 

2 - Dark Style, Semi-transparent

3+ Ignored, assumed Normal Style


----

'''
[[UINavigationBar]] delegate methods
'''

%%BEGINCODESTYLE%%- (void)navigationBar:([[UINavigationBar]]'')bar buttonClicked:(int)which;%%ENDCODESTYLE%%

0 for left, 1 for right.

NOTE: my demo app is returning 1 for left, 0 for right.