While there are more sophisticated routines and objects for parsing HTML (note the General/OmniFrameworks ), you can do simple parsing in an General/NSTextView with the help of General/NSAttributedString:

    
General/textView textStorage] setAttributedString:[[[[[NSAttributedString 
alloc] initWithHTML:General/[NSData dataWithBytes:[theString cString] 
length:[theString length]] documentAttributes:nil] autorelease]];


(Thanks to Andreas Monitzer for the code snippet!)

Note that this does not automatically make General/URLs clickable. We have some sample code for a General/ClickableUrlInTextView, too though.

----

It's also worth noting that this seems to start loading any graphics referenced by <img> tags in a background thread, but they don't seem to show up unless the text view is repeatedly resized or otherwise refreshed.  (See the General/SmallSockets 0.4.0 test application)  Anyone know how to make this happen automatically?

----

does calling the view's display or invalidateRectInWhateverThatMethodIsCalled method work?

----

Ok, I just want to be clear.  To the above code, you need to add something like
    
NSURL *websiteURL;

websiteURL = General/NSURL alloc] initWithString:[textField stringValue;
theString = General/[[NSString alloc] initWithContentsOfURL:websiteURL];

Then everything works fine.  This does the job of converting the textField string to a URL and then using this URL to connect to the internet and download the HTML into the string theString.

I tried the following code...
    
NSURL *websiteURL;
[websiteURL General/URLWithString:[textField stringValue]];
[theString stringWithContentsOfURL:websiteURL];

But this does not work.  Project Builder tells me that General/NSString does not respond to stringWithContentsOfURL and NSURL does not respond to General/URLWithString.  Why doesn't the second code work?

Also, using the above code (which works), typing in "http://www.apple.com" works, but typing in "www.apple.com" does not.  How do you add the ability of the textField to automatically append "http://" to the address the user types in if the user omits it? --General/AlexanderD

Prepend, you mean. First, you might want to check the string to see if it is prefixed with "http://"; after that, you might try looking at the NSURL methods. I don't know which method refers to the "http://" bit specifically, but it's a start. -- General/RobRix

----
Shouldn't that be:
    
NSURL *websiteURL = [NSURL urlWithString: [textField stringValue]];
[theString stringWithContentsOfURL:websiteURL];
