

The [[UIButtonBar]] initializer works with a list of items (withItemList: parameter). From what I can 
see, it's an [[NSArray]] (or something to responds to objectAtIndex:) of [[NSDictionary]] (or something 
that reponds to objectForKey:)

I built collection that logs objectForKey method calls and the only key I see coming is 
@"[[UIButtonBarButtonTarget]]".

This corresponds well with some constant strings defined in [[UIKit]].framework:
[[UIButtonBarButtonTitleWidth]]
[[UIButtonBarButtonStyle]]
[[UIButtonBarButtonTarget]]
[[UIButtonBarButtonAction]]
[[UIButtonBarButtonTag]]
[[UIButtonBarButtonSelectedInfo]]
[[UIButtonBarButtonInfo]]
[[UIButtonBarButtonTitle]]
[[UIButtonBarButtonType]]

Maybe these are used in a fashion similar to [[NSAttributedString]] -- the dictionary defines the 
attributes of the button in the button bar. Oddly, there doesn't appear to a way to specify an 
instance of [[UIButtonBarButton]] or [[UIButtonBarTextButton]]. Also, how the hell do you put an 
@selector into a dictionary for [[UIButtonBarButtonAction]]?

Here is some stuff I've been trying:

[[UIButtonBarButton]] ''testButton = [[[[[UIButtonBarButton]] alloc] initWithImage:[[[UIImage]] 
imageNamed:@"arrowup.png"] selectedImage:[[[UIImage]] imageNamed:@"arrowdown.png"] 
label:@"Test" labelHeight:20.0f withBarStyle:0 withStyle:0 withOffset:[[NSMakeSize]](0.0f, 0.0f)] 
autorelease];

[[NSDictionary]] ''dictionary = [[[NSDictionary]] dictionaryWithObjectsAndKeys:
		testButton, @"[[UIButtonBarButtonTarget]]",
		nil];

[[NSArray]] ''itemList = [[[NSArray]] arrayWithObject:dictionary];

[[UIButtonBar]] ''buttonBar = [[[[[UIButtonBar]] alloc] initInView:mainView withItemList:itemList] 
autorelease];
[buttonBar setBarStyle:1];
[buttonBar setDelegate:self];

All I get is the blank button bar at the bottom of the view.

Any thoughts or help here would be most appreciated.

----

Mobile Colloquy is using [[UIButtonBar]]. See http://mcolloquy.googlecode.com/svn/trunk/[[CQChatController]].m

<code>
extern [[NSString]] ''kUIButtonBarButtonAction;
extern [[NSString]] ''kUIButtonBarButtonInfo;
extern [[NSString]] ''kUIButtonBarButtonInfoOffset;
extern [[NSString]] ''kUIButtonBarButtonSelectedInfo;
extern [[NSString]] ''kUIButtonBarButtonStyle;
extern [[NSString]] ''kUIButtonBarButtonTag;
extern [[NSString]] ''kUIButtonBarButtonTarget;
extern [[NSString]] ''kUIButtonBarButtonTitle;
extern [[NSString]] ''kUIButtonBarButtonTitleVerticalHeight;
extern [[NSString]] ''kUIButtonBarButtonTitleWidth;
extern [[NSString]] ''kUIButtonBarButtonType;

[[NSDictionary]] ''buttonItem = [[[NSDictionary]] dictionaryWithObjectsAndKeys:[[[CQConnectionsController]] defaultController], kUIButtonBarButtonTarget, @"showConnections", kUIButtonBarButtonAction, @"connections.png", kUIButtonBarButtonInfo, [[[NSNumber]] numberWithUnsignedInt:1], kUIButtonBarButtonTag, [[[NSValue]] valueWithSize:[[NSMakeSize]](0., 2.)], kUIButtonBarButtonInfoOffset, nil];
[[NSArray]] ''items = [[[NSArray]] arrayWithObjects:buttonItem, nil];
[[UIButtonBar]] ''buttonBar = [[[[UIButtonBar]] alloc] initInView:contentView withFrame:[[CGRectMake]](0., screenRect.size.height - 40., screenRect.size.width, 40.) withItemList:items];

int buttons[1] = { 1 };
[buttonBar registerButtonGroup:1 withButtons:buttons withCount:1];
[buttonBar showButtonGroup:1 withDuration:0.];
</code>

Note: [[UIButtonBar]] only works if it is in the contentView of the [[UIWindow]]. It will not intercept clicks if it in a subview of any other view.

----
I've figured out how to do text buttons for a [[UIButtonBar]].  Use the same basic structure as the above Colloquy code, but the following dictionary will make a [[UIButtonBarTextButton]] instead:

<code>

        [[NSDictionary]] ''buttonItem = [[[NSDictionary]] dictionaryWithObjectsAndKeys:
                //self, kUIButtonBarButtonTarget,
                //@"someSelector", kUIButtonBarButtonAction,
                [[[NSNumber]] numberWithUnsignedInt:1], kUIButtonBarButtonTag,
                [[[NSNumber]] numberWithUnsignedInt:3], kUIButtonBarButtonStyle,
                [[[NSNumber]] numberWithUnsignedInt:1], kUIButtonBarButtonType,
                @"Button!", kUIButtonBarButtonInfo,
                nil
        ];

</code>

----
Maps use the following description to create its bottom button bar:

