Hey guys, very new to Obj-C >.<

I've written a Chess game in Obj-C. Now I'm writing the UI to it. I've been following the Hillegas book to learn Cocoa. 

To cut to the chase:

I want to send some text, @"Hello", to an General/NSTextView, which is declared in my General/AppController class to handle UI stuff, *devTextView, from my other source files. 

I will be calling this method from the General/AppController:

- (void)appendToDevLog:(General/NSString *)someString;

This handles appending text to the General/NSTextView. 

How do I call this method, without making another instance of my General/AppController class, in my other source files in the project?

----
See General/MailingListMode, General/HowToUseThisSite, General/TextFormattingRules, and *don't post the same question on two different pages*.