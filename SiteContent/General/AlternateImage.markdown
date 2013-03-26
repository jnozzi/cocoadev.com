How do I set an alternate image of a button in [[InterfaceBuilder]]?

I've tried this <code> [myButton setImage:@"myImage"];</code> It doesn't work!

----

Of course it doesn't work if you are you doing this! <code>[myButton setAlternateImage:@"myImage"];</code>

Your problem is that you are using a string object when setting the image. You should be using an image object, not the name of an image. If your image is a bundled resource (i.e. you can reference the image by name -> <code>myImage = [NSImage imageNamed:@"myImage"];</code>), then your code should look like this:

<code>[myButton setAlternateImage:[NSImage imageNamed:@"myImage"]];</code>

----

For discussion about more complicated modification of the appearance of your [[NSButton]] in various states, see [[CustomNSButton]]