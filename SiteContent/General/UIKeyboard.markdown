

Part of the iPhone [[UIKit]] framework. Subclass of [[UIView]].

%%BEGINCODESTYLE%%+ (void)initImplementationNow;%%ENDCODESTYLE%%

Must be called before initWithFrame?

%%BEGINCODESTYLE%%- (id)initWithFrame:([[CGRect]])frame;%%ENDCODESTYLE%%

<code>    [[[UIKeyboard]] initImplementationNow];
  [[UIKeyboard]] ''keyboard = [[[[UIKeyboard]] alloc] initWithFrame: [[CGRectMake]](0.0f, 245.0f,
                                                              320.0f, 480.0f - 245.f)];
//Call up your keyboard into your mainView created as a [[UIWindow]]
mainView = [[[[UIView]] alloc] initWithFrame: rect];

</code>

enum values for setDefaultReturnKeyType:

<code>

0 = Return (gray background)
1 = Go (blue background)
2 = Google (blue background)
3 = Join (blue background)
4 = Next (gray background)
5 = Route (blue background)
6 = Search (blue background)
7 = Send (blue background)
8 = Yahoo! (blue background)

</code>

To change the keyboard layout, use one of the below enums for setPreferredKeyboardType, followed with a call to showPreferredLayout: 

<code>

0 = default QWERTY layout
1 = numeric/punctuation layout
2 = phone keypad
3 = URL layout
4 = SMS (?) layout, shift disabled, num key goes to phone keypad
5 = black version of default layout
6 = spartan phone keypad
7 = black spartan (clean!)
8 = email keypad w/ space key
9 = email keypad w/ @ instead of space

</code>

As an aside, if you're using [[UIAlert]], be sure to set popupAlertAnimated:NO otherwise your showPreferredLayout will be overridden with the default layout. For example:

<code>

      [myAlert popupAlertAnimated:NO];
      [[myAlert keyboard] setPreferredKeyboardType: 1];
      [[myAlert keyboard] showPreferredLayout];

</code>