<code>

    {
        [[UIButtonBarButtonAction]] = directionsEnabled; 
        [[UIButtonBarButtonInfo]] = <[[UIImage]]: 0x175d80>; 
        [[UIButtonBarButtonStyle]] = 1; 
        [[UIButtonBarButtonTag]] = 1; 
        [[UIButtonBarButtonTarget]] = <[[ButtonBar]]: 0x174aa0>; 
        [[UIButtonBarButtonType]] = 2; 
    }, 
    {
        [[UIButtonBarButtonAction]] = searchEnabled; 
        [[UIButtonBarButtonInfo]] = <[[UIImage]]: 0x175d80>; 
        [[UIButtonBarButtonStyle]] = 2; 
        [[UIButtonBarButtonTag]] = 2; 
        [[UIButtonBarButtonTarget]] = <[[ButtonBar]]: 0x174aa0>; 
        [[UIButtonBarButtonType]] = 2; 
    }, 
    {
        [[UIButtonBarButtonInfo]] = <[[UISegmentedControl]]: 0x174c10>; 
        [[UIButtonBarButtonTag]] = 3; 
        [[UIButtonBarButtonType]] = 3; 
    }, 
    {
        [[UIButtonBarButtonAction]] = trafficDisabled; 
        [[UIButtonBarButtonInfo]] = <[[UIImage]]: 0x175ee0>; 
        [[UIButtonBarButtonStyle]] = 2; 
        [[UIButtonBarButtonTag]] = 5; 
        [[UIButtonBarButtonTarget]] = <[[ButtonBar]]: 0x174aa0>; 
        [[UIButtonBarButtonType]] = 2; 
    }, 
    {
        [[UIButtonBarButtonAction]] = trafficEnabled; 
        [[UIButtonBarButtonInfo]] = <[[UIImage]]: 0x175ee0>; 
        [[UIButtonBarButtonStyle]] = 1; 
        [[UIButtonBarButtonTag]] = 4; 
        [[UIButtonBarButtonTarget]] = <[[ButtonBar]]: 0x174aa0>; 
        [[UIButtonBarButtonType]] = 2; 
    }

</code>

----
You may as well have a look at [[MobilScrobbler]] http://dev.c99.org/[[MobileScrobbler]]/ - they make heavy use of an iPod-Styled [[UIButtonBar]].

<code>

- ([[NSArray]] '')buttonBarItems {
	        return [ [[NSArray]] arrayWithObjects:
	                                        [ [[NSDictionary]] dictionaryWithObjectsAndKeys:
	                                         @"buttonBarItemTapped:", kUIButtonBarButtonAction,
	                                         @"[[BarPodcasts]].png", kUIButtonBarButtonInfo,
	                                         @"BarPodcasts_Sel.png", kUIButtonBarButtonSelectedInfo,
	                                         [ [[NSNumber]] numberWithInt: 1], kUIButtonBarButtonTag,
	                                         self, kUIButtonBarButtonTarget,
	                                         [[NSLocalizedString]](@"Radio", @"Radio view"), kUIButtonBarButtonTitle,
	                                         @"0", kUIButtonBarButtonType,
	                                         nil 
	                                         ],
	                                       
	                                        [ [[NSDictionary]] dictionaryWithObjectsAndKeys:
	                                         @"buttonBarItemTapped:", kUIButtonBarButtonAction,
	                                         @"History.png", kUIButtonBarButtonInfo,
	                                         @"[[HistorySelected]].png", kUIButtonBarButtonSelectedInfo,
	                                         [ [[NSNumber]] numberWithInt: 2], kUIButtonBarButtonTag,
	                                         self, kUIButtonBarButtonTarget,
	                                         [[NSLocalizedString]](@"Charts", @"Charts view"), kUIButtonBarButtonTitle,
	                                         @"0", kUIButtonBarButtonType,
	                                         nil 
	                                         ],
	                                       
	                                        [ [[NSDictionary]] dictionaryWithObjectsAndKeys:
	                                         @"buttonBarItemTapped:", kUIButtonBarButtonAction,
	                                         @"Search.png", kUIButtonBarButtonInfo,
	                                         @"[[SearchSelected]].png", kUIButtonBarButtonSelectedInfo,
	                                         [ [[NSNumber]] numberWithInt: 3], kUIButtonBarButtonTag,
	                                         self, kUIButtonBarButtonTarget,
	                                         [[NSLocalizedString]](@"Search", @"Search view"), kUIButtonBarButtonTitle,
	                                         @"0", kUIButtonBarButtonType,
	                                         nil 
	                                         ],
	                                       
	                                        nil
	                                        ];
	}

</code>

And they have a good example on how to get the button tapps:

<code>

	- (void)buttonBarItemTapped:(id) sender {
	        int button = [ sender tag ];
	        if(button != _currentView) {
	                _currentView = button;         
	                switch (button) {
	                        case 1:
	                                [_transition transition:[[UITransitionFade]] toView:_radioListView];
	                                break;
	                        case 2:
	                                [_transition transition:[[UITransitionFade]] toView:_chartsView];
	                                break;
	                        case 3:
	                                [_transition transition:[[UITransitionFade]] toView:_radioSearchView];
	                                break;
	                }
	        }
	}

</code>

Hope this helps ;)