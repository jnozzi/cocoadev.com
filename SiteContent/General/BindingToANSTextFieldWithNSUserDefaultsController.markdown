Hi,

I am trying to use the General/NSUserDefaultsController class to bind a General/NSTextField to the shared user defaults. In the init method for my app, I create a General/NSDictionary with a single entry that associates a key called colorKey with an General/NSString (the color). I then register the defaults by calling registerDefaults, and passing the General/NSDictionary as an argument.

The settings for the General/NSTextField in Interface Builder that I want to bind are:

value:
bind to: General/NSUserDefaultsController
Controller key: values
Model key path: colorKey

When the app loads, the General/NSTextField is empty. Changes to the General/NSTextField are not changed when I quit the app. I've wasted more time than I care to admit on this exercise, so if anybody knows what I am doing wrong/not doing, please let me know.

Thanks

The value will only be set in the dictionary when you exit the text field. Maybe you should check "Continuously sets value" in the Binding settings (I'm guessing that is your problem).