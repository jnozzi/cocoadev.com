[[UIButton]] is a subclass of [[UIControl]].

In iPhone SDK beta 5, it seems that [[UIButton]] is an abstract class. The method +buttonWithType:([[UIButtonType]])type creates a button with a class based on type. These class (like [[UIRoundedRectButton]] ) are private.


